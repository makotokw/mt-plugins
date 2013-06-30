<?php
function smarty_function_mtsbbuzzurl($args, &$ctx) {
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
    
    $ret .= '<a href="http://buzzurl.jp/entry/'.$entry_link.'">';
    if ($image != 0) {
         $ret .= '<img src="'.$static_link.'/plugins/MTSocialBookmarks/buzzurl.gif"'
              . ' width="21" height="15" style="vertical-align:middle; border: none;"'
              . ' alt="Buzzurlへ追加"/>'
              ;
    }
    if ($text != 0) $ret .= 'Buzzurl';
    $ret .= '</a>';
    if ($users != 0) {
        $ret .= '<a href="http://buzzurl.jp/entry/'.$entry_link.'">'
             . '<img src="http://api.buzzurl.jp/api/counter/'.$entry_link.'" style="vertical-align:middle; border:0" alt="このエントリーのBuzzurlブックマーク数"/>'
             . '</a>';
    }
    
    return $ret;
}
?>