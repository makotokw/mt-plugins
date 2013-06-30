package MT::Plugin::MTmylo;

use MT 4;
use base qw( MT::Plugin );

my $enabled = 0;
our $VERSION = '0.10';
my $plugin = __PACKAGE__->new({
    name        => "MTmylo(mylo UI Support)",
    author_name => "<a href='http://blog.makotokw.com/'>makoto_kw</a>",
    description => "Provides an mylo-friendly UI for Movable Type. Once enabled, navigate to your MT installation from your mylo to use this interface.",
    version     => $VERSION,
    blog_config_template => <<TMPL,
<dl>
<dt><__trans phrase="Upload Destination"></dt>
<dd><input name="mylo_extra_path" size="20" value="<mt:var name="mylo_extra_path">"/></dd>
<dt><__trans phrase="Alignment"></dt>
<dd>
<select name="mylo_image_default_align">
<option value="none"<mt:if name="mylo_image_default_align" eq="none"> selected</mt:if>><__trans phrase="None"></option>
<option value="left"<mt:if name="mylo_image_default_align" eq="left"> selected</mt:if>><__trans phrase="Left"></option>
<option value="center"<mt:if name="mylo_image_default_align" eq="center"> selected</mt:if>><__trans phrase="Center"></option>
<option value="right"<mt:if name="mylo_image_default_align" eq="right"> selected</mt:if>><__trans phrase="Right"></option>
</select>
</dd>
<dt><__trans phrase="Use thumbnail"></dt>
<dd>
<input type="checkbox" name="mylo_image_default_thumb" value="1" <mt:if name="mylo_image_default_thumb">checked="checked" </mt:if>/>
<label for="create_thumbnail"><__trans phrase="Use thumbnail"></label>
(<label for="mylo_image_default_width"><__trans phrase="width:"></label>
<input name="mylo_image_default_width" id="mylo_image_default_width" value="<mt:var name="mylo_image_default_width">" size="4" /> <__trans phrase="pixels">)
</dd>
<dt><__trans phrase="Link image to full-size version in a popup window."></dt>
<dd>
<input type="checkbox" name="mylo_image_default_popup" id="mylo_image_default_popup" value="1" <mt:if name="mylo_image_default_popup">checked="checked" </mt:if>/>
<label for="mylo_image_default_popup"><__trans phrase="Link image to full-size version in a popup window."></label>
</dd>
</dl>
TMPL
    settings => new MT::PluginSettings([
        ['mylo_extra_path', { Default => 'mylo'} ],
        ['mylo_image_default_popup', { Default => 1} ],
        ['mylo_image_default_wrap_text', { Default => 1} ],
        ['mylo_image_default_thumb', { Default => 1} ],
        ['mylo_image_default_align', { Default => 'left'} ],
        ['mylo_image_default_width', { Default => '500'} ],
    ]),
    registry => {
        applications => {
            cms => {
                methods => {
                    mylo_main => \&mylo_main,
                    edit_entry => \&mylo_edit_entry,
                    edit_comment => \&mylo_edit_comment,
                    delete_confirm => \&mylo_delete_confirm,
                    set_comment_status => \&mylo_set_comment_status,
                    view => \&mylo_view,
                    # save_entry => \&mylo_save_entry,
                },
            },
        },
        callbacks => {
            template_param => \&page_param,
            'template_param.list_comment' => \&mylo_list_comment_param,
        },
    },
});
MT->add_plugin($plugin);

sub mylo_list_comment_param {
    return unless $enabled;
    my $cb = shift;
    my ($app, $param, $tmpl) = @_;

    if (my $pager_json = $param->{'pager_json'}) {
        # Fix parameters for pagination of comments (app listing method
        # no longer provides these, but populates a json value that is
        # handled by a javascript routine to display pagination in MT4).
        require JSON;
        my $pager = JSON::jsonToObj($pager_json);
        my $offset = $pager->{offset};
        my $limit = $pager->{limit};
        if ($offset) {
            $param->{prev_offset}     = 1;
            $param->{prev_offset_val} = $offset - $limit;
            $param->{prev_offset_val} = 0 if $param{prev_offset_val} < 0;
        }
        my $next_offset = ( $offset || 0 ) + $limit;
        if ($next_offset < $pager->{listTotal}) {
            $param->{next_offset}     = 1;
            $param->{next_offset_val} = $next_offset;
        }
    }
}

sub init_request {
    my $plugin = shift;
    my ($app) = @_;

    $enabled = 0;

    # user agent test; if mylo and CMS app, switch template directory
    if ($app->isa('MT::App::CMS')) {
        if (my $ua = $ENV{HTTP_USER_AGENT}) {
            if ( $ua =~ m!Sony\/(COM[0-9])/! ) {
                $app->config('mylo',$1);
                $enabled = 1;
                # Redirect 'dashboard' or 'default' modes to mylo_main
                $app->mode('mylo_main')
                    if ($app->mode eq 'default') || ($app->mode eq 'dashboard');

                $app->config('AltTemplatePath', $plugin->path . '/tmpl');
            }
        }
    }
}

sub mylo_view {
    my $app = shift;
    if ($enabled && ($app->param('_type') eq 'entry')) {
        # We replace the 'view' mode since after saving an entry,
        # we get redirected back to a view mode.
        return mylo_edit_entry($app, @_);
    }
    else {
        return undef;
    }
}

sub mylo_main {
    my $app = shift;
    my $param = {};
    $param->{blog_id} = $app->param('blog_id');
    $app->build_blog_selector($param);
    my $blog_loop = $param->{top_blog_loop} || [];
    foreach (@$blog_loop) {
        $_->{blog_name} = $_->{top_blog_name};
        $_->{blog_id} = $_->{top_blog_id};
    }
    $param->{blogs} = $blog_loop;
    $param->{user_has_weblog} = 1 if @$blog_loop;
    $app->load_tmpl('main.tmpl', $param);
}

sub mylo_set_comment_status {
    my $app = shift;
    my $id = $app->param('id');
    my $blog_id = $app->param('blog_id');
    $app->param('_type', 'comment');
    $app->return_args('__mode=list_comments&id=' . $id . '&blog_id=' . $blog_id);
    my $status = $app->param('status');
    if ( $status eq 'delete' ) {
        return $app->delete();
    }
    elsif ( $status eq 'junk' ) {
        return $app->handle_junk();
    }
    elsif ( $status eq '2' ) {
        return $app->approve_item();
    }
    else {
        return $app->unapprove_item();
    }
}

sub mylo_delete_confirm {
    my $app = shift;

    my $blog_id = $app->param('blog_id');
    my $type = $app->param('_type') || 'entry';
    my $param = {
        blog_id => $blog_id,
        id => $app->param('id'),
        type => $type,
        return => 'edit_entry',
        id_loop => [ $app->param('id') ],
        script_parent_url => $app->uri,
    };
    return $app->build_page('delete_confirm.tmpl', $param);
}

sub mylo_edit_comment {
    my $app = shift;
    $app->param('_type', 'comment');
    return $app->edit_object();
}

# sub mylo_save_entry {
#     my $app = shift;
#     return $app->save_entry(@_) unless $enabled;
# 
#     if ($app->param('preview_entry')) {
#         return $app->preview_entry(@_);
#     }
#     return $app->save_entry(@_);
# }

sub mylo_edit_entry {
    my $app = shift;

    $app->param('_type', 'entry');
    my $tmpl = $app->edit_object();

    my $sel_cats = $tmpl->param('selected_category_loop') || [];
    my @cat_loop;
    my $curr_cats = '';
    my $curr_cat_ids = '';
    my %selected;
    foreach my $sel (@$sel_cats) {
        my $cat = MT::Category->load($sel) or next;
        $curr_cats .= ', ' if $curr_cats ne '';
        $curr_cat_ids .= ',' if $curr_cat_ids ne '';
        $curr_cats .= $cat->label;
        $curr_cat_ids .= $cat->id;
        $selected{$cat->id} = 1;
    }

    my $c_data = $app->_build_category_list(
        blog_id => $app->blog->id,
        type    => 'category',
    );
    for my $row (@$c_data) {
        my $spacer = $row->{category_label_spacer} || '';
        push @cat_loop, {
            category_id => $row->{category_id},
            category_label => $spacer . MT::Util::encode_html($row->{category_label}),
            category_is_selected => $selected{$row->{category_id}} ? 1 : 0,
        };
    }
    $tmpl->param('category_loop', \@cat_loop);
    $tmpl->param('current_categories', $curr_cats);
    $tmpl->param('current_category_ids', $curr_cat_ids);
    return $tmpl;
}

sub page_param {
    return unless $enabled;

    my $cb = shift;
    my ($app, $param, $tmpl) = @_;
    $param->{portal_label} = MT->translate("Movable Type");
    $param->{user_id} = $app->user && $app->user->id;
    $param->{script_base_url} = $param->{script_parent_url} = $app->uri;
    $param->{page_mode} = $app->mode;
    $param->{static_uri} = $app->static_path . $plugin->{envelope} . '/';
    $param->{org_static_uri} = $app->static_path;
    $param->{plugin_name} = "MTmylo";
    $param->{plugin_version} = $VERSION;
    $param->{edit_field} = "text";
    
    # override options image
    my $q = $app->param;
    my $blog_id = $q->param('blog_id');
    my $config = $plugin->get_config_hash('blog:'.$blog_id);
    $param->{extra_path} = $config->{mylo_extra_path};
    $param->{image_popup}      = $config->{mylo_image_default_popup}     ? 1 : 0;
    $param->{image_wrap_text}  = $config->{mylo_image_default_wrap_text} ? 1 : 0;
    $param->{image_make_thumb} = $config->{mylo_image_default_thumb}     ? 1 : 0;
    $param->{ 'image_align_' . $_ } =
      ( $config->{mylo_image_default_align} || 'none' ) eq $_ ? 1 : 0
      for qw(none left center right);
    $param->{ 'image_unit_w' . $_ } =
      ( $config->{mylo_image_default_wunits} || 'pixels' ) eq $_ ? 1 : 0
      for qw(percent pixels);
    $param->{image_thumb_width} = $config->{mylo_image_default_width};
}

1;
