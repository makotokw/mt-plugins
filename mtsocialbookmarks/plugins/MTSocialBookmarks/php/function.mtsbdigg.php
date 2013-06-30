<?php
function smarty_function_mtsbdigg($args, &$ctx) {
    require_once('function.mtentrypermalink.php');
    require_once('function.mtstaticwebpath.php');
    require_once('modifier.encode_url.php');
    
    $entry = $ctx->stash('entry');
    $image 	= (!array_key_exists('image',$args)) ? 1 : $args['image'];
    $text 	= (!array_key_exists('text',$args)) ? 0 : $args['text'];
    $users 	= (!array_key_exists('users',$args)) ? 0 : $args['users'];
    
    $entry_title = smarty_modifier_encode_url($entry['entry_title']);
    $entry_link = smarty_function_mtentrypermalink($args, $ctx);
    $static_link = smarty_function_mtstaticwebpath($args, $ctx);
    
    $ret .= '<a href="http://digg.com/submit?phase=2&amp;url='.$entry_link.'">';
    if ($image != 0) {
         $ret .= '<img src="'.$static_link.'/plugins/MTSocialBookmarks/digg.gif"'
              . ' width="16" height="16" style="vertical-align:middle; border: none;"'
              . ' alt="add to Digg"/>'
              ;
    }
    if ($text != 0) $ret .= 'Digg';
    $ret .= '</a>';
    return $ret;
}
?>