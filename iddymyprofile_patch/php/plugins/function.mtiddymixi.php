<?php
require_once('iddy.inc.php');
function smarty_function_mtiddyxixi($args, &$ctx)
{
    $content = get_iddy_profile_tag($ctx,"mixi");
    return $content;
}
?>