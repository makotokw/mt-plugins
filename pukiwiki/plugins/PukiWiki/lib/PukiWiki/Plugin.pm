# PukiWiki for Movable Type
# Copyright (C) 2009 makoto_kw (http://makotokw.com)
# License: GPL v2 or (at your option) any later version
package PukiWiki::Plugin;

use strict;
use MT 4;
use LWP::UserAgent;

our $VERSION = '0.1';
our $UA      = 'PukiWiki for Movable Type/' . $VERSION;

sub filter_pukiwiki_transform {
    my ( $text, $ctx ) = @_;
    '<div class="pukiwiki_content">' . convert_html($text) . '</div>';
}

sub filter_pukiwiki_transform_when {
    my ($t) = @_;
    return 1 if $t && ( $t eq 'entry' || $t eq 'page');
}

sub convert_html {
    my ($text) = @_;
    my $path = MT->config->CGIPath;
    if ( $path !~ /\/$/ ) { $path .= '/'; }
    $path .= 'plugins/PukiWiki/svc/';

    my $ua  = LWP::UserAgent->new;
    my $res = $ua->post(
        $path,
        { "content" => $text },
        "User-Agent"   => $UA,
        "Content-Type" => "application/x-www-form-urlencoded"
    );
    $res->content;
}

1;