quiet;
open sources=files/perl_channels.xml;
create merge news-items;
$i = 0;
foreach sources://rss-url {
    $name = string(.);
    open $i=$name;
    xcopy $i://item into merge:/news-items;
    close $i;
    $i=$i+1;
};

close sources;
saveas merge files/headlines.xml;
close merge;
