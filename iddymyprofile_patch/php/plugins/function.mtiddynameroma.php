<?php
require_once('iddy.inc.php');
function smarty_function_mtiddynameroma($args, &$ctx)
{
    $content = get_iddy_profile_tag($ctx,"nameroma");
    return $content;
}
?>