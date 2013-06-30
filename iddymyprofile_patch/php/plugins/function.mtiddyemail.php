<?php
require_once('iddy.inc.php');
function smarty_function_mtiddyemail($args, &$ctx)
{
    $content = get_iddy_profile_tag($ctx,"mail");
    return $content;
}
?>