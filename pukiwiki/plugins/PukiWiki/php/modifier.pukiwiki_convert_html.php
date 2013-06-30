<?php
/*
 PukiWiki for Movable Type
 Copyright (C) 2009 makoto_kw (http://www.makotokw.com)
 License: GPL v2 or (at your option) any later version
 */
function smarty_modifier_pukiwiki_convert_html($text) {
	require_once('MTUtil.php');
	require_once('function.mtcgipath.php');
	global $mt;
	$ctx =& $mt->context();
	$path = smarty_function_mtcgipath($args, $ctx);
	$path .= 'plugins/PukiWiki/svc/';
	$ua = 'PukiWiki for Movable Type/0.1';
	return mt_pukiwiki_convert_html($ua, $path, $text);
}

function mt_pukiwiki_convert_html($ua, $path, $text) {
	$content = http_build_query(array('content'=>$text));
	$headers = array(
		'User-Agent: '.$ua,
		'Content-Type: application/x-www-form-urlencoded',
		'Content-Length: '.strlen($content),
	);
	$opt = array(
		'http' => array(
			'method'  => 'POST',
			'header'  => implode("\r\n", $headers),
			'content' => $content
		)
	);
	return file_get_contents($path, false, stream_context_create($opt));
}
?>