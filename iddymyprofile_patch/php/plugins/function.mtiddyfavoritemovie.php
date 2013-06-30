<?php
require_once('iddy.inc.php');
function smarty_function_mtiddyfavoritemovie($args, &$ctx)
{
    $content = get_iddy_profile_tag($ctx,"favoritemovie");
	$content = str_replace(",",$args['glue'],$content);
    return $content;
}
?>