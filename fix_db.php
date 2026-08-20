<?php

require __DIR__.'/vendor/autoload.php';
$app = require_once __DIR__.'/bootstrap/app.php';
$app->make(\Illuminate\Contracts\Console\Kernel::class)->bootstrap();

$user = App\Models\User::where('email', 'admin@gmail.com')->first();
if ($user) {
    $user->password = 'admin123';
    $user->save();
    echo "BERHASIL_DIPERBAIKI_PASSWORD\n";
} else {
    echo "USER_TIDAK_KETEMU\n";
}
