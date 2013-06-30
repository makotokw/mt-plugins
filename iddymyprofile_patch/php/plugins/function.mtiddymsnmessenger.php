<?php
require_once('iddy.inc.php');
function smarty_function_mtiddymsnmessenger($args, &$ctx)
{
    $content = get_iddy_profile_tag($ctx,"msnmessenger");
    return $content;
}
?>