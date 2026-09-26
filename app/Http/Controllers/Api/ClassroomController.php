<?php
namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;
use App\Models\Classroom;

class ClassroomController extends Controller
{
    // Mengambil data kelas/jurusan
    public function index(Request $request)
    {
        $classrooms = Classroom::all();
        return response()->json($classrooms, 200);
    }

    // Menyimpan kelas/jurusan baru ke database
    public function store(Request $request)
    {
        $user = $request->user();
        if ($user && !in_array($user->role, ['admin', 'guru_piket'])) {
            return response()->json(['message' => 'Hanya Admin atau Guru Piket yang dapat menambahkan kelas/jurusan.'], 403);
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

        $classroom = Classroom::create([
            'name' => $request->name,
            'grade' => $request->grade,
            'singkatan' => $request->singkatan ?? $request->name,
            'academic_batch_id' => $request->academic_batch_id,
        ]);

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

        // Hanya admin atau guru piket yang boleh mengedit
        if ($user && !in_array($user->role, ['admin', 'guru_piket'])) {
            return response()->json(['message' => 'Anda tidak memiliki hak untuk mengubah kelas ini.'], 403);
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

        // Hanya admin atau guru piket yang boleh menghapus
        if ($user && !in_array($user->role, ['admin', 'guru_piket'])) {
            return response()->json(['message' => 'Anda tidak memiliki hak untuk menghapus kelas ini.'], 403);
        }

        $classroom->delete();

        return response()->json([
            'message' => 'Jurusan/Kelas berhasil dihapus dari database'
        ], 200);
    }
}