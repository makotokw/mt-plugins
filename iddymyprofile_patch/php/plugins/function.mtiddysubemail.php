<?php
require_once('iddy.inc.php');
function smarty_function_mtiddysubemail($args, &$ctx)
{
    $content = get_iddy_profile_tag($ctx,"submail");
    return $content;
}
?>