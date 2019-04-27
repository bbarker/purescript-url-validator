module URI.Validator where

import Prelude

import Data.Nullable           (Nullable(..), toMaybe)

foreign import _vaildateUrl :: Boolean -> String -> Nullable String
