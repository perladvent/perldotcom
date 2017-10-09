(function() {
  "use strict";
  var httpRequest, response, url, ul, i, div, css_link, head, url_parts, hostDomain, linkDomain, links, linkCount;
  url = "https://perltricks.com/perlybot/links.json";
  linkCount = 10;

  if (window.XMLHttpRequest) {
      httpRequest = new XMLHttpRequest();
      httpRequest.onreadystatechange = buildLinksList;
      httpRequest.open("GET", url, true);
      httpRequest.send();
  }

  function buildLinksList() {
    if (httpRequest.readyState === XMLHttpRequest.DONE) {
      if (httpRequest.status === 200 || httpRewquest.status === 304) {
        response = JSON.parse(httpRequest.responseText);
        hostDomain = extractDomain(window.location.href);

        // build list of html links
        ul = '<ul>';
        links = [];
        for (i=0; i < 10; i++){
          linkDomain = extractDomain(response[i].url);
          // skip links to articles on the host's own website
          if (linkDomain === hostDomain) {
            continue;
          }
          links.push('<li><a href="' + response[i].url + '">' + response[i].title + '</a><br/>' + linkDomain + '</li>');
        }
        var div = document.getElementById("toplinks");
        div.innerHTML = '<div class="toplinksheader">LATEST COMMUNITY ARTICLES</div>' + ul + links.join('') + '</ul>';

        // inject css
        head = document.getElementsByTagName('head')[0];
        css_link = document.createElement('link');
        css_link.setAttribute('rel','stylesheet');
        css_link.setAttribute('type','text/css');
        css_link.setAttribute('href','/widgets/toplinks/toplinks.css');
        head.appendChild(css_link);
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
