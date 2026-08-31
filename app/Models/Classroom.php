<?php

// app/Models/Classroom.php
namespace App\Models;
use Illuminate\Database\Eloquent\Model;

class Classroom extends Model
{
    protected $fillable = ['name', 'grade', 'singkatan', 'academic_batch_id', 'user_id'];
    public function students()
    {
        return $this->hasMany(Student::class);
    }

    public function subjects()
    {
        return $this->belongsToMany(Subject::class, 'subject_jurusan', 'classroom_id', 'subject_id');
    }
}

