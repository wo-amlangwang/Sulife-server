<?php

/* Notification letter config */

$config = Array(
    'password' => 'password', // Password to access notification page.
    'email' => 'email@example.com', // Your email address. It will go to "FROM" field.
    'name' => 'Almighty Notifier', // Your name. It will also go to "FROM" field.
    'subject' => 'You are AWESOME!', // The subject of your letter.
    'message' => 'Congratulations! You are awesome!' // The text of your letter. %s will be replaced with user name.
);

return $config;

?>