
<?php
include "meramapCfg.php";

if (file_exists($cfgFile)) {
    header('Content-Type: application/json');
    header('Expires: 0');
    header('Cache-Control: must-revalidate');
    ob_clean();
    flush();
    readfile($cfgFile);
    exit;
} else {
    header('Content-Type: text/html');
    print "Error ".$cfgFile." Not Found";
}
  

?>