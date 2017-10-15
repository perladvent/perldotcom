{
   "thumbnail" : "/images/_pub_2004_07_02_poeintro/111-poe.gif",
   "tags" : [
      "poe",
      "session",
      "thread"
   ],
   "image" : null,
   "title" : "Application Design with POE",
   "categories" : "development",
   "date" : "2004-07-02T00:00:00-08:00",
   "draft" : null,
   "authors" : [
      "matt-cashner"
   ],
   "description" : " Day in and day out, I write large applications in perl. I'm cursed I tell you. While large scale, long-running applications in pure perl may sound fairly easy to write, they are not. Perl, beyond a certain size and...",
   "slug" : "/pub/2004/07/02/poeintro.html"
}



Day in and day out, I write large applications in perl. I'm cursed I tell you. While large scale, long-running applications in pure perl may sound fairly easy to write, they are not. Perl, beyond a certain size and complexity, gets really difficult to manage if one is not extremely careful. The proper choice of an application framework helps to minimize this difficulty. For many applications, apache and mod\_perl make a lot of sense. This is an excellent choice for user interface applications and data display systems. However, HTML and the WWW simply don't make sense for many forms of long-running applications, particularly network based servers. Apache certainly isn't the right choice for syslog monitoring or edge host traffic analysis.

My framework of choice is POE. POE is a single-threaded, event driven, cooperative multitasking environment for perl. Basically, POE is an application framework in which a single threaded perl process waits for events to occur so it can act accordingly. This event loop comprises the core of a POE process.

If all POE offered was an event loop, there would not be much to talk about though. Nor would POE be particularly special. Several event loop modules already exist on CPAN. Event, Coro, IO::Events, and IO::Poll all offer similar functionality. However, any worthwhile application demands more than a simple set of actions.

### <span id="SESSIONS">SESSIONS</span>

POE programs begin with a 'session'. Each session represents a cooperatively multi-tasked state machine.

        POE::Session->create(
            inline_states => {
                _start => \&start,
                _stop => \&stop,

                do_something => \&do_something,
            },
            heap => {
                'some' => 'data',
            },
        );

Sessions are slightly analogous to threads in that they have a unique runtime context and a semi-private data store (called the "heap"). Each session operates independently from other sessions, receiving time-slices from the POE kernel. It is important to remember that, despite the similarity to threads, all POE sessions run in the same single-threaded process.

Sessions provide very simple, easy to understand building blocks on which to build more complex applications. POE provides a way to give sessions names, called *aliases*, which uniquely address the session from outside the session itself. `$poe_kernel->alias_set($alias)` sets an alias for the current session. Any POE session in the process can then send events to that session using the named identifier.

        if($door_bell) {
            $poe_kernel->post( $alias => 'pizza' );
        }

Remote addressing provides the ability to have a service-like model inside an application. Different sessions provide different services to the application. One session may provide DNS resolution while another provides data storage. Using commonly known names, perhaps stored in a config file, the central application becomes much smaller and easier to manage.

### <span id="COMPONENTS">COMPONENTS</span>

POE components provide an abstract api to service-like POE sessions. Rather than duplicating the session construction call and the accompanying subroutines every time you find a new use for your sessions, it is a better idea to roll all that code into a perl module.

        package POE::Component::MyService;

        sub create {
            POE::Session->create(
                # ...
            );
        }

        sub start {
            $poe_kernel->alias_set(__PACKAGE__);
        }
        
        
        ####
        
        
        #!/usr/bin/perl
        use POE;
        use POE::Component::MyService;

        POE::Component::MyService->create();
        POE::Kernel->run();

The POE community has created a standard namespace of `POE::Component` for these modules. Typically they have a constructor called `create()` or `spawn()` and provide a service to the POE application via a session. Apart from these few simple rules, components are free to do whatever is necessary to fulfill their purpose. `POE::Component::Server::Syslog`, for instance, spawns a UDP listener and provides syslog data via callbacks. `POE::Component::RSS` accepts RSS content via an alias and calls specially named events to deliver data. `POE::Component::IRC` follows a similar model.

### <span id="WHEELS">WHEELS</span>

For some tasks, a full session is unnecessary. Sometimes, it makes more sense to alter the abilities of an existing session to provide the desired functionality. POE has a special namespace called `POE::Wheel` for modules which mutate or alter the abilities of the current session to provide some new functionality.

        package POE::Wheel::MyFunction;

        sub new {
            # ...
        }

        ####

        #!/usr/bin/perl
        use POE;
        use POE::Wheel::MyFunction;

        POE::Session->create(
            #...
            foo => \&foo,
        );

        POE::Kernel->run();

        sub start {
            POE::Wheel::MyFunction->new(
                FooState => 'foo'
            );
        }

