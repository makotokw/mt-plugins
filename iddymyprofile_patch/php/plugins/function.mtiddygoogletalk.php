<?php
require_once('iddy.inc.php');
function smarty_function_mtiddygoogletalk($args, &$ctx)
{
    $content = get_iddy_profile_tag($ctx,"googletalk");
    return $content;
}
?>