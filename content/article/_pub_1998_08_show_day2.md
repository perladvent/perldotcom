{
   "slug" : "/pub/1998/08/show/day2.html",
   "tags" : [],
   "draft" : null,
   "description" : null,
   "date" : "1998-08-19T00:00:00-08:00",
   "image" : null,
   "thumbnail" : null,
   "authors" : [
      "brent-michalski"
   ],
   "title" : "Day 2: Perl Mongers at The Conference",
   "categories" : "Community"
}



### Advanced Perl Fundamentals

Day 2 of The Perl Conference was another exciting day! I spent the day in the *Advanced Perl Fundamentals* tutorial given by Randal Schwartz and Tom Phoenix.

Randal and Tom make an excellent team. Randal did most of the speaking and Tom did the technical work but any time he was needed, Tom was right there to answer any questions or fill in where Randal left off.

The tutorial was actually one of the classes that Randal gives when he teaches for [Stonehenge Consulting](http://www.stonehenge.com). Normally, this would be a three or four day class but Randal presented it in one very intense day. I wouldn't recommend taking this course in a one day setting if you can help it! Randal did a great job answering the questions from the audience and was able to stay on topic, most of the time. Randal and Tom have a great sense of humor and they were able to keep us all interested by combining Perl instruction and jokes throughout the day.

Randal covered many advanced Perl topics like regular expressions, the `map` operator, the `eval` operator, anonymous arrays and Object Oriented Perl - to name a few. One of the more interesting items Randal covered was the *Schwartzian Transformation*. Simply put, the Schwartzian Transformation is a very efficient way to sort hashes. Here it is, in it's entirety:

    @sorted_files =
      map { $_->[0] }
      sort { $a->[1] <=> $b->[1] }
      map { [ $_, -s $_ ] }
      <*>;

This example sorts a directory by file size but Randal assured us it can be easily modified to fit just about any situation.

Towards the end of the tutorial, Randal was talking about Object Oriented Perl. Randal summed it all up when someone asked whether OO Perl was better than non-OO Perl. Randal's answer was simple *"Objects are good when they are good."* With those words of wisdom, we were let go to gather whatever brain cells we had left and prepare for the evening activities.

#### The [Perl Mongers](http://www.pm.org) BOF Session

This was not a regular tutorial, but instead was part of the evening activities to keep the Perl developers busy. brian d foy *(No, I didn't spell it wrong.)* was on hand to talk about what the Perl Mongers are, and explain the concept behind the Perl Mongers group.

brian started a non-profit organization called Perl Mongers and its purpose is to get Perl programmers together. The idea is that Perl Monger groups are formed in the different cities/areas of the world and the members meet and discuss Perl. This is very much like a user-group, but with the Perl Mongers, brian is trying to take a lot of the hassle out of starting the groups by doing the *grunt work* himself. By "grunt work", I mean brian is handling things like mailing lists, providing DNS names and taking care of the legal issues.

There are already several Perl Monger groups around the globe and this meeting created even more interest in the idea. Good luck brian, Perl Mongers is a great idea.

#### Fireside Chat with Jon Orwant

To close out the evening, I attended the *Fireside Chat with Jon Orwant*. Jon is the publisher of [The Perl Journal](http://www.tpj.com).

This was to be an evening of drinks and "talking Perl", but the evening started out a bit differently than I had expected. There was a group of about 40 of us and the idea was to go to a local bar because it had a picture of a camel on it. Well, the bar was much too small so we proceeded to three of four other bars before we found one that could accommodate us! Try to imagine 40 Perl programmers walking the streets of San Jose at night, *it's not a pretty picture* ;-) Needless to say, we got many strange looks from the people we passed.

We ended up singing *Happy Birthday* to Jon and thoroughly embarrassing him, he tried to keep it a secret. Happy Birthday Jon!

Tomorrow is Larry Wall's *State of the Onion Address*. I have been looking forward to this speech and I will bring you the details of Day 3 at The Perl Conference tomorrow!
