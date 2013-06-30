<?php
// Gravatar for Movable Type
// Copyright (C) 2009 makoto_kw (http://makotokw.com)
// Released under the Artistic License
function smarty_function_mtcommentgravatar($args, &$ctx) {
	$comment = $ctx->stash('comment');

	$name = trim($comment['comment_author']);
	$email = trim($comment['comment_email']);
	$size = (isset($args['size'])) ? $args['size'] : '32';
	
	$url = "http://www.gravatar.com/avatar.php?gravatar_id=".md5(strip_tags($email));
	$url .= (isset($args['rating'])) ? "&amp;rating=".$args['rating'] : "";
	$url .= "&amp;size=".$size;
	$url .= (isset($args['default'])) ? "&amp;default=".urlencode($args['default']) : "";
	
	return '<img class="avatar avatar-'.$size.'" width="'.$size.'" height="'.$size.'" src="'.$url.'" alt="'.$name.'"/>';
}
?>
