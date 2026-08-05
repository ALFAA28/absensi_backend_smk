<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Subject;

class SubjectController extends Controller
{
    // Mengambil daftar mapel (bisa difilter per classroom_id)
    public function index(Request $request)
    {
        $query = Subject::with('classrooms');

        if ($request->has('classroom_id') && $request->classroom_id != '') {
            $classroomId = $request->classroom_id;
            $hasAssignedMapel = Subject::whereHas('classrooms', function ($q) use ($classroomId) {
                $q->where('classrooms.id', $classroomId);
            })->exists();

            if ($hasAssignedMapel) {
                $query->whereHas('classrooms', function ($q) use ($classroomId) {
                    $q->where('classrooms.id', $classroomId);
                });
            }
        }

        $subjects = $query->get();
        return response()->json($subjects, 200);
    }

    // Menyimpan mapel baru (otomatis terhubung ke classroom_id jika dikirim)
    public function store(Request $request)
    {
        $request->validate([
            'kode_mapel' => 'required|string|unique:subjects,kode_mapel',
            'nama_mapel' => 'required|string|max:255',
            'classroom_id' => 'nullable|exists:classrooms,id',
            'classroom_ids' => 'nullable|array',
            'classroom_ids.*' => 'exists:classrooms,id',
        ]);

        $subject = Subject::create([
            'kode_mapel' => $request->kode_mapel,
            'nama_mapel' => $request->nama_mapel,
        ]);

        if ($request->has('classroom_id') && $request->classroom_id) {
            $subject->classrooms()->syncWithoutDetaching([$request->classroom_id]);
        }

        if ($request->has('classroom_ids') && is_array($request->classroom_ids)) {
            $subject->classrooms()->syncWithoutDetaching($request->classroom_ids);
        }

        return response()->json([
            'message' => 'Mata pelajaran berhasil ditambahkan',
            'data' => $subject->load('classrooms')
        ], 201);
    }

    // Menghubungkan mapel ke kelas/jurusan tertentu
    public function assignClassrooms(Request $request, $id)
    {
        $subject = Subject::find($id);
        if (!$subject) {
            return response()->json(['message' => 'Mapel tidak ditemukan'], 404);
        }

        $request->validate([
            'classroom_ids' => 'required|array',
            'classroom_ids.*' => 'exists:classrooms,id',
        ]);

        $subject->classrooms()->sync($request->classroom_ids);

        return response()->json([
            'message' => 'Jurusan/Kelas untuk mata pelajaran berhasil diperbarui',
            'data' => $subject->load('classrooms')
        ], 200);
    }

    // Menghapus mapel
    public function destroy($id)
    {
        $subject = Subject::find($id);
        if (!$subject) {
            return response()->json(['message' => 'Mapel tidak ditemukan'], 404);
        }

        $subject->delete();
        return response()->json(['message' => 'Mata pelajaran berhasil dihapus'], 200);
    }
}
