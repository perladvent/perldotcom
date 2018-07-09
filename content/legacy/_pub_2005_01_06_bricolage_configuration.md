{
   "date" : "2005-01-06T00:00:00-08:00",
   "categories" : "web",
   "title" : "Bricolage Configuration Directives",
   "image" : null,
   "tags" : [
      "bricolage",
      "bricolage-configuration",
      "bricolage-directives",
      "cms",
      "content-management",
      "cpan-installation",
      "mod-perl-installation",
      "web-management"
   ],
   "thumbnail" : null,
   "description" : " In my previous article, I provided a guided tour of the Bricolage installation process. If you followed along, you should now have a nice, functioning installation of Bricolage 1.8 all ready to go. But as Mr. Popeil used to...",
   "slug" : "/pub/2005/01/06/bricolage_configuration.html",
   "draft" : null,
   "authors" : [
      "david-wheeler"
   ]
}



In my previous article, I provided [a guided tour of the Bricolage installation process](/pub/2004/10/28/bricolage_installation.html "Installing Bricolage"). If you followed along, you should now have a nice, functioning installation of Bricolage 1.8 all ready to go. But as [Mr. Popeil](http://www.com-www.com/weirdal/mrpopeil.html "Mr. Popeil") used to say, *"But wait, there's more!"*

Like many other applications, Bricolage comes with a runtime configuration file. This file, named *bricolage.conf*, lives in the *conf* subdirectory of your Bricolage root. It contains a list of settings that tell Bricolage how to find things, how to connect to the database, which optional features to include, and other good stuff. This article provides a guided tour of all of the configuration settings in *bricolage.conf* to enable you to configure things exactly the way you need them, so that you can manage your sites more effectively with Bricolage.

### <span id="configurationformat">Configuration Format</span>

The format of *bricolage.conf*, derived from the [“Perl Cookbook”](http://www.oreilly.com/catalog/cookbook/ "Perl Cookbook in the
O'Reilly Catalog"), is quite simple. A directive appears on a single line, followed by a space, an equal sign, and then the value. Anything after a pound sign (“\#”) is a comment. Typical entries look like this:

    APACHE_BIN   = /usr/local/apache/bin/httpd
    APACHE_CONF  = /usr/local/bricolage/conf/httpd.conf
    LISTEN_PORT  = 80
    SSL_PORT     = 443
    SSL_ENABLE   = No

Most *bricolage.conf* configuration options are one of two types: Boolean values or strings. A Boolean configuration directive can be either enabled or disabled, but you have several ways in which to do so. To enable a Boolean directive, simply set its value to “Yes”, “On”, or “1” (the number one). To disable it, set it to “No”, “Off”, or “0” (zero). String values follow the equal sign. They can be as long as necessary, but cannot break across lines.

### <span id="apacheconfiguration">Apache Configuration</span>

The first section of *bricolage.conf* configures Bricolage to use the Apache web server. Because Bricolage runs on top of Apache but uses its own startup scripts, it needs to know where to find Apache resources so that it can configure and start Apache properly. Bricolage's default method of dynamically configuring Apache therefore relies on these directives. The installation sets many of them for you, but not all, so it's worth it to have a look to see if you need to tweak any of them:

<span id="apachebin">`APACHE_BIN`</span>
This directive tells Bricolage where to find your Apache *httpd* executable, which it uses to start itself up.

<span id="apachecon">`APACHE_CON`</span>
This directive points to the *httpd.conf* file. This, of course, is the famous Apache configuration file. It, too, needs configuration to run Bricolage (the Bricolage installer configures the default *httpd.conf* in the *conf* subdirectory of your Bricolage root directory), and Bricolage, in turn, uses this directive to tell *httpd* where to find the configuration file when it starts up.

<span id="listenport">`LISTEN_PORT`</span>  
This is the TCP/IP port on which Bricolage will listen for requests. It uses the HTTP standard port 80 by default, but you can [change Bricolage to use another port](http://www.bricolage.cc/docs/howtos/2004/04/19/virtual_host_config/ "How to run Bricolage on a Virtual Host and on Non-Standard Ports") if you already have another server listening on port 80.

<span id="sslport">`SSL_PORT`</span>
This is the TCP/IP port on which Bricolage will listen for secure sockets layer (SSL) requests. It defaults to the standard HTTP SSL port 443, but again, you can change it to another port if something else is already using port 443. SSL is disabled by default, however, so read on for details on how to turn it on.

<span id="sslenable">`SSL_ENABLE`</span>
This directive turns on SSL support. You must have either `mod_ssl` or Apache-SSL installed and properly configured in your Apache server. Not quite a Boolean configuration directive, the possible values for `SSL_ENABEL` are “No” (or “Off” or “0” \[zero\]), “mod\_ssl”, or “apache-ssl”. SSL is a useful feature for keeping communications encrypted between the server and users' browsers.

<span id="alwaysusessl">`ALWAYS_USE_SSL`</span>
By default, an SSL-enabled Bricolage installation uses SSL only for logging in to Bricolage and in the user profile (where users can change their passwords). Users can elect to encrypt all communications by checking the “Always use SSL” checkbox when logging in, but some security policies may require the encryption of *all* communications. In such cases, enable this Boolean directive to force the encryption of *all* communications between the Bricolage server and users' browsers.

<span id="sslcertificatekeyfile">`SSL_CERTIFICATE_KEY_FILE`</span>
<span id="sslcertificatefile">`SSL_CERTIFICATE_FILE`</span>
These directives specify the location of your SSL keys. If you've configured `mod_ssl` or Apache-SSL, you should already be familiar with these files. They help to encrypt and decrypt requests between the server and the browser. If you use `make certificate` to generate your SSL certificate during the Apache build process, by default your server key file will be *server.key* in the *conf/ssl.key* subdirectory of your Apache root directory, while the server public key file will be *server.crt* and in the *conf/ssl.crt* subdirectory. Bricolage uses these directives to set the Apache `SSLCertificateKeyFile` and `SSLCertificateFile` directives, respectively, in its dynamic configuration of Apache.

<span id="namevhost">`NAME_VHOST`</span>
This directive roughly corresponds to the Apache *httpd.conf* `NameVirtualHost` directive. Set it to the IP address on which the Bricolage Apache server will listen for requests. If you have only one IP address on your server, the simplest thing to do is to leave this directive set to “\*”, which applies to all IP addresses. Again, Bricolage uses this directive in its dynamic configuration of Apache.

<span id="vhostservername">`VHOST_SERVER_NAME`</span>
This is the virtual host name under which to run Bricolage. Bricolage requires a full host or virtual host to run and will use this directive to configure the virtual host dynamically. Leave it set to “\_default\_” to use the default host name set in your *httpd.conf* file.

<span id="manualapache">`MANUAL_APACHE`</span>
Bricolage uses Apache::ReadConfig to configure the httpd daemon. There is no *httpd.conf* include file. If you want to take control of your Bricolage Apache server by manually configuring it, enable this Boolean directive. It will generate a file, *bric\_httpd.conf*, in the *bricolage* subdirectory of your temporary directory (see the [TEMP\_DIR](#tempdir) directive for the location of the temporary directory). This file will contain all of the Apache configuration directives that Bricolage uses to configure Apache dynamically. Restarting Bricolage will rewrite this file, but if you want to use it and edit it manually, copy it to the *conf* subdirectory of your Bricolage root directory, disable the `MANUAL_APACHE` directive, and then change the section of the *httpd.conf* file that configures Bricolage from:

    PerlPassEnv BRICOLAGE_ROOT
    PerlModule Bric::App::ApacheConfig

To:

    Include /usr/local/bricolage/conf/bric_httpd.conf
    PerlPassEnv BRICOLAGE_ROOT
    PerlModule Bric::App::ApacheStartup

Here */usr/local/bricolage/conf/bric\_httpd.conf* is the full path name to the newly generated *bric\_httpd.conf* file. You can now tweak this file to your heart's content. Just be sure to generate a new one after each upgrade of Bricolage, as certain directives may change between releases.

<span id="sysuser">`SYS_USER`</span>
<span id="sysgroup">`SYS_GROUP`</span>
These directives configure the system user and group used by Bricolage. They should contain the same value as the `User` and `Group` *httpd.conf* directives, usually “nobody” or “www”. Any files written to the file system by Bricolage will be owned by this user and group.

### <span id="databaseconfiguration">Database Configuration</span>

The next major section of the Bricolage configuration file configures the database. Bricolage uses PostgreSQL 7.3 or later for its data store. Connecting to that database requires several attributes, not least of which are the username and password. These are all set during installation, but it's worth being familiar with them in case things change down the line.

<span id="dbname">`DB_NAME`</span>
The name of the database that stores Bricolage's data. The installer will set this for you. The default value, “bric”, works well in most situations, but it might be set to a different name if you entered one during installation, perhaps because you already had another database named “bric”; Why would you want to do that? Perhaps you have multiple Bricolage installations on the same host. Another reason it might be different is that your ISP provides you with a single database that they name according to their own naming conventions. At any rate, you're unlikely to need to change the value of this directive.

<span id="dbuser">`DB_USER`</span>
The username that Bricolage will use when connecting to the database. Again, you are unlikely to need to change this directive, especially because, when Bricolage creates the database, it specifically assigns permissions for this user to access the appropriate tables, sequences, and such. Note that, for security reasons, you should *never* use the PostgreSQL superuser for this directive.

<span id="dbpass">`DB_PASS`</span>  
The password for the `DB_USER` to use to connect to the PostgreSQL database. You'll need to change this directive if the password ever changes in the database. Depending on your PostgreSQL server's security model, it might not matter what the password is. For example, if the PostgreSQL is on the same host as your Bricolage server and trusts local users (the default configuration), it will ignore the password. Consult your PostgreSQL [authentication settings](http://www.postgresql.org/docs/current/static/client-authentication.html "Documentation for PostgreSQL Client Authentication") (in the server's *pg\_hba.conf* file) or check with your PostgreSQL DBA if you have questions.

<span id="dbhost">`DB_HOST`</span>
This is the host name of your PostgreSQL server. If it's on the same host as your Bricolage server, it will likely be commented out, thereby letting Bricolage default to “localhost”. Otherwise, it will be a different host name or IP address. Change this setting if ever your PostgreSQL server moves to a different host or has its host name or IP address changed.

<span id="dbport">`DB_PORT`</span>
The TCP/IP port on which your PostgreSQL server listens for connections. This directive will be commented out if you've installed PostgreSQL locally and you're using Unix sockets instead of TCP/IP for its connectivity (a good idea for security-conscious environments). It will also be commented out if Bricolage should use the default PostgreSQL port of 5432. Otherwise, if Bricolage must connect to the PostgreSQL server via TCP/IP on a port other than 5432, set this directive to the appropriate port number.

### <span id="directorysettings">Directory Settings</span>

Bricolage stores a lot of files on your server's file system, generally in well-named directories below your Bricolage root directory. Sometimes you may want them installed elsewhere, perhaps for the purposes of conserving disk space or distributing I/O between different partitions. If you want to move any of these directories to a location other than that set by the installer, copy over any existing files to ensure that Bricolage continues to operate correctly.

<span id="tempdir">`TEMP_DIR`</span>
Bricolage creates several temporary files as it runs, for its cache, user sessions, and the like. If you selected the “multi” option when installing Bricolage, this directive will point to a directory named *tmp* under your Bricolage root. Otherwise, it will point to your system's global *tmp* directory.

<span id="masoncomproot">`MASON_COMP_ROOT`</span>  
The Bricolage UI uses [HTML::Mason](http://www.masonhq.com/ "Mason
HQ"). All of the components to power the UI live in this directory, generally a subdirectory of your Bricolage root named *comp*. However, media files uploaded to Bricolage also go in this directory, which means that it can become quite large if you manage a lot of media documents. It might be useful, therefore, to move this directory to a separate partition.

<span id="masondataroot">`MASON_DATA_ROOT`</span>
Mason compiles the Bricolage UI components into object files and stores them in this directory. For the most part you don't need to worry about where these files live (the default is the *data* directory under the Bricolage root directory), although Bricolage will read from it quite a lot as it loads the object files into memory, so disk I/O is important. It's unlikely to grow too except...

<span id="burnroot">`BURN_ROOT`</span>
This directive tells Bricolage where to store formatting templates, object files, and burned files that are ready for distribution. As such, it can also grow quite large, especially if you've published or previewed a lot of documents. Bricolage never deletes these files so that you always have a canonical directory of the distribution files output by Bricolage. However, the default location for the `BURN_ROOT` is under the directory specified by the `MASON_DATA_ROOT` directive. If you encounter disk space problems, you might want to move this directory to another partition.

### <span id="xml::writerconfiguration">XML::Writer Configuration</span>

The Bricolage Mason burner is responsible for pushing documents through Mason formatting templates. If you're writing templates that output XML (and I'll demonstrate writing templates in a later article, so hang in there!), you might want to simplify things by using an [XML::Writer](http://search.cpan.org/dist/XML-Writer/ "XML::Writer on
CPAN") object to generate the XML. Bricolage simplifies things by providing these directives to create a globally available XML::Writer object for use in all Mason templates.

<span id="includexmlwriter">`INCLUDE_XML_WRITER`</span>
Enable this Boolean directive to tell Bricolage to create an XML::Writer object that's globally available as `$writer` to all Mason templates. Bricolage is smart enough to configure the XML::Writer object to output XML to Mason's buffer, so that you can even mix standard Mason output in your templates with XML::Writer output.

<span id="xmlwriterargs">`XML_WRITER_ARGS`</span>  
Use this directive to specify a list of options to pass to the XML::Writer constructor when `INCLUDE_XML_WRITER` is enabled. This directive is a string containing a Perl expression to pass to XML::Writer. The [XML::Writer documentation](http://search.cpan.org/dist/XML-Writer/Writer.pm#Writing_XML "Read
the XML::Writer documentation on CPAN") has the full list of possible parameters. Common parameters include `NEWLINES` to trigger the output of new lines between XML elements, and `DATA_INDENT` to indent nested XML elements by a certain number of characters.

### <span id="authenticationconfiguration">Authentication Configuration</span>

Several configuration directives affect the behavior and security of the Bricolage authentication system. Bricolage handles its own authentication, storing passwords in the database as MD5-encrypted hashes and recording authentication in a browser cookie. In a security-conscious environment, it pays to be familiar with these directives and even to review their settings periodically.

<span id="authttl">`AUTH_TTL`</span>
This directive specifies the time-to-live, in seconds, for an authentication session. Each time an authenticated user sends a request to the server, the elapsed time resets to zero. You could therefore set `AUTH_TTL` to 3600 seconds for a one-hour time-to-live, and a user would be able to use Bricolage all day, as long as each request was less than an hour apart (but she might have to re-authenticate after lunch). This directive is especially useful in environments where users access Bricolage from public workstations and forget to log out. The default value of 28800 (eight hours) is probably too long in a production environment.

<span id="authsecret">`AUTH_SECRET`</span>
Bricolage stores the user authentication session locally and keys it off of an MD5 string stored in a browser cookie. The MD5 string comes from the browser's IP subnet, the expiration time, the user name, and the last access time. Because such a string is potentially replicable by someone trying to crack the system, Bricolage also uses a random string of characters to salt the MD5 string. `AUTH_SECRET` is the string used for this purpose. The installer generates it for you, but you might want to change it now and then, in order to keep it random and meet the specifications of your security policy. All users will need to re-authenticate after you change `AUTH_SECRET` and restart Bricolage.

<span id="loginlength">`LOGIN_LENGTH`</span>
This directive specifies a minimum user name length. Each user must have a user name of at least this number of characters. The default, “5”, is generally adequate, and allows the default “admin” user name to work properly.

<span id="passwdlength">`PASSWD_LENGTH`</span>
This directive corresponds to the `LOGIN_LENGTH` directive, but applies to passwords. The password length in Bricolage is unlimited, but it's generally a good idea to ensure that they all contain a minimum number of characters. The default is “5”.

### <span id="distributionconfiguration">Distribution Configuration</span>

When Bricolage previews or publishes documents, it pushes them through formatting templates (written in Mason, Template Toolkit, or HTML::Template) and writes the resulting files to disk. It then distributes those files to the appropriate servers specified in the destination manager in the user interface. (A later article will explain more of the Bricolage administrative interface.) Many run-time configuration directives affect the behavior of the Bricolage distribution server.

<span id="enabledist">`ENABLE_DIST`</span>
This Boolean directive enables Bricolage distribution. The only reason to disable distribution is if you set up a separate distribution server. To my knowledge, no one has actually done this, even though Bricolage supports it. The [QUEUE\_PUBLISH\_JOBS](#queuepublishjobs) directive is more popular to reduce Bricolage server overhead.

<span id="distattempts">`DIST_ATTEMPTS`</span>
Bricolage distributes files via file system copy, FTP, SFTP, or WebDAV—depending on your destination configuration. We all know that failures can occasionally occur. Bricolage will attempt to distribute a file after a failed distribution and will do it multiple times. Set the `DIST_ATTEMPTS` directive to the number of times it should attempt to distribute a file before giving up.

<span id="previewlocal">`PREVIEW_LOCAL`</span>
This Boolean directive enables Bricolage's internal preview server. This is just a URI in the Bricolage UI that knows to serve previewed content rather than the UI. This is handy for evaluating Bricolage, but be sure to disable it in a production environment, especially if your front-end server needs to serve something other than static HTML. The recommended approach is to set up a separate preview server that is identical to your production server and configure a destination to distribute and redirect previews to that server.

<span id="previewmason">`PREVIEW_MASON`</span>
With the `PREVIEW_LOCAL` directive enabled, if the content you're generating includes Mason calls, you can enable this boolean directive to make Bricolage's internal preview server evaluate the Mason code before serving documents.

<span id="defmediatype">`DEF_MEDIA_TYPE`</span>
This string directive identifies the default media type (also called a “MIME type”) of files for which Bricolage cannot determine the media type. The default value, “text/html”, covers a lot of typical files in a Web content management environment, such as *.php* or *.jsp* files. To add new types for Bricolage to recognize, use the media type manager in the UI.

<span id="enablesftpmover">`ENABLE_SFTP_MOVER`</span>
By default, Bricolage does not support distribution via secure FTP (SFTP). If you need it, install the required Net::SFTP module, enable this directive, and restart Bricolage.

<span id="sftphome">`SFTP_HOME`</span>  
If you've enabled SFTP distribution, use this directive specify a home directory for SFTP to use, especially if you want to use public and private SSH keys. Consult the [Net::SFTP](http://search.cpan.org/dist/net-SFTP/ "Net::SFTP on CPAN") documentation for details.

<span id="enablesftpv2">`ENABLE_SFTP_V2`</span>
Enable this directive to prefer SSH2 support for SFTP distribution. You'll also need to install more Perl modules from CPAN. Consult the Net::SFTP documentation for details.

<span id="sftpmovercipher">`SFTP_MOVER_CIPHER`</span>  
Net::SFTP uses the [Net::SSH::Perl](http://search.cpan.org/dist/Net-SSH-Perl/ "Net::SSH::Perl on CPAN") module to handle the SSH side of things. This module supports multiple encryption ciphers. If you prefer one, specify it via this directive.

<span id="enablewebdavmover">`ENABLE_WEBDAV_MOVER`</span>  
Bricolage also supports distribution via [WebDAV](http://www.webdav.org/ "WebDav Resources"), a standard for distributing documents via the HTTP protocol. DAV, as it is also known, has support in multiple web servers including Microsoft's IIS and Apache 2. If you'd like to distribute document files to your production server or servers via DAV, install the [HTTP::DAV](http://search.cpan.org/dist/HTTP-DAV/ "HTTP::DAV on
CPAN") module, enable this Boolean directive and restart Bricolage.

<span id="queuepublishjobs">`QUEUE_PUBLISH_JOBS`</span>
By default, when a user schedules a document to publish immediately, the Bricolage server will immediately execute the distribution. If users publish a lot of documents or you're bulk publishing large sections of your site at once, this can really slow down the Bricolage UI for other users. This is even true even if you've scheduled a bulk of documents to publish at a future date and time, because the way the default *bric\_dist\_mon* script works is to tickle the Bricolage server to distribute documents.

The way around this problem is to enable the `QUEUE_PUBLISH_JOBS` boolean directive and then use the *bric\_queued* program instead of *bric\_dist\_mon*. With `QUEUE_PUBLISH_JOBS` enabled, the Bricolage server will *never* burn and distribute documents, even if a user schedules them to publish *yesterday*. Instead, *bric\_queued* handles all of the burning and distribution itself, without having the Bricolage server expend resources on the task. With this approach, be sure to run *bric\_queued* from a fairly aggressive cron job.

<span id="ftpunlinkbeforemove">`FTP_UNLINK_BEFORE_MOVE`</span>
When Bricolage distributes files via FTP, it uploads them with a temporary file name, and then, when the transfer is complete, it renames the file to the final name. However, if an earlier version of the file is already present, the rename might fail. (This depends on your FTP server, but Microsoft's IIS is the server that led us to add this feature.) In such a case, enable this directive and Bricolage will delete any existing instance of the file before renaming the temporary file.

### <span id="alertconfiguration">Alert Configuration</span>

Bricolage has an interface for sending alert emails when it logs events that meet certain criteria against objects. Bricolage needs to know a few things before it can send the alerts.

<span id="smtpserver">`SMTP_SERVER`</span>
Bricolage uses an SMTP server to send alert email messages. The default value for this directive, “localhost”, is fine if you use a Unix system with sendmail (or some other SMTP server) running locally. If your organization has a dedicated SMTP server or if your Bricolage host has none of its own, change the value of this directive.

<span id="alertfrom">`ALERT_FROM`</span>
Set this directive to an email address that you want to appear in the “From” header of alert emails. I typically set it to something like “Bricolage Admin &lt;www@example.com&gt;”, but use whatever is appropriate for your organization. If your users are inclined to reply to alert emails, you may want to set up a special `ALERT_FROM` email address that has an auto-responder to let the user know that the reply will go unread.

<span id="alerttometh">`ALERT_TO_METH`</span>
This string directive indicates which header to use for specifying alert recipients in email alerts. The possible values are “To” and “Bcc”.

### <span id="userinterfaceconfiguration">User Interface Configuration</span>

Some configuration directives enable you to affect how the Bricolage user interface works in subtle ways. If you haven't used the Bricolage browser-based interface much yet, some of these won't make much sense just now. Feel free to come back and look again when you're you've had some experience with the Bricolage interface and want to make it behave more according to your own notions of correctness.

<span id="fullsearch">`FULL_SEARCH`</span>
By default, when you search for objects in the Bricolage admin interfaces, or for stories, media, or templates in the asset library, the Bricolage UI appends a wildcard character to the end of your search string. Thus if you search for “foo”, the search will return results for all records that *start with “foo”*. If, however, you set the `FULL_SEARCH` Boolean directive to a true value, all searches in the Bricolage UI will become substring searches. So a search for “foo” will return all records where “foo” appears anywhere in a record.

The downside to this approach is that it prevents PostgreSQL from using its database indexes. In principal, this is only a problem if you have a large number of objects in Bricolage. If, say, you had 100,000 stories in Bricolage, you would notice that story searches would be noticeably slower with `FULL_SEARCH` enabled than with it disabled. Leave it disabled if you expect to manage a lot of documents. Your users can always manually prepend the wildcard character (“%”) to the front of search queries if they want a substring search.

<span id="allowworkflowtransfer">`ALLOW_WORKFLOW_TRANSFER`</span>
Bricolage workflows are made up of a series of desks. In general, workflows have their own desks, but desks can appear in more than one workflow. In such a case, documents moved to such a shared desk in one workflow will be visible on the same desk in another workflow. This is great for managing common tasks across workflows, such as translation or legal review. The upshot is that, by default, a document placed on a desk in one workflow cannot be transferred from that desk to another desk in a different workflow. Users can only move it to other desks in the workflow in which it originated. Set the `ALLOW_WORKFLOW_TRANSFER` Boolean directive to a true value to remove this constraint, so that a document placed on a desk in one workflow can be moved from that desk to other desks in other workflows that the desk is in.

<span id="allowallsitescx">`ALLOW_ALL_SITES_CX`</span>
When managing multiple sites in Bricolage, the user interface will display a “site context” select list. Only the workflows for the selected site will be displayed. If you want to allow users to see all of the workflows for all of the sites that they have permission to access, set this Boolean directive to a true value to add an “All Sites” option to the “Site context” select list. But beware! If you have access to a lot of sites, you'll have access to a bewildering number of workflows when you select this option!

<span id="yearspanbefore">`YEAR_SPAN_BEFORE`</span>
<span id="yearspanafter">`YEAR_SPAN_AFTER`</span>
For the input of dates in Bricolage, the user interface offers select lists for the day, month, and year. By default, the years available in the “Year” select list have a limit of the ten years before and after the value for the year or the current year. If you need more years in your select list, set these directives to the number of years before and after the current value or current year. For example, if you manage a site of historical photographs with Bricolage, you might need to select years that range back over 100 years. In such a case, set `YEAR_SPAN_BEFORE` to “100”. A science fiction book review site, on the other hand, might need years much farther in the future. For such a case, set `YEAR_SPAN_AFTER` to the appropriately high number.

<span id="defaultfilename">`DEFAULT_FILENAME`</span>
<span id="defaultfileext">`DEFAULT_FILE_EXT`</span>
The file names generated for story documents are set on a per-output channel basis. The user interface offers default values for these settings in the output channel profile. The default file name is “index”, and the default file name suffix is “html”. If, say, you were outputing content to an IIS server, you might want to set the `DEFAULT_FILENAME` directive to “default” and the `DEFAULT_FILE_EXT` directive to “htm”, instead. It's not a big deal either way, though, because you can actually set the values you need for each output in the user interface. These are just the displayed defaults, settable as directives for the ultimate in laziness.

<span id="enableocassetassociation">`ENABLE_OC_ASSET_ASSOCIATION`</span>
Document models are associated with output channels in Bricolage. When you create a new document based on a model, it will automatically have the output channel associations defined by the model. If you'd like users to be able to change the associations—say, to assign output channels defined by the model to be optionally associated with documents based on that model—set this directive to a true value. If, however, the added complexity of output channel associations will only confuse your users, set this directive to a false value to remove the user interface for changing document output channel associations.

<span id="enablecategorybrowser">`ENABLE_CATEGORY_BROWSER`</span>
When editing a story document in Bricolage, you'll see a select list of all categories that you have READ permission to access to allow you to optionally add the story to a new category. Most of the time, however, you'll only add a story to one or two categories, and then never change these settings. Therefore, if you have a lot of categories in your Bricolage installation (and there are systems in production with over 2000 categories), it's wasteful to load them all every time you edit a story document when you'll never change them again.

In such a case, set the Boolean `ENABLE_CATEGORY_BROWSER` directive to a true value and restart Bricolage. This will change the story profile to offer a link to a category browser, which enables you to search for the category or categories to associate with a story. Now, not only will you no longer load all categories every time you access the story profile (and the story profile is, for content producers, the most commonly accessed page in the Bricolage UI), but you'll only load those you search for in the category browser. I highly recommend that every Bricolage admin to set this directive to a true value.

### <span id="documentmanagementconfiguration">Document Management Configuration</span>

These directives relate to how Bricolage manages documents.

<span id="publishrelatedassets">`PUBLISH_RELATED_ASSETS`</span>
Bricolage allows you to create relationships between documents. These can point to “related stories” or add images to a document, among other things. By default, when you publish a document, Bricolage will also try to publish any related documents. This will help to prevent 404s or broken image problems. In some cases, you might not want this behavior, so set the `PUBLISH_RELATED_ASSETS` Boolean directive to a false value.

<span id="storyuriwithfilename">`STORY_URI_WITH_FILENAME`</span>  
Story documents in Bricolage must have unique URIs. URIs consist of a story's category and optionally other parts of the story, such as its cover date and its slug (a one-word description of a story). They do not, however, consist of the file name. This is in keeping with W3C [suggestions](http://www.w3.org/Provider/Style/URI.html "“Cool URIs don't
change“, by Tim Berners-Lee"). The idea is that the story has a directory URI, and there may be several forms of the story with different file names in that directory, such as “index.html” for HTML, “rdf.xml” for RDF, and “index.pdf” for PDFs.

However, some organizations have Website policies that demand the inclusion of file names in the URI. This is so that different documents can be in the same directory. A common example might be a “About Us” directory with separate “/about/index.html”, “/about/contact.html”, and “/about/copyright.html” documents. Such URIs are not possible by default in Bricolage, which requires that all stories have unique URIs, because each of these stories would have the same URI, namely “/about”. To get around this issue, set the `STORY_URI_WITH_FILENAME` Boolean directive to a true value. From then on, all stories will include their file names in their URIs. Be careful, though! Existing stories will not have their URIs changed. Decide how you want to set this directive when you start using Bricolage, and never change it.

<span id="allowsluglessnonfixed">`ALLOW_SLUGLESS_NONFIXED`</span>
The URIs for story documents are determined by patterns specified on a per-output channel basis. There are two different URI formats in each output channel, one for fixed documents and one for non-fixed documents. Non-fixed documents typically use parts of the cover date in their URIs, while fixed URIs do not. Each document model has a flag set to indicate whether documents based on the model will use the fixed for non-fixed URI patterns. The result is that, for non-fixed stories, you might have URIs like “/reviews/books/2004/12/23/princess\_bride”. Here the URI format includes the slug, a one-word summary of the contents of a story (the “princess\_bride” part of this example). However, slugs are optional in stories, even non-fixed stories. If you want to force all non-fixed stories to include the slug in order to guarantee the creation of more meaningful URIs, set this Boolean directive to a true value.

<span id="autogenerateslug">`AUTOGENERATE_SLUG`</span>
This Boolean directive complements the `ALLOW_SLUGLESS_NONFIXED` directive. If you want to keep the slug optional but generate one when a user neglects to type one in, set `AUTOGENERATE_SLUG` to a true value. This will cause Bricolage to generate a simple slug based on the title of the story. For example, a story with the title “Essential Perl 6” would have the slug “essential\_perl\_6” generated for it.

### <span id="apache::sizelimitconfiguration">Apache::SizeLimit Configuration</span>

Bricolage is a large application that includes many CPAN modules as well as its own 120,000+ lines of code. When you start it up, its processes can take up 30MB of memory or more. In general this isn't a problem, because Apache shares that memory between child processes. As each process handles requests, however, its size can swell independent of other processes. If you're performing resource intensive activities, such as publishing a lot of documents at once, the process that handles the request can become quite large. Because Perl (and, by extension, `mod_perl`) does not return memory to the system, this can give the appearance that you have a memory leak.

The solution to this problem is to use the [Apache::SizeLimit](http://search.cpan.org/dist/mod_perl-1.29/lib/Apache/SizeLimit.pm "Apache::SizeLimit on CPAN") module distributed with `mod_perl` to check your `mod_perl` processes periodically and kill them when they exceed a certain size. Bricolage has integrated support for Apache::SizeLimit that these directives can quickly enable and configure.

<span id="checkprocesssize">`CHECK_PROCESS_SIZE`</span>
This Boolean directive turns on the Apache::SizeLimit support. After you set it to a true value and restart Bricolage, it will use the settings in the following directives to decide how often to check your processes and to kill them when they get to be too big.

<span id="maxprocesssize">`MAX_PROCESS_SIZE`</span>
This is the maximum size, in bytes, that processes can reach before Apache::SizeLimit will kill them.

<span id="checkfrequency">`CHECK_FREQUENCY`</span>
This directive determines how often Apache::SizeLimit will check the size of your `mod_perl` processes. If you set it to “5”, it will check a process after every fifth request handled by that process. The default is “1”.

<span id="minsharesize">`MIN_SHARE_SIZE`</span>
This directive indicates the minimum amount of shared memory the process must employ to avoid being considered a candidate for termination. Consult the Apache::SizeLimit documentation for more information. The default is “0”, meaning that all Apache `mod_perl` processes will have their sizes checked.

<span id="maxunsharedsize">`MAX_UNSHARED_SIZE`</span>
This directive sets a limit on the amount of unshared memory a process may consume to not be a candidate for termination. You can use this directive to tweak your settings if you find that Apache::SizeLimit terminates processes while they are still mainly using shared memory. The default is “0”.

### <span id="virtualftpserverconfiguration">Virtual FTP Server Configuration</span>

Bricolage pushes story documents through formatting templates to generate output when you preview or publish them. Formatting templates can use Mason, Template Toolkit, or HTML::Template. If you have a lot of different types of story documents, or just elements of story documents, you'll likely end up with a lot of templates to manage. Editing templates in the browser interface's `textarea` fields can be a pain. A better approach is to use the Bricolage virtual FTP server, which provides access to all Bricolage templates via FTP. If the security of your password isn't a serious consideration (because FTP sends passwords in the clear, and maybe you work behind a firewall or over a virtual private network), enable the virtual FTP server and edit Bricolage templates from within your favorite FTP-enabled editor (Emacs, Vim, HomeSite, etc.). Here's how.

<span id="enableftpserver">`ENABLE_FTP_SERVER`</span>  
This boolean directive enables the virtual FTP server. Set it to a true value, tune the other FTP directives, reboot Bricolage, fire up the [*bric\_ftpd*](http://www.bricolage.cc/docs/current/api/bric_ftpd.html "bric_ftpd
man page") application, and get to work! Just connect to your Bricolage FTP server on the port specified by the `FTP_PORT` directive, login with your Bricolage username and password, and you can browse templates by site, output channel, and category.

<span id="ftpport">`FTP_PORT`</span>
This directive specifies a TCP/IP port on which the Bricolage virtual FTP server will listen for connections. The default is “2121”.

<span id="ftpaddress">`FTP_ADDRESS`</span>
If your host has more than one IP address, specify one of them here to have the virtual FTP server to listen for connections on that IP address only. By default, the FTP server will listen on all of your host's IP addresses.

<span id="ftplog">`FTP_LOG`</span>
The location of the virtual FTP server log. By default, it will be in the *log* subdirectory of your Bricolage root directory.

<span id="ftppidfile">`FTP_PID_FILE`</span>
Specify the location of the PID file for the Bricolage FTP server. *bric\_ftpd* will use this file to record the PID of the server when you start it and to stop the server when you execute `bric_ftpd -k`. The default is to store the PID file in the *log* subdirectory of your Bricolage root directory.

<span id="ftpdeployonupload">`FTP_DEPLOY_ON_UPLOAD`</span>
As of Bricolage 1.8 and later, the Bricolage FTP server will save templates to your private sandbox when you upload them. This means that they will be checked out to you, appear in your personal workspace in the UI, and execute when you (and only you) preview stories that use them. To check in and deploy a template to use in production when other users preview and publish documents, simply append the string *.deploy* to the end of the file name when you upload it and Bricolage will do the rest.

Prior to version 1.8.0, the Bricolage virtual FTP server checked out, updated, checked in, and deployed templates on every upload. If for some reason you prefer this approach (and to be honest, I can't imagine why *anyone* would!), set the `FTP_DEPLOY_ON_UPLOAD` directive to a true value and restart *bric\_ftpd*.

<span id="ftpdebug">`FTP_DEBUG`</span>
If for some reason the virtual FTP server isn't behaving the way you expect, set this Boolean directive to a true value and restart *bric\_ftpd*. Then tail the FTP log (specified by the `FTP_LOG` directive) to diagnose the problem.

### <span id="preloadingconfiguration">Preloading Configuration</span>

Because Bricolage runs on Apache 1.3, the parent process loads all of its code at startup time, before it forks off any children. This is memory efficient, because most modern operating systems use a copy-on-write forking design. This means that the children all share memory with the parent until they write to that memory, at which time the kernel copies that memory to the child process.

When loading a lot of code, children never overwrite much of it. It's highly advantageous to load as much code as you think you'll need into the parent process at startup time, to prevent each of the children from loading it themselves and taking up that much more memory. These directives help you to do just that.

<span id="perlloader">`PERL_LOADER`</span>  
This string directive can be any Perl code you like, as long as it's all on one line in the *bricolage.conf* file. Bricolage will execute this code at startup time, in the namespace used by the Mason burner. This is very useful for loading Perl modules that your templates use, so that you're not loading them in each child process. The default value loads [Apache::Util](http://search.cpan.org/dist/mod_perl-1.29/Util/Util.pm "Apache::Util on CPAN"), which has many useful HTML output utility functions, and [Bric::Util::Burner](http://www.bricolage.cc/docs/current/api/Bric::Util::Burner "Bric::Util::Burner documentation"), which exports several constants that you can use in templates to tell what type of burn is being executed (preview or publish). Other common modules you might want to load here include [CGI.pm](http://search.cpan.org/dist/CGI.pm/ "CGI on
CPAN") or [XML::RSS](http://search.cpan.org/dist/XML-RSS/ "XML::RSS on CPAN") to assist with HTML and RSS output, respectively. You can load anything here, really.

<span id="loadlanguages">`LOAD_LANGUAGES`</span>
Bricolage has localizations for multiple languages, including German, Portuguese, Italian, Cantonese, Mandarin, and Russian. The localization libraries are Perl modules loaded at server startup time. For the most efficient use of memory, load the languages you expect to use most often by specifying the appropriate language codes (such as “en” for English, “pt\_pt” for Portuguese, “de\_de” for German, etc.) in a space-delimited list via the `LOAD_LANGUAGES` directive.

<span id="loadcharsets">`LOAD_CHAR_SETS`</span>
This directive functions just like the `LOAD_LANGUAGES` directive, except that it loads the libraries that convert to and from UTF-8. Bricolage allows individual users to use different character sets when accessing the Bricolage UI, including ISO-8859-1, ISO-8859-2, Big5, ShiftJIS, GB-2312, and others. To save memory overhead, specify each character set that you expect your users will need to use day-to-day in Bricolage in a space-delimited list in the `LOAD_CHAR_SETS` directive.

### <span id="thumbnailconfiguration">Thumbnail Configuration</span>

As of Bricolage 1.8.0, Bricolage can generate thumbnail versions of image files uploaded for media documents. All you need to do is install the [Imager](http://search.cpan.org/dist/Imager/ "Imager on CPAN") module from CPAN (along with the necessary libraries for the image formats you use—see the [Imager README](http://search.cpan.org/src/TONYC/Imager-0.44/README "Imager
README") file for details) and configure thumbnail support via these directives.

<span id="usethumbnails">`USE_THUMBNAILS`</span>
Set this Boolean directive to a true value and restart Bricolage to have thumbnails generated for all image files in Bricolage. You must have Imager installed, of course. You might also want to consider installing media type icons specific to particular types of non-image files. See the *README* file and script in *contrib/copy\_gnome\_icons* in the Bricolage sources for information on which icon files to use and how to install them using the *copy\_gnome\_icons* script.

<span id="thumbnailsize">`THUMBNAIL_SIZE`</span>
Set this directive to the maximum dimension of thumbnail images, in pixels. Bricolage will use this number to constrain the size of the thumbnail so that its greatest dimension does not exceed this number. For example, if `THUMBNAIL_SIZE` has its default value, “75”, and you upload a 150 x 100 pixel image file, Bricolage will generate a 75 x 50 pixel thumbnail.

### <span id="htmlareaconfiguration">htmlArea Configuration</span>

Bricolage 1.8.0 added support for WYSIWYG (what you see is what you get) editing via the [htmlArea](http://www.htmlarea.com/ "htmlArea
Website") JavaScript editor, though it has this feature disabled by default. To enable it, download and install htmlArea 3.0 (in beta release as of this writing) in the *comp/media/htmlarea* directory under your Bricolage root. Then configure it via these directives and restart Bricolage. You will then be able to specify a “WYSIWYG” field type in document element definitions, and content editors can take advantage of htmlArea's WYSIWYG features when editing content in those fields.

<span id="enablehtmlarea">`ENABLE_HTMLAREA`</span>
Set this Boolean directive to a true value to enable Bricolage's htmlArea support. You must have htmlArea installed in the *comp/media/htmlarea* directory under your Bricolage root.

<span id="htmlareatoolbar">`HTMLAREA_TOOLBAR`</span>
The htmlArea editor offers a lot of WYSIWYG features as controls (buttons) in its interface. The controls handle tasks such as copy, paste, italicize, boldface, link, etc. By default, Bricolage enables only a subset of these controls. The subset excludes layout type features such as font selection and color, line justification, and the like. The idea is to provide only the tools needed for users to easily add semantically meaningful markup rather than layout markup, so as to keep content independent of presentation. If you really need to allow your users to use six different type faces in twelve colors, you can enable the htmlArea controls for these features via the `HTMLAREA_TOOLBAR` directive. The value of the directive is a comma-separated list of single-quoted strings with brackets at either end. See the htmlArea documentation for a [complete list of supported controls](http://www.htmlarea.com/htmlarea_2/documentation.html#setup3 "“htmlArea documentation: How can I change what controls are
displayed on the toolbar?“").

### <span id="upnext">Up Next</span>

Now you have all the information you need to configure how Bricolage operates to your heart's content. My next article will explore the nitty-gritty of defining document models in Bricolage.
