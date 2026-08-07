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
        Schema::create('inventaris', function (Blueprint $table) {
            $table->id();
            $table->string('kode')->unique();       // Contoh: "INV-001"
            $table->string('nama');                  // Contoh: "Proyektor Epson"
            $table->string('kategori');              // Elektronik, Furniture, Aksesoris, Lainnya
            $table->integer('jumlah')->default(0);
            $table->string('kondisi')->default('Baik'); // Baik, Rusak Ringan, Rusak Berat
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('inventaris');
    }
};
