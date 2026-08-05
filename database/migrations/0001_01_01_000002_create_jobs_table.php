<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        // 1. xxxx_xx_xx_000001_create_academic_years_table.php
        Schema::create('academic_years', function (Blueprint $table) {
            $table->id();
            $table->string('year'); // Contoh: "2025/2026"
            $table->enum('semester', ['Odd', 'Even']); // Ganjil/Genap
            $table->boolean('is_active')->default(false);
            $table->timestamps();
        });

        // 2. xxxx_xx_xx_000002_create_classrooms_table.php
        Schema::create('classrooms', function (Blueprint $table) {
            $table->id();
            $table->string('name'); // Contoh: "10 DKV A", "11 RPL B"
            $table->enum('grade', ['10', '11', '12']);
            $table->timestamps();
        });

        // 3. xxxx_xx_xx_000003_create_users_table.php (Sesuaikan bawaan Laravel)
        Schema::table('users', function (Blueprint $table) {
            $table->foreignId('classroom_id')->nullable()->constrained('classrooms')->onDelete('set null'); // Wali kelas mengampu kelas apa
        });

        // 4. xxxx_xx_xx_000004_create_students_table.php
        Schema::create('students', function (Blueprint $table) {
            $table->id();
            $table->string('nisn')->unique();
            $table->string('name');
            $table->foreignId('classroom_id')->constrained('classrooms');
            $table->timestamps();
            $table->softDeletes(); // Menampung histori (deleted_at) agar nama tidak hilang di rekap lama
        });

        // 5. xxxx_xx_xx_000005_create_attendances_table.php
        Schema::create('attendances', function (Blueprint $table) {
            $table->id();
            $table->foreignId('student_id')->constrained('students')->onDelete('cascade');
            $table->foreignId('subject_id')->constrained('subjects')->onDelete('cascade');
            $table->foreignId('academic_year_id')->constrained('academic_years')->onDelete('cascade');
            $table->foreignId('created_by')->nullable()->constrained('users')->onDelete('set null');
            $table->date('date');
            $table->enum('status', ['Hadir', 'Sakit', 'Izin', 'Alfa']);
            $table->text('notes')->nullable();
            $table->timestamps();
        });

        // 6. xxxx_xx_xx_000006_create_violations_table.php
        Schema::create('violations', function (Blueprint $table) {
            $table->id();
            $table->foreignId('student_id')->constrained();
            $table->foreignId('academic_year_id')->constrained();
            $table->foreignId('created_by')->constrained('users');
            $table->date('date');
            $table->string('type'); // Contoh: "Telat", "Atribut Tidak Lengkap"
            $table->text('notes')->nullable();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('academic_years');
        Schema::dropIfExists('classrooms');
        Schema::table('users', function (Blueprint $table) {
            $table->dropForeign(['classroom_id']);
            $table->dropColumn('classroom_id');
        });
        Schema::dropIfExists('students');
        Schema::dropIfExists('attendances');
        Schema::dropIfExists('violations');
    }
};
