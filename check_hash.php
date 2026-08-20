<?php
$conn_str = "host=absensi-db-31236.j77.aws-ap-southeast-3.cockroachlabs.cloud port=26257 dbname=neondb user=smknu-absensi password=Gj7GUPYBmBsWwZGrjmAcRw options='--cluster=absensi-db-31236'";
$db = pg_connect($conn_str);

$query = "SELECT password FROM users WHERE email = 'test12345@gmail.com'";
$result = pg_query($db, $query);
$row = pg_fetch_assoc($result);

echo "Hash from server: " . $row['password'] . "\n";
