<?php
function smarty_function_mtsmilevideo($args, &$ctx) {
	require_once('modifier.encode_url.php');
	require_once('mtsmilevideo.inc.php');
	$video_id   = (!array_key_exists('video_id',$args)) ? "" : $args['video_id'];
	if (empty($video_id)) return;
	$item = mtsmilevideo_getitem($video_id,$ctx);
	if (!$item) exit;

	$item['view_counter'] = number_format($item['view_counter'],',');
	$item['comment_num'] = number_format($item['comment_num'],',');
	$item['mylist_counter'] = number_format($item['mylist_counter'],',');
	$item['first_retrieve'] = date('Y/m/d H:i', $item['first_retrieve']);
	$item['description'] = mtsmilevideo_ellipse_summary($item['description'], 50);

	$tpl = <<<EOT
<div class="smilevideo-item">
<table border="0" cellpadding="4" cellspacing="0" style="margin-bottom:4px;">
<td><a href="http://www.nicovideo.jp/" target="_blank"><img src="http://res.nicovideo.jp/img/thumb/nico/logo_w.gif" alt="ニコニコ動画"></a></td>
<td><img src="http://res.nicovideo.jp/img/thumb/nico/txt_video.gif" alt="VIDEO"></td>
</tr>
</table>
<div style="padding:4px;">
<p class="TXT10">
再生：<strong>{view_counter}</strong>
コメント：<strong>{comment_num}</strong>
マイリスト：<strong>{mylist_counter}</strong>
</p>
<table border="0" cellpadding="0" cellspacing="0" summary="" style="margin-top:2px;">
<tr valign="top">
<td>
<p><a href="{watch_url}} target="_blank"><img alt="" src="{thumbnail_url}" class="video_img"></a></p>
<p class="TXT10" style="margin-top:2px;"><strong>{length}</strong></p>
</td>
<td style="padding-left:4px;">
<p class="TXT10">
<strong>{first_retrieve}</strong> 投稿
</p>
<p class="TXT12"><a href="{watch_url}" target="_blank" class="video">{title}</a></p>
<p class="TXT10">{description}</p>
</td>
</tr>
</table>
<div class="video_res">{last_res_body}</div>
</div>
</div>
EOT;
	foreach ($item as $key => $value) {
		$tpl = preg_replace("/{".$key."}/i", $value, $tpl);
	}
	return $tpl;
}
?>