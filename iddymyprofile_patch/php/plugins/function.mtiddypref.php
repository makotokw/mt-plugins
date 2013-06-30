<?php
require_once('iddy.inc.php');
function smarty_function_mtiddypref($args, &$ctx)
{
    $content = get_iddy_profile_tag($ctx,"pref");
    return $content;
}
?>