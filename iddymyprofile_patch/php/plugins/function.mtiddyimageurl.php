<?php
require_once('iddy.inc.php');
function smarty_function_mtiddyimageurl($args, &$ctx)
{
    $content = get_iddy_profile_tag($ctx,"imageurl");
    return $content;
}
?>