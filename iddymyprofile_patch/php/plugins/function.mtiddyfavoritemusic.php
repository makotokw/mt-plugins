<?php
require_once('iddy.inc.php');
function smarty_function_mtiddyfavoritemusic($args, &$ctx)
{
    $content = get_iddy_profile_tag($ctx,"favoritemusic");
	$content = str_replace(",",$args['glue'],$content);
    return $content;
}
?>