<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class AcademicBatch extends Model
{
    protected $fillable = ['name', 'year'];

    // Relasi ke kelas/jurusan jika diperlukan
    public function classrooms()
    {
        return $this->hasMany(Classroom::class);
    }
}