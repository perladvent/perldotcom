#!c:\perl\bin\perl

#activedirectory_daemon.pl

use strict;
use Win32::OLE;
use Win32::OLE::Const 'Microsoft ActiveX Data Objects';
use Frontier::Daemon;

#return variable cannot be local to subroutine
#so all occurrences of return references must be declared outside subroutines
my $refAdRecord;
my $refCommandChain;

sub GetManagerCN {
    my $strManagerString=shift(@_);
    $strManagerString =~ /\bCN=[-_#@%\&\$\*\.a-zA-Z0-9\s]+/;
    my $strManagerCN=substr($strManagerString,$-[0],$+[0]-$-[0]);                       
    $strManagerCN =~ /CN=\s*/;
    $strManagerCN=substr($strManagerCN,$+[0]);
                       
    return $strManagerCN;    
}

sub GetManagerString {
    my %hashAdRecord = %$refAdRecord;
  
    my $strManagerString=$hashAdRecord{"manager"};

    return $strManagerString;    
}

sub GetUserData {
    my $strAttributeName=shift(@_); #could be cn, userPrincipalName, etc
    my $strAttributeValue=shift(@_); #could be cn value, userPrincipalName value, etc
    my $strADsPath=shift(@_);
    my $strDomain=shift(@_);
 
    if ($strAttributeName eq "userPrincipalName") {
            $strAttributeValue = $strAttributeValue . $strDomain;
    }

    my $strProvider="Active Directory Provider";

    my $strConnectionString=$strProvider;

    my $strFilter="(" . $strAttributeName . "=" . $strAttributeValue . ")";

    my $strAttribs="userPrincipalName,sn,givenName,cn,department,telephoneNumber,mail,title,manager"; 

    my $strScope="subtree";

    my $strCommandText="<" . $strADsPath . ">;" . $strFilter . ";" . $strAttribs . ";" . $strScope;


    my $objConnection = Win32::OLE->new ("ADODB.Connection") or die ("Cannot create ADODB object!");
    my $objRecordset = Win32::OLE->new ("ADODB.Recordset") or die ("Cannot create ADODB recordset!");
    my $objCommand = Win32::OLE->new ("ADODB.Command") or die ("Cannot create ADODB command!");

    my %hashAdRecord;
 
    
    $objConnection->{Provider} = ("ADsDSOObject");

    $objConnection->{ConnectionString} = ($strConnectionString);

    $objConnection->Open();

    $objCommand->{ActiveConnection} = ($objConnection);

    $objCommand->{CommandText} = ($strCommandText);

    $objRecordset = $objCommand->Execute($strCommandText) or die ("Cannot execute!");

    if (!$objRecordset) {
       my $errors = $objConnection->Errors();
        print "Errors:\n";
        foreach my $mistake (keys %$errors) {
            print $mistake->{Description}, "\n";
        }
        die;
    }

    if ($objRecordset->EOF) {
         %hashAdRecord = (result=>"failed");
    }
    
    while (!$objRecordset->EOF) {
        %hashAdRecord = (
                    result=>"passed",
                    userPrincipalName=>$objRecordset->Fields("userPrincipalName")->value,
                    sn=>$objRecordset->Fields("sn")->value,
                    givenName=>$objRecordset->Fields("givenName")->value,
                    cn=>$objRecordset->Fields("cn")->value,
                    title=>$objRecordset->Fields("title")->value,
                    department=>$objRecordset->Fields("department")->value,
                    telephoneNumber=>$objRecordset->Fields("telephoneNumber")->value,
                    mail=>$objRecordset->Fields("mail")->value,
                    manager=>$objRecordset->Fields("manager")->value
            );
        $objRecordset->MoveNext;        
    }    

    $objCommand->Close;
    $objRecordset->Close;
    $objConnection->Close;

    $refAdRecord = \%hashAdRecord;
    return $refAdRecord;
}


sub GetCommandChain {
    $refAdRecord = shift(@_);
    my $strApexTitle = shift(@_);


    my $strManagerString;
    my $strManagerCN;
    my %hashAdRecord;
    my $strTitle;
    my @arrCommandChain;
    
    $strManagerString = GetManagerString($refAdRecord);
    $strManagerCN = GetManagerCN($strManagerString);

    do  {
        $refAdRecord = GetUserData("cn",$strManagerCN,"LDAP://OU=somedivision,OU=somedepartment,DC=someuniversity,DC=edu","\@someuniversity.edu");   

        %hashAdRecord=%$refAdRecord;
    
        #how to extract a corresponding value from a key in a hash        
        $strTitle = $hashAdRecord{"title"};
    

        #adding another hash to an array; adding elements to the list of hashes
        push @arrCommandChain, {%hashAdRecord};    

    
        $strManagerString = GetManagerString($refAdRecord);
        $strManagerCN = GetManagerCN($strManagerString);
    
    } until ($strTitle eq $strApexTitle);

    $refCommandChain = \@arrCommandChain;

    return $refCommandChain;    
}

sub AuthenticateUser {
    my $strUserID = shift(@_) || "someuserid"; 
    my $strUserPassword = shift(@_) || "Somepassword1";
    my $strADsPath = shift(@_) || 'LDAP://OU=somedivision,OU=somedepartment,DC=someuniversity,DC=edu';
    my $strDomain = shift() || "\@someuniversity.edu";

    my $strAttributeName = "userPrincipalName";
    my $strAttributeValue = $strUserID;

    
     
    my $objNameSpace = Win32::OLE->GetObject ('LDAP:') or die ("Cannot create LDAP object");
     
    my $objObjSec = $objNameSpace->OpenDSObject($strADsPath, $strUserID, $strUserPassword, 1);

    my %hashAdRecord;

    # Win32::OLE->LastError() is equivalent to Err.Number in Visual Basic
    if   (Win32::OLE->LastError()==0) {
        #when using OUs as filters, cannot have a fully qualified host name i.e. hostname.domain
        #OU list must also be in ascending order of hierarchy        
        $refAdRecord = GetUserData($strAttributeName,$strAttributeValue,$strADsPath,$strDomain);
    } else {
        %hashAdRecord =('result' => 'failed');
        $refAdRecord = \%hashAdRecord;
    }

    $objObjSec->Close;
    $objNameSpace->Close;
    
    
    #return only references across xmlrpc    
    return $refAdRecord;
}

 
my $methods = {
                        'activedirectory_daemon.GetUserData' => \&GetUserData,
                        'activedirectory_daemon.GetCommandChain' => \&GetCommandChain,
                        'activedirectory_daemon.AuthenticateUser' => \&AuthenticateUser,
                   };

Frontier::Daemon->new(LocalPort => 8080, methods => $methods) or die ("Cannot start HTTP daemon: $!");

 
  

 





