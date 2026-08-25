<?php
namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\User;
use Illuminate\Support\Facades\Hash;

class AuthController extends Controller
{
    public function login(Request $request)
    {
        $request->validate([
            'email' => 'required|email',
            'password' => 'required',
            'app_source' => 'nullable|string|in:absensi,storing'
        ]);

        // Cari user beserta nama kelas yang diampunya
        $user = User::with('classroom')->where('email', $request->email)->first();

        // 1. Cek Email & Password
        if (!$user || !Hash::check($request->password, $user->password)) {
            return response()->json(['message' => 'Email atau password salah.'], 401);
        }

        // 2. Cek Status Akun (KECUALI UNTUK ADMIN)
        if ($user->role !== 'admin' && $user->status !== 'active') {
            return response()->json([
                'message' => 'Akun Anda belum disetujui atau sedang dinonaktifkan oleh Admin.'
            ], 403);
        }

        // 3. Validasi Pemisahan Hak Akses Platform (Web Absensi vs Web Storing Modul)
        $targetApp = $request->input('app_source', 'absensi');
        $userApp = $user->app_source ?? 'absensi';

        if ($user->role !== 'admin') {
            if ($targetApp === 'absensi' && $userApp === 'storing') {
                return response()->json([
                    'message' => 'Akun ini terdaftar khusus untuk Storing Modul dan tidak dapat digunakan pada Web Absensi.'
                ], 403);
            }

            if ($targetApp === 'storing' && $userApp === 'absensi') {
                return response()->json([
                    'message' => 'Akun ini terdaftar untuk Web Absensi dan tidak dapat digunakan pada Web Storing Modul.'
                ], 403);
            }
        }

        // 4. Jika lolos pengecekan, generate token
        $token = $user->createToken('auth_token')->plainTextToken;

        return response()->json([
            'message' => 'Login Berhasil',
            'token' => $token,
            'user' => [
                'id' => $user->id,
                'name' => $user->name,
                'email' => $user->email,
                'role' => $user->role,
                'status' => $user->status,
                'app_source' => $userApp,
                'nrg' => $user->nrg,
                'managed_class' => $user->classroom ? $user->classroom->name : null,
                'classroom_id' => $user->classroom_id
            ]
        ], 200);
    }

    public function register(Request $request)
    {
        $request->validate([
            'nama' => 'required|string|max:255',
            'email' => 'required|string|email|max:255|unique:users',
            'password' => 'required|string|min:6',
            'classroom_id' => 'nullable|exists:classrooms,id',
            'nrg' => 'nullable|string|max:50',
            'app_source' => 'nullable|string|in:absensi,storing'
        ]);

        $appSource = $request->app_source ?? 'absensi';
        $role = ($appSource === 'absensi' && $request->classroom_id) ? 'wali_kelas' : 'guru_mapel';

        $user = User::create([
            'name' => $request->nama,
            'email' => $request->email,
            'password' => $request->password,
            'role' => $role,
            'classroom_id' => $appSource === 'absensi' ? $request->classroom_id : null,
            'nrg' => $request->nrg,
            'app_source' => $appSource,
            'status' => 'pending'
        ]);

        return response()->json([
            'message' => 'Registrasi Berhasil. Menunggu persetujuan admin.',
            'user' => $user
        ], 201);
    }

    // Fungsi untuk dipanggil di halaman Manajemen Akun (Admin)
    public function getUsers()
    {
        $users = User::with('classroom')->where('id', '!=', auth()->id())->orderBy('created_at', 'desc')->get();
        return response()->json($users, 200);
    }

    // Fungsi untuk mengubah status akun (Approve/Deactivate)
    public function updateStatus(Request $request, $id)
    {
        $request->validate([
            'status' => 'required|string|in:active,inactive,pending'
        ]);

        $user = User::find($id);

        if (!$user) {
            return response()->json(['message' => 'User tidak ditemukan'], 404);
        }

        // PROTEKSI: Mencegah akun admin dinonaktifkan
        if ($user->role === 'admin') {
            return response()->json(['message' => 'Status akun Admin tidak dapat diubah.'], 403);
        }

        $user->status = $request->status;
        $user->save();

        return response()->json([
            'message' => 'Status user berhasil diperbarui',
            'user' => $user
        ], 200);
    }

