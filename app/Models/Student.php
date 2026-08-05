<?php
// app/Models/Student.php
namespace App\Models;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class Student extends Model
{
    use SoftDeletes;
    protected $fillable = ['nisn', 'name', 'classroom_id', 'status', 'status_keterangan'];

    public function classroom()
    {
        return $this->belongsTo(Classroom::class);
    }

    public function attendances()
    {
        return $this->hasMany(Attendance::class);
    }
}

