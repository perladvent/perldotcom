{
   "draft" : false,
   "authors" : [
      "david-farrell"
   ],
   "slug" : "9/2013/4/1/Check-your-module-POD-using-perldoc",
   "description" : "Perl ships with a command-line program called perldoc that makes it easier to search and read Perl's vast documentation in the POD markup language. If perldoc is called with the -F flag, it will display the POD markup of an input file - this can be useful when your are developing a new Perl distribution and want to check the appearance of the POD in your module before it appears on CPAN for all to see.",
   "title" : "Check your module POD using perldoc",
   "date" : "2013-04-01T22:45:35",
   "image" : null,
   "categories" : "testing",
   "tags" : [
      "debugging",
      "documentation",
      "pod",
      "old_site"
   ]
}


Perl ships with a command-line program called perldoc that makes it easier to search and read Perl's vast documentation in the POD markup language. If perldoc is called with the -F flag, it will display the POD markup of an input file - this can be useful when your are developing a new Perl distribution and want to check the appearance of the POD in your module before it appears on CPAN for all to see.

``` prettyprint
# Pass a local file to perldoc

perldoc -F ProxyManager.pm
```

This will then display the POD markup:

``` prettyprint
ProxyManager(3)                                            

NAME
       Net::OpenVPN::ProxyManager - connect to proxy servers using OpenVPN.

SYNOPSIS
       use Net::OpenVPN::ProxyManager;
       my $pm = Net::OpenVPN::ProxyManager->new;

       # Create a config object to capture proxy server details
       my $config_object = $pm->create_config({remote => '100.120.3.34 53', proto => 'udp'});

       # Launch OpenVPN and connect to the proxy
       $pm->connect($config_object);
       # do some stuff

       # Disconnect from the proxy server
       $pm->disconnect();

DESCRIPTION
       Net::OpenVPN::ProxyManager is an object oriented module that provides methods to simplify the management of proxy connections that support OpenVPN.

This is a base generic class, see Net::OpenVPN::ProxyManager::HMA for additional methods to interact with hidemyass.com proxy servers.

METHODS
   new
       The constructor accepts an anonymous hash for two optional parameters: config_path and warning_flag. config_path is the path that ProxyManager.pm will use to create the config file when the create_config method is called. By default config_path is set to '/tmp/openvpn-config.conf'.
```

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
