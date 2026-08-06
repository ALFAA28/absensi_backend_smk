<?php
$dsn = 'pgsql:host=ep-morning-leaf-azbrhfcn-pooler.c-3.ap-southeast-1.aws.neon.tech;port=5432;dbname=neondb;sslmode=require;options=endpoint=ep-morning-leaf-azbrhfcn';
try {
    $pdo = new PDO($dsn, 'neondb_owner', 'npg_FIqoY9ga7CQ0');
    echo 'Connected with endpoint option!' . PHP_EOL;
} catch (PDOException $e) {
    echo 'Failed with endpoint option: ' . $e->getMessage() . PHP_EOL;
}

$dsn2 = 'pgsql:host=ep-morning-leaf-azbrhfcn-pooler.c-3.ap-southeast-1.aws.neon.tech;port=5432;dbname=neondb;sslmode=require';
try {
    $pdo = new PDO($dsn2, 'neondb_owner', 'npg_FIqoY9ga7CQ0');
    echo 'Connected without endpoint option!' . PHP_EOL;
} catch (PDOException $e) {
    echo 'Failed without endpoint option: ' . $e->getMessage() . PHP_EOL;
}
