{
   "description" : " Michael Schwern will be speaking at the O'Reilly Open Source Convention in San Diego, CA, July 23-27, 2001. Excuse me, I'm going to ramble a bit about traffic lights as they relate to language design to see whether something...",
   "draft" : null,
   "tags" : [
      "design",
      "development",
      "lights",
      "perl-6",
      "traffic"
   ],
   "slug" : "/pub/2001/05/22/trafficlights.html",
   "categories" : "community",
   "title" : "Taking Lessons From Traffic Lights",
   "authors" : [
      "michael-schwern"
   ],
   "image" : null,
   "thumbnail" : null,
   "date" : "2001-05-22T00:00:00-08:00"
}



[<img src="/images/conf/confchrome.jpg" alt="O&#39;Reilly Open Source Convention" width="252" height="77" />](http://conferences.oreilly.com/oscon/)
*Michael Schwern will be speaking at the [O'Reilly Open Source Convention](http://conferences.oreilly.com/oscon/) in San Diego, CA, July 23-27, 2001.*

Excuse me, I'm going to ramble a bit about traffic lights as they relate to language design to see whether something interesting falls out.

I was riding my bike to work today and started thinking about the trouble we were having with string concatenation in Perl 6 [\[1\]](#1) and how the basic problem is that we've run out of ASCII characters. I briefly thought about Unicode, but it's not nearly well-supported.

Then I stopped at a traffic light (the police in Belfast get annoyed by bikes blowing through lights, even at 2a.m. on an otherwise empty road. And they drive unmarked cars). Traffic lights convey their signals through color. I briefly thought it would be neat to convey Perl grammar via color, but that can't be done for similar reasons to Unicode.

### Color Coding vs. Position

The interesting thing about traffic lights is that the color is just for clarification. The real communication is through position. Stop on top, caution in middle, go at the bottom (some communities do this a bit differently, but it's all locally consistent). This is important, because a large section of the population is color blind, but even if you saw a traffic light in black-and-white you could still make out the signals by their position.

If you ask anyone on the street what "stop" and "go" are on a traffic light, they'll probably say 'red' and 'green' without even thinking. But if you asked them to draw a traffic light they'd be sure to put the red on top and green on bottom. It's interesting that although we respond strongly to color cues, we subconsciously remember the positional cues. It's especially interesting given that we're never actually taught "go is on the bottom".

There's a thin analogy to syntax highlighting of code, where the color is just there to highlight and position conveys the actual meaning.

This idea of having redundant syntax that exists to merely make something easier to remember is perhaps one we can explore.

### Sequence

<table>
<colgroup>
<col width="100%" />
</colgroup>
<tbody>
<tr class="odd">
<td><hr />
<img src="/images/conf/sidebar-chrome.jpg" alt="O&#39;Reilly Open Source Convention Featured Speaker" width="187" height="73" /></td>
</tr>
<tr class="even">
<td><p><strong><a href="http://conferences.oreillynet.com/cs/os2001/view/e_spkr/324">Michael Schwern</a> will be presenting four sessions at the <a href="http://conferences.oreilly.com/oscon/">O'Reilly Open Source Convention</a> in San Diego, CA, July 23-27, 2001. Rub elbows with Open Source leaders while relaxing on the beautiful Sheraton San Diego Hotel and Marina waterfront. For more information, visit our <a href="http://conferences.oreilly.com/oscon/">conference home page</a>.</strong></p>
<hr /></td>
</tr>
</tbody>
</table>

Now, color and position aren't the only tools a traffic light has. Order is another. Stop, Go, Caution, Stop, Go, Caution ... that's the way it goes. Again, most people know this subconsciously even if they've never been taught it or ever thought about it. It's a pattern that's picked up on and expected. Go follows Stop. Caution precedes Stop. If a light were to suddenly jump from Go to Stop, drivers would be momentarily confused and indecisive.

The lesson there is simple: be consistent.

So while order doesn't convey any extra information, its consistency can be important. I experienced this when I came to Belfast. The lights here go: Stop, Caution, Get Ready, Go where "Get Ready" is conveyed by a combination of red and yellow. Very useful (especially if you drive a stick or have toe-clips on your bike and need a moment to get ready) but a bit confusing the first few times.

This directly contradicts the above lesson, eschew consistency if it's going to add a useful feature. People may be taken back the first few times, but the utility will shine through in the long run. This could be considered a learning curve.

### Combinations

Which brings us to another tool: combinations. Although rarely done, you can squeeze more meaning out a set of lights by combining them. Just like a three-bit number. The red-yellow combination is the only one I can think of, and probably rightly so. While there's still three more combinations available, they would rapidly get confusing if used.

Perhaps the lesson is: Just because you can wedge more meaning in doesn't mean you should.

The final method of communication is flashing. Flashing red is like a stop sign. Flashing yellow, proceed with caution. I don't think flashing green is ever used or what it could mean [\[2\]](#2). Most flashing lights are there to draw attention. Emergency vehicles, gaudy advertisements, navigation lights. Flashing signals are deliberately jarring. They're also rarely used in combination with the normal signals. This is very important. The normal confusion associated with a break in the pattern isn't there since the normal pattern is totally absent. The meaning of the flashing signals is close to their normal solid meaning, which allows most drivers to know what they mean without thinking about it.

Flashing signals are also rather rare. They're used at times when there's few cars on the road (late at night) or on roads that carry little traffic.

The lesson there, if you're going to be inconsistent, is make sure you don't do it in a way that will mix with the normal pattern of things. Think about how the inconsistent feature will be used and make sure it will be used in spots that are distanced from normal use. Also, the potential uses of the inconsistent feature should be relatively rare.

As an aside, when I was young and on vacation with my family, we visited my uncle in the middle of the Mohave Desert. He worked at a borax mine (yep, mining for soap). Aside from the 40-foot-high dump trucks, the thing I remember most is the speed-limit signs. Has to be 15 years ago and I still remember this. The speed limit was "12 1/2 MPH." Why? Not because you'll get pulled over if you go 13 MPH, but so you'll take notice. Consistency can ease understanding, but it can also encourage complacency.

Back to flashing. Although it will vary from light to light, a single light will only use one frequency. They could use more. In fact, an almost infinite amount of information could be conveyed by various frequencies of flashing. This technique is in active use today by most Navies of the world as a method of secure, short-range ship-to-ship communication. Powerful signal lamps with shutters are used to flash Morse code between ships. More commonly, FM (Frequency Modulation) radio is essentially just a big flashing traffic light.

Traffic lights chose to use only one frequency. Why? Simplicity. There is flashing and there is not flashing. That's it. Easy to remember, but more importantly, easy (and quick) to recognize. Very important when a car is approaching at 65 mph.

There comes a point when you're cutting the syntax too fine. When the distinctions between one meaning and another take too much careful examination to distinguish. A good example being the string concat proposals that wanted to use certain whitespace combinations to distinguish, or special uses of quotes. Perl 6 must be careful of this sort of thing as we strive to shove more and more information into just 95 lights (the set of printable ASCII characters). There's a reason the Navy employs highly trained men on those signal lamps.

### Sound as Syntax or Grammar

Finally, there's sound. I lived in Pittsburgh for a while near a school for blind children and a clinic for the blind. The major intersections for a few blocks around all had the normal walk-don't-walk pedestrian signals, but these are a bit different. Rather than the usual Walk with the green, Don't Walk with the red, it would be Don't Walk in all directions. When Walk came on, all lights would go red and pedestrians could cross in any direction.

This was accompanied by a distinct, very loud "koo-koo" sound to let the blind know it was time to cross. Also, there was a speaker at each corner to give them something to walk toward.

Sound as syntax. It would be interesting to use sound as grammar, especially since we already have a grammar to represent sound (i.e. sheet music). However, I don't know about you, but I'm not about to start dragging around a Moog with me to code Perl ... though playing chords to represent code would be neat. Imagine the twisted noises coding a particularly nasty regex might produce.

Rambling along this thread, it has been reported that London.pm recently attempted to encode DeCSS as an interpretive dance. Perhaps DeCSS will surpass the Tarentella as the "Forbidden Dance".

There are also some attempts at translating Perl code to music. I think someone hooked Perl code run through the DNA module into something that generates music from genetic code. But I digress.

### The Function of Traffic Lights

Let's think about what traffic lights are used for. Well, they're there to control the flow of traffic. Theoretically, you'd want to use them to maximize use of the available roads and get the most cars to their destinations as quickly and efficiently as possible. You'd do things like time the lights down a stretch of road so someone going the speed limit never hit a red light. You'd want to keep the lights green as long as possible on the major roads at intersections. You'll want sensors to detect when no car is waiting for a red so it can keep the other side green longer. By doing this you'll get everyone coordinated and moving about quickly.

But then traffic lights can be used for the exact opposite. They can be used to deliberately slow and minimize traffic, say around a school or in a shopping district with lots of pedestrians. Lights will be deliberately set to prevent drivers from going continuously down a road, making them stop often and keeping their awareness up (but perhaps their frustration and gasoline consumption as well). All sides of an intersection can be stopped at once to allow pedestrians to pass safely. Flashing yellows can be employed to warn of a school zone. Lights can be placed at dangerous intersections (or ones where children are known to be about) even though drivers should be able to self-regulate.

So the same device and features can be combined and used in different ways to produce contradictory effects. Perl 6 must have this nature, as is clearly evident from the wildly differing and contradictory RFCs presented, often in direct opposition to each other. We should design Perl features to be like traffic lights. The same feature can be used for different and contradictory effects. This will ease the pressure to squeeze more and more grammar out of our limited syntax possibilities.

Oddly enough, varying the number of traffic lights can effect efficiency. By over-regulating you can choke off traffic. Constant fiddling with the setups and timings, trying to control each and every intersection to maximize throughput leads to grid lock, zero throughput. The exact opposite of what was intended.

We are in danger of doing just that. By wanting to correct, streamline and optimize each bump and snag in Perl we may cross some imaginary line and have syntactical grid lock where the language design descends into a morass of continual minor adjustment. By backing off we can often find a much more sweeping solution than just putting up lights on each corner. A perfect example is Larry's "module" solution to the Perl 6 vs. Perl 5 interpretation (although it still needs a few extra lights here and there to make it really work).

### Life without Traffic Lights

There is an alternative to all this. I've been working in Ireland for the past three months, and like most Americans I have met that peculiar English invention, the roundabout. [\[3\]](#3) Three, four, five, even six-way intersections are handled seamlessly by this apparently anarchistic piece of the transportation landscape. All without any traffic lights.

First few times, I fearfully creeped across, pushing my bike along as a pedestrian, too frightened to try and enter the unending flow of traffic. After a while, and asking around a bit, the underlying rule became obvious: yield to traffic in the circle. With this revelation I was able to zip through confidently. I rather like them now and appreciate how they keep the traffic flowing even for the most complicated intersections. The apparent complexity of the details (lots of cars zipping about, merging and leaving from many points) all stems from a single rule.

Contrast this with the typical American four-way intersection. Roads placed at right angles, traffic lights poised in each direction. Cars jerk forward hesitantly and the system rapidly breaks down under heavy traffic. Initially easier to learn, anyone can understand a traffic light, but the devilish complexity of right-of-way and subtleties of making a proper left turn betray that what seems at first simple, might actually be clunky in the long run. And that which seems complex and frightening will yield its underlying simplicity with time and experience.

So the lesson there, aside from "roundabouts are neat" is about learning curves and the wisdom of focusing design on "beginners." While effort must be made to flatten the learning curve, don't short-change the ultimate goal just to make it easier initially. After all, we are only beginners for so long. [\[4\]](#4)

### Foot Notes

<span id="1">\[1\]</span> It has been decided that `.` will be used instead of `->` for method calls in Perl 6. This leaves the problem of how to concatenate strings. Everyone and their dog seemed to have a proposal on the perl6-language mailing list, all of them a bit contrived as we've run out of characters.

<span id="2">\[2\]</span> It has been reported by two sources that there is a flashing green light outside of Boston that meant "this light will rarely go red."

<span id="3">\[3\]</span> Some may call them "traffic circles." Most Americans know them best from "National Lampoon's European Vacation" ("Look kids! Big Ben, Parliament!") They're used in a couple places in the U.S.: Oregon, Florida, New England. "[Modern Roundabouts](http://www.engr.orst.edu/~taekrtha/round.html%0A)" gives a nice explanation and visualization from an American point-of-view (i.e. the right side of the road).

<span id="4">\[4\]</span> Of course, this can get a little out of hand: "[Swindon's Magic Roundabout"](http://www.swindonweb.com/life/lifemagi0.htm%0A)
