<?php
function mtsmilevideo_ellipse_summary($s,$len=40) {
	$s = preg_replace('/<\/?[^>]+>/i', '', $s);
	return (mb_strlen($s,'UTF-8') > $len) ? mb_substr($s, 0, $len-3,'UTF-8').'...' : $s;
}
function mtsmilevideo_getitem($video_id) {
	// require PHP5 or later
	if (!function_exists("simplexml_load_string")) return;
	$url = "http://ext.nicovideo.jp/api/getthumbinfo/{$video_id}";
	$xml = file_get_contents($url);
	if (empty($xml)) return;
	$d = simplexml_load_string($xml);
	$v = array();
	$atts = $d->attributes();
	if ("ok" == (string)$atts['status']) {
		$thumb = $d->thumb;
		return array(
			"video_id"=>(string)$thumb->video_id,
			"title"=>(string)$thumb->title,
			"description"=>(string)$thumb->description,
			"thumbnail_url"=>(string)$thumb->thumbnail_url,
			"first_retrieve"=>strtotime((string)$thumb->first_retrieve),
			"length"=>(string)$thumb->length,
			"view_counter"=>(int)$thumb->view_counter,
			"comment_num"=>(int)$thumb->comment_num,
			"mylist_counter"=>(int)$thumb->mylist_counter,
			"last_res_body"=>(string)$thumb->last_res_body,
			"watch_url"=>(string)$thumb->watch_url,
			"thumb_type"=>(string)$thumb->thumb_type,
			"embeddable"=>(int)$thumb->embeddable,
		);
	}
	return array();
}
?>