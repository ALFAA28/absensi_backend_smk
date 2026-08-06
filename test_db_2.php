<?php
$dsn = 'pgsql:host=ep-morning-leaf-azbrhfcn-pooler.c-3.ap-southeast-1.aws.neon.tech;port=5432;dbname=neondb;sslmode=require';
try {
    $pdo = new PDO($dsn, 'neondb_owner', 'npg_FIqoY9ga7CQ0$endpoint=ep-morning-leaf-azbrhfcn');
    echo 'Connected with endpoint in password!' . PHP_EOL;
} catch (PDOException $e) {
    echo 'Failed with endpoint in password: ' . $e->getMessage() . PHP_EOL;
}
