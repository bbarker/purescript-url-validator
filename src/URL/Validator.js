"use strict";

// Adapted from Hugh Grigg's code found at
// https://www.hughgrigg.com/posts/validating-urls-with-the-dom/
// In absence of a URI for the author: https://github.com/hughgrigg

// Returns an error string if there is an error, otherwise,
// returns "SUCCESS"
exports._validateURL = function(credsCheck) {
  return function (url) {
    if (!url || !/^https?:\/\//.test(url)) {
      return "Unknown or missing protocol format";
    }

    var parser = document.createElement("a");
    parser.href = url;

    // Reject URLs with username or password
    if (credsCheck) {
      if (parser.username) {
        return "URL contains a username";
      }
      if (parser.password) {
        return "URL contains a password";
      }
    }

    // Require a dot then something other than
    // numbers and dots in the hostname
    if (!/\.[^0-9.]/.test(parser.hostname)) {
      return "Invalid hostname";
    }

    // Disallow whitespace, starting with a dot
    // or ending with a dot in the hostname
    if (/(\s|^\.|\.$)/.test(parser.hostname)) {
      return "Hostname contains whitespace";
    }

    if (parser.href.toLowerCase() !== url.toLowerCase()) {
      return "Uknown error: supplied URL " + url + " doesn't " +
        "match parsed href " + parser.href;
    }
    return "SUCCESS";
  };
};

