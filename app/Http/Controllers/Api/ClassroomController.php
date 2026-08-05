<?php
namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Classroom;

class ClassroomController extends Controller
{
    // Mengambil semua data kelas/jurusan
    public function index()
    {
        $classrooms = Classroom::all();
        return response()->json($classrooms, 200);
    }

    // Menyimpan kelas/jurusan baru ke database
    public function store(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:255|unique:classrooms,name',
            'grade' => 'required|in:10,11,12',
            'singkatan' => 'required|string|max:50',
            'academic_batch_id' => 'required|exists:academic_batches,id',
        ]);

        // 1. Buat kelas baru di database
        $classroom = Classroom::create([
            'name' => $request->name,
            'grade' => $request->grade,
            'singkatan' => $request->singkatan ?? $request->name,
            'academic_batch_id' => $request->academic_batch_id
        ]);

        $user = $request->user();

        // 2. Jika yang membuat adalah wali_kelas dan belum punya kelas binaan, otomatis set kelas ini untuknya
        if ($user->role === 'wali_kelas' && empty($user->classroom_id)) {
            $user->classroom_id = $classroom->id;
            $user->save();
        }

        return response()->json([
            'message' => 'Jurusan/Kelas berhasil ditambahkan dan otomatis terhubung!',
            'data' => $classroom,
            'assigned_classroom_id' => $user->classroom_id // Mengirim info kelas binaan terbaru
        ], 201);
    }

    public function update(Request $request, $id)
    {
        $classroom = Classroom::find($id);
        if (!$classroom) {
            return response()->json(['message' => 'Jurusan/Kelas tidak ditemukan'], 404);
        }

        $request->validate([
            'name' => 'required|string|max:255|unique:classrooms,name,' . $id,
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
    public function destroy($id)
    {
        $classroom = Classroom::find($id);

        if (!$classroom) {
            return response()->json(['message' => 'Jurusan/Kelas tidak ditemukan'], 404);
        }

        $classroom->delete();

        return response()->json([
            'message' => 'Jurusan/Kelas berhasil dihapus dari database'
        ], 200);
    }
}