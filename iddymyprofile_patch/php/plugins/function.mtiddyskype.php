<?php
require_once('iddy.inc.php');
function smarty_function_mtiddyskype($args, &$ctx)
{
    $content = get_iddy_profile_tag($ctx,"skype");
    return $content;
}
?>