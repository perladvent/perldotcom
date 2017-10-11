 1 #!/usr/bin/perl -w
 2 
 3 use Gnome;
 4 
 5 init Gnome::Panel::AppletWidget "ping_gateway.pl";
 6 $applet = new Gnome::Panel::AppletWidget "ping_gateway.pl";
 7 
 8 $off_label = "Check\nGateway\n<click>";
 9 
10 Gtk->timeout_add(20000, \&check_gateway );
11 $button = new Gtk::ToggleButton($off_label);
12 $button->signal_connect ("clicked", \&reset_state);
13 
14 $button->set_usize(50, 50);
15 show $button;
16 $applet->add($button);
17 show $applet;
18 
19 fetch_gateway();
20 
21 gtk_main Gnome::Panel::AppletWidget;
22 
23 use Socket;
24 
25 sub fetch_gateway 
26 {
27   foreach $line (`netstat -rn`) 
28   {
29     my ($dest, $gate, $other) = split(' ', $line, 3);
30     if ($dest eq "0.0.0.0")
31     {
32       ($hostname) = gethostbyaddr(inet_aton($gate), AF_INET);
33       $hostname =~ y/A-Z/a-z/;
34     }
35   }
36 }
37 
38 sub reset_state 
39 {
40   $state = $button->get_active();
41   if (!$state) 
42   { 
43     $button->child->set($off_label)
44   }
45   else 
46   { 
47     $button->child->set("Wait...")
48   }
49 }
50 
51 sub check_gateway 
52 { 
53   my $uphost = length($hostname) > 8 ? "gateway" : $hostname;
54 
55   if ($state) 
56   {
57     my $result = system("/bin/ping -c 1 2>&1>/dev/null $hostname");
58 
59     if ($result) 
60     { 
61       $button->child->set("$hostname:\nNo\nResponse") 
62     }
63     else 
64     {
65       $button->child->set( "$uphost\nis\nalive" );
66     }
67   }
68   return 1;
69 }

