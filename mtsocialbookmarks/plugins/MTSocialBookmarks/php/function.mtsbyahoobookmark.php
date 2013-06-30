<?php
function smarty_function_mtsbyahoobookmark($args, &$ctx) {
    require_once('function.mtentrypermalink.php');
    require_once('function.mtstaticwebpath.php');
    require_once('modifier.encode_url.php');
    
    $entry = $ctx->stash('entry');
    $image 	= (!array_key_exists('image',$args)) ? 1 : $args['image'];
    $text 	= (!array_key_exists('text',$args)) ? 0 : $args['text'];
    $users 	= (!array_key_exists('users',$args)) ? 0 : $args['users'];
    $domain = (!array_key_exists('$domain',$args)) ? 'co.jp' : $args['$domain'];
    
    $entry_title = smarty_modifier_encode_url($entry['entry_title']);
    $entry_link = smarty_function_mtentrypermalink($args, $ctx);
    $static_link = smarty_function_mtstaticwebpath($args, $ctx);
    
    $ret = '';
    if ($domain == 'co.jp')
    {
        $ret .= '<a href="#"'
         . " onclick=\"window.open('http://bookmarks.yahoo.co.jp/bookmarklet/showpopup?t=$entry_title&amp;u=$entry_link&amp;opener=bm&amp;ei=UTF-8'"
         . ",'popup','width=550px,height=480px,status=1,location=0,resizable=1,scrollbars=0,left=100,top=50',0); return false;\">";
        if ($image != 0) {
             $ret .= '<img src="'.$static_link.'/plugins/MTSocialBookmarks/yahoobookmarkjp.gif"'
                  . ' width="16" height="16" style="vertical-align:middle; border: none;"'
                  . ' alt="Yahoo!ブックマークへ追加"/>'
                  ;
        }
        if ($text != 0) $ret .= 'Yahoo!ブックマーク';
        $ret .= '</a>';
        
        if ($users != 0) {
            $ret .= '<script type="text/javascript" src="http://num.bookmarks.yahoo.co.jp/ybmno.php"></script>人が登録';
        }
    }
    return $ret;
}
?>