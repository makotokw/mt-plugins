<?php
require_once('iddy.inc.php');
function smarty_function_mtiddyname($args, &$ctx)
{
    $content = get_iddy_profile_tag($ctx,"name");
    return $content;
}
?>