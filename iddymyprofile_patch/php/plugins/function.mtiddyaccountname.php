<?php
require_once('iddy.inc.php');
function smarty_function_mtiddyaccountname($args, &$ctx)
{
    $content = get_iddy_profile_tag($ctx,"accountname");
    return $content;
}
?>