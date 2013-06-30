# DashbaordHatenaTrends
# Copyright (C) 2009 makoto_kw (http://makotokw.com)
# Released under the Artistic License
package MT::Plugin::DashboardHatenaTrends;

use strict;
use warnings;
use utf8;

use MT;
use MT::Log;
use base qw(MT::Plugin);
use MT::I18N qw( encode_text );

use LWP::Simple;
use Date::Simple;
use XML::Simple;

my $plugin = MT::Plugin::DashboardHatenaTrends->new({
    id => 'proj.movabletype.dashboardhatenatrends',
    label => 'DashbaordHatenaTrends',
    version => 0.1.1,
    description => 'Displays Hatene Hot Keywords',
    author => 'Makoto Kawasaki',
    name => 'DashbaordHatenaTrends',
    author_link => 'http://www.makotokw.com/',
    blog_config_template => <<TMPL,
<dl>
<dt>display count(1-100)</dt>
<dd><input name="hhk_displaycount" size="20" value="<mt:var name="hhk_displaycount">"/></dd>
</dl>
TMPL
    settings => new MT::PluginSettings([
        ['hhk_displaycount'],
    ]),
});

MT->add_plugin($plugin);
sub instance { $plugin }

sub init_registry {
    my $plugin = shift;
    $plugin->registry({
        applications => {
            cms => {
                widgets => {
                    DashboardHatenaTrends => {
                        label => 'Hatena Trends',
                        template => 'hatenatrends.tmpl',
                        set => 'sidebar',
                        singular => 1,
                        handler => \&_hdlr_hatenatrends_widget,
                    },
                },
            }
        },
    });
}

our $hhk_feed_url = 'http://d.hatena.ne.jp/hotkeyword?mode=rss';
sub _hdlr_hatenatrends_widget {
    my $app = shift;
    my ($tmpl, $param) = @_;
    
    my $q = $app->param;
    my $blog_id = $q->param('blog_id');
    my $config = $plugin->get_config_hash('blog:'.$blog_id); 
    my $displaycount = $config->{hhk_displaycount};
    
    my $trycount = 7; # try 7 days
    my $trydate = Date::Simple->new;
    my $ua = $app->new_ua;
    
    local $XML::Simple::PREFERRED_PARSER = 'XML::Parser';
    
    while ($trycount>0)
    {
        my $url = $hhk_feed_url.'&Date='.$trydate->format("%Y-%m-%d");
        my $xml = LWP::Simple::get($url);
         
        if (defined($xml))
        {
            utf8::encode($xml) if MT->version_number < 5;
            my $ref = XMLin($xml);
            my $items = $ref->{item};
            if ($displaycount>0 && $displaycount<=100) {
                @{$param->{keywords}} = @{$ref->{item}}[0..$displaycount-1];
            } else {
                $param->{keywords} = $ref->{item};
            }
             $param->{date} = $trydate->format("%Y-%m-%d");
            last;
        }
        $trydate = $trydate->prev;
        $trycount--;
    }
    1;
}

1;