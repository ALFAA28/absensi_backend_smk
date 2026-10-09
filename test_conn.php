<?php
require __DIR__.'/vendor/autoload.php';
$app = require_once __DIR__.'/bootstrap/app.php';
$app->make(Illuminate\Contracts\Console\Kernel::class)->bootstrap();

try {
    DB::connection()->getPdo();
    echo "Connected successfully to: " . DB::connection()->getDatabaseName() . "\n";
} catch (\Exception $e) {
    echo "Could not connect to the database. Error:\n" . $e->getMessage() . "\n";
}
