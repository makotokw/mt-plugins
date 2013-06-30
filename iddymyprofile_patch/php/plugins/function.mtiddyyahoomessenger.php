<?php
require_once('iddy.inc.php');
function smarty_function_mtiddyyahoomessenger($args, &$ctx)
{
    $content = get_iddy_profile_tag($ctx,"yahoomessenger");
    return $content;
}
?>