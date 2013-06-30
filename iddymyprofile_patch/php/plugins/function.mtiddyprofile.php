<?php
require_once('iddy.inc.php');
function smarty_function_mtiddyprofile($args, &$ctx)
{
    $content = get_iddy_profile_tag($ctx,"profile");
    return $content;
}
?>