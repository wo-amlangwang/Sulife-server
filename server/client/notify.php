<?php

session_start();

$config = require_once('notify.config.php');

if(empty($config) || !is_array($config) || empty($config['email']) || empty($config['name']) || empty($config['subject']) || empty($config['message'])) {
    die('Empty config');
}

if(!empty($_POST['password']) && empty($_SESSION['auth'])) {
    if($_POST['password'] == $config['password']) {
        $_SESSION['auth'] = TRUE;
    }
}

if(empty($_SESSION['auth'])) {
    echo '<p>Enter your password to send notifications:</p><form action="notify.php" method="POST"><input type="password" name="password"><input type="submit" value="Send"></form>';
    die();
}

if(!isset($_GET['activate'])) {
    echo '<h2>Do you really want to send notifications about project launch to all subscribers on the list?</h2>';
    echo '<h3><a href="notify.php?password=' . $password . '&activate" style="margin-right: 50px">Send</a><a href="index.html">Do not send</a></h3>';
    die();
}

$headers = 'Content-type: text/html; charset="utf-8"\r\n';
$headers .= 'From: ' . $config['name'] . ' <' . $config['email'] . '>\r\n';
$headers .= 'Subject: ' . $config['subject'] . '\r\n';
$headers .= 'Content-type: text/html; charset="utf-8"';

$file = @fopen("subscription_list.txt", "r");

if($file) {
    $notifications_sent = 0;

    while($line = fgets($file)) {
        $email = trim($line);

        if(!$email) {
            continue;
        }

        $email = htmlspecialchars($email);
        $message = $config['message'];

        $send_result = mail($email, $config['subject'], $message, $headers);

        if($send_result) {
            $notifications_sent++;
            echo '<strong>' . $email . "</strong> has been notified.<br>";
        }
        else {
            echo 'Notification to <strong>' . $email . "</strong> failed.<br>";
        }
    }

    fclose($file);
}

echo "<br>-----------------------------<br>Notifications sent: " . $notifications_sent;
?>