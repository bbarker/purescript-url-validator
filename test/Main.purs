module Test.Main where

import Prelude

import Data.Either                       (isRight)
import Effect                            (Effect)
import Test.Unit                         (TestSuite, suite, test)
import Test.Unit.Main                    (runTest)
import Test.Unit.Assert                  as Assert
import URL.Validator

url1 :: String
url1 = "https://www.example.com:80/page?q=foobar#section"

main :: Effect Unit
main = runTest do
  suite "Public URLs that should validate" do
    publicUrlTestPositive url1

publicUrlTestPositive :: String -> TestSuite
publicUrlTestPositive url = test url do
  Assert.assert (url <> " should validate") $ validatePublicURL url
  Assert.assert (url <> " should return Right") $ isRight $ parsePublicURL url
