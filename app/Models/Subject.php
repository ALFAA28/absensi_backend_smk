<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Subject extends Model
{
    protected $fillable = ['kode_mapel', 'nama_mapel'];

    public function attendances()
    {
        return $this->hasMany(Attendance::class);
    }

    // Mapel terhubung ke Kelas/Jurusan
    public function classrooms()
    {
        return $this->belongsToMany(Classroom::class, 'subject_jurusan', 'subject_id', 'classroom_id');
    }
}