Where components often use subroutine callbacks in the same way as `POE::Session`, wheels use local event names to provide functionality. Internally, they create wrappers around calls to these events which build the context necessary for a POE event to occur.

Wheels are much more complex to create, for good reason. Wheels share their entire operating context with the user's session but share very little of the niceties. Wheels do not have their own heap and cannot create aliases for themselves. In many ways, they are like a parasite clinging to the side of the user's code. As long as they don't get in the way and they provide a useful function, they are allowed to exist.

The development overhead is made up for, however, by the loss of internal POE overhead. Sessions require a certain amount of maintenance to keep running. POE checks sessions to see if they still have work to do, if there are timers or alarms outstanding for them, if they should be garbage collected, etc etc. The more sessions that exist in a system, the more that overhead grows. This overhead is especially noticeable in time sensitive applications. Wheels have none of this overhead. They piggyback on top of the user's session so, apart from any events they may trigger as part of their normal operation, there is no inherent internal POE overhead in using a wheel.

### <span id="FILTERS">FILTERS</span>

Many wheels handle incoming and outgoing data. They exist to help the user get data from some strange source (say, HTTP) into a format the user can analyze or take apart in perlish ways. `POE::Wheel::SocketFactory`, for instance, handles all the scariness of nonblocking socket creation and maintenance. For most of us, however, SocketFactory doesn't go far enough. I don't want to have to worry about pack calls or http headers or whatever other nonsense is necessary to take a transaction off the wire and make it palatable. Special modules in the `POE::Filter` namespace handle this drudgery.

        package POE::Filter::MyData;

        sub new {
            # ...
        }
        
        sub put {
            # ...
        }

        sub get {
            # ...
        }

Filters are very simple data parsing modules. Most POE filters are limited enough to be used outside of a POE environment. They know nothing of POE or of the running POE environment. The standard interface requires three methods: `new()`, the constructor; `get()`, the input parser; and `put()` the output generator. `get()` takes a stream of data and returns parsed records, which may be hashes, arrays, objects, or anything else one might desire. `put()` takes user generated records and converts them to raw data.

<span id="Design">Design</span>
===============================

With these four simple building blocks, POE applications can grow to meet almost any need while still being maintainable. The key is to break the application up into small chunks. This is beneficial for two main reasons: 1) the individual chunks are more easily understood by a new staff member or someone else looking at the code six months from now. 2) Smaller blocks of code spend less time ... well, blocking.

As noted above, a POE application is a single-threaded process that pretends to perform asynchronous actions through a technique called cooperative multitasking. At any given time, only one subroutine inside a POE application is executing. If that one subroutine has a `sleep 60;` inside of it, the entire application will sleep for 60 seconds. No alarms will be triggered; no actions will occur. Smaller blocks of code mean that POE gets a chance to do other actions like cleaning up sessions that are shutting down or executing another event.

Even long-running for-loops can be broken down into small POE events.

        while(@data) {
            # ... process, process
        }

can become

        $poe_kernel->yield('process_data' => $_) for @data;

This gives POE time to read from sockets, do internal housekeeping, and so on,between each bit of processing time. If `@data` is large enough, however, this method can lead to resource depletion - spewing out 5000 events to process `@data` may get the job done and allow POE to do housekeeping, but it means that for the next 5000 event invocations, POE is doing nothing but processing that array.

POE's event queue is a FIFO (First In First Out). Events are processed in the order they are invoked. There are two major exceptions to this. Signals can trigger immediate event processing, and using `call()` instead of `yield()` or `post()` will cause immediate event processing. Beyond those two exceptions, every event happens in order, all of the time.

In the example above, we asked POE to push a large number of events on the queue. While POE can still read off whatever socket we're getting data from inbetween those `yield`s, the events triggered by that socket read will not be invoked until after we're done processing our giant array. We can break that pattern out very easily.

If we don't need to process `@data` in any timely fashion, we can stagger the processing out further:

        $poe_kernel->delay_add('process_data' => $hence++ => $_) for @data;

This will process one chunk of `@data` every second. Not very efficient or timely but other events can take place between invocations. One second is by no means the smallest time value accepted by `delay_add()`. Use of `Time::HiRes` allows for microsecond delay values:

        use Time::HiRes;
        use POE;

The use of `Time::HiRes` before importing `POE` causes POE to use `Time::HiRes`' `time()` instead of perl's built-in `time()`. While `Time::HiRes` has much greater resolution on time values, it may or may not be the most accurate time keeper on your particular platform. Do your homework and make the choice that best suits your situation and needs.

<span id="Conclusion">Conclusion</span>
=======================================

POE is a flexible application framework appropriate for long-running large-scale perl applications. It provides standard interfaces for task abstraction and forces the coder to think about their software in smaller, more maintainable chunks.

POE is available on CPAN (<http://search.cpan.org/dist/POE>) and has a rich, community-maintained website (<http://poe.perl.org>).
