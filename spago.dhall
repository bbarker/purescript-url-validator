{ name = "url-validator"
, dependencies =
  [ "either"
  , "maybe"
  , "prelude"
  , "strings"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs" ]
}
