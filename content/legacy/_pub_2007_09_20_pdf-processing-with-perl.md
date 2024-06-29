{
   "date" : "2007-09-21T00:00:00-08:00",
   "title" : "PDF Processing with Perl",
   "image" : null,
   "categories" : "cpan",
   "thumbnail" : null,
   "tags" : [
      "creating-pdfs",
      "pdf",
      "pdf-create",
      "pdf-reuse"
   ],
   "description" : " Adobe's PDF has become a standard for text documents. Most office products can export their content into PDF. However, this software reaches its limits if you want advanced tasks such as combining different PDF documents into one single document...",
   "slug" : "/pub/2007/09/20/pdf-processing-with-perl.html",
   "authors" : [
      "detlef-groth"
   ],
   "draft" : null
}



[Adobe](http://www.adobe.com/)'s PDF has become a standard for text documents. Most office products can export their content into PDF. However, this software reaches its limits if you want advanced tasks such as combining different PDF documents into one single document or adding and adjusting the bookmarks panel for better navigation. Imagine that you want to collect all relevant Perl.com articles in one PDF file with an up-to-date bookmarks panel. You could use a tool like [HTMLDOC](http://www.easysw.com/), but adding article number 51 would require you to fetch articles one through 50 from the Web again. In most cases you would not be satisfied by the resulting bookmarks panel, either. This article shows how to use [PDF::Reuse]({{<mcpan "PDF::Reuse" >}}), by Lars Lundberg, for combining different PDF documents and adding bookmarks to them.

### Example Material

Although its capabilities are limited in this area, you can also use `PDF::Reuse` to create PDF documents. If you want to create more sophisticated documents you should investigate other PDF-packages like [PDF::API2]({{<mcpan "PDF::API2" >}}) from Alfred Reibenschuh or [Text::PDF]({{<mcpan "Text::PDF" >}}) from Martin Hosken. However `PDF::Reuse` is sufficient to create a simple PDF to use in later examples. The following listing should be rather self explanatory.

     # file: examples/create-pdfs.pl
      use strict;
      use PDF::Reuse;

      mkdir "out" if (!-e "out") ;

      foreach my $x (1..4) {
          prFile("out/file-$x.pdf");

          foreach my $y (1..10) {
              prText(35,800,"File: file-$x.pdf");
              prText(510,800,"Page: $y");

              foreach my $z (1..15) {
                  prText(35,700-$z*16,"Line $z");
              }

              # add graphics with the prAdd function

              # stroke color
              prAdd("0.1 0.1 0.9 RG\n");

              # fill color
              prAdd("0.9 0.1 0.1 rg\n");

              my $pos = 750 - ($y * 40);

              prAdd("540 $pos 10 40 re\n");
              prAdd("B\n");

              if ($y < 10) {
                  prPage();
              }
          }

          prEnd();
      }

Open a new file with with `prFile($filename)` and close it with `prEnd`. Between those two calls, add text with the `prText` command. You can also draw graphics by using the low level command `prAdd` with plain PDF markup as parameter. Start a new page with `prPage`. `prFile` starts the first one automatically, so you need to add a new page only if your document has more than one page. Be aware that for the `prText(x,y,Text)` command the origin of the coordinate system is on the left bottom of the page.

As an example of adding PDF markup with `prAdd`, the code creates a red rectangle with blue borders. In case you would like to add more graphics or complex graphics to your PDF, you can study the examples of the [PDF reference manual](http://partners.adobe.com/public/developer/pdf/index_reference.html). If so, consider switching to `PDF::API2` or `Text::PDF` instead of using `prAdd`, as they both provide a comfortable layer of abstraction over the PDF markup language.

### Combining PDF Documents

`PDF::Reuse`'s main strength is the modification and reassembling of existing PDF documents. The next example assembles a new file from the example material.

      # file: examples/combine-pdfs.pl

      use strict;
      use PDF::Reuse;

      prFile("out/resultat.pdf");

      prDoc('out/file-1.pdf',1,4);
      prDoc('out/file-2.pdf',2,9);
      prDoc('out/file-3.pdf',8);
      prDoc('out/file-4.pdf');

      prEnd();

Again, `prFile($filename)` opens the file. Next, the `prDoc($filename, $firstPage, $lastPage)` calls add to the new file various page ranges from the example file. The arguments `$firstPage` and `$lastPage` are optional. Omit both to add the entire document. If only `$firstPage` is present, the call will add everything from that page to the end. Finally, `prEnd` closes the file.

### Reusing Existing PDF Files

With `PDF::Reuse` it is possible to use existing PDF files as templates for creating new documents. Suppose that you have a file *customer.txt* containing a list of customers to whom to send a letter. You've used a tool to create a PDF document, such as OpenOffice.org or Adobe Acrobat, to produce the letter itself. Now you can write a short program to add the date and the names and addresses of your customers to the letter.

      # file: examples/reuse-letter.pl
      use PDF::Reuse;
      use Date::Formatter;
      use strict;

      my $date = Date::Formatter->now();
      $date->createDateFormatter("(DD).(MM). (YYYY)");

      my $n      =  1;
      my $incr   = 14;
      my $infile = 'examples/customer.txt';

      prFile("examples/sample-letters.pdf");

      prCompress(1);
      prFont('Arial');
      prForm("examples/sample-letter.pdf");

      open (my $fh, "<$infile") || die "Couldn't open $infile, $!\n aborts!\n";

      while (my $line = <$fh>)  {
          my $x = 60;
          my $y = 760;

          my ($first, $last, $street, $zipCode, $city, $country) = split(/,/, $line);
          last unless $country;

          prPage() if $n++ > 1 ;
          prText($x, $y, "$first $last");

          $y -= $incr;
          prText($x, $y, $street);

          $y -= $incr;
          prText($x, $y, $zipCode);
          prText(($x + 40), $y, $city);

          $y -= $incr;
          prText($x,   $y, $country);
          prText(60,  600, "Dear $first $last,");
          prText(400, 630, "Berlin, $date");
      }

      prEnd();
      close $fh;

After opening the file with `prFile`, the call to `prCompress(1)` enables PDF compression. `prFont` sets the file's font. The always-available options are Times-Roman, Times-Bold, Times-Italic, Times-BoldItalic, Courier, Courier-Bold, Courier-Oblique, Courier-BoldOblique, Helvetica, Helvetica-Bold, Helvetica-Oblique, and Helvetica-BoldOblique. Set the font size with `prFontSize`. The default font is Helvetica, with 12 pixel size.

The rest of the code is a simple loop over the file containing the customer data to filling the template with `prText`.

### Adding Page Numbers

Sometimes you need only make a small change to a document, such as adding missing page numbers.

      # file: examples/sample-numbers.pl
      use PDF::Reuse;
      use strict;

      my $n = 1;

      prFile('examples/sample-numbers.pdf');

      while (1) {
         prText(550, 40, $n++);
         last unless prSinglePage('sample-letters.pdf');
      }

      prEnd();

`prSinglePage` takes one page after the other from an existing PDFdocument and returns the number of remaining pages after each invocation.

### Low-Level PDF Commands

If you know low-level PDF instructions, you can add them with with the `prAdd(string)` subroutine. `PDF::Reuse` will perform no syntax checks on the instructions, so refer to the PDF reference manual. Here's an example of printing colored rectangles with the `prAdd` subroutine.

      # file: examples/sample-rectangle.pl
      use PDF::Reuse;
      use strict;

      prFile('examples/sample-rectangle.pdf');

      my $x = 40;
      my $y = 50;
      my @colors;

      foreach my $r (0..5) {
         foreach my $g (0..5) {
             foreach my $b (0..5) {
                 push @colors,
                     sprintf("%1.1f %1.1f %1.1f rg\n",
                     $r * 0.2, $g * 0.2, $b * 0.2);
             }
         }
      }

      while (1) {
         if ($x > 500) {
             $x = 40; $y += 40;
             last unless @colors;
         }

         # a rectangle
         my $string = "$x $y 30 30 re\n";
         $string   .= shift @colors;

         # fill and stroke
         $string   .= "b\n";

         prAdd($string);

         $x += 40;
      }

      prEnd();

### Adding Bookmarks

Working with PDF files becomes comfortable if the document has bookmarks with a table of contents-like structure. Some applications either can't provide the PDF document with bookmarks or support insufficient or incorrect bookmarks. `PDF::Reuse` can fill this gap with the `prBookmark($reference)` subroutine.

A bookmark reference is a hash or a array of hashes that looks like:

       {  text  => 'Document-Text',
                 act   => 'this.pageNum = 0; this.scroll(40, 500);',
                 kids  => [ { text => 'Chapter 1',
                              act  => '1, 40, 600'
                            },
                            { text => 'Chapter 2',
                              act  => '10, 40, 600'
                            }
                          ]
       }

...where `act` is a JavaScript action to trigger when someone clicks on the bookmark. Because those JavaScript actions only work in the Acrobat Reader but not in other PDF viewer applications, I will later show a improvement of `PDF::Reuse` that fixes this issue.

Other examples for using `PDF::Reuse`, including image embedding, are available in the [PDF::Reuse::Tutorial]({{<mcpan "PDF::Reuse::Tutorial" >}}).

### A Console Application for Combining PDF Documents

To avoid editing the Perl code for combining PDF documents every time you want to merge documents, I've written a console application that takes the names of the input files and the page ranges for each file as arguments. That's easy to reuse in a graphical application using Perl/Tk, so I've put that code in a separate Perl module called `CombinePDFs`. The command-line application will interact with this package instead of directly working on `PDF::Reuse`. The following diagram shows the relationship between the Packages, example, and applications.

      Examples    |     Packages            |     applications
      -------------------------------------------------------------------
      combine.pdfs                           app-combine-console-pdfs.pl
                  \                         /
                   PDF::Reuse -- CombinePDFs
                  /                         \
       create.pdfs                           app-combine-tk-pdfs.pl

The application *app-combine-console-pdfs.pl* does not deal directly with `PDF::Reuse` but parses the command line arguments with [Getopt::Long]({{<mcpan "Getopt::Long" >}}) written by Johan Vromans. This is the standard package for this task. Here it parses the input filenames and the page ranges into two arrays of same length. The user also has to supply a filename for the output and, optionally, a bookmarks file. The main subroutine that parses the command line arguments and executes `CombinePDFs::createPDF` is:

      sub main {
          GetOptions("infile=s"    => \@infiles,
                     "outfile=s"   => \$outfile,
                     "pages=s",    => \@pages,
                     'overwrite'   => \$overwrite,
                     'bookmarks:s' => \$bookmarks,
                     'help'        => \&help);
          help unless ((@infiles and $outfile and @pages) and @pages == @infiles);

          checkPages();
          checkFiles();
          checkBookmarks();

          CombinePDFs::createPDF(\@infiles, \@pages, $outfile, $bookmarks);
      }

If the user passes an insufficient number of arguments, invalid filenames, or incorrect page ranges, the code invokes the the usage subroutine. It also gets invoked if the user asks explicitly for `-help` on the command line. Any good command line application should be written that way. [Getopt::Long]({{<mcpan "Getopt::Long" >}}) can distinguish between mandatory arguments, with `=` as the symbol after the argument name (infile, pages), optional arguments, with `:` (bookmarks), or flags (overwrite, usage), without a symbol. It can store these arguments as arrays (infile, pages), hashes, or scalars. It also supports type checking.

### CombinePDFs Package

The application itself mainly performs error checking. If everything is fine, it calls the `CombinePDFs::createPDF` subroutine, passing the array of input files, the array of page ranges, and the bookmarks information. The bookmarks scalar is optional.

Page ranges can be comma-separated ranges (`1-11,14,17-23`), single pages, or the `all` token. You can include the same page several times in the same document.

The file-checking code looks for read permissions and tests if the file is a PDF document by using the `CombinePDFs::isPDF($filename)` subroutine. Although [PDF]({{<mcpan "PDF" >}}), by Antonio Rosella, also provides such a method, this package was not developed with the `use strict` pragma and gives a lot of warnings. Furthermore, the package is not actively maintained, so there seems to be no chance to fix this in the near future. Implementing the `isPDF` subroutine is quite simple; it reads the first line of the PDF file and checks for the magic string `%PDF-1.[0-9]` in the first line of the document.

Please note that `PDF::Reuse` is not an object oriented package. Therefore the `CombinePDFs` package is not object oriented, either. A user of this package could create several instances, but all instances work on the same PDF file.

Submitting complex data structures via the command line is a difficult issue, so I decided that bookmarks should come from a text file. This file has a simple markup to reflect a tree structure, where each line resembles:

     <level> "bookmarks text" <page>

The level starts with 0 for root bookmarks. Children of the root bookmarks have a level of 1, their children a level of 2, and so on. Currently, the system supports bookmarks up to three levels of nesting:

     0 "Folder File 1 - Page 1" 1
     1 "File 1 - Page 2" 2
     1 "Subfolder File 1 - Page 3" 3
     2 "File 1 - Page 4"  4
     0 "Folder File 2 - Page 7 " 7
     1 "File 2 - Page 7" 7
     1 "File 2 - Page 9" 9

The parsing subroutine for the bookmarks file `CombinePDFs::addBookmarks($filename)` should be easy to understand, though that's not necessarily true of the complex data structure created inside this subroutine.

Bookmarks are an array of hashes. `addBookmarks` uses several attributes. `text` is the title of the entry in the bookmarks panel. `act` is the action to trigger when someone clicks the entry. Here it is the page number to open. `kids` contains a reference to the children of this bookmark entry. During the loop over the file content, the code searches for each level the last entry in a variable and pushes its related children on those last entries. The root bookmarks get collected as an array, and the loop adds the children as a reference to an array, and so on for the grand children. The result is a nested complex data structure which stores all children in the `kids` attribute of the parent's bookmarks hash—an array of hashes containing other arrays of hashes and so on.

The parsing subroutine for the bookmarks file `CombinePDFs::addBookmarks($filename)` collects bookmarks in a array of hashes. At the end, it adds the bookmarks to the document with `prBookmarks($reference)`. All of this means that you can use a bookmarks file with the PDF file with a command line like:

       $ perl bin/app-combine-pdfs.pl \
          --infile out/file-1.pdf --pages 1-6 \
          --infile out/file-2.pdf --pages 1-4,7,9-10 \
          --bookmarks out/bookmarks.cnt \
          --outfile file-all.pdf --overwrite

Currently, you must open the document's navigation panel manually because `PDF::Reuse` does not yet allow you to declare a default view, whether full screen or panel view. This is easy to fix, and the author Lars Lundberg has promised me to do so in a next release of `PDF::Reuse`. In order to enable this feature until a new release will appear I included a modified version of `PDF::Reuse` in the examples zip file that accompanies this article.

Furthermore, the bookmarks use JavaScript functions. To use the bookmarks in PDF viewers other than Acrobat Reader, my patched `PDF::Reuse` package replaces JavaScript bookmarks with PDF specification compliant bookmarks. To do that, replace the `act` key with a `page` key using the appropiate page number and scroll options:

     $bookmarks = {  text  => 'Document',
                     page  => '0,40,50;',
                     kids  => [ { text => 'Chapter 1',
                              page  => '1, 40, 600'
                            },
                            { text => 'Chapter 2',
                              page  => '10, 40, 600'
                            }
                          ]
              }

Then print the bookmarks to the PDF document as usual with `prBookmark($bookmarks);`.

### Tk Application to Combine PDF Documents

Console applications are fine for experienced users, but you can't expect that all users belong to this category. Therefore it might be worth it to write a GUI for combining PDF documents. The [Perl/Tk toolkit]({{<mcpan "Tk" >}}) founded on the old Tix widgets for Tcl/Tk is not very modern, although this might change with the [Tcl/Tk release 8.5](http://www.tcl.tk/software/tcltk/8.5.html) and the Tile widgets—but it is very portable. That's why I used it for the GUI example. Because I put a layer between the `PDF::Reuse` package and the command line application with the `CombinePDFs` package, it was easy to reuse those parts in the Tk-application *app-combine-tk-pdfs.pl*.

With the Tk application, the user visually selects PDF files, orders the files in a `Tk::Tree` widget, and changes the page ranges and the bookmarks text in `Tk::Entry` fields. Furthermore, the application can store the resulting tree structure inside a session file and restored that later on. It's also possible to copy and paste entries inside the tree, which makes it easy to create a bookmarks panel for single files without using bookmark files. The Tk application can be found in the download at the end of this article.

Beside the final PDF file, the application creates a file with the same basename and the *.cnt* extension. This file contains the bookmarks for the PDF. It's also useful to continue the processing of the combined PDF file instead of reassembling all the source files again. The entry for this feature is `File->Load Bookmarks-File`.

When loading a bookmarks file, the same extension convention is in place.

### Other PDF Packages on CPAN

I like `PDF::Reuse`, but there are several other options for PDF creation and manipulation on the CPAN.

-   [PDF::API2]({{<mcpan "PDF::API2" >}}), by Alfred Reibenschuh, is actively maintained. It is the package of choice if creating new PDF documents from scratch.
-   [PDF::API2::Simple]({{<mcpan "PDF::API2::Simple" >}}), by Red Tree Systems, is a wrapper over the `PDF::API2` module for users who find the PDF::API2 module to difficult to use.
-   [Text::PDF]({{<mcpan "Text::PDF" >}}), by Martin Hosken, can work on more than PDF file at the same time and has Truetype font support.
-   [CAM::PDF]({{<mcpan "CAM::PDF" >}}), by Clotho Advanced Media, is like `PDF::Reuse` more focused on reading and manipulating existing PDF documents. However, it can work on multiple files at the same time. Use it if you need more features than `PDF::Reuse` actually provides.

### Conclusions

`PDF::Reuse` is a well-written and well-documented package, which makes it easy to create, combine, and change existing PDF documents. The two sample applications show some of its capabilities. Two limitations should be mentioned however, `PDF::Reuse` can't reuse existing bookmarks, and after combining different PDF documents some of the inner document hyperlinks might stop working properly. The [example source code](/media/_pub_2007_09_20_pdf-processing-with-perl/pdf_reuse.zip) for the applications, packages, and the modified `PDF::Reuse` is available.