    // Fungsi untuk menghapus akun secara permanen
    public function destroyUser($id)
    {
        $user = User::find($id);

        if (!$user) {
            return response()->json(['message' => 'User tidak ditemukan'], 404);
        }

        // PROTEKSI: Mencegah akun admin dihapus
        if ($user->role === 'admin') {
            return response()->json(['message' => 'Akun Admin tidak dapat dihapus.'], 403);
        }

        $user->delete();

        return response()->json(['message' => 'User berhasil dihapus'], 200);
    }

    // Fungsi untuk mereset password pengguna oleh Admin
    public function resetPassword($id)
    {
        $user = User::find($id);

        if (!$user) {
            return response()->json(['message' => 'User tidak ditemukan'], 404);
        }

        // Proteksi: Jangan biarkan admin mereset password admin lain (opsional)
        if ($user->role === 'admin') {
            return response()->json(['message' => 'Tidak dapat mereset sandi sesama Admin.'], 403);
        }

        // Set sandi default
        $defaultPassword = 'password123';
        $user->password = $defaultPassword;
        $user->save();

        return response()->json([
            'message' => 'Sandi berhasil direset menjadi: ' . $defaultPassword
        ], 200);
    }

    // Fungsi untuk mengubah password oleh pemilik akun yang sedang login
    public function changePassword(Request $request)
    {
        $request->validate([
            'current_password' => 'required',
            'new_password' => 'required|string|min:6',
        ]);

        $user = $request->user(); // Mengambil data user dari token yang sedang login

        // Periksa apakah password lama sudah benar
        if (!Hash::check($request->current_password, $user->password)) {
            return response()->json(['message' => 'Kata sandi lama yang Anda masukkan salah.'], 400);
        }

        // Update ke password baru
        $user->password = $request->new_password;
        $user->save();

        return response()->json(['message' => 'Kata sandi berhasil diubah.'], 200);
    }

    public function store(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|string|email|unique:users',
            'password' => 'required|string|min:6',
            'role' => 'required|string|in:wali_kelas,guru_mapel,admin,sarpras',
            'classroom_id' => 'nullable|exists:classrooms,id',
            'nrg' => 'nullable|string|max:50',
            'app_source' => 'nullable|string|in:absensi,storing'
        ]);

        $user = User::create([
            'name' => $request->name,
            'email' => $request->email,
            'password' => $request->password,
            'role' => $request->role,
            'classroom_id' => $request->role === 'wali_kelas' ? $request->classroom_id : null,
            'nrg' => $request->nrg,
            'app_source' => $request->app_source ?? 'absensi',
            'status' => 'active'
        ]);

        return response()->json(['message' => 'Akun berhasil ditambahkan', 'data' => $user], 201);
    }

    // Fungsi untuk memperbarui role, kelas binaan, sumber akun, dan NRG pengguna oleh Admin
    public function updateRole(Request $request, $id)
    {
        $request->validate([
            'role' => 'required|string|in:wali_kelas,guru_mapel,admin,sarpras',
            'classroom_id' => 'nullable|exists:classrooms,id',
            'app_source' => 'nullable|string|in:absensi,storing',
            'nrg' => 'nullable|string|max:50'
        ]);

        $user = User::find($id);

        if (!$user) {
            return response()->json(['message' => 'User tidak ditemukan'], 404);
        }

        $user->role = $request->role;
        if ($request->has('classroom_id')) {
            $user->classroom_id = $request->role === 'wali_kelas' ? $request->classroom_id : null;
        }
        if ($request->has('app_source')) {
            $user->app_source = $request->app_source;
        }
        if ($request->has('nrg')) {
            $user->nrg = $request->nrg;
        }
        $user->save();

        return response()->json([
            'message' => 'Akun berhasil diperbarui',
            'user' => $user->load('classroom')
        ], 200);
    }
}

