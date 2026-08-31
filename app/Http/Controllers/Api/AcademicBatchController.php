<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\AcademicBatch;
use App\Models\Classroom;

class AcademicBatchController extends Controller
{
    public function index(Request $request)
    {
        $user = $request->user();
        if ($user && $user->role === 'wali_kelas') {
            if ($user->classroom_id) {
                $classroom = Classroom::find($user->classroom_id);
                if ($classroom && $classroom->academic_batch_id) {
                    $batches = AcademicBatch::where('id', $classroom->academic_batch_id)->get();
                    return response()->json($batches, 200);
                }
            }
            return response()->json([], 200);
        }

        return response()->json(AcademicBatch::all(), 200);
    }

    public function store(Request $request)
    {
        $user = $request->user();
        if ($user && $user->role !== 'admin') {
            return response()->json(['message' => 'Hanya Admin yang dapat menambahkan angkatan.'], 403);
        }

        $request->validate([
            'name' => 'required|string|max:255',
            'year' => 'required|string|max:255',
        ]);

        $batch = AcademicBatch::create([
            'name' => $request->name,
            'year' => $request->year,
        ]);

        return response()->json([
            'message' => 'Angkatan berhasil disimpan ke database',
            'data' => $batch
        ], 201);
    }

    public function update(Request $request, $id)
    {
        $user = $request->user();
        if ($user && $user->role !== 'admin') {
            return response()->json(['message' => 'Hanya Admin yang dapat mengubah angkatan.'], 403);
        }

        $batch = AcademicBatch::find($id);
        if (!$batch) {
            return response()->json(['message' => 'Angkatan tidak ditemukan'], 404);
        }

        $request->validate([
            'name' => 'required|string|max:255',
            'year' => 'required|string|max:255',
        ]);

        $batch->update([
            'name' => $request->name,
            'year' => $request->year,
        ]);

        return response()->json(['message' => 'Angkatan berhasil diperbarui', 'data' => $batch], 200);
    }

    public function destroy(Request $request, $id)
    {
        $user = $request->user();
        if ($user && $user->role !== 'admin') {
            return response()->json(['message' => 'Hanya Admin yang dapat menghapus angkatan.'], 403);
        }

        $batch = AcademicBatch::find($id);
        if (!$batch) {
            return response()->json(['message' => 'Angkatan tidak ditemukan'], 404);
        }
        $batch->delete();
        return response()->json(['message' => 'Angkatan berhasil dihapus'], 200);
    }
}