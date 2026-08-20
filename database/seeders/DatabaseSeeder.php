<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    use WithoutModelEvents;

    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        // User::factory(10)->create();

        // Contoh membuat akun via php artisan tinker
        User::create([
            'name' => 'Staf Sarpras',
            'email' => 'sarpras@gmail.com',
            'password' => 'pw123',
            'role' => 'sarpras'
        ]);

        User::create([
            'name' => 'Pak Budi (Guru)',
            'email' => 'guru@gmail.com',
            'password' => 'pw123',
            'role' => 'guru'
        ]);

        User::create([
            'name' => 'Admin Sekolah',
            'email' => 'admin@gmail.com',
            'password' => 'pw123',
            'role' => 'admin'
        ]);
    }
}
