<?php
header('Content-Type: text/html;charset=UTF-8');
// Write the contents to the file, 

//file_put_contents($_GET["url"], json_decode(urldecode($_GET["data"])));

file_put_contents($_POST["url"], json_decode($_POST["data"]));
?>