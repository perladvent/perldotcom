{
   "categories" : "windows",
   "title" : "Manipulating Word Documents with Perl",
   "image" : null,
   "date" : "2005-05-26T00:00:00-08:00",
   "tags" : [
      "invoke-perl-on-windows",
      "perl-embed",
      "word-macro-alternatives",
      "word-manipulation"
   ],
   "thumbnail" : "/images/_pub_2005_05_26_word_control/111-perl_in_word.gif",
   "draft" : null,
   "authors" : [
      "andrew-savikas"
   ],
   "slug" : "/pub/2005/05/26/word_control.html",
   "description" : " In a recent lightning article, Customizing Emacs with Perl, Bob DuCharme explained how to use the Emacs shell-command-on-region function to invoke a Perl script on a marked region of text. Bob writes that he was reluctant to invest the..."
}



In a recent lightning article, [Customizing Emacs with Perl](/pub/2005/03/31/lightning2.html), [Bob DuCharme](/authors/bob-ducharme) explained how to use the Emacs `shell-command-on-region` function to invoke a Perl script on a marked region of text. Bob writes that he was reluctant to invest the time needed to write the [elisp](http://www.gnu.org/software/emacs/elisp-manual/html_mono/elisp.html) code needed for a particular string manipulation, especially when he knew how much easier it would be for him to do that manipulation with Perl. However, by using the Emacs function `shell-command-on-region`, Bob could have his cake an eat it too--keep editing with Emacs, while using Perl on demand for string manipulation.

I've often been in the same boat as Bob, though while using Microsoft Word. When facing a thorny string manipulation problem, I, too, have found myself thinking, *This would be so easy if I could just use Perl!*

Unfortunately, Word VBA doesn't include a feature analogous to the `shell-command-on-region` function ...which certainly sounded like a challenge to me. In [Word Hacks](http://www.oreilly.com/catalog/wordhks), [Sean M. Burke](http://www.oreillynet.com/cs/catalog/view/au/906) and I [demonstrated](http://www.windowsdevcenter.com/pub/windows/excerpt/wdhks_1/index.html?page=5)how to use the Windows clipboard as a primitive but simple means of exchanging data between Word and a Perl script. I decided to see if I could generalize that technique to emulate the Emacs `shell-command-on-region` function from Word, using VBA and Perl. I'm happy to report that it works. Using the code shown in this article, you'll be able to run any DOS command that accepts standard input (like most in the fabulous [UnxUtils package](http://unxutils.sourceforge.net/)) on text you've selected in Microsoft Word, then either have the output echoed back or use it to replace the selected text. As an example, you can use the code in this article to run Bob's [`OLDate2ISO.pl`](/media/_pub_2005_05_26_word_control/ol2iso.pl) script on a selected date. (The `OLDate2ISO.pl` script converts a Microsoft Outlook style date, like "Sat 4/16/2005 7:35 PM" to ISO 8609 format, like "2005-04-16T19:35".)

VBA doesn't offer any easy way to capture shell command output, so there are actually two scripts needed to emulate the Emacs `shell-command-on-region` function: a Perl script to interact with the DOS shell, and a VBA function to manage that Perl script and deal with the output. In addition, I also wrote a simple wrapper macro that emulates the interactive (`Escape+|`) form of the `shell-command-on-region` function, using an input box, as shown in [Figure 2](#shell_command_dialog).

### The [clip2shell.pl](/media/_pub_2005_05_26_word_control/clip2shell.pl) script

It's true that VBA does include a `Shell()` function, but when using that function, there's no way to capture the output (if any) of the command invoked. To capture the output of a command run on the DOS shell, I've used a simple Perl script, named `clip2shell.pl` that takes one argument: a single string containing the name of the command to run (including any arguments). The current contents of the Windows clipboard are the input to that command, and the command's output is then put to the clipboard. (The `Win32::Clipboard` module is included in the standard [ActivePerl](http://www.activestate.com/Products/ActivePerl/) distribution). Here's the code:

    # clip2shell.pl 
    # A script for running a DOS shell command
    # on the contents of the clipboard, then
    # putting the command's results back
    # on the clipboard
    use Win32::Clipboard;
    my $TEMP          = $ENV{'TEMP'};
    my $semaphore     = "$TEMP/$$.tmp";
    my $cliptext_file = "$TEMP/$$.cliptext.tmp";

    my $clipboard     = Win32::Clipboard();
    my $cliptext      = $clipboard->Get();
    my $shell_command = shift @ARGV;

    open F, ">$cliptext_file" or die;
    print F $cliptext;
    close F;

    my $output = `$shell_command $cliptext_file`;
    $clipboard->Set($output);

    unlink($cliptext_file);
    rmdir($semaphore);

Note that before exiting, the script deletes a folder named with `$semaphore`, which contains the script's [PID](http://en.wikipedia.org/wiki/Process_identifier), appended with a *.tmp* extension, located in the current user's TEMP folder. This is how `clip2shell.pl` tells VBA that it's safe to read the result back from the clipboard. As I mentioned earlier, the VBA `Shell()` command doesn't return the command's output--but it does return the command's PID.

### The `shell-command-on-region` function, VBA style

The VBA function, `ShellCommandOnRegion`, manages the interaction between Word and the `clip2shell.pl` script. When this function invokes `clip2shell.pl` using the VBA `Shell()` function, it also creates the semaphore folder, named using `clip2shell.pl`'s PID (the return value of the `Shell` function), then waits for the deletion of that folder before getting the output from the clipboard. At that point, it either echoes back the output (using the Status Bar, or, for output more than 80 characters long, a separate message box), or pastes it back in to the document, replacing the current selection. The optional `bReplaceCurrentSelection` argument controls the output method, which is `False` by default.

    Function ShellCommandOnRegion(sShellCommand As String, _
                   Optional ByVal sngMaxWaitSeconds As Single = 5, _
                   Optional ByVal bReplaceCurrentSelection As Boolean = False) As Boolean
    Dim lPID As Long
    Dim sSemaphore As String
    Dim sngStartTime As Single
    Dim oClipboard As New DataObject
    Dim sel As Selection
    Dim sResult As String

    Set sel = Selection

    If sel.Type = wdSelectionIP Then
        StatusBar = "Please select some text first."
        Exit Function
    End If

    sel.Copy

    sngStartTime = Timer

    lPID = Shell("perl c:\clip2shell.pl " + Chr(34) + sShellCommand + Chr(34))
    sSemaphore = Environ("TEMP") + "\" + CStr(lPID) + ".tmp"
    MkDir sSemaphore

    Do: DoEvents
    Loop Until Len(Dir(sSemaphore, vbDirectory)) = 0 _
                Or ((Timer - sngStartTime) > sngMaxWaitSeconds)

    If Not Len(Dir(sSemaphore, vbDirectory)) = 0 Then
        RmDir sSemaphore
        Exit Function
    End If

    oClipboard.GetFromClipboard
    sResult = oClipboard.GetText

    If bReplaceCurrentSelection Then
        Selection.Paste
    Else
        If Len(sResult) > 80 Then
            MsgBox sResult
        Else
            StatusBar = sResult
        End If
    End If

    ShellCommandOnRegion = True
    End Function

If there's a problem and clip2shell.pl doesn't delete the semaphore folder within a certain amount of time (the default shown here is 5 seconds, as represented with the optional `sngMaxWaitSeconds` argument), `ShellCommandOnRegion` gives up, deletes the semaphore folder itself, and returns a value of `False`.

NOTE: Before using this code, make sure you have a reference set to the **`Microsoft Forms 2.0 Object Library`**, as shown in [Figure 1](#msforms_reference). Without this reference set, the `DataObject` object type won't be available to your code, which will cause a compilation error. To reach this dialog from Word, choose Tools, Macro, Visual Basic Editor. From within the Visual Basic Editor, choose Tools, References.

<img src="/images/_pub_2005_05_26_word_control/msforms_reference.gif" alt="setting a reference" width="449" height="364" />
*Figure 1. Setting a reference to the `Microsoft Forms 2.0 Object Library`.*

### Putting it Together

With the `clip2shell.pl` script and the `ShellCommandOnRegion` function set up, it's time to demonstrate how to use Bob DuCharme's `OLDate2ISO.pl` script on text selected in a Word document. First, I want to show a macro that runs `OLDate2ISO.pl` on selected text, then I'll show a more generalized macro, which emulates the interactive (`Escape+|`) version of the Emacs `shell-command-on-region` function.

Here's the `OLDate2ISO.pl` script, modified slightly to make its substitution globally on all the dates in its input:

    # Convert Outlook format date to ISO 8309 date 
    #(e.g. Wed 2/16/2005 5:27 PM to 2005-02-16T17:27)
    while (<>) {
      s{\w+ (\d+)/(\d+)/(\d{4}) (\d+):(\d+) ([AP])M} {
         my $hour  = $4;
         $hour    += 12 if $6 eq 'P';
         sprintf( '%04d-%02d-%02dT%02s:%02s', $3, $1, $2, $hour, $5 );
      }gse;
      print;
    }

Here's the `OLDate2ISO` macro. After putting it in the template or document of your choice, run it by pressing `Alt-F8` (which is the same as choosing Tools -&gt; Macro -&gt; Macros), or by assigning it to a menu or keyboard shortcut:

    Sub OLDate2ISO()
    If ShellCommandOnRegion("perl c:\ol2iso.pl", , True) = False Then
        MsgBox "Couldn't fix selected dates"
    End If
    End Sub

A dedicated macro is great for frequently used Perl scripts (or other shell commands), but it's also helpful to be able to run an arbitrary shell command on the selected Word text, and have the text echoed back, using the Status Bar (or, if longer than will easily fit on the Status Bar, in a separate message box--the Status Bar/message box route was the closest I could get to an Emacs mini-buffer).

Here's the code for the general-purpose macro, named `RunShellCommandOnSelection`:

    Sub RunShellCommandOnSelection()
    Static sShellCommand As String
    sShellCommand = InputBox(prompt:="Enter full Shell Command to run on selection:", _
                    Title:="ShellCommandOnRegion", _
                    Default:=sShellCommand)

    If Len(sShellCommand) = 0 Then Exit Sub

    If Selection.Type = wdSelectionIP Then
        MsgBox "Please select some text first."
        Exit Sub
    End If

    If ShellCommandOnRegion(sShellCommand) = False Then
        MsgBox "Shell command failed"
    End If
    End Sub

Running this macro brings up the dialog shown in [Figure 2](#shell_command_dialog).

<img src="/images/_pub_2005_05_26_word_control/shell_command_dialog.gif" alt="the macro&#39;s dialog" width="363" height="152" />
*Figure 2. The dialog that appears when running the `RunShellCommandOnSelection` macro.*

By using a `Static` variable declaration, the command entered will be "sticky" within Word sessions (to some extent), making it easy to re-run the same command multiple times. If you wanted to replace the selected text instead of echoing the result, modify the `RunShellCommandOnSelection` macro by adding the optional `bReplaceCurrentSelection` argument to the `ShellCommandOnRegion` call (leaving a blank value for the `sngMaxWaitSeconds` argument):

    If ShellCommandOnRegion(sShellCommand, ,True) = False Then

Word may not be quite as customizable as Emacs, but by emulating a single Emacs function using Perl and VBA, it's possible to add a powerful new tool to Word, and in doing so, give any Perl refugees who find themselves in the Word world--whether by choice or circumstance--some of the comforts of home.
