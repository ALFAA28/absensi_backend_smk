<?php
namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;
use App\Models\Classroom;

class ClassroomController extends Controller
{
    // Mengambil data kelas/jurusan (Jika wali_kelas, hanya kelas binaannya — kecuali scope=all untuk dashboard)
    public function index(Request $request)
    {
        $user = $request->user();
        if ($user && $user->role === 'wali_kelas' && $request->query('scope') !== 'all') {
            // Wali kelas melihat kelas yang mereka buat (user_id) ATAU kelas binaan utama mereka (classroom_id)
            $classrooms = Classroom::where('user_id', $user->id)
                                   ->orWhere('id', $user->classroom_id)
                                   ->get();
            return response()->json($classrooms, 200);
        }

        $classrooms = Classroom::all();
        return response()->json($classrooms, 200);
    }

    // Menyimpan kelas/jurusan baru ke database
    public function store(Request $request)
    {
        $user = $request->user();
        if ($user && !in_array($user->role, ['admin', 'wali_kelas'])) {
            return response()->json(['message' => 'Hanya Admin atau Wali Kelas yang dapat menambahkan kelas/jurusan.'], 403);
        }

        $request->validate([
            'name' => [
                'required', 'string', 'max:255',
                Rule::unique('classrooms')->where(function ($query) use ($request) {
                    return $query->where('academic_batch_id', $request->academic_batch_id);
                }),
            ],
            'grade' => 'required|in:10,11,12',
            'singkatan' => 'required|string|max:50',
            'academic_batch_id' => 'required|exists:academic_batches,id',
        ]);

        // 1. Buat kelas baru di database
        $classroom = Classroom::create([
            'name' => $request->name,
            'grade' => $request->grade,
            'singkatan' => $request->singkatan ?? $request->name,
            'academic_batch_id' => $request->academic_batch_id,
            'user_id' => $user->id ?? null, // Simpan ID pembuat
        ]);

        // Jika user adalah wali kelas dan belum memiliki kelas binaan, jadikan ini sebagai kelas binaannya
        if ($user && $user->role === 'wali_kelas' && !$user->classroom_id) {
            $user->classroom_id = $classroom->id;
            $user->save();
        }

        return response()->json([
            'message' => 'Jurusan/Kelas berhasil ditambahkan!',
            'data' => $classroom
        ], 201);
    }

    public function update(Request $request, $id)
    {
        $user = $request->user();
        $classroom = Classroom::find($id);
        
        if (!$classroom) {
            return response()->json(['message' => 'Jurusan/Kelas tidak ditemukan'], 404);
        }

        // Hanya admin, atau wali kelas yang membuat kelas ini yang boleh mengedit
        if ($user && $user->role !== 'admin') {
            if ($user->role !== 'wali_kelas' || $classroom->user_id !== $user->id) {
                return response()->json(['message' => 'Anda tidak memiliki hak untuk mengubah kelas ini.'], 403);
            }
        }

        $request->validate([
            'name' => [
                'required', 'string', 'max:255',
                Rule::unique('classrooms')->where(function ($query) use ($request) {
                    return $query->where('academic_batch_id', $request->academic_batch_id);
                })->ignore($id),
            ],
            'grade' => 'required|in:10,11,12',
            'singkatan' => 'required|string|max:50',
            'academic_batch_id' => 'required|exists:academic_batches,id',
        ]);

        $classroom->update([
            'name' => $request->name,
            'grade' => $request->grade,
            'singkatan' => $request->singkatan,
            'academic_batch_id' => $request->academic_batch_id,
        ]);

        return response()->json(['message' => 'Jurusan/Kelas berhasil diperbarui', 'data' => $classroom], 200);
    }

    // Menghapus kelas/jurusan dari database secara permanen
    public function destroy(Request $request, $id)
    {
        $user = $request->user();
        $classroom = Classroom::find($id);

        if (!$classroom) {
            return response()->json(['message' => 'Jurusan/Kelas tidak ditemukan'], 404);
        }

        // Hanya admin, atau wali kelas yang membuat kelas ini yang boleh menghapus
        if ($user && $user->role !== 'admin') {
            if ($user->role !== 'wali_kelas' || $classroom->user_id !== $user->id) {
                return response()->json(['message' => 'Anda tidak memiliki hak untuk menghapus kelas ini.'], 403);
            }
        }

        $classroom->delete();

        return response()->json([
            'message' => 'Jurusan/Kelas berhasil dihapus dari database'
        ], 200);
    }
}