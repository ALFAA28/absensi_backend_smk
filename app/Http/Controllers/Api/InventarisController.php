<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use App\Models\Inventaris;
use App\Models\Peminjaman;

class InventarisController extends Controller
{
    // ========================
    // CRUD BARANG INVENTARIS
    // ========================

    // GET /api/inventaris — Ambil semua barang
    public function index()
    {
        $data = Inventaris::orderBy('created_at', 'desc')->get();
        return response()->json($data, 200);
    }

    // POST /api/inventaris — Tambah barang baru
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'kode' => 'required|string|unique:inventaris,kode',
            'nama' => 'required|string|max:255',
            'kategori' => 'required|string|max:100',
            'jumlah' => 'required|integer|min:0',
            'kondisi' => 'required|string|in:Baik,Rusak Ringan,Rusak Berat',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'message' => 'Validasi gagal',
                'errors' => $validator->errors()
            ], 422);
        }

        $barang = Inventaris::create($request->only(['kode', 'nama', 'kategori', 'jumlah', 'kondisi']));

        return response()->json([
            'message' => 'Barang berhasil ditambahkan',
            'data' => $barang
        ], 201);
    }

    // PUT /api/inventaris/{id} — Edit barang
    public function update(Request $request, $id)
    {
        $barang = Inventaris::find($id);
        if (!$barang) {
            return response()->json(['message' => 'Barang tidak ditemukan'], 404);
        }

        $validator = Validator::make($request->all(), [
            'kode' => 'required|string|unique:inventaris,kode,' . $id,
            'nama' => 'required|string|max:255',
            'kategori' => 'required|string|max:100',
            'jumlah' => 'required|integer|min:0',
            'kondisi' => 'required|string|in:Baik,Rusak Ringan,Rusak Berat',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'message' => 'Validasi gagal',
                'errors' => $validator->errors()
            ], 422);
        }

        $barang->update($request->only(['kode', 'nama', 'kategori', 'jumlah', 'kondisi']));

        return response()->json([
            'message' => 'Data barang berhasil diperbarui',
            'data' => $barang
        ], 200);
    }

    // DELETE /api/inventaris/{id} — Hapus barang
    public function destroy($id)
    {
        $barang = Inventaris::find($id);
        if (!$barang) {
            return response()->json(['message' => 'Barang tidak ditemukan'], 404);
        }

        $barang->delete();
        return response()->json(['message' => 'Barang berhasil dihapus'], 200);
    }

    // ========================
    // PEMINJAMAN BARANG
    // ========================

    // GET /api/peminjaman — Ambil semua riwayat peminjaman
    public function riwayatPeminjaman()
    {
        $data = Peminjaman::with('inventaris')
            ->orderBy('created_at', 'desc')
            ->get();

        return response()->json($data, 200);
    }

    // POST /api/peminjaman — Catat peminjaman baru + kurangi stok
    public function pinjam(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'inventaris_id' => 'required|exists:inventaris,id',
            'nama_peminjam' => 'required|string|max:255',
            'tanggal_pinjam' => 'required|date',
            'jumlah' => 'required|integer|min:1',
            'keterangan' => 'nullable|string',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'message' => 'Validasi gagal',
                'errors' => $validator->errors()
            ], 422);
        }

        $barang = Inventaris::find($request->inventaris_id);

        if ($request->jumlah > $barang->jumlah) {
            return response()->json(['message' => 'Jumlah pinjam melebihi stok tersedia!'], 422);
        }

        // Buat record peminjaman
        $pinjam = Peminjaman::create([
            'inventaris_id' => $request->inventaris_id,
            'nama_peminjam' => $request->nama_peminjam,
            'tanggal_pinjam' => $request->tanggal_pinjam,
            'jumlah' => $request->jumlah,
            'keterangan' => $request->keterangan,
            'status' => 'Sedang Dipinjam',
        ]);

        // Kurangi stok barang
        $barang->jumlah -= $request->jumlah;
        $barang->save();

        return response()->json([
            'message' => 'Peminjaman berhasil dicatat',
            'data' => $pinjam->load('inventaris'),
            'stok_sisa' => $barang->jumlah
        ], 201);
    }

    // PUT /api/peminjaman/{id}/kembalikan — Kembalikan barang + tambah stok
    public function kembalikan($id)
    {
        $pinjam = Peminjaman::find($id);
        if (!$pinjam) {
            return response()->json(['message' => 'Data peminjaman tidak ditemukan'], 404);
        }

        if ($pinjam->status === 'Dikembalikan') {
            return response()->json(['message' => 'Barang sudah dikembalikan sebelumnya'], 422);
        }

        // Update status peminjaman
        $pinjam->status = 'Dikembalikan';
        $pinjam->save();

        // Kembalikan stok
        $barang = Inventaris::find($pinjam->inventaris_id);
        if ($barang) {
            $barang->jumlah += $pinjam->jumlah;
            $barang->save();
        }

        return response()->json([
            'message' => 'Barang berhasil dikembalikan',
            'data' => $pinjam->load('inventaris'),
            'stok_sekarang' => $barang ? $barang->jumlah : null
        ], 200);
    }
}
