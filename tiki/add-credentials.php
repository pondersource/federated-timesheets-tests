<?php
$timeldKey = file_get_contents(__DIR__ . "/timeld-key");
$timeldKey = rtrim($timeldKey);

$servername = getenv('TIKI_DB_HOST');
$username = getenv('TIKI_DB_USER');
$password = getenv('TIKI_DB_PASS');
$dbname = getenv('TIKI_DB_NAME');

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);
// Check connection
if ($conn->connect_error) {
  die("Connection failed: " . $conn->connect_error);
}

$sql = 'INSERT INTO tiki_source_auth VALUES ("prejournal","http","prejournal.local","/","basic","{\"username\":\"alice\",\"password\":\"alice123\"}","alice")';
$result = $conn->query($sql);
var_dump($result);

$sql = 'INSERT INTO tiki_source_auth VALUES ("timeld","http","timeld-gateway.local","/","basic","{\"username\":\"alice\",\"password\":\"' . mysqli_escape_string($conn, $timeldKey) . '\"}","alice")';
echo $sql;
$result = $conn->query($sql);
var_dump($result);