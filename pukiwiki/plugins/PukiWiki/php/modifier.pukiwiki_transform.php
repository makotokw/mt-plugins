<?php
/*
 PukiWiki for Movable Type
 Copyright (C) 2009 makoto_kw (http://makotokw.com)
 License: GPL v2 or (at your option) any later version
 */
function smarty_modifier_pukiwiki_transform($str) {
	require_once('modifier.pukiwiki_convert_html.php');
	return '<div class="pukiwiki_content">'.smarty_modifier_pukiwiki_convert_html($str).'</div>';
}
?>