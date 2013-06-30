# MTSocialBookmarks for Movable Type 4 or later
# Author: makoto_kw (http://makotokw.com/)
# Copyright (C) 2008-2009 makoto_kw
# This file is licensed under the Artistic License, or the same
# terms as Perl itself.
package MTSocialBookmarks::Plugin;

use strict;
use MT 4;

sub tag_sb_hatena_bookmark {
    my ($ctx, $args) = @_;
    my $ret = q();
    my $image = ($args->{image} == '') ? 1 : $args->{image};
    my $text = ($args->{text} == '') ? 0 : $args->{text};
    my $users = ($args->{users} == '') ? 0 : $args->{users};
    my $entry = $ctx->stash('entry');
    
    return $ctx->error(MT->translate(
        "You used an '[_1]' tag outside of the context of an entry; " .
        "perhaps you mistakenly placed it outside of an 'MTEntries' container?",
        'MTSocialBookmarks')) unless $entry;
    
    my $static_link = MT->config->StaticWebPath;
    my $entry_link = $entry->permalink;
    my $entry_title = MT::Util::encode_url($entry->title);
    
    $ret .= '<a href="http://b.hatena.ne.jp/entry/'.$entry_link.'">';
    if ($image != 0) {
      $ret .= '<img src="'.$static_link.'/plugins/MTSocialBookmarks/hatenabookmark.gif"'
           . ' width="16" height="12" style="vertical-align:middle; border: none;"'
           . ' alt="このエントリーを含むはてなブックマーク"/>'
           ;
    }
    if ($text != 0) { $ret .= 'はてなブックマーク'; }
    $ret .= '</a>';
    
    if ($users != 0) {
        $ret .= '<a href="http://b.hatena.ne.jp/entry/'.$entry_link.'">'
             . '<img src="http://b.hatena.ne.jp/entry/image/'.$entry_link.'" style="vertical-align:middle; border: none;" alt="このエントリーのはてなブックマーク数"/>'
             . '</a>';
    }
    
    $ret;
}

sub tag_sb_buzzurl {
    my ($ctx, $args) = @_;
    my $ret = q();
    my $image = ($args->{image} == '') ? 1 : $args->{image};
    my $text = ($args->{text} == '') ? 0 : $args->{text};
    my $users = ($args->{users} == '') ? 0 : $args->{users};
    my $entry = $ctx->stash('entry');
    
    return $ctx->error(MT->translate(
        "You used an '[_1]' tag outside of the context of an entry; " .
        "perhaps you mistakenly placed it outside of an 'MTEntries' container?",
        'MTSocialBookmarks')) unless $entry;
    
    my $static_link = MT->config->StaticWebPath;
    my $entry_link = $entry->permalink;
    my $entry_title = MT::Util::encode_url($entry->title);
    
    $ret .= '<a href="http://buzzurl.jp/entry/'.$entry_link.'">';
    if ($image != 0) {
      $ret .= '<img src="'.$static_link.'/plugins/MTSocialBookmarks/buzzurl.gif"'
           . ' width="21" height="15" style="vertical-align:middle; border: none;"'
           . ' alt="Buzzurlへ追加"/>'
           ;
    }
    if ($text != 0) { $ret .= 'Buzzurl'; }
    $ret .= '</a>';
    
    if ($users != 0) {
        $ret .= '<a href="http://buzzurl.jp/entry/'.$entry_link.'">'
             . '<img src="http://api.buzzurl.jp/api/counter/'.$entry_link.'" style="vertical-align:middle; border:0" alt="このエントリーのBuzzurlブックマーク数"/>'
             . '</a>';
    }
    $ret;
}

sub tag_sb_livedoor_ciip {
    my ($ctx, $args) = @_;
    my $ret = q();
    my $image = ($args->{image} == '') ? 1 : $args->{image};
    my $text = ($args->{text} == '') ? 0 : $args->{text};
    my $users = ($args->{users} == '') ? 0 : $args->{users};
    my $entry = $ctx->stash('entry');
    
    return $ctx->error(MT->translate(
        "You used an '[_1]' tag outside of the context of an entry; " .
        "perhaps you mistakenly placed it outside of an 'MTEntries' container?",
        'MTSocialBookmarks')) unless $entry;
    
    my $static_link = MT->config->StaticWebPath;
    my $entry_link = $entry->permalink;
    my $entry_title = MT::Util::encode_url($entry->title);
    
    $ret .= '<a href="http://clip.livedoor.com/clip/add?link='.$entry_link.'&amp;title='.$entry_title.'&amp;jump=ref">'; 
    if ($image != 0) {
      $ret .= '<img src="'.$static_link.'/plugins/MTSocialBookmarks/livedoorclip.gif"'
           . ' width="16" height="16" style="vertical-align:middle; border: none;"'
           . ' alt="livedoorクリップへ追加" />'
           ;
    }
    if ($text != 0) { $ret .= 'livedoorクリップ'; }
    $ret .= '</a>';
    
    if ($users != 0) {
        $ret .= '<a href="http://clip.livedoor.com/clip/add?link='.$entry_link.'&amp;title='.$entry_title.'&amp;jump=ref">'
             . '<img src="http://image.clip.livedoor.com/counter/'.$entry_link.'" style="vertical-align:middle; border:0" alt="このエントリーのlivedoorクリップ数"/>'
             . '</a>';
    }
    
    $ret;
}

sub tag_sb_yahoo_bookmark {
    my ($ctx, $args) = @_;
    my $ret = q();
    my $image = ($args->{image} == '') ? 1 : $args->{image};
    my $text = ($args->{text} == '') ? 0 : $args->{text};
    my $users = ($args->{users} == '') ? 0 : $args->{users};
    my $domain = ($args->{domain} == '') ? 'co.jp' : $args->{domain};
    my $entry = $ctx->stash('entry');
    
    return $ctx->error(MT->translate(
        "You used an '[_1]' tag outside of the context of an entry; " .
        "perhaps you mistakenly placed it outside of an 'MTEntries' container?",
        'MTSocialBookmarks')) unless $entry;
    
    my $static_link = MT->config->StaticWebPath;
    my $entry_link = $entry->permalink;
    my $entry_title = MT::Util::encode_url($entry->title);
    
    if ($domain == 'co.jp') {
        $ret .= '<a href="#"'
             . " onclick=\"window.open('http://bookmarks.yahoo.co.jp/bookmarklet/showpopup?t=$entry_title&amp;u=$entry_link&amp;opener=bm&amp;ei=UTF-8'"
             . ",'popup','width=550px,height=480px,status=1,location=0,resizable=1,scrollbars=0,left=100,top=50',0); return false;\">"; 
        if ($image != 0) {
          $ret .= '<img src="'.$static_link.'/plugins/MTSocialBookmarks/yahoobookmarkjp.gif"'
               . ' width="16" height="16" style="vertical-align:middle; border: none;"'
               . ' alt="Yahoo!ブックマークへ追加" />'
               ;
        }
        if ($text != 0) { $ret .= 'Yahoo!ブックマーク'; }
        $ret .= '</a>';
        
        if ($users != 0) {
            $ret .= '<script type="text/javascript" src="http://num.bookmarks.yahoo.co.jp/ybmno.php"></script>人が登録';
        }
    }
    $ret;
}

sub tag_sb_pookmark_airlines {
    my ($ctx, $args) = @_;
    my $ret = q();
    my $image = ($args->{image} == '') ? 1 : $args->{image};
    my $text = ($args->{text} == '') ? 0 : $args->{text};
    my $users = ($args->{users} == '') ? 0 : $args->{users};
    my $entry = $ctx->stash('entry');
    
    return $ctx->error(MT->translate(
        "You used an '[_1]' tag outside of the context of an entry; " .
        "perhaps you mistakenly placed it outside of an 'MTEntries' container?",
        'MTSocialBookmarks')) unless $entry;
    
    my $static_link = MT->config->StaticWebPath;
    my $entry_link = $entry->permalink;
    my $entry_title = MT::Util::encode_url($entry->title);
    
    $ret .= '<a href="http://pookmark.jp/post?url='.$entry_link.'&amp;title='.$entry_title.'">';
    if ($image != 0) {
      $ret .= '<img src="'.$static_link.'/plugins/MTSocialBookmarks/pookmarkairlines.gif"'
           . ' width="18" height="12" style="vertical-align:middle; border: none;"'
           . ' alt="POOKMARK Airlinesへ追加" />'
           ;
    }
    if ($text != 0) { $ret .= 'POOKMARK Airlines'; }
    $ret .= '</a>';
    $ret;
}

sub tag_sb_saaf {
    my ($ctx, $args) = @_;
    my $ret = q();
    my $image = ($args->{image} == '') ? 1 : $args->{image};
    my $text = ($args->{text} == '') ? 0 : $args->{text};
    my $users = ($args->{users} == '') ? 0 : $args->{users};
    my $entry = $ctx->stash('entry');
    
    return $ctx->error(MT->translate(
        "You used an '[_1]' tag outside of the context of an entry; " .
        "perhaps you mistakenly placed it outside of an 'MTEntries' container?",
        'MTSocialBookmarks')) unless $entry;
    
    my $static_link = MT->config->StaticWebPath;
    my $entry_link = $entry->permalink;
    my $entry_title = MT::Util::encode_url($entry->title);
    
    $ret .= '<a href="http://bm.saaf.jp/bm/add?url='.$entry_link.'">';
    if ($image != 0) {
      $ret .= '<img src="'.$static_link.'/plugins/MTSocialBookmarks/saaf.gif"'
           . ' width="16" height="16" style="vertical-align:middle; border: none;"'
           . ' alt="Saafへ追加" />'
           ;
    }
    if ($text != 0) { $ret .= 'Saaf'; }
    $ret .= '</a>';
    $ret;
}

