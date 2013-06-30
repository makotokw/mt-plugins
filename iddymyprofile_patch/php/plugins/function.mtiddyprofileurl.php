<?php
require_once('iddy.inc.php');
function smarty_function_mtiddyprofileurl($args, &$ctx)
{
    $content = get_iddy_profile_tag($ctx,"profileurl");
    return $content;
}
?>