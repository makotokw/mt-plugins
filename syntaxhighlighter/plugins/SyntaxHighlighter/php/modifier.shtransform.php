<?php
/*
    SyntaxHighlighter for Movable Type
    Copyright (C) 2009 makoto_kw (http://www.makotokw.com)

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
function smarty_modifier_shtransform($str) {
    require_once('MTUtil.php');
    /*
    global $mt;
    $ctx =& $mt->context();
    $blog_id = $ctx->stash('blog_id') || $ctx->var('blog_id');
    $config = $ctx->mt->db->fetch_plugin_config('SyntaxHighlighter', "blog:$blog_id");
    $version = @$config['syntaxhighlighter_version'];
    if ($version == '2.0') {
        $replace = 'return "<pre class=\"brush: $matches[1]\">".encode_html($matches[2])."</pre>";';
    } else {
        $replace = 'return "<pre name=\"code\" class=\"$matches[1]\">".encode_html($matches[2])."</pre>";';
    }*/
    $replace = 'return "<pre class=\"brush: $matches[1]\">".encode_html($matches[2])."</pre>";';
    return preg_replace_callback('/\[code:([\w#+-]+)\](.*?)\[\/code\]/s',create_function('$matches',$replace),$str);
}
?>