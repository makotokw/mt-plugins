# SyntaxHighlighter for Movable Type
#    Copyright (C) 2009 makoto_kw (http://www.makotokw.com)
# 
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
package SyntaxHighlighter::Plugin;

use strict;
use MT 4;

sub tag_sh_include {
    my ($ctx, $args) = @_;
    my $content = '';
    my $brush = (!exists($args->{'brush'})) ? '' : lc($args->{'brush'});
    my $theme = (!exists($args->{'theme'})) ? '' : lc($args->{'theme'});
    
    my $plugin = MT->component("SyntaxHighlighter");
    my $scope = "blog:".$ctx->stash('blog_id');
    
    my $version = '20';
    my $use_legacy = $plugin->get_config_value('syntaxhighlighter_15compatible',$scope);
    #my $version = $plugin->get_config_value('syntaxhighlighter_version',$scope);
    #my %spverlist = ('1.5'=>'15','2.0'=>'20','2'=>'20');
    #if ($version eq '' || !exists($spverlist{$version})) { $version = '15'; }
    #else { $version = $spverlist{$version}; }
    
    eval "\$content = \&tag_sh_include_$version(\$brush,\$theme,\$use_legacy)";
    return $content;
}

sub tag_sh_include_15 {
    my ($brush, $theme) = @_;
    my $version = '1.5';
    my $content = '';
    my %spbrushlist = (
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
    my @brushes = ($brush eq '') ? keys(%spbrushlist) : split(/,/, $brush);
    my $shpath = MT->config->StaticWebPath;
    if ($shpath !~ /\/$/) { $shpath .='/'; }
    $shpath .= "plugins/SyntaxHighlighter/$version";

    $content = <<"EOF"
<link rel="stylesheet" type="text/css" charset="utf-8" href="$shpath/Styles/SyntaxHighlighter.css"/>
EOF
;
    my @jslist = ('shCore');
    foreach my $b (@brushes) {
         $b =~ s/^[\s]+(.*?)[\s]+$/$1/;
         if (exists($spbrushlist{$b})) {
             push(@jslist,$spbrushlist{$b});
         }
    }
    foreach my $js (@jslist) {
        $content .= <<"EOF"
<script type="text/javascript" src="$shpath/Scripts/$js.js"></script>
EOF
;
     }
$content .= <<EOF
<script type="text/javascript">
function initSyntaxHighlighter() {
	dp.SyntaxHighlighter.ClipboardSwf = '$shpath/Scripts/clipboard.swf';
	dp.SyntaxHighlighter.HighlightAll('code');
}
if ('function' == typeof(mtAttachEvent)) mtAttachEvent("load",initSyntaxHighlighter);
else window.onload = initSyntaxHighlighter;
</script>
EOF
;
    return $content;
}

sub tag_sh_include_20 {
    my ($brush, $theme, $use_legacy) = @_;
    my $version = '2.0';
    my $content = '';
    my %spthemelist = (
        'default'=>'shThemeDefault',
        'django'=>'shThemeDjango',
        'emacs'=>'shThemeEmacs',
        'fadetogrey'=>'shThemeFadeToGrey',
        'midnight'=>'shThemeMidnight',
        'rdark'=>'shThemeRDark'
    );
    my %spbrushlist = (
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
    if ($theme eq '' || !exists($spthemelist{$theme})) { $theme = 'default'; }
    my @brushes = ($brush eq '') ? keys(%spbrushlist) : split(/,/, $brush);
    my $shpath = MT->config->StaticWebPath;
    if ($shpath !~ /\/$/) { $shpath .='/'; }
    $shpath .= "plugins/SyntaxHighlighter/$version";

    $content = <<"EOF"
<link rel="stylesheet" type="text/css" charset="utf-8" href="$shpath/styles/shCore.css"/>
<link rel="stylesheet" type="text/css" charset="utf-8" href="$shpath/styles/$spthemelist{$theme}.css"/>
EOF
;
    my @jslist = ('shCore');
    if ($use_legacy) {push(@jslist,'shLegacy');}
    foreach my $b (@brushes) {
         $b =~ s/^[\s]+(.*?)[\s]+$/$1/;
         if (exists($spbrushlist{$b}) && !in_array($spbrushlist{$b},@jslist)) {
             push(@jslist,$spbrushlist{$b});
         }
    }
    foreach my $js (@jslist) {
        $content .= <<"EOF"
<script type="text/javascript" src="$shpath/scripts/$js.js"></script>
EOF
;
     }
$content .= <<EOF
<script type="text/javascript">
	SyntaxHighlighter.config.clipboardSwf = '$shpath/scripts/clipboard.swf';
	SyntaxHighlighter.all();
</script>
EOF
;
    if ($use_legacy) {
$content .= <<EOF
<script type="text/javascript">
    dp.SyntaxHighlighter.HighlightAll('code');
</script>
EOF
;
    }
    return $content;
}

sub sh_transform {
    my ($class,$code,$version) = @_;
    if ($version eq '') { $version = '1.5'; }
    if ($version=='2.0') {
        return "<pre class='brush: $class'>".MT::Util::encode_html($code)."<\/pre>";
    } else {
        return "<pre name='code' class='$class'>".MT::Util::encode_html($code)."<\/pre>";
    }
}

sub filter_sh_transform {
    my($text, $ctx) = @_;
    my $version = '2.0';
    my $plugin = MT->component("SyntaxHighlighter");
    if (UNIVERSAL::can($ctx, 'stash') and my $blog_id = $ctx->stash('blog_id')) {
       #$version = $plugin->get_config_value('syntaxhighlighter_version',"blog:".$blog_id);
    }
    $text =~ s/\[code:([\w#+-]+)\](.*?)\[\/code\]/&sh_transform($1,$2,$version)/esg;
    return $text;
}

sub filter_sh_transform_line_breaks {
    return MT::Util::html_text_transform(filter_sh_transform(@_));
}

sub filter_sh_transform_when {
    my ($t) = @_;
    return 1 if $t && ($t eq 'entry' || $t eq 'page');
}

sub filter_sh_transform_linebreaks_when { 
    return filter_sh_transform_when(@_);
}
sub in_array {
    my ($needle, @haystack) = @_;
    foreach my $hs (@haystack) {
        return 1 if $hs eq $needle;
    }
    return 0;
}
1;