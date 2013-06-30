<?php
require_once('iddy.inc.php');
function smarty_function_mtiddyhobby($args, &$ctx)
{
    $content = get_iddy_profile_tag($ctx,"hobby");
    $content = str_replace(",",$args['glue'],$content);
    return $content;
}
?>