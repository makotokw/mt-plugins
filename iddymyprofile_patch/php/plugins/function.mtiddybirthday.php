<?php
require_once('iddy.inc.php');
function smarty_function_mtiddybirthday($args, &$ctx)
{
    $content = get_iddy_profile_tag($ctx,"birthday");
    return $content;
}
?>