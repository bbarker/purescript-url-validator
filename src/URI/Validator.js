"use strict";

// Returns an error string if there is an error, otherwise,
// returns null
exports.validateUrl = function(credsCheck) {
  return function (url) {
    if (!url || !/^https?:\/\//.test(url)) {
      return "Unknown or missing protocol format";
    };

    const parser = document.createElement('a');
    parser.href = url;

    // Reject URLs with username or password
    if (credsCheck) {
      if (parser.username) {
        return "URL contains a username"
      };
      if (parser.password) {
        return "URL contains a password"
      };
    };

    // Require a dot then something other than
    // numbers and dots in the hostname
    if (!/\.[^0-9.]/.test(parser.hostname)) {
      return "Invalid hostname"
    };

    // Disallow whitespace, starting with a dot
    // or ending with a dot in the hostname
    if (/(\s|^\.|\.$)/.test(parser.hostname)) {
      return "Hostname contains whitespace"
    };

    if (parser.href !== url) {
      return "Uknown error: supplied url ${url} doesn't match parsed href ${parser.href}"
    };
    return null;
  };
};

