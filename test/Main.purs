module Test.Main where

import Prelude

import Data.Array                        (concat)
import Data.Either                       (isLeft, isRight)
import Data.Foldable                     (for_)
import Effect                            (Effect)
import Test.Unit                         (TestSuite, suite, test)
import Test.Unit.Main                    (runTest)
import Test.Unit.Assert                  as Assert
import URL.Validator

-- type FreeTestF = Compose TestSuite

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
]

badUrls :: Array String
badUrls = [
    "httqs://www.example.com:80/page?q=foobar#section"
  , "https://www.exa mple.com:80/page?q=foobar#section"
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
  Assert.assert (url <> " should return Right") $ isRight $ parsePublicURL url

publicUrlTestNegative :: String -> TestSuite
publicUrlTestNegative url = test url do
  Assert.assertFalse (url <> " should NOT validate") $ validatePublicURL url
  Assert.assert (url <> " should return Left") $ isLeft $ parsePublicURL url

anyUrlTestPositive :: String -> TestSuite
anyUrlTestPositive url = test url do
  Assert.assert (url <> " should validate") $ validateURL url
  Assert.assert (url <> " should return Right") $ isRight $ parseURL url

anyUrlTestNegative :: String -> TestSuite
anyUrlTestNegative url = test url do
  Assert.assertFalse (url <> " should NOT validate") $ validateURL url
  Assert.assert (url <> " should return Left") $ isLeft $ parseURL url
