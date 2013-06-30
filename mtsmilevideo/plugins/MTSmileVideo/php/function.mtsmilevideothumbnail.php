<?php
function smarty_function_mtsmilevideothumbnail($args, &$ctx) {
	require_once('modifier.encode_url.php');
	require_once('mtsmilevideo.inc.php');
	$video_id   = (!array_key_exists('video_id',$args)) ? "" : $args['video_id'];
	if (empty($video_id)) return;
	$item = mtsmilevideo_getitem($video_id);
	if (!$item) exit;
	$title = $item["title"];
	$watch_url = $item["watch_url"];
	$thumbnail_url = $item["thumbnail_url"];
	$contents = <<<EOF
<div class="smilevideo-thumbnail">
<a href="{$watch_url}" title="{$title}"><img class="video" src="{$thumbnail_url}" alt="{$title}"/></a>
</div>
EOF;
	return $contents;
}
?>