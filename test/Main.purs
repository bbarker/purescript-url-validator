module Test.Main where

import Prelude

import Data.Array                        ((!!), length)
import Data.Int                          (toNumber)
import Data.Maybe                        (Maybe(..), fromJust, fromMaybe)
import Data.Natural                      (intToNat)
-- import Debug.Trace                       (traceM)
import Effect                            (Effect)
import Effect.Aff                        (Aff)
import Effect.Class                      (liftEffect)
import Effect.Console                    (logShow)
import Foreign                           (isUndefined, isNull, unsafeToForeign)
import Partial.Unsafe                    (unsafePartial)
import Test.Data                         as TD
import Test.Unit                         (suite, test)
import Test.Unit.Main                    (runTest)
import Test.Unit.Assert                  as Assert


url1 = "https://www.example.com:80/page?q=foobar#section"

main :: Effect Unit
main = runTest do
  suite "non-namespaced tests" do
    test "note.xml and catalog.xml" do

tlog :: forall a. Show a => a -> Aff Unit
tlog = liftEffect <<< logShow
