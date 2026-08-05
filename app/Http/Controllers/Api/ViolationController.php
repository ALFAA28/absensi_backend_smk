<?php
namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Violation;
use App\Models\AcademicYear;

class ViolationController extends Controller
{
    public function store(Request $request)
    {
        $request->validate([
            'student_id' => 'required|exists:students,id',
            'date' => 'required|date',
            'type' => 'required|string|max:255',
            'notes' => 'nullable|string',
        ]);

        $activeYear = AcademicYear::where('is_active', true)->first();
        if (!$activeYear) {
            return response()->json(['message' => 'Tahun ajaran aktif belum ditentukan.'], 400);
        }

        $violation = Violation::create([
            'student_id' => $request->student_id,
            'academic_year_id' => $activeYear->id,
            'created_by' => $request->user()->id,
            'date' => $request->date,
            'type' => $request->type,
            'notes' => $request->notes,
        ]);

        return response()->json(['message' => 'Pelanggaran berhasil dicatat.', 'data' => $violation], 201);
    }
}