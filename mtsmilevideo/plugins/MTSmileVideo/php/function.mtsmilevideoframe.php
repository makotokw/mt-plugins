<?php
function smarty_function_mtsmilevideoframe($args, &$ctx) {
    $video_id   = (!array_key_exists('video_id',$args)) ? "" : $args['video_id'];
    if (empty($video_id)) return;
$contents = <<<EOF
<iframe src="http://www.nicovideo.jp/thumb/{$video_id}" width="312" height="176" scrolling="no" style="border:solid 1px #CCC;" frameborder="0"/>
EOF;
    return $contents;
}
?>