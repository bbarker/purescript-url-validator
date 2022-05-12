// Adapted from Hugh Grigg's code found at
// https://www.hughgrigg.com/posts/validating-urls-with-the-dom/
// In absence of a URI for the author: https://github.com/hughgrigg

// Returns an error string if there is an error, otherwise,
// returns "SUCCESS"
export function _validateURL(credsCheck) {
  return function (url) {
    if (!url || !/^https?:\/\//.test(url)) {
      return "Unknown or missing protocol format in url: " + url;
    }

    var parser = document.createElement("a");
    parser.href = url;

    // Reject URLs with username or password
    if (credsCheck) {
      if (parser.username) {
        return "URL " + url + " contains a username: " + parser.username;
      }
      if (parser.password) {
        return "URL " + url + " contains a password: " + parser.password;
      }
    }

    // Require a dot then something other than
    // numbers and dots in the hostname
    if (!/\.[^0-9.]/.test(parser.hostname)) {
      return "Invalid hostname '" + parser.href + "' in " + url;
    }

    // Disallow whitespace, starting with a dot
    // or ending with a dot in the hostname
    if (/(\s|^\.|\.$)/.test(parser.hostname)) {
      return "Hostname '" + parser.href +
        "' contains whitespace in " + url;
    }

    if (parser.href.toLowerCase().replace(/\/+$/g,"") !==
        url.toLowerCase().replace(/\/+$/g,"")) {
      return "Unkown error: supplied URL " + url + " doesn't " +
        "match parsed href " + parser.href;
    }
    return "SUCCESS";
  };
}

