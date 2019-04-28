module Test.Main where

import Prelude

import Data.Either                       (isLeft, isRight)
import Data.Foldable                     (for_)
import Effect                            (Effect)
import Test.Unit                         (TestSuite, suite, test)
import Test.Unit.Main                    (runTest)
import Test.Unit.Assert                  as Assert
import URL.Validator

-- type FreeTestF = Compose TestSuite

goodUrls :: Array String
goodUrls = [
    "https://www.example.com:80/page?q=foobar#section"
  , "https://www.example.com:80/pa+ge?q=foobar#section"
  , "https://www.example.com:80/pa%20ge?q=foobar#section"
]

badUrls :: Array String
badUrls = [
    "httqs://www.example.com:80/page?q=foobar#section"
  , "https://www.exa mple.com:80/page?q=foobar#section"
]

main :: Effect Unit
main = runTest do
  suite "Public URLs that should validate" do
    for_ goodUrls publicUrlTestPositive

  suite "Public URLs that should NOT validate" do
    for_ badUrls publicUrlTestNegative

publicUrlTestPositive :: String -> TestSuite
publicUrlTestPositive url = test url do
  Assert.assert (url <> " should validate") $ validatePublicURL url
  Assert.assert (url <> " should return Right") $ isRight $ parsePublicURL url

publicUrlTestNegative :: String -> TestSuite
publicUrlTestNegative url = test url do
  Assert.assertFalse (url <> " should NOT validate") $ validatePublicURL url
  Assert.assert (url <> " should return Left") $ isLeft $ parsePublicURL url
