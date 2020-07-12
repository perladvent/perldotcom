use Win32::Clipboard;

my $TEMP          = $ENV{'TEMP'};
my $semaphore     = "$TEMP/$$.tmp";
my $cliptext_file = "$TEMP/$$.cliptext.tmp";

my $clipboard     = Win32::Clipboard();
my $cliptext      = $clipboard->Get();
my $shell_command = shift @ARGV;

open F, ">$cliptext_file" or die "Cannot open $cliptext_file: $!\n";
print F $cliptext;
close F;

my $output = `$shell_command $cliptext_file`;
$clipboard->Set($output);

# no "or die" here since stdout isn't visible
# when running this script. Could go to log file?
unlink($cliptext_file);
rmdir($semaphore);
