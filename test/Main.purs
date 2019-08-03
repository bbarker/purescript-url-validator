module Test.Main where

import Prelude

import Data.Array                        (concat)
import Data.Either                       (Either(..), isLeft, isRight, fromLeft, fromRight)
import Data.Foldable                     (for_)
import Effect                            (Effect)
import Test.Unit                         (TestSuite, suite, test)
import Test.Unit.Main                    (runTest)
import Test.Unit.Assert                  as Assert
import URL.Validator

goodPrivateUrls :: Array String
goodPrivateUrls = [
  "https://userid:password@example.com:80/page?q=foobar#section"
]

badPrivateUrls :: Array String
badPrivateUrls = [
  "https://userid:password@exam ple.com:80/page?q=foobar#section"
]

goodUrls :: Array String
goodUrls = [
    "https://www.example.com:80/page?q=foobar#section"
  , "https://www.example.com:80/pa+ge?q=foobar#section"
  , "https://www.example.com:80/pa%20ge?q=foobar#section"
  , "https://www.exa%20mple.com:80/page?q=foobar#section"
  , "http://HgMuxvbx.au/"
  , "http://foo.com"
]

badUrls :: Array String
badUrls = [
    "httqs://www.example.com:80/page?q=foobar#section"
  , "https://www.exa mple.com:80/page?q=foobar#section"
  , ""
  , "http://"
  , "https://"
]

main :: Effect Unit
main = runTest do
  suite "URLs that should pass public validation" $
    for_ goodUrls publicUrlTestPositive

  suite "URLs that should NOT pass public validation" $
    for_ (concat [badUrls, goodPrivateUrls]) publicUrlTestNegative

  suite "URLs that should pass private validation" $
    for_ (concat [goodUrls, goodPrivateUrls]) anyUrlTestPositive

  suite "URLs that should NOT pass private validation" $
    for_ (concat [badUrls, badPrivateUrls]) anyUrlTestNegative

publicUrlTestPositive :: String -> TestSuite
publicUrlTestPositive url = test url do
  Assert.assert (url <> " should validate") $ validatePublicURL url
  let pRes = parsePublicURL url
  err <- pure $ case pRes of
    Left e -> e
    Right _ -> ""
  Assert.assert (url <> " should return Right, but: " <> err) $ isRight $ pRes

publicUrlTestNegative :: String -> TestSuite
publicUrlTestNegative url = test url do
  Assert.assertFalse (url <> " should NOT validate") $ validatePublicURL url
  Assert.assert (url <> " should return Left") $ isLeft $ parsePublicURL url

anyUrlTestPositive :: String -> TestSuite
anyUrlTestPositive url = test url do
  Assert.assert (url <> " should validate") $ validateURL url
  let pRes = parseURL url
  err <- pure $ case pRes of
    Left e -> e
    Right _ -> ""
  Assert.assert (url <> " should return Right, but: " <> err) $ isRight $ pRes


anyUrlTestNegative :: String -> TestSuite
anyUrlTestNegative url = test url do
  Assert.assertFalse (url <> " should NOT validate") $ validateURL url
  Assert.assert (url <> " should return Left") $ isLeft $ parseURL url
