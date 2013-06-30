<?php
require_once('iddy.inc.php');
function smarty_function_mtiddypersonaltag($args, &$ctx)
{
    $content = get_iddy_profile_tag($ctx,"personaltag");
    $content = str_replace(",",$args['glue'],$content);
    return $content;
}
?>