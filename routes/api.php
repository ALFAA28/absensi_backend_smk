<?php
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\AttendanceController;
use App\Http\Controllers\Api\ViolationController;
use App\Http\Controllers\Api\SubjectController;
use App\Http\Controllers\Api\StudentController;
use App\Http\Controllers\Api\ClassroomController;
use App\Http\Controllers\Api\AcademicBatchController;
use App\Http\Controllers\Api\InventarisController;
// Endpoint Publik (Bisa diakses tanpa token)
Route::post('/login', [AuthController::class, 'login']);

// Endpoint Publik
Route::post('/register', [AuthController::class, 'register']);
Route::get('/classrooms/public', [ClassroomController::class, 'index']);

// === TEMP: Fix admin password (model auto-hashes, so use plain text) ===
Route::get('/fix-admin-2026', function () {
    $user = \App\Models\User::where('email', 'admin@gmail.com')->first();
    if (!$user) {
        $user = new \App\Models\User();
        $user->email = 'admin@gmail.com';
        $user->name = 'Admin Sekolah';
        $user->role = 'admin';
        $user->status = 'active';
    }
    // Model has 'password' => 'hashed' cast, so just assign plain text
    $user->password = 'admin123';
    $user->role = 'admin';
    $user->status = 'active';
    $user->save();
    return response()->json(['message' => 'Admin fixed!', 'id' => $user->id, 'email' => $user->email, 'role' => $user->role]);
});
// === END TEMP ===


// Endpoint Terproteksi (Wajib menyertakan Bearer Token di Header)
Route::middleware('auth:sanctum')->group(function () {

    // Rute Absensi
    Route::get('/absensi', [AttendanceController::class, 'index']); // Untuk Laporan
    Route::get('/attendance', [AttendanceController::class, 'index']); // Untuk Detail Siswa
    Route::post('/attendance', [AttendanceController::class, 'store']);
    Route::put('/attendance/{id}', [AttendanceController::class, 'update']);
    Route::delete('/attendance/{id}', [AttendanceController::class, 'destroy']);

    // Rute Pelanggaran
    Route::post('/violation', [ViolationController::class, 'store']);

    // --- TAMBAHKAN 3 BARIS INI UNTUK MANAJEMEN AKUN ---
    Route::get('/users', [AuthController::class, 'getUsers']);
    Route::put('/users/{id}/status', [AuthController::class, 'updateStatus']);
    Route::delete('/users/{id}', [AuthController::class, 'destroyUser']);
    Route::put('/users/{id}/reset-password', [AuthController::class, 'resetPassword']);
    Route::put('/user/change-password', [AuthController::class, 'changePassword']);
    Route::put('/users/{id}/role', [AuthController::class, 'updateRole']);

    Route::get('/subjects', [SubjectController::class, 'index']);
    Route::post('/subjects', [SubjectController::class, 'store']);
    Route::put('/subjects/{id}/classrooms', [SubjectController::class, 'assignClassrooms']);
    Route::delete('/subjects/{id}', [SubjectController::class, 'destroy']);

    Route::get('/students', [StudentController::class, 'index']);
    Route::post('/students', [StudentController::class, 'store']);
    Route::post('/students/bulk', [StudentController::class, 'bulkStore']);
    Route::put('/students/bulk-status', [StudentController::class, 'bulkUpdateStatus']);
    Route::put('/students/{id}', [StudentController::class, 'update']);
    Route::put('/students/{id}/status', [StudentController::class, 'updateStatus']);
    Route::delete('/students/{id}', [StudentController::class, 'destroy']);

    Route::get('/classrooms', [ClassroomController::class, 'index']);
    Route::post('/classrooms', [ClassroomController::class, 'store']);
    Route::put('/classrooms/{id}', [ClassroomController::class, 'update']);
    Route::delete('/classrooms/{id}', [ClassroomController::class, 'destroy']);

    Route::get('/academic-batches', [AcademicBatchController::class, 'index']);
    Route::post('/academic-batches', [AcademicBatchController::class, 'store']);
    Route::put('/academic-batches/{id}', [AcademicBatchController::class, 'update']);
    Route::delete('/academic-batches/{id}', [AcademicBatchController::class, 'destroy']);

    // Cek status user yang sedang login saat ini (opsional untuk frontend check)
    Route::get('/user', function (Request $request) {
        return $request->user()->load('classroom');
    });

    // Rute Inventaris Barang (Sarpras)
    Route::get('/inventaris', [InventarisController::class, 'index']);
    Route::post('/inventaris', [InventarisController::class, 'store']);
    Route::put('/inventaris/{id}', [InventarisController::class, 'update']);
    Route::delete('/inventaris/{id}', [InventarisController::class, 'destroy']);

    // Rute Peminjaman Barang
    Route::get('/peminjaman', [InventarisController::class, 'riwayatPeminjaman']);
    Route::post('/peminjaman', [InventarisController::class, 'pinjam']);
    Route::put('/peminjaman/{id}/kembalikan', [InventarisController::class, 'kembalikan']);
});

