<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Student;

class StudentController extends Controller
{
    // Mengambil semua data siswa beserta relasi kelasnya dan rekap absensi
    public function index(Request $request)
    {
        $students = Student::with('classroom')
            ->withCount([
                'attendances as hadir_count' => function ($query) {
                    $query->where('status', 'Hadir');
                },
                'attendances as sakit_count' => function ($query) {
                    $query->where('status', 'Sakit');
                },
                'attendances as izin_count' => function ($query) {
                    $query->where('status', 'Izin');
                },
                'attendances as alfa_count' => function ($query) {
                    $query->whereIn('status', ['Alpa', 'Alfa']);
                },
            ])
            ->get();
        return response()->json($students, 200);
    }

    public function store(Request $request)
    {
        $request->validate([
            'nisn' => 'required|unique:students,nisn',
            'name' => 'required|string|max:255',
            'classroom_id' => 'required|exists:classrooms,id',
            'status' => 'nullable|string',
            'status_keterangan' => 'nullable|string',
        ]);

        $student = Student::create([
            'nisn' => $request->nisn,
            'name' => $request->name,
            'classroom_id' => $request->classroom_id,
            'status' => $request->status ?? 'Aktif',
            'status_keterangan' => $request->status_keterangan ?? null,
        ]);

        return response()->json([
            'message' => 'Siswa berhasil ditambahkan',
            'data' => $student
        ], 201);
    }

    public function update(Request $request, $id)
    {
        $student = Student::find($id);
        if (!$student) {
            return response()->json(['message' => 'Siswa tidak ditemukan'], 404);
        }

        $request->validate([
            'nisn' => 'required|unique:students,nisn,' . $id,
            'name' => 'required|string|max:255',
            'classroom_id' => 'required|exists:classrooms,id',
            'status' => 'nullable|string',
            'status_keterangan' => 'nullable|string',
        ]);

        $updateData = [
            'nisn' => $request->nisn,
            'name' => $request->name,
            'classroom_id' => $request->classroom_id,
        ];

        if ($request->has('status')) {
            $updateData['status'] = $request->status;
        }
        if ($request->has('status_keterangan')) {
            $updateData['status_keterangan'] = $request->status_keterangan;
        }

        $student->update($updateData);

        return response()->json(['message' => 'Siswa berhasil diperbarui', 'data' => $student], 200);
    }

    // Ubah Status Aktif/Nonaktif & Keterangan (Lulus / Drop Out)
    public function updateStatus(Request $request, $id)
    {
        $student = Student::withTrashed()->find($id);
        if (!$student) {
            return response()->json(['message' => 'Siswa tidak ditemukan'], 404);
        }

        $request->validate([
            'status' => 'required|string',
            'status_keterangan' => 'nullable|string',
        ]);

        $rawStatus = $request->status;
        $keterangan = $request->status_keterangan;

        if ($rawStatus === 'Aktif') {
            $status = 'Aktif';
            $keterangan = null;
        } else if ($rawStatus === 'Lulus') {
            $status = 'Nonaktif';
            $keterangan = 'Lulus';
        } else if ($rawStatus === 'Drop Out') {
            $status = 'Nonaktif';
            $keterangan = 'Drop Out';
        } else {
            $status = 'Nonaktif';
            $keterangan = $keterangan ?: 'Nonaktif';
        }

        $student->update([
            'status' => $status,
            'status_keterangan' => $keterangan,
        ]);

        return response()->json([
            'message' => 'Status siswa berhasil diperbarui',
            'data' => $student
        ], 200);
    }

    public function bulkStore(Request $request)
    {
        $request->validate([
            'students' => 'required|array',
            'students.*.nisn' => 'required|string',
            'students.*.name' => 'required|string',
            'students.*.classroom_id' => 'required|exists:classrooms,id',
        ]);

        $inserted = [];
        foreach ($request->students as $s) {
            $student = Student::updateOrCreate(
                ['nisn' => $s['nisn']],
                [
                    'name' => $s['name'],
                    'classroom_id' => $s['classroom_id'],
                    'status' => $s['status'] ?? 'Aktif',
                    'status_keterangan' => $s['status_keterangan'] ?? null,
                    'deleted_at' => null // Restore jika soft deleted
                ]
            );
            $inserted[] = $student;
        }

        return response()->json([
            'message' => 'Berhasil mengimpor ' . count($inserted) . ' data siswa!',
            'data' => $inserted
        ], 200);
    }

    public function bulkUpdateStatus(Request $request)
    {
        $request->validate([
            'classroom_id' => 'required|exists:classrooms,id',
            'status' => 'required|string',
            'status_keterangan' => 'nullable|string',
        ]);

        $rawStatus = $request->status;
        $keterangan = $request->status_keterangan;

        if ($rawStatus === 'Aktif') {
            $status = 'Aktif';
            $keterangan = null;
        } else if ($rawStatus === 'Lulus') {
            $status = 'Nonaktif';
            $keterangan = 'Lulus';
        } else if ($rawStatus === 'Drop Out') {
            $status = 'Nonaktif';
            $keterangan = 'Drop Out';
        } else {
            $status = 'Nonaktif';
            $keterangan = $keterangan ?: 'Nonaktif';
        }

        Student::where('classroom_id', $request->classroom_id)->update([
            'status' => $status,
            'status_keterangan' => $keterangan,
        ]);

        return response()->json([
            'message' => 'Status seluruh siswa di kelas berhasil diperbarui',
        ], 200);
    }

    // --- TAMBAHKAN FUNGSI INI UNTUK MENGHAPUS SISWA ---
    public function destroy($id)
    {
        // MenggunakanwithTrashed() untuk memastikan data yang sudah berstatus soft delete tetap bisa ditemukan
        $student = Student::withTrashed()->find($id);

        if (!$student) {
            return response()->json(['message' => 'Siswa tidak ditemukan'], 404);
        }

        // Menggunakan forceDelete() untuk menghapus data secara permanen dari database MySQL
        $student->forceDelete();

        return response()->json(['message' => 'Data siswa berhasil dihapus secara permanen'], 200);
    }
}
