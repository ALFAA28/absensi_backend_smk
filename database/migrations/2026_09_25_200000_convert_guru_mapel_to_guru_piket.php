<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    /**
     * Ubah semua akun guru_mapel menjadi guru_piket
     * agar guru piket dapat mengakses absensi semua jurusan.
     */
    public function up(): void
    {
        DB::table('users')
            ->where('role', 'guru_mapel')
            ->update(['role' => 'guru_piket']);
    }

    /**
     * Rollback: kembalikan guru_piket ke guru_mapel
     * (hanya yang sebelumnya guru_mapel — tidak bisa dibedakan, jadi rollback tidak sempurna)
     */
    public function down(): void
    {
        // Tidak ada cara aman untuk rollback karena tidak bisa membedakan
        // mana yang awalnya guru_mapel vs guru_piket
    }
};
