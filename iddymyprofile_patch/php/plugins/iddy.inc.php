<?php
// Get iddy profile
function get_iddy($ctx) {
	//var_dump($ctx->mt->config);
    $path = $ctx->mt->config['mtdir'];
    if (!preg_match('!/$!', $path))
        $path .= '/';
  	
	$file_data = $path.'plugins/iddyMyProfile/data/data.cgi';
	$lines_content = @file($file_data);
	list($date_data,$accountname) = split(",", $lines_content[0], 2);

	$date_chk = strftime("%Y%m%d%H%M%S",time()-60*3);
	$blog = $ctx->stash('blog');
	$iddy_config = iddy_config($ctx);
	$an = ($iddy_config!=null) ? $iddy_config['id_usrname'] : "";
		
	if (($date_data < $date_chk) or ($accountname != $an)) {
		$url = 'http://iddy.jp/api/user/?apikey=2f81a9d399752350434f8df139c5652a36a14beb&type=all&accountname='.$an;
		$content_in = @file_get_contents($url);	
    	$date_now = strftime("%Y%m%d%H%M%S",time());
    	$content_in = "$date_now,$an\n".$content_in;
    	@file_put_contents($file_data,$content_in);
	}
	
	$content = @file_get_contents($file_data);
	$content = ereg_replace("\r|\n","",$content);
	
    return array($content,$an);
}

function iddy_config($ctx) {
    $config = $ctx->stash('iddy-config');
    if (!$config)
    {
    	$dbkey = "iddy My Profile";
    	$blog_id = $ctx->stash('blog_id');
	    $config = $ctx->mt->db->fetch_plugin_config($dbkey, 'blog:' . $blog_id);
	    if (!$config) {
	    	$config = $ctx->mt->db->fetch_plugin_config($dbkey);
	    }
	    if ($config) {
	        $ctx->stash('iddy-config', $config);
	    }
    }
    return $config;
}

function get_iddy_profile_tag($ctx,$tag)
{
	list($content,$an) = get_iddy($ctx);
    if (!$an)
    	$ctx->error($plugin->translate('Please input your username'));
    
	$pattern = "/(.+)".$tag.">(.+)<\/".$tag."(.+)/";
	if (preg_match($pattern,$content,$match)) {
		$content = $match[2];
	} else {
      	$content = '';
    }
    
    $charset = $ctx->mt->config['PublishCharset'];
    $content = mb_convert_encoding($content, $charset, 'utf-8');
    
    return $content;
}
?>
