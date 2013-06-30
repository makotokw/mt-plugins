<?php
function smarty_function_mtcaptchajsurl($args, &$ctx) {
/*
captcha.pl
sub captcha_js_url {
    my ($ctx, $args) = @_;
    my $blog_id = $ctx->stash('blog')->id;
    my $path = MT::ConfigMgr->instance->CGIPath;
    $path .= '/' unless $path =~ m!/$!;
    $path . 'plugins/captcha/captcha_js.cgi?blog_id=' . $blog_id;
}
*/
    $blog = $ctx->stash('blog');
    $path = $ctx->mt->config['cgipath'];
    if (!preg_match('!/$!', $path))
        $path .= '/';
	$path .= 'plugins/captcha/captcha_js.cgi?blog_id=' . $blog->id;
    return $path;
}
?>
