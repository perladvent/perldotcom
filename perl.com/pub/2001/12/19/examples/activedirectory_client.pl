#!c:\perl\bin\perl

#activedirectory_client.pl

use strict;
use Frontier::Client;


my $strDaemon_url;
my $strServer;
my $refAdRecord;
my %hashAdRecord;
my $refCommandChain;
my @arrCommandChain;
my $strApexTitle;
my $numListSize;
my $strKey;


$strDaemon_url = "http://www.someuniversity.edu:8080/RPC2";

# this client will accept a URL on the command line if it's given
if ($#ARGV > -1) {
    $strDaemon_url = $ARGV[0];
}

$strServer = Frontier::Client->new(url => $strDaemon_url);

$refAdRecord= $strServer->call('activedirectory_daemon.AuthenticateUser','someuserid','Somepassword1','LDAP://OU=somedivision,OU=somedepartment,DC=someuniversity,DC=edu',"\@someuniversity.edu");

print "User Record below:\n\n";

#getting values out of a references to a hash
%hashAdRecord = %$refAdRecord;
foreach $strKey (keys %hashAdRecord) {
    print $strKey . "=>". $hashAdRecord{$strKey} . "\n";
}

print "\n\n\n";

$strApexTitle="Vice-Principal, UDD";
$refCommandChain= $strServer->call('activedirectory_daemon.GetCommandChain',$refAdRecord,$strApexTitle);
@arrCommandChain = @$refCommandChain;


print "Command Chain below:\n\n";

$numListSize=@arrCommandChain;
print "No of elements: " . $numListSize . "\n\n";

for (my $i=0; $i<$numListSize;$i++) {
    %hashAdRecord = %{$arrCommandChain[$i]};
    foreach $strKey (keys %hashAdRecord) {
        print $strKey . "=>". $hashAdRecord{$strKey} . "\n";
    }
    print "\n\n\n";
}

print "Endorser Record:\n\n";
%hashAdRecord = %{$arrCommandChain[$numListSize-2]};
foreach $strKey (keys %hashAdRecord) {
    print $strKey . "=>". $hashAdRecord{$strKey} . "\n";
}
print "\n\n\n";

print "Approver Record:\n\n";
%hashAdRecord = %{$arrCommandChain[$numListSize-1]};
foreach $strKey (keys %hashAdRecord) {
    print $strKey . "=>". $hashAdRecord{$strKey} . "\n";
}
print "\n\n\n";






