<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\AcademicBatch;

class AcademicBatchController extends Controller
{
    public function index()
    {
        return response()->json(AcademicBatch::all(), 200);
    }

    public function store(Request $request)
    {
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

    public function destroy($id)
    {
        $batch = AcademicBatch::find($id);
        if (!$batch) {
            return response()->json(['message' => 'Angkatan tidak ditemukan'], 404);
        }
        $batch->delete();
        return response()->json(['message' => 'Angkatan berhasil dihapus'], 200);
    }
}