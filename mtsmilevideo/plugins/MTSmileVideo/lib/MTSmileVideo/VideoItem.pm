package MTSmileVideo::VideoItem;
use strict;

use MT::Object;
@MTSmileVideo::VideoItem::ISA = qw( MT::Object );
__PACKAGE__->install_properties({
    column_defs => {
        'id'            => 'integer not null auto_increment',
        'video_id'      => 'string(50) not null', 
        'title'         => 'string(150)',
        'watch_url'     => 'string(255)',
        'thumbnail_url' => 'string(255)',
        'description'   => 'text', 
        'submittedat'   => 'datetime',
    },
    indexes => {
        video_id => 1,
    },
    audit => 1,
    datasource => 'smilevideoitem',
    primary_key => 'id',
});

1;
