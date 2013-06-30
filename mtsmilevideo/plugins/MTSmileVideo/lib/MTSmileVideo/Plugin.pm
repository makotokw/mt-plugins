# MTSmileVideo plugin for Movable Type 4 or later
# Released under the Artistic License
package MTSmileVideo::Plugin;

use MT 4;
use strict;

use utf8;

use LWP::Simple;
use XML::Simple;
use POSIX qw(strftime);
use HTTP::Date qw(str2time);

use MTSmileVideo::VideoItem;

sub tag_smile_video {
    my ( $ctx, $args ) = @_;
    my $video_id = $args->{'video_id'};
    my (%item) = &mtsmilevideo_getitem($video_id);
    return if ( !%item );

    # format
    while ( $item{view_counter}   =~ s/(.*\d)(\d\d\d)/$1,$2/ ) { }
    while ( $item{comment_num}    =~ s/(.*\d)(\d\d\d)/$1,$2/ ) { }
    while ( $item{mylist_counter} =~ s/(.*\d)(\d\d\d)/$1,$2/ ) { }
    $item{first_retrieve} =
      strftime( "%Y/%m/%d %H:%M", localtime( $item{first_retrieve} ) );
    $item{description} = mtsmilevideo_ellipse_summary( $item{description}, 50 );

    my $tpl = <<EOT;
<div class="smilevideo-item">
<table border="0" cellpadding="4" cellspacing="0" style="margin-bottom:4px;">
<tr>
<td><a href="http://www.nicovideo.jp/" target="_blank"><img src="http://res.nicovideo.jp/img/thumb/nico/logo_w.gif" alt="ニコニコ動画"></a></td>
<td><img src="http://res.nicovideo.jp/img/thumb/nico/txt_video.gif" alt="VIDEO"></td>
</tr>
</table>
<div style="padding:4px;">
<p class="TXT10">
再生：<strong>{view_counter}</strong>
コメント：<strong>{comment_num}</strong>
マイリスト：<strong>{mylist_counter}</strong>
</p>
<table border="0" cellpadding="0" cellspacing="0" summary="" style="margin-top:2px;">
<tr valign="top">
<td>
<p><a href="{watch_url}} target="_blank"><img alt="" src="{thumbnail_url}" class="video_img"></a></p>
<p class="TXT10" style="margin-top:2px;"><strong>{length}</strong></p>
</td>
<td style="padding-left:4px;">
<p class="TXT10">
<strong>{first_retrieve}</strong> 投稿
</p>
<p class="TXT12"><a href="{watch_url}" target="_blank" class="video">{title}</a></p>
<p class="TXT10">{description}</p>
</td>
</tr>
</table>
<div class="video_res">{last_res_body}</div>
</div>
</div>
EOT

    while ( my ( $key, $value ) = each(%item) ) {
        $tpl =~ s/{$key}/$value/ig;
    }
    utf8::encode($tpl) if MT->version_number < 5;
    $tpl;
}

sub tag_smile_video_thumbnail {
    my ( $ctx, $args ) = @_;
    my $video_id = $args->{'video_id'};
    my (%item) = &mtsmilevideo_getitem($video_id);
    return if ( !%item );

    my $title         = $item{title};
    my $watch_url     = $item{watch_url};
    my $thumbnail_url = $item{thumbnail_url};

    my $contents = << "END_HTML";
<div class="smilevideo-thumbnail">
<a href="$watch_url" title="$title"><img class="video" src="$thumbnail_url" alt="$title"/></a>
</div>
END_HTML

    utf8::encode($contents) if MT->version_number < 5;
    $contents;
}

sub tag_smile_video_frame {
    my ( $ctx, $args ) = @_;
    my $video_id = $args->{'video_id'};
    my $contents = << "END_HTML";
<iframe src="http://www.nicovideo.jp/thumb/$video_id" width="312" height="176" scrolling="no" style="border:solid 1px #CCC;" frameborder="0"/>
END_HTML
    $contents;
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

sub filter_nicovideo_transform {
    my($text, $ctx) = @_;
    $text =~ s/\[nicovideo\]([\w]+)\[\/nicovideo\]/&tag_smile_video($ctx,{video_id=>$1})/esg;
    return $text;
}

sub filter_nicovideo_transform_line_breaks {
    return MT::Util::html_text_transform(filter_nicovideo_transform(@_));
}

sub filter_nicovideo_transform_when {
    my ($t) = @_;
    return 1 if $t && ($t eq 'entry' || $t eq 'page');
}

sub mtsmilevideo_ellipse_summary {
    my ( $s, $len ) = @_;
    $s =~ s/<\/?[^>]+>//ig;
    $s = ( length($s) > $len ) ? substr( $s, 0, $len - 3 ) . '...' : $s;
    return $s;
}

sub mtsmilevideo_getitem {
    my ($video_id) = @_;
    my $url        = "http://ext.nicovideo.jp/api/getthumbinfo/$video_id";
    my $xml        = LWP::Simple::get($url);
    return if ( !defined($xml) );
    local $XML::Simple::PREFERRED_PARSER = 'XML::Parser';
    my $data = XMLin($xml);
    if ( $data->{status} == 'ok' ) {
        my $thumb = $data->{thumb};
        #print Dumper($thumb);
        my %v = (
            video_id       => $thumb->{video_id},
            title          => $thumb->{title},
            description    => $thumb->{description},
            thumbnail_url  => $thumb->{thumbnail_url},
            first_retrieve => str2time( $thumb->{first_retrieve} ),
            length         => $thumb->{length},
            view_counter   => $thumb->{view_counter},
            comment_num    => $thumb->{comment_num},
            mylist_counter => $thumb->{mylist_counter},
            last_res_body  => $thumb->{last_res_body},
            watch_url      => $thumb->{watch_url},
            thumb_type     => $thumb->{thumb_type},
            embeddable     => $thumb->{embeddable},
        );
        return %v;
    }
}
1;