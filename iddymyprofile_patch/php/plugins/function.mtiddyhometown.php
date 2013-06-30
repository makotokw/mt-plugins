<?php
require_once('iddy.inc.php');
function smarty_function_mtiddyhometown($args, &$ctx)
{
    $content = get_iddy_profile_tag($ctx,"hometown");
    return $content;
}
?>