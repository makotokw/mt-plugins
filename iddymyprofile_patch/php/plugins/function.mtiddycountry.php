<?php
require_once('iddy.inc.php');
function smarty_function_mtiddycountry($args, &$ctx)
{
    $content = get_iddy_profile_tag($ctx,"country");
    return $content;
}
?>