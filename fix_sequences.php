<?php
$conn_str = "host=absensi-db-31236.j77.aws-ap-southeast-3.cockroachlabs.cloud port=26257 dbname=neondb user=smknu-absensi password=Gj7GUPYBmBsWwZGrjmAcRw options='--cluster=absensi-db-31236'";
$db = pg_connect($conn_str);

if (!$db) {
    echo "Connection failed: " . pg_last_error() . "\n";
    exit;
}

echo "=== Connected to CockroachDB successfully! ===\n\n";

// List of tables to fix
$tables = [
    'academic_years',
    'academic_batches',
    'classrooms',
    'subjects',
    'subject_jurusan',
    'users',
    'students',
    'attendances',
    'violations',
    'inventaris',
    'peminjaman',
    'personal_access_tokens'
];

foreach ($tables as $table) {
    // Check if table exists
    $chk = pg_query_params($db, "SELECT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = $1)", [$table]);
    $row = pg_fetch_row($chk);
    if (!$row || $row[0] !== 't') {
        echo "Table '$table' does not exist. Skipping.\n";
        continue;
    }

    // Get max id
    $res = pg_query($db, "SELECT MAX(id) FROM \"$table\"");
    if (!$res) {
        echo "Error querying max id for '$table': " . pg_last_error($db) . "\n";
        continue;
    }
    $maxRow = pg_fetch_row($res);
    $maxId = $maxRow[0];

    echo "Table: $table | Current MAX(id): " . ($maxId !== null ? $maxId : 'NULL') . "\n";

    if ($maxId !== null && is_numeric($maxId) && intval($maxId) > 0) {
        $maxInt = intval($maxId);
        $nextVal = $maxInt + 1;

        // In CockroachDB / Postgres, let's find the sequence or column default
        $colRes = pg_query_params($db, "
            SELECT column_default 
            FROM information_schema.columns 
            WHERE table_name = $1 AND column_name = 'id'
        ", [$table]);

        $defaultVal = '';
        if ($colRes && ($cRow = pg_fetch_row($colRes))) {
            $defaultVal = $cRow[0] ?? '';
            echo "  Column default: $defaultVal\n";
        }

        // Try method 1: setval with pg_get_serial_sequence
        $seqUpdated = false;
        $q1 = pg_query($db, "SELECT setval(pg_get_serial_sequence('\"$table\"', 'id'), $maxInt, true)");
        if ($q1) {
            echo "  [OK] setval with pg_get_serial_sequence succeeded.\n";
            $seqUpdated = true;
        } else {
            echo "  [Notice] pg_get_serial_sequence failed: " . trim(pg_last_error($db)) . "\n";
        }

        // Try method 2: setval with table_id_seq
        if (!$seqUpdated) {
            $seqName = "{$table}_id_seq";
            $q2 = pg_query($db, "SELECT setval('$seqName', $maxInt, true)");
            if ($q2) {
                echo "  [OK] setval('$seqName', $maxInt) succeeded.\n";
                $seqUpdated = true;
            } else {
                echo "  [Notice] setval('$seqName') failed: " . trim(pg_last_error($db)) . "\n";
            }
        }

        // Try method 3: ALTER SEQUENCE
        if (!$seqUpdated) {
            $seqName = "{$table}_id_seq";
            $q3 = pg_query($db, "ALTER SEQUENCE \"$seqName\" RESTART WITH $nextVal");
            if ($q3) {
                echo "  [OK] ALTER SEQUENCE \"$seqName\" RESTART WITH $nextVal succeeded.\n";
                $seqUpdated = true;
            } else {
                echo "  [Notice] ALTER SEQUENCE failed: " . trim(pg_last_error($db)) . "\n";
            }
        }

        // Try method 4: ALTER TABLE ... ALTER COLUMN id RESTART WITH ...
        if (!$seqUpdated) {
            $q4 = pg_query($db, "ALTER TABLE \"$table\" ALTER COLUMN id RESTART WITH $nextVal");
            if ($q4) {
                echo "  [OK] ALTER TABLE \"$table\" ALTER COLUMN id RESTART WITH $nextVal succeeded.\n";
                $seqUpdated = true;
            } else {
                echo "  [Notice] ALTER TABLE ALTER COLUMN failed: " . trim(pg_last_error($db)) . "\n";
            }
        }
    }
}

echo "\n--- TESTING INSERT INTO students ---\n";
// Let's test inserting a student to verify no duplicate key error happens!
$testNisn = "TEST_" . time();
$classroomRes = pg_query($db, "SELECT id FROM classrooms LIMIT 1");
$classroomId = 1;
if ($classroomRes && ($cRow = pg_fetch_row($classroomRes))) {
    $classroomId = $cRow[0];
}

$insQ = "INSERT INTO students (nisn, name, classroom_id, created_at, updated_at) VALUES ('$testNisn', 'TEST AUTO INC', $classroomId, NOW(), NOW()) RETURNING id";
$insRes = pg_query($db, $insQ);

if ($insRes && ($insRow = pg_fetch_row($insRes))) {
    $newId = $insRow[0];
    echo "SUCCESS! Inserted test student with generated ID = $newId\n";
    
    // Clean up
    pg_query($db, "DELETE FROM students WHERE id = $newId");
    echo "Cleaned up test student record (id: $newId)\n";
} else {
    echo "FAILED INSERT TEST: " . pg_last_error($db) . "\n";
}

pg_close($db);
