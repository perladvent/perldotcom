(function() {
  "use strict";
  var httpRequest, response, url, ul, i, div, url_parts, hostDomain, linkDomain, links, linkCount;
  url = "https://s3.amazonaws.com/perly-bot.org/links.json";
  linkCount = 10;

  if (window.XMLHttpRequest) {
      httpRequest = new XMLHttpRequest();
      httpRequest.onreadystatechange = buildLinksList;
      httpRequest.open("GET", url, true);
      httpRequest.send();
  }

  function buildLinksList() {
    var ignore_hosts = [ 'www.perl.com', 'perl.com', 'perldotcom.perl.org' ];
    if (httpRequest.readyState === XMLHttpRequest.DONE) {
      if (httpRequest.status === 200 || httpRequest.status === 304) {
        response = JSON.parse(httpRequest.responseText);
        hostDomain = extractDomain(window.location.href);
        ignore_hosts.push( hostDomain );
        // build list of html links
        ul = '<ul>';
        links = [];
        for (i=0; i < 10; i++){
          linkDomain = extractDomain(response[i].url);
          console.log( "linkDomain is " + linkDomain );
          // skip links to articles on the host's own website
          if (ignore_hosts.includes(linkDomain)) {
          console.log( "linkDomain is in the ignore list" );
            continue;
          }
          links.push('<li><a href="' + response[i].url + '">' + response[i].title + '</a><br/>' + linkDomain + '</li>');
        }
        var div = document.getElementById("toplinks");
        div.innerHTML = '<div class="toplinksheader">LATEST COMMUNITY ARTICLES</div>' + ul + links.join('') + '</ul>';
      }
      else {
        console.log("Error requesting " + url);
      }
    }
  }
  function extractDomain(url) {
    return url.split("/")[2];
  }
})();
