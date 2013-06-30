<?php
require_once('iddy.inc.php');
function smarty_function_mtiddyfavoritefood($args, &$ctx)
{
    $content = get_iddy_profile_tag($ctx,"favoritefood");
	$content = str_replace(",",$args['glue'],$content);
    return $content;
}
?>