<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('attendances', function (Blueprint $table) {
            $table->index('date');
            $table->index('student_id');
            $table->index('subject_id');
        });

        Schema::table('students', function (Blueprint $table) {
            $table->index('classroom_id');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('attendances', function (Blueprint $table) {
            $table->dropIndex(['attendances_date_index']);
            $table->dropIndex(['attendances_student_id_index']);
            $table->dropIndex(['attendances_subject_id_index']);
        });

        Schema::table('students', function (Blueprint $table) {
            $table->dropIndex(['students_classroom_id_index']);
        });
    }
};
