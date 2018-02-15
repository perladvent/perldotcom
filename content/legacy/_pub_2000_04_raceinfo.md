{
   "thumbnail" : null,
   "tags" : [
      "perl-conference"
   ],
   "title" : "Program Repair Shop and Red Flags",
   "image" : null,
   "categories" : "development",
   "date" : "2000-05-02T00:00:00-08:00",
   "draft" : null,
   "authors" : [
      "mark-jason-dominus"
   ],
   "description" : "What's wrong with this picture? -> What's wrong with this picture? Reading the Input Computing Average and Total Times Sort Order Printing the Report Red Flags Get Rid of Array Size Variables Use Compound Data Structures Instead of Variable Families...",
   "slug" : "/pub/2000/04/raceinfo.html"
}



-   [What's wrong with this picture?](#What_s_wrong_with_this_picture_)
    -   [Reading the Input](#Reading_the_Input)
    -   [Computing Average and Total Times](#Computing_Average_and_Total_Time)
    -   [Sort Order](#Sort_Order)
    -   [Printing the Report](#Printing_the_Report)
-   [Red Flags](#Red_Flags)
    -   [Get Rid of Array Size Variables](#Get_Rid_of_Array_Size_Variables)
    -   [Use Compound Data Structures Instead of Variable Families](#Use_Compound_Data_Structures_Ins)
    -   [Use `foreach` to Loop Over Arrays](#Use_C_foreach_to_Loop_Over_Arra)

Someone recently asked me to take a look at his report-generating program because he wasn't able to get the final report sorted the way he wanted.

The program turned out to require only a minor change to get the report in order, but it also turned out to be a trove of common mistakes--which is wonderful, because I can use one program to show how to identify and fix all the common mistakes at once!

First I'll show the program, and then I'll show how to make it better. Here's the original. (Note: Lines of code may be broken for display purposes.)

         1  #!/usr/bin/perl
         2  use Getopt::Std;
         3  getopt('dV');
         4  $xferlog="./xferlog";
         5  $\ = "\n";
         6  $i=0;
         7  open XFERLOG, $xferlog or die "Cant't find file $xferlog";
         8  
         9  foreach $line (<XFERLOG>) {
        10        chomp($line);
        11        if (( $line =~ /$opt_d/i) && ( $line !~ /_ o r/)) 
        12           {
        13           ($Fld1,$Fld2,$Fld3,$Fld4,$Fld5,$Fld6,$Fld7,$Fld8,
                   $Fld9,$Fld10,$Fld11,$Fld12,$Fld13,$Fld14,$Fld15) = split(' ',$line);
     
        14            $uplist[$i] = join ' ',$Fld6, $Fld8, $Fld9, $Fld14, $Fld15;
        15            $time[$i]=$Fld6; $size[$i]=$Fld8; $file[$i]=$Fld9; 
                   $user[$i]=$Fld14; $group[$i]=$Fld15;
          
        16            $username= join '@', $user[$i], $group[$i];
        17            push @{$table{$username}}, $uplist[$i];
        18            $i++;     
        19      }
        20  }
        21  close XFERLOG;
        22  
        23  undef %saw;
        24  # @newuser = grep(!$saw{$_}++, @user);
        25  $j=0;
        26  foreach  $username ( sort keys %table )
        27          {
        28          my @mylist = @{$table{$username}};
        29          $m=0;
        30          $totalsize=0;
        31          $totaltime=0;
        32          $gtotal=0;
        33          $x=0;
        34          $x=@mylist;
        35          for ($m = 0 ; $m < ($x); $m++)
        36          {
        37                  ( $seconds, $size, $file, $user, $group) = split(' ', $mylist[$m]);
        38                  $totaltime = ($totaltime + $seconds);
        39                  $totalsize = ($totalsize + $size);
        40          }
        41          if ($totaltime==0) { $totaltime=1; }
        42          if ($totalsize==0) { $totalsize=1; }
        43          $avgtr = (($totalsize/$totaltime)/1024);
        44          $gtotal=($totalsize+$gtotal);
        45          $finale[$j]= join ' ', ($totalsize/(1024*1024)), $username, ($x), $totaltime, $avgtr;
        46  #       print $finale[$j];
        47          $j++;
        48  }
        49  @realfinal =  sort @finale;
        50  #print @finale;
        51  $p=0;
        52  $w=0;
        53  $w=@realfinal;
        54  #print $w;
        55  for ($p=($w-1) ; $p>=0; $p--)
        56  {
        57          ($Size, $User, $Files, $Time, $AvgSpeed)= split " ", $realfinal[$p];
        58          $position= ($w-$p);
        59          $percent=(($Size/($gtotal/(1024*1024)))*100);
        60          printf ("$position. $User $Files files ");
        61          printf("%.2fMB", $Size) ;
        62          printf " $Time(s) ";
        63          printf ("%.2f% ", $percent);
        64          printf("%.2fK/s", $AvgSpeed);
        65          print " ";
        66  }
        67          

Let's start at the top, with the argument and file handling.

         1  #!/usr/bin/perl
         2  use Getopt::Std;
         3  getopt('dV');
         4  $xferlog="./xferlog";
         5  $\ = "\n";
         6  $i=0;
         7  open XFERLOG, $xferlog or die "Cant't find file $xferlog";
         8  
         9  foreach $line (<XFERLOG>) {
            ...
        20  }
        21  close XFERLOG;

The name of the input file is hardwired on line 4. Getting the filename from the command line is more flexible. We can leave the old filename in place as a default, retaining compatibility with the original version. I've also added error handling to the `getopt` argument parsing.

     
           getopt('dV') or die "Usage: $0 [-d] [-V] [filename]\n";
            @ARGV = ('./xferlog') unless @ARGV;
            while (<>) {
              ...
            }

`getopt` removes the options from `@ARGV`, leaving only the filenames, if any. If there weren't any, we put the default filename, `/.xferlog`, into `@ARGV` as if the user had supplied it themselves. Since the `<>` operator reads from the files named in `@ARGV`, it will read from `./xferlog` if no file was specified on the command line. Using `<>` handles `open` errors for us automatically, and we can omit the `close` call because it's already taken care of for us.
Line 5 is superfluous, because `$\` already defaults to `"\n"`. Line 6 is superfluous, since `$i` would be implicitly initialized to 0, but it won't matter because we're going to get rid of `$i` anyway.

I replaced the `foreach` loop with a `while` loop. The `foreach` loaded the entire file into memory at once, then iterated over the list of lines. `while` reads one line at a time into `$_`, discarding each line after it has been examined. If the input file is large, this will save a huge amount of memory. If available memory is small, the original program might have run very slowly because of thrashing problems; the new program is unlikely to have the same trouble, and might run many times faster as a result.

------------------------------------------------------------------------

         9  foreach $line (<XFERLOG>) {
        10        chomp($line);
        11        if (( $line =~ /$opt_d/i) && ( $line !~ /_ o r/)) 
        12           {
        13           ($Fld1,$Fld2,$Fld3,$Fld4,$Fld5,$Fld6,$Fld7,$Fld8,
                   $Fld9,$Fld10,$Fld11,$Fld12,$Fld13,$Fld14,$Fld15) = split(' ',$line);
          
        14            $uplist[$i] = join ' ',$Fld6, $Fld8, $Fld9, $Fld14, $Fld15;
        15            $time[$i]=$Fld6; $size[$i]=$Fld8; $file[$i]=$Fld9; 
                   $user[$i]=$Fld14; $group[$i]=$Fld15;
          
        16            $username= join '@', $user[$i], $group[$i];
        17            push @{$table{$username}}, $uplist[$i];
        18            $i++;     
        19      }
        20  }

Here's my replacement:

            while (<>) {
              chomp;
              if (/$opt_d/oi &&  ! /_ o r/) {
                my @Fld = split;
                my $uplist = {time => $Fld[5],      size => $Fld[7],
                              file => $Fld[8],      user => $Fld[13],
                              group => $Fld[14],
                             };
                my $username = "$Fld[13]\@$Fld[14]";
                push @{$table{$username}}, $uplist;
              }
            }

Because the current line is in `$_` now instead of `$line`, we can use the argumentless versions of `chomp` and `split` and the unbound version of the pattern match operators, which apply to `$_` by default. I added the `/o` option on the first pattern match to tell Perl that `$opt_d` will not change over the lifetime of the program.

Any time you have a series of variables named `$Fld1`, `$Fld2`, etc., it means you made a mistake, because they should have been in an array. I've replaced the `$Fld1`, `$Fld2`, ... family with a single array, `@Fld`.

`$uplist` was a problem before. It's a large string continaing several fields. Later on, the program would have had to split this string to get at the various fields; this is a waste of time because we have the fields already split up right here and there's no point in joining them just to split them up again later. Instead of turning the relevant fields into a string, I've put them into an anonymous hash, indexed by key, so that the filename is in $uplist-&gt;{file} instead of the third section of a whitespace separated string.

This way of doing things is not only faster, it's more robust. If the input file format changes so that a filename might contain space characters, we only need to change the initial `split` that parses the input data itself. The original version of the program would have needed to have the `join` changed also, as well as the later `split` the re-separated the data. Storing the fields in a hash eliminates this problem entirely.

I also eliminated the superfluous `@time`, `@size`, `@user`, `@group`, and `@uplist` arrays. They were never used. Packaging all the relevant data into a single hash obviates any possible use of these arrays anyway. Because all the arrays have gone away, we no longer need the index variable `$i`. Such a variable, which exists only to allow data to be added to the end of an array, is rarely needed in Perl. It is almost always preferable to use `push`. The `push` line itself is essentially the same.

------------------------------------------------------------------------

This next section is way too long:

        23  undef %saw;
        24  # @newuser = grep(!$saw{$_}++, @user);
        25  $j=0;
        26  foreach  $username ( sort keys %table )
        27          {
        28          my @mylist = @{$table{$username}};
        29          $m=0;
        30          $totalsize=0;
        31          $totaltime=0;
        32          $gtotal=0;
        33          $x=0;
        34          $x=@mylist;
        35          for ($m = 0 ; $m < ($x); $m++)
        36          {
        37                  ( $seconds, $size, $file, $user, $group) = split(' ', $mylist[$m]);
        38                  $totaltime = ($totaltime + $seconds);
        39                  $totalsize = ($totalsize + $size);
        40          }
        41          if ($totaltime==0) { $totaltime=1; }
        42          if ($totalsize==0) { $totalsize=1; }
        43          $avgtr = (($totalsize/$totaltime)/1024);
        44          $gtotal=($totalsize+$gtotal);
        45          $finale[$j]= join ' ', ($totalsize/(1024*1024)), $username, ($x), $totaltime, $avgtr;
        46  #       print $finale[$j];
        47          $j++;
        48  }

26 lines is too much for one block. A 26-line block should be rewritten if possible, and if not, its guts should be scooped out and made into a subroutine.

We can reduce this to about fifteen lines, so I won't use a subroutine here. A lot of that reduction is simply elimination of unnecessary code. We can scrap lines 23 and 24, which are never used. Line 25 is an unnecessary initialization of `$j` whose only purpose is to track the length of the `@finale` array; we can eliminate `$j` entirely by changing this:

        45          $finale[$j]= join ' ', ($totalsize/(1024*1024)), $username, ($x), $totaltime, $avgtr;
        46  #       print $finale[$j];
        47          $j++;

to say this instead:

            push @finale, join ' ', ($totalsize/(1024*1024)), $username, ($x), $totaltime, $avgtr;
            # print $finale[-1];

Now let's work on that inner loop:

        35          for ($m = 0 ; $m < ($x); $m++)
        36          {
        37                  ( $seconds, $size, $file, $user, $group) = split(' ', $mylist[$m]);
        38                  $totaltime = ($totaltime + $seconds);
        39                  $totalsize = ($totalsize + $size);
        40          }

Any time you have a C-like `for` loop that loops over the indices of an array, you're probably making a mistake. Perl has a `foreach` construction that iterates over an array in a much simpler way:

            for $item (@{$table{$username}}) {
              $totaltime += $item->{time};
              $totalsize += $item->{size};
            }

Here we reap the benefit of the anonymous hash introduced above. To get the time and size we need only extract the hash values `time` and `size`. In the original code, we had to do another `split`.

This allows us to eliminate the superfluous variables `$m`, `$x` and `@mylist`, so we can remove lines 28, 29, 33, and 34. We've also used the `+=` operator here to save extra mentions of the variable names on the right-hand side of the `=`.

The modified code now looks like:

            foreach  $username ( sort keys %table ) {
              $totalsize=0;
              $totaltime=0;
              $gtotal=0;
              for $item (@{$table{$username}}) {
                $totaltime += $item->{time};
                $totalsize += $item->{size};
              }
              if ($totaltime==0) { $totaltime=1; }
              if ($totalsize==0) { $totalsize=1; }
              $avgtr = (($totalsize/$totaltime)/1024);
              $gtotal=($totalsize+$gtotal);

              push @finale, join ' ', ($totalsize/(1024*1024)), $username, ($x), $totaltime, $avgtr;
              #     print $finale[-1];
            }

This is already only half as large. But we can make it smaller and cleaner yet. `$totalsize` and `$totaltime` are related, so they should go on the same line. `$gtotal` is incorrectly set to 0 here. It is a grand total size of all the files downloaded, and any initialization of it should be *outside* the loop. The check for `$totaltime==0` is to prevent a divide-by-zero error in the computation of `$avgtr`, but no such computation is performed for `$totalsize`, so the corresponding check is wasted and should be eliminated:

            my  $gtotal=0;

            foreach  $username ( sort keys %table ) {
              my ($totalsize, $totaltime) = (0, 0);
              for $item (@{$table{$username}}) {
                $totaltime += $item->{time};
                $totalsize += $item->{size};
              }
              if ($totaltime==0) { $totaltime=1; }
              $avgtr = ($totalsize/$totaltime)/1024;
              $gtotal += $totalsize;
              push @finale, join ' ', ($totalsize/(1024*1024)), $username, ($x), $totaltime, $avgtr;
              #     print $finale[-1];
            }

For the computation of `$avgtr`, we can do better. The previous line has a special case for when `$totaltime` is zero and the average is undefined. In this case, `$avgtr` is set to an arbitrary and bizarre value; if we sort by `$avgtr` later, these arbitrary values will appear scattered throughout the rest of the data. It's better to handle this exceptional condition explicitly, by replacing

              if ($totaltime==0) { $totaltime=1; }
              $avgtr = ($totalsize/$totaltime)/1024;

with

              if ($totaltime==0) { $avgtr = '---' }
              else { $avgtr = ($totalsize/$totaltime)/1024 }

Finally, the `join` here is committing the same error as the one we eliminated before. There's no point in `join`ing when we're just going to have to `split` it again later anyway; the data are separate now so we might as well keep them separate. The solution is similar; instead of joining the five data items into a string, we parcel them into an anonymous hash so that we can extract them by name when we need to. The final version of the loop looks like this:

            foreach  $username ( sort keys %table ) {
              my ($totalsize, $totaltime) = (0, 0);
              for $item (@{$table{$username}}) {
                $totaltime += $item->{time};
                $totalsize += $item->{size};
              }

              if ($totaltime==0) { $avgtr = '---' } 
              else { $avgtr = ($totalsize/$totaltime)/1024 }
              $gtotal += $totalsize;

              push @finale, {size => $totalsize/(1024*1024),
                             username => $username, 
                             num_items => scalar @{$table{$username}}, 
                             totaltime => $totaltime,
                             avgtr => $avgtr,
                            };
              #     print $finale[-1];
            }

------------------------------------------------------------------------

<span id="Sort_Order">Sort Order</span>
---------------------------------------

Line 49 is the one that I was originally asked to change:

        49  @realfinal =  sort @finale;

Now that `@finale` contains structured records, the change is straightforward:

            @realfinal = sort {$a->{size} <=> $b->{size}} @finale;

If you want to sort the final report by username instead, it's equally straightforward: `@realfinal = sort {$a->{username} cmp $b->{username}} @finale;`

------------------------------------------------------------------------

<span id="Printing_the_Report">Printing the Report</span>
---------------------------------------------------------

Now we're into the home stretch:

        51  $p=0;
        52  $w=0;
        53  $w=@realfinal;
        54  #print $w;
        55  for ($p=($w-1) ; $p>=0; $p--)
        56  {
        57          ($Size, $User, $Files, $Time, $AvgSpeed)= split " ", $realfinal[$p];
        58          $position= ($w-$p);
        59          $percent=(($Size/($gtotal/(1024*1024)))*100);
        60          printf ("$position. $User $Files files ");
        61          printf("%.2fMB", $Size) ;
        62          printf " $Time(s) ";
        63          printf ("%.2f% ", $percent);
        64          printf("%.2fK/s", $AvgSpeed);
        65          print " ";
        66  }
        67          

Here we have another C-style `for` loop that should be replaced by a simple `foreach` loop; this allows us to eliminate `$p` and `$w`. We can loop over the reversed list if we want, or simply adjust the `sort` line above so that the items are sorted into the right (reversed) order to begin with, which is probably better.

The percentage here is the only place in the program that we use `$gtotal`, which needs to be converted to megabytes to match the `size` fields in `@realfinal`. We may as well do this conversion up front. Making these changes, and eliminating the `split` because the `@realfinal` data is structured, yields:

            $gtotal /= (1024*1024);  # In megabytes
            #print @finale;
            my $position = 1;
            for $user (@realfinal) {
                    printf ("$position. $user->{username} $user->{num_items} files ");
                    printf("%.2fMB", $user->{size}) ;
                    printf " $user->{totaltime}(s) ";
                    printf ("%.2f% ", ($user->{size}/$gtotal)*100); # percentage
                    printf("%.2fK/s", $user->{avgtr});
                    print "\n";
                    ++$position;
            }

It's probably a little cleaner to merge the many `printf`s into a single print; another upside of this is that it's easier to see what the format of the output will be:

            $gtotal /= (1024*1024);  # In megabytes
            #print @finale;
            my $position = 1;
            for $user (@realfinal) {
              printf ("%d. %s %s files %.2fMB %.2f%% %.2fK/s\n" , 
                $position, $user->{username}, $user->{num_items}        
                $user->{size}, ($user->{size}/$gtotal)*100, $user->{avgtr}
              );
              ++$position;
            }

That's enough. The new program is 33 lines long, not counting comments, blank lines, and lines that have only a close brace. The original program was 51 lines, so we've reduced the length of the program by more than one-third. The original program had 41 scalar variables, 8 arrays, and 2 hashes, for a total of 51 named variables. The new program has 11 scalars, 3 arrays, and 1 hash, for a total of 14; we have eliminated more than two-thirds of the variables. 15 of these were the silly `$Fld3` variables, and another 22 weren't.

------------------------------------------------------------------------

<span id="Red_Flags">Red Flags</span>
=====================================

A red flag is a warning sign that something is wrong. When you see a red flag, you should immediately consider whether you have an opportunity to make the code cleaner. I liked this program because it raised many red flags:

------------------------------------------------------------------------

<span id="Get_Rid_of_Array_Size_Variables">Get Rid of Array Size Variables</span>
---------------------------------------------------------------------------------

A variable whose only purpose is to track the number of items in an array is a red flag; it should usually be eliminated. For example:

            while (...) {
              $array[$n] = SOMETHING;
              ++$n;
            }

should be replaced with

            while (...) {
              push @array, SOMETHING;
            }

eliminating `$n`.

Notice that although the `$position` variable in the final version of the program looks like it might be an index variable, it actually serves a more important purpose than that: It appears in the final output as a ranking.

------------------------------------------------------------------------

<span id="Use_Compound_Data_Structures_Ins">Use Compound Data Structures Instead of Variable Families</span>
------------------------------------------------------------------------------------------------------------

A series of variables named `$f1`, `$f2`, etc., should always be replaced with an array. For example:

        ($Fld1,$Fld2,$Fld3,$Fld4,$Fld5,$Fld6) = split(' ',$line);

should be replaced with

        @Fld = split(' ',$line);

A similar statement can be made about hashes. If you have `$user_name`, `$user_weight`, and `$user_login_date`, consider using one structure called `%user` with keys `name`, `weight`, and `login_date`.

------------------------------------------------------------------------

<span id="Use_C_foreach_to_Loop_Over_Arra">Use `foreach` to Loop Over Arrays</span>
-----------------------------------------------------------------------------------

C-style `for` loops should be avoided. In particular,

            for ($i=0; $i < @array; $i++) {
              SOMETHING($array[$i]);
            }

should be replaced with

            foreach $item (@array) {
              SOMETHING($item);
            }
