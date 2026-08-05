<?php
// app/Models/Violation.php
namespace App\Models;
use Illuminate\Database\Eloquent\Model;

class Violation extends Model
{
    protected $fillable = ['student_id', 'academic_year_id', 'created_by', 'date', 'type', 'notes'];
    public function student()
    {
        return $this->belongsTo(Student::class);
    }
}