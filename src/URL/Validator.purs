module URL.Validator (
    URL
  , parseURL
  , parsePublicURL
  , urlToString
  , validateURL
  , validatePublicURL
) where

import Data.Either          (Either(..))

newtype URL = URL String

foreign import _validateURL :: Boolean -> String -> String

-- | Returns `true` if a valid URL is passed in, `false` otherwise.
validateURL :: String -> Boolean
validateURL urlIn =_checkHrefStatus hrefStatus
  where hrefStatus = _validateURL false urlIn

-- | Returns true if a valid URL is passed in, `false` otherwise.
-- | Also returns `false` if the URL contains a username or password.
validatePublicURL :: String -> Boolean
validatePublicURL urlIn = _checkHrefStatus hrefStatus
  where hrefStatus = _validateURL true urlIn

_checkHrefStatus :: String -> Boolean
_checkHrefStatus "SUCCESS" = true
_checkHrefStatus _ = false

-- | Returns a URL if it is determiend the input string is a URL.
-- | Otherwise, returns an error message string.
parseURL :: String -> Either String URL
parseURL urlIn = _statusToURL urlIn hrefStatus
  where hrefStatus = _validateURL false urlIn

-- | Returns a URL if it is determiend the input string is a URL
-- | and that the URL contains no username or password.
-- | Otherwise, returns an error message string.
parsePublicURL :: String -> Either String URL
parsePublicURL urlIn = _statusToURL urlIn hrefStatus
  where hrefStatus = _validateURL true urlIn

_statusToURL :: String -> String -> Either String URL
_statusToURL urlIn status = case _checkHrefStatus status of
  true -> Right (URL urlIn)
  false -> Left status

urlToString :: URL -> String
urlToString (URL str) = str
