<?php
function smarty_modifier_nicovideoform($str) {
	require_once('MTUtil.php');
	require_once('function.mtsmilevideo.php');
	$ctx = array();
	$replace = 'return smarty_function_mtsmilevideo(array("video_id"=>$matches[1]),$ctx);';
	return preg_replace_callback('/\[nicovideo\]([\w]+)\[\/nicovideo\]/s',create_function('$matches',$replace),$str);
}
?>