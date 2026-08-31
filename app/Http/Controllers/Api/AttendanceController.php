<?php
namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Attendance;
use App\Models\AcademicYear;
use Illuminate\Support\Facades\Validator;

class AttendanceController extends Controller
{
    public function index(Request $request)
    {
        $user = $request->user();

        $query = Attendance::query()
            ->join('students', 'attendances.student_id', '=', 'students.id')
            ->join('classrooms', 'students.classroom_id', '=', 'classrooms.id')
            ->leftJoin('subjects', 'attendances.subject_id', '=', 'subjects.id')
            ->select(
                'attendances.id',
                'attendances.student_id',
                'attendances.subject_id',
                'attendances.date',
                'attendances.status',
                'attendances.notes',
                'students.nisn',
                'students.name as student_name',
                'classrooms.name as classroom_name',
                'subjects.nama_mapel'
            );

        // KETAT: Jika role wali_kelas, kunci hanya ke classroom_id miliknya
        if ($user && $user->role === 'wali_kelas') {
            if ($user->classroom_id) {
                $query->where('students.classroom_id', $user->classroom_id);
            } else {
                $query->whereRaw('1 = 0');
            }
        } else if ($request->filled('classroom_id')) {
            $query->where('students.classroom_id', $request->classroom_id);
        }

        if ($request->filled('tanggal')) {
            $query->where('attendances.date', $request->tanggal);
        }

        if ($request->filled('bulan')) {
            // Gunakan range tanggal (bisa pakai index) bukan LIKE
            $start = $request->bulan . '-01';
            $end = date('Y-m-t', strtotime($start));
            $query->whereBetween('attendances.date', [$start, $end]);
        }

        if ($request->filled('semester') && $request->filled('tahun')) {
            $tahun = $request->tahun;
            if ($request->semester == 'genap') {
                $start = $tahun . '-01-01';
                $end = $tahun . '-06-30';
            } else if ($request->semester == 'ganjil') {
                $start = $tahun . '-07-01';
                $end = $tahun . '-12-31';
            }
            if (isset($start) && isset($end)) {
                $query->whereBetween('attendances.date', [$start, $end]);
            }
        }

        if ($request->filled('subject_id')) {
            $query->where('attendances.subject_id', $request->subject_id);
        }

        if ($request->filled('student_id')) {
            $query->where('attendances.student_id', $request->student_id);
        }

        if ($user && $user->role !== 'wali_kelas' && $request->filled('batch_id')) {
            $batchId = $request->batch_id;
            $query->where(function ($q) use ($batchId) {
                $q->where('classrooms.grade', $batchId)
                    ->orWhere('classrooms.academic_batch_id', $batchId);
            });
        }

        // Pencarian berdasarkan Nama Siswa atau NISN
        if ($request->filled('search')) {
            $search = $request->search;
            $query->where(function ($q) use ($search) {
                $q->where('students.name', 'like', '%' . $search . '%')
                  ->orWhere('students.nisn', 'like', '%' . $search . '%');
            });
        }

        $attendances = $query->orderBy('attendances.date', 'desc')
            ->limit(500)
            ->get();

        $formatted = $attendances->map(function ($att) {
            return [
                'id' => $att->id,
                'student_id' => $att->student_id,
                'siswa_id' => $att->student_id,
                'subject_id' => $att->subject_id,
                'tanggal' => $att->date,
                'date' => $att->date,
                'nama_mapel' => $att->nama_mapel ?? '-',
                'nisn' => $att->nisn ?? '-',
                'nama_siswa' => $att->student_name ?? '-',
                'kelas_siswa' => $att->classroom_name ?? '-',
                'status_kehadiran' => $att->status,
                'status' => $att->status,
                'keterangan' => $att->notes,
                'notes' => $att->notes,
            ];
        });

        return response()->json($formatted, 200);
    }

    // Menyimpan absensi harian secara massal (Batch Insert)
    public function store(Request $request)
    {
        $request->validate([
            'date' => 'required|date',
            'attendances' => 'required|array',
            'attendances.*.student_id' => 'required|exists:students,id',
            'attendances.*.status' => 'required|in:Hadir,Sakit,Izin,Alfa',
        ]);

        $user = $request->user();
        if ($user && $user->role === 'wali_kelas') {
            if (!$user->classroom_id) {
                return response()->json(['message' => 'Anda belum memiliki kelas binaan.'], 403);
            }
        }

        // Ambil tahun ajaran yang sedang aktif di database
        $activeYear = AcademicYear::where('is_active', true)->first();

        if (!$activeYear) {
            return response()->json(['message' => 'Tahun ajaran aktif belum ditentukan di database.'], 400);
        }

        $savedCount = 0;
        foreach ($request->attendances as $item) {
            $student = \App\Models\Student::find($item['student_id']);
            if (!$student) {
                continue;
            }

            // Keamanan: wali_kelas hanya bisa mengabsen siswa di kelasnya sendiri
            if ($user && $user->role === 'wali_kelas' && $student->classroom_id != $user->classroom_id) {
                continue;
            }

            // Lewati siswa yang berstatus Nonaktif, Lulus, atau Drop Out
            if ($student->status === 'Nonaktif' || $student->status === 'Lulus' || $student->status === 'Drop Out') {
                continue;
            }

            Attendance::updateOrCreate(
                [
                    'student_id' => $item['student_id'],
                    'date' => $request->date,
                ],
                [
                    'status' => $item['status'],
                    'notes' => $item['notes'] ?? null,
                    'subject_id' => null, // Karena sudah nullable dan tidak dipakai lagi
                    'academic_year_id' => $activeYear->id,
                    'created_by' => $user->id,
                ]
            );
            $savedCount++;
        }

        return response()->json(['message' => 'Berhasil menyimpan absensi untuk ' . $savedCount . ' siswa aktif (siswa nonaktif/lulus/drop out dilewati).'], 200);
    }

    public function update(Request $request, $id)
    {
        $attendance = Attendance::with('student')->find($id);
        if (!$attendance) {
            return response()->json(['message' => 'Absensi tidak ditemukan'], 404);
        }

        $user = $request->user();
        if ($user && $user->role === 'wali_kelas') {
            if (!$attendance->student || $attendance->student->classroom_id != $user->classroom_id) {
                return response()->json(['message' => 'Anda tidak memiliki akses untuk mengubah absensi siswa di kelas lain.'], 403);
            }
        }

        $request->validate([
            'date' => 'sometimes|required|date',
            'status' => 'sometimes|required|in:Hadir,Sakit,Izin,Alfa',
            'notes' => 'nullable|string',
        ]);

        if ($request->has('date')) {
            $attendance->date = $request->date;
        }
        if ($request->has('status')) {
            $attendance->status = $request->status;
        }
        if ($request->has('notes')) {
            $attendance->notes = $request->notes;
        }

        $attendance->save();

        return response()->json(['message' => 'Absensi berhasil diperbarui', 'data' => $attendance], 200);
    }

    public function destroy(Request $request, $id)
    {
        $attendance = Attendance::with('student')->find($id);
        if (!$attendance) {
            return response()->json(['message' => 'Absensi tidak ditemukan'], 404);
        }

        $user = $request->user();
        if ($user && $user->role === 'wali_kelas') {
            if (!$attendance->student || $attendance->student->classroom_id != $user->classroom_id) {
                return response()->json(['message' => 'Anda tidak memiliki akses untuk menghapus absensi siswa di kelas lain.'], 403);
            }
        }

        $attendance->delete();

        return response()->json(['message' => 'Absensi berhasil dihapus'], 200);
    }
}