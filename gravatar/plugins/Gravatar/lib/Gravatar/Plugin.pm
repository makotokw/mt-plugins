# Gravatar for Movable Type
# Copyright (C) 2009 makoto_kw (http://makotokw.com)
# Released under the Artistic License
package Gravatar::Plugin;

use strict;
use MT 4;
use URI::Escape;
use Digest::MD5 qw(md5_hex);

sub tag_comment_gravatar {
    my ($ctx, $args) = @_;
    my $tag = $ctx->stash('tag');
    my $c = $ctx->stash($tag =~ /Preview/ ? 'comment_preview' : 'comment') 
    or return $ctx->_no_comment_error('MT' . $tag);
    
    my $email = $c->email;
    my $name = $c->author;
    my $size = exists $args->{size} ? "&amp;size=".$args->{size} : "32";
    
    my $url = "http://www.gravatar.com/avatar.php?gravatar_id=".md5_hex($email);
    $url .= exists $args->{rating} ? "&amp;rating=".$args->{rating} : "";
    $url .= "&amp;size=".$size;
    $url .= exists $args->{default} ? "&amp;default=".uri_escape($args->{default}) : "";
    
    return '<img class="avatar avatar-'.$size.'" width="'.$size.'" height="'.$size.'" src="'.$url.'" alt="'.$name.'"/>';
}
1;