<?php
$conn_str = "host=absensi-db-31236.j77.aws-ap-southeast-3.cockroachlabs.cloud port=26257 dbname=neondb user=smknu-absensi password=Gj7GUPYBmBsWwZGrjmAcRw options='--cluster=absensi-db-31236'";
$db = pg_connect($conn_str);

if (!$db) {
    echo "Connection failed\n";
    exit;
}

// Laravel hashes "admin123" to:
$hashed_password = password_hash("admin123", PASSWORD_BCRYPT, ['cost' => 4]); // Since BCRYPT_ROUNDS=4 in .env

$query = "UPDATE users SET password = $1 WHERE email = 'admin@gmail.com'";
$result = pg_query_params($db, $query, array($hashed_password));

if ($result) {
    echo "BERHASIL DIPERBAIKI! Password di-reset langsung ke database.\n";
} else {
    echo "GAGAL UPDATE\n";
}
