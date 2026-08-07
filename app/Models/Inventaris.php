<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Inventaris extends Model
{
    protected $table = 'inventaris';

    protected $fillable = ['kode', 'nama', 'kategori', 'jumlah', 'kondisi'];

    public function peminjaman()
    {
        return $this->hasMany(Peminjaman::class, 'inventaris_id');
    }
}
