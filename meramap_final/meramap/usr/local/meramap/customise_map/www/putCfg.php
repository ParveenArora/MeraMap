
<?php
include "meramapCfg.php";

$jsonStr =  $_REQUEST["json"];

# Note, user www-data needs write permission on this file!!
# Best bet is to do sudo chgrp www-data <filename>
#                        chmod g+w <filename>
#
$fh = fopen($cfgFile, 'w') or die("can't open file ".$cfgFile.".");
fwrite($fh, $jsonStr);
fclose($fh);

echo "JSON String: ".$jsonStr." written to file ".$cfgFile.".";  

?>