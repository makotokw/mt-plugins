<?php
function smarty_function_mtsblivedoorclip($args, &$ctx) {
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
    
    $ret .= '<a href="http://clip.livedoor.com/clip/add?link='.$entry_link.'&amp;title='.$entry_title.'&amp;jump=ref">';
    if ($image != 0) {
         $ret .= '<img src="'.$static_link.'/plugins/MTSocialBookmarks/livedoorclip.gif"'
              . ' width="16" height="16" style="vertical-align:middle; border: none;"'
              . ' alt="livedoorクリップへ追加"/>'
              ;
    }
    if ($text != 0) $ret .= 'livedoorクリップ';
    $ret .= '</a>';
    
    if ($users != 0) {
        $ret .= '<a href="http://clip.livedoor.com/clip/add?link='.$entry_link.'&amp;title='.$entry_title.'&amp;jump=ref">'
             . '<img src="http://image.clip.livedoor.com/counter/'.$entry_link.'" style="vertical-align:middle; border:0" alt="このエントリーのlivedoorクリップ数"/>'
             . '</a>';
    }
    
    return $ret;
}
?>