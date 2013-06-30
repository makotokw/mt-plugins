<?php
require_once('iddy.inc.php');
function smarty_function_mtiddynamekana($args, &$ctx)
{
    $content = get_iddy_profile_tag($ctx,"namekana");
    return $content;
}
?>