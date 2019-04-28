module Test.Main where

import Prelude

import Data.Either                       (isLeft, isRight)
import Effect                            (Effect)
import Test.Unit                         (TestSuite, suite, test)
import Test.Unit.Main                    (runTest)
import Test.Unit.Assert                  as Assert
import URL.Validator

goodUrl1 :: String
goodUrl1 = "https://www.example.com:80/page?q=foobar#section"
goodUrl2 :: String
goodUrl2 = "https://www.example.com:80/pa+ge?q=foobar#section"
goodUrl3 :: String
goodUrl3 = "https://www.example.com:80/pa%20ge?q=foobar#section"

badUrl1 :: String
badUrl1 = "httqs://www.example.com:80/page?q=foobar#section"
badUrl2 :: String
badUrl2 = "https://www.exa mple.com:80/page?q=foobar#section"

main :: Effect Unit
main = runTest do
  suite "Public URLs that should validate" do
    publicUrlTestPositive goodUrl1
    publicUrlTestPositive goodUrl2
    publicUrlTestPositive goodUrl3

  suite "Public URLs that should NOT validate" do
    publicUrlTestNegative badUrl1
    publicUrlTestNegative badUrl2

publicUrlTestPositive :: String -> TestSuite
publicUrlTestPositive url = test url do
  Assert.assert (url <> " should validate") $ validatePublicURL url
  Assert.assert (url <> " should return Right") $ isRight $ parsePublicURL url

publicUrlTestNegative :: String -> TestSuite
publicUrlTestNegative url = test url do
  Assert.assertFalse (url <> " should NOT validate") $ validatePublicURL url
  Assert.assert (url <> " should return Left") $ isLeft $ parsePublicURL url
