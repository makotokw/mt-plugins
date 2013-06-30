<?php
function smarty_modifier_nicovideoformlinebreaks($str) {
	require_once('MTUtil.php');
	require_once('modifier.nicovideoform.php');
	return html_text_transform(smarty_modifier_nicovideoform($str));
}
?>