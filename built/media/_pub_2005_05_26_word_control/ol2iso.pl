# Convert Outlook format date to ISO 8309 date 
#(e.g. Wed 2/16/2005 5:27 PM to 2005-02-16T17:27)

while (<>) {
  $_ =~ s{\w+ (\d+)/(\d+)/(\d{4}) (\d+):(\d+) ([AP])M}{
     $AorP = $6;
     $minutes = $5;
     $hour = $4;
     $year = $3;
     $month = $1;
     $day = $2;
     $day = '0' . $day if ($day < 10);
     $month = '0' . $month if ($month < 10);
     $hour = $hour + 12 if ($6 eq 'P');
     $hour = '0' . $hour if ($hour < 10);
     "$year-$month-$day" . "T$hour:$minutes";
  }gse;
  print;
}
