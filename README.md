# purescript-url-validator

## About

This is a fairly minimal URL parser. It relies on JavaScript APIs provided by
the browser (`DOM` and `RegExp`), and has no external JavaScript or `PureScript`
dependencies, other than `PureScript` prelude.

It has not been extensively tested, and likely is not perfect, so if you notice
any issues, please report them. There are some existing unit tests for URLs,
which can be easily extended by adding your own URLs.

## Installation

```
bower install purescript-url-validator
```

## Documentation

Module documentation is [published on Pursuit](http://pursuit.purescript.org/packages/purescript-url-validator).

## Tests

### Run tests in a browser

Do `npm run testbrowser` then open up `dist/index.html` with your browser's web
console open.

### Headless testing

Currently not working, but could be run with `npm run test`
