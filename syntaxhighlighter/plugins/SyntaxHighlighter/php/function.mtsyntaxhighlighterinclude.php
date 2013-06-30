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
function smarty_function_mtsyntaxhighlighterinclude($args, &$ctx) {
    $blog_id = $ctx->stash('blog_id') || $ctx->var('blog_id');
    if (empty($blog_id)) return '';
    $config = $ctx->mt->db()->fetch_plugin_config('SyntaxHighlighter', "blog:$blog_id");
    //if ($config) $version = @$config['syntaxhighlighter_version'];
    //$spverlist = array('1.5'=>'15','2.0'=>'20','2'=>'20');
    //if (empty($version) || !array_key_exists($version,$spverlist)) { $version = '15'; }
    //else { $version = $spverlist[$version]; }
    $version = '20';
    $brush = (!array_key_exists('brush',$args)) ? '' : strtolower($args['brush']);
    $theme = (!array_key_exists('theme',$args)) ? 'Default' : $args['theme'];
    $func = "get_mtsyntaxhighlighterinclude{$version}";
    return $func($brush, $theme, $config, $ctx);
}

function get_mtsyntaxhighlighterinclude15($brush, $theme, $config, &$ctx) {
    $version = '1.5';
    require_once('function.mtstaticwebpath.php');
    $swpath = smarty_function_mtstaticwebpath($args, $ctx);
    if (!preg_match('/\/$/',$swpath)) $swpath.='/';
    $shpath = $swpath.'plugins/SyntaxHighlighter/'.$version;
    $spbrushlist = array(
        'cpp'=>'shBrushCpp',
        'csharp'=>'shBrushCSharp',
        'css'=>'shBrushCss',
        'delphi'=>'shBrushDelphi',
        'jscript'=>'shBrushJScript',
        'java'=>'shBrushJava',
        'php'=>'shBrushPhp',
        'python'=>'shBrushPython',
        'sql'=>'shBrushSql',
        'vb'=>'shBrushVb',
        'xml'=>'shBrushXml'
    );
    $brushes = (empty($brush)) ? array_keys($spbrushlist) : explode(",",$brush);
    $cotent = <<<EOF
<link rel="stylesheet" type="text/css" charset="utf-8" href="$shpath/Styles/SyntaxHighlighter.css"/>

EOF;

    $jslist = array('shCore');
    foreach ($brushes as $b) {
        if (array_key_exists($b,$spbrushlist)) {
           $jslist[] = $spbrushlist[$b];
        }
    }
    
    foreach ($jslist as $js) {
        $cotent .= <<<EOF
<script type="text/javascript" src="{$shpath}/Scripts/{$js}.js"></script>

EOF;
    }
        $cotent .= <<<EOF
<script type="text/javascript">
function initSyntaxHighlighter() {
	dp.SyntaxHighlighter.ClipboardSwf = '$shpath/Scripts/clipboard.swf';
	dp.SyntaxHighlighter.HighlightAll('code');
}
if ('function' == typeof(mtAttachEvent)) mtAttachEvent("load",initSyntaxHighlighter);
else window.onload = initSyntaxHighlighter;
</script>

EOF;
    return $cotent;
}

function get_mtsyntaxhighlighterinclude20($brush, $theme, $config, &$ctx) {
    $version = '2.0';
    require_once('function.mtstaticwebpath.php');
    $swpath = smarty_function_mtstaticwebpath($args, $ctx);
    if (!preg_match('/\/$/',$swpath)) $swpath.='/';
    $shpath = $swpath.'plugins/SyntaxHighlighter/'.$version;
    $spthemelist = array(
        'default'=>'shThemeDefault',
        'django'=>'shThemeDjango',
        'emacs'=>'shThemeEmacs',
        'fadetogrey'=>'shThemeFadeToGrey',
        'midnight'=>'shThemeMidnight',
        'rdark'=>'shThemeRDark'
    );

    $spbrushlist = array(
        'as3'=>'shBrushAS3',
        'actionscript3'=>'shBrushAS3',
        'bash'=>'shBrushBash',
        'shell'=>'shBrushBash',
        'c-sharp'=>'shBrushCSharp',
        'csharp'=>'shBrushCSharp',
        'cpp'=>'shBrushCpp',
        'c'=>'shBrushCpp',
        'css'=>'shBrushCss',
        'delphi'=>'shBrushDelphi',
        'pas'=>'shBrushDelphi',
        'pascal'=>'shBrushDelphi',
        'diff'=>'shBrushDiff',
        'patch'=>'shBrushDiff',
        'groovy'=>'shBrushGroovy',
        'js'=>'shBrushJScript',
        'jscript'=>'shBrushJScript',
        'javascript'=>'shBrushJScript',
        'java'=>'shBrushJava',
        'jfx'=>'shBrushJavaFX',
        'javafx'=>'shBrushJavaFX',
        'perl'=>'shBrushPerl',
        'pl'=>'shBrushPerl',
        'php'=>'shBrushPhp',
        'plain'=>'shBrushPlain',
        'text'=>'shBrushPlain',
        'ps'=>'shBrushPowerShell',
        'powershell'=>'shBrushPowerShell',
        'py'=>'shBrushPython',
        'python'=>'shBrushPython',
        'rails'=>'shBrushRuby',
        'ror'=>'shBrushRuby',
        'ruby'=>'shBrushRuby',
        'scala'=>'shBrushScala',
        'sql'=>'shBrushSql',
        'vb'=>'shBrushVb',
        'vbnet'=>'shBrushVb',
        'xml'=>'shBrushXml',
        'xhtml'=>'shBrushXml',
        'xslt'=>'shBrushXml',
        'html'=>'shBrushXml',
        'xhtml'=>'shBrushXml'
    );
    if ($theme == '' || !array_key_exists($theme,$spthemelist)) { $theme = 'default'; }
    $themefile = $spthemelist[$theme];
    $brushes = (empty($brush)) ? array_keys($spbrushlist) : explode(",",$brush);
    $cotent = <<<EOF
<link rel="stylesheet" type="text/css" charset="utf-8" href="{$shpath}/styles/shCore.css"/>
<link rel="stylesheet" type="text/css" charset="utf-8" href="{$shpath}/styles/{$themefile}.css"/>

EOF;

    $jslist = array('shCore');
    $use_legacy = @$config['syntaxhighlighter_15compatible'];
    if ($use_legacy==1) $jslist[] = 'shLegacy';
    foreach ($brushes as $b) {
        if (array_key_exists($b,$spbrushlist) && !in_array($b, $jslist)) {
           $jslist[] = $spbrushlist[$b];
        }
    }
    foreach ($jslist as $js) {
        $cotent .= <<<EOF
<script type="text/javascript" src="{$shpath}/scripts/{$js}.js"></script>

EOF;
    }
        $cotent .= <<<EOF
<script type="text/javascript">
	SyntaxHighlighter.config.clipboardSwf = '$shpath/scripts/clipboard.swf';
	SyntaxHighlighter.all();
</script>
EOF;
if ($use_legacy==1) {
        $cotent .= <<<EOF
<script type="text/javascript">
	dp.SyntaxHighlighter.HighlightAll('code');
</script>
EOF;
}
    return $cotent;
}
?>