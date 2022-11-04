<?php
  $db_tiki = 'mysqli';
  $dbversion_tiki = '21';
  $host_tiki = getenv('TIKI_DB_HOST');
  $user_tiki = getenv('TIKI_DB_USER');
  $pass_tiki = getenv('TIKI_DB_PASS');
  $dbs_tiki  = getenv('TIKI_DB_NAME');
  $client_charset = 'utf8mb4';
  foreach (glob('/var/www/conf.d/*.php') as $conf) { include($conf); }