sub tag_sb_nfty_clip {
    my ($ctx, $args) = @_;
    my $ret = q();
    my $image = ($args->{image} == '') ? 1 : $args->{image};
    my $text = ($args->{text} == '') ? 0 : $args->{text};
    my $users = ($args->{users} == '') ? 0 : $args->{users};
    my $entry = $ctx->stash('entry');
    
    return $ctx->error(MT->translate(
        "You used an '[_1]' tag outside of the context of an entry; " .
        "perhaps you mistakenly placed it outside of an 'MTEntries' container?",
        'MTSocialBookmarks')) unless $entry;
    
    my $static_link = MT->config->StaticWebPath;
    my $entry_link = $entry->permalink;
    my $entry_title = MT::Util::encode_url($entry->title);
    
    $ret .= '<a href="http://clip.nifty.com/create?url='.$entry_link.'&amp;title='.$entry_title.'">';
    if ($image != 0) {
      $ret .= '<img src="'.$static_link.'/plugins/MTSocialBookmarks/niftyclip.gif"'
           . ' width="14" height="14" style="vertical-align:middle; border: none;"'
           . ' alt="ニフティクリップへ追加" />'
           ;
    }
    if ($text != 0) { $ret .= 'ニフティクリップ'; }
    $ret .= '</a>';
    $ret;
}

sub tag_sb_delicious {
    my ($ctx, $args) = @_;
    my $ret = q();
    my $image = ($args->{image} == '') ? 1 : $args->{image};
    my $text = ($args->{text} == '') ? 0 : $args->{text};
    my $users = ($args->{users} == '') ? 0 : $args->{users};
    my $entry = $ctx->stash('entry');
    
    return $ctx->error(MT->translate(
        "You used an '[_1]' tag outside of the context of an entry; " .
        "perhaps you mistakenly placed it outside of an 'MTEntries' container?",
        'MTSocialBookmarks')) unless $entry;
    
    my $static_link = MT->config->StaticWebPath;
    my $entry_link = $entry->permalink;
    my $entry_title = MT::Util::encode_url($entry->title);
    
    $ret .= '<a href="http://del.icio.us/post?url='.$entry_link.'&amp;title='.$entry_title.'">';
    if ($image != 0) {
      $ret .= '<img src="'.$static_link.'/plugins/MTSocialBookmarks/delicious.gif"'
           . ' width="10" height="10" style="vertical-align:middle; border: none;"'
           . ' alt="add to del.icio.us" />'
           ;
    }
    if ($text != 0) { $ret .= 'del.icio.us'; }
    $ret .= '</a>';
    $ret;
}

sub tag_sb_digg {
    my ($ctx, $args) = @_;
    my $ret = q();
    my $image = ($args->{image} == '') ? 1 : $args->{image};
    my $text = ($args->{text} == '') ? 0 : $args->{text};
    my $users = ($args->{users} == '') ? 0 : $args->{users};
    my $entry = $ctx->stash('entry');
    
    return $ctx->error(MT->translate(
        "You used an '[_1]' tag outside of the context of an entry; " .
        "perhaps you mistakenly placed it outside of an 'MTEntries' container?",
        'MTSocialBookmarks')) unless $entry;
    
    my $static_link = MT->config->StaticWebPath;
    my $entry_link = $entry->permalink;
    my $entry_title = MT::Util::encode_url($entry->title);
    
    $ret .= '<a href="http://digg.com/submit?phase=2&amp;url='.$entry_link.'">';
    if ($image != 0) {
      $ret .= '<img src="'.$static_link.'/plugins/MTSocialBookmarks/digg.gif"'
           . ' width="16" height="16" style="vertical-align:middle; border: none;"'
           . ' alt="add to Digg" />'
           ;
    }
    if ($text != 0) { $ret .= 'Digg'; }
    $ret .= '</a>';
    $ret;
}

sub tag_sb_reddit {
    my ($ctx, $args) = @_;
    my $ret = q();
    my $image = ($args->{image} == '') ? 1 : $args->{image};
    my $text = ($args->{text} == '') ? 0 : $args->{text};
    my $users = ($args->{users} == '') ? 0 : $args->{users};
    my $entry = $ctx->stash('entry');
    
    return $ctx->error(MT->translate(
        "You used an '[_1]' tag outside of the context of an entry; " .
        "perhaps you mistakenly placed it outside of an 'MTEntries' container?",
        'MTSocialBookmarks')) unless $entry;
    
    my $static_link = MT->config->StaticWebPath;
    my $entry_link = $entry->permalink;
    my $entry_title = MT::Util::encode_url($entry->title);
    
    $ret .= '<a href="http://reddit.com/submit?url='.$entry_link.'&amp;title='.$entry_title.'">';
    if ($image != 0) {
      $ret .= '<img src="'.$static_link.'/plugins/MTSocialBookmarks/reddit.gif"'
           . ' width="19" height="15" style="vertical-align:middle; border: none;"'
           . ' alt="add to Reddit" />'
           ;
    }
    if ($text != 0) { $ret .= 'Reddit'; }
    $ret .= '</a>';
    $ret;
}

1;
