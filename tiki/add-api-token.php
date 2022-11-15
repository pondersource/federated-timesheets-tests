<?php
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

$valid = strtotime("+1 year");
$sql = 'insert into tiki_api_tokens values (null, "manual", "admin", "testnet-supersecret-token", null, null, 1668460845, 1668460845, ' . $valid . ', 1)';
$result = $conn->query($sql);