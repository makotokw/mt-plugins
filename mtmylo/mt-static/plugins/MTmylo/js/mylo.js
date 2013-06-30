// Global

function confirmLogout( msg )
{
    if( !confirm( msg ) )
        return false;
    return true;
}


// Home

function revealWeblogs( id )
{
    var new_post_links = TC.elementOrId( id );
    if( !new_post_links )
        return false;
    TC.removeClassName( new_post_links, 'hidden' )
    return false;
}

function concealWeblogs( id )
{
    var new_post_links = TC.elementOrId( id );
    if( !new_post_links )
        return false;
    TC.addClassName( new_post_links, 'hidden' )
    return false;
}


// Editor

function focusTitle()
{
    var title = TC.elementOrId( 'title' );
    if( !title )
        return false;
    title.focus();
    return true;
}

function setDirty() { dirty = true; }
function clearDirty() { dirty = false; }


// Comment

function publishComment()
{
    submitForm( 'hidden-form', { status: 2, from: 'edit_comment', to: 'list_comments' } );
    return false;
}

function unpublishComment()
{
    submitForm( 'hidden-form', { status: 1, from: 'edit_comment', to: 'list_comments' } );
    return false;
}

function deleteComment( status, msg )
{
    if( !confirm( msg ) )
        return false;
    submitForm( 'hidden-form', { status: status, from: 'edit_comment', to: 'list_comments' } );
    return false;
}


// TrackBack

function publishTrackback()
{
    submitForm( 'hidden-form', { status: 2 } );
    return false;
}

function unpublishTrackback()
{
    submitForm( 'hidden-form', { status: 1 } );
    return false;
}

function deleteTrackback( status, msg )
{
    if( !confirm( msg ) )
        return false;
    submitForm( 'hidden-form', { status: status } );
    return false;
}


// Utilities

function submitForm( f, params )
{
    var f = TC.elementOrId( f );
    if( !f )
        return false;
    if( params )
    {
        var inputs = f.getElementsByTagName( "input" );
        for( var i = 0; i < inputs.length; i++ )
        {
            var input = inputs[ i ];
            if( TC.defined( params[ input.name ] ) && params[ input.name ] != null )
                input.value = params[ input.name ];
        }
    }
    f.submit();
    return false;
}

// Dialog

function getByID(n, d) {
    if (!d) d = document;
    if (d.getElementById)
        return d.getElementById(n);
    else if (d.all)
        return d.all[n];
}

function show(id, d, style) {
    var el = getByID(id, d);
    if (!el) return;
    if ( TC.hasClassName( el, "hidden" ) ) {
        TC.removeClassName( el, "hidden");
    } else {
        el.style.display = style ? style : 'block';
    }
    /* hack */
    //if ( TC.hasClassName( el, "autolayout-height-parent" ) )
    //    TC.setHeight( el, finiteInt( el.parentNode.clientHeight ) );
}

function hide(id, d) {
    var el = getByID(id, d);
    if (!el) return;
    if (!TC.hasClassName(el, "hidden")) {
        TC.addClassName(el, "hidden");
    } else {
        el.style.display = 'none';
    }
}

function dialogKeyPress(e) {
    if (e.keyCode == 27) {
        // escape key...
        //DOM.removeEventListener( document.body, "keypress", dialogKeyPress, true );
    	 TC.detachEvent(document.body, "keypress", dialogKeyPress);
        closeDialog();
    }
}

function openDialog(f, mode, params) {
    var url = ScriptURI;
    url += '?__mode=' + mode;
    if (params) url += '&' + params;
    url += '&__type=dialog';
    show("dialog-container");
    TC.detachEvent(document.body, "keypress", dialogKeyPress);
    openDialogUrl(url);
    return false;
}

function openDialogUrl(url) {
    var iframe = getByID("dialog-iframe");
    var frame_d = iframe.contentDocument;
    if (!frame_d) {
        // Sometimes the contentWindow is unavailable because we've just
        // unhidden the container div that holds the iframe. If this happens
        // we have to wait for the contentWindow object to be created
        // before we can access the document within. This may take an extra
        // try using a setTimeout on this window.
        if (iframe.contentWindow)
            frame_d = iframe.contentWindow.document || iframe.document;
    }
    if (frame_d) {
      frame_d.location = url;
      return;
    }
    /*
    if (frame_d) {
        frame_d.open();
        frame_d.write("<html><head><style type=\"text/css\">\n"
            + "#dialog-indicator {\nposition: relative;\ntop: 200px;\n"
            + "background: url(" + StaticURI + "images/indicator.gif) "
            + "no-repeat;\nwidth: 66px;\nheight: 66px;\nmargin: 0 auto;"
            + "\n}\n</style><script type=\"text/javascript\">\n"
            + "function init() {\ndocument.location = \"" + url + "\";\n}\n"
            + "if (window.navigator.userAgent.match(/ AppleWebKit\\//))\n"
            + "window.setTimeout(\"init()\", 1500);\n"
            + "else window.onload = init;\n</scr"+"ipt></head><body>"
            + "<div align=\"center\"><div id=\"dialog-indicator\"></div>"
            + "</div></body></html>");
        frame_d.close();
    } else {
        window.setTimeout("openDialogUrl('" + url + "')", 100);
    }*/
}

function closeDialog(url) {
    var w = window;
    while (w.parent && (w.parent != w))
        w = w.parent;
    if (url) {
        w.location = url;
    } else {
        hide("dialog-container", w.document);
    }
    return false;
}

function toggleSubPrefs(c) {
    var div = TC.elementOrId((c.name || c.id)+"-prefs") || TC.elementOrId((c.name || c.id)+'_prefs');
    if (div) {
        if (c.type) {
            var on = c.type == 'checkbox' ? c.checked : c.value != 0;
            if (on) {
                TC.removeClassName(div, "hidden");
            } else {
                TC.addClassName(div, "hidden");
            }
            // div.style.display = on ? "block" : "none";
        } else {
            var on = div.style.display && div.style.display != "none";
            if (on) {
                TC.addClassName(div, "hidden");
            } else {
                TC.removeClassName(div, "hidden");
            }
            // div.style.display = on ? "none" : "block";
        }
    }
    return false;
}