module API where

import           Control.Applicative
import qualified Data.Map                as Map
import           Data.Text               hiding (empty, filter, groupBy,
                                          intercalate)
import           Network.HTTP.Types
import           Network.Wai

import           Control.Monad.Reader
import qualified Data.ByteString         as Strict hiding (pack)
import qualified Data.ByteString.Builder as Builder
import qualified Data.ByteString.Char8   as Strict
import qualified Data.ByteString.Lazy    as Lazy
import           Server


type Endpoint = [(StdMethod, Action)]

server :: Request -> Server Response
server req = case pathInfo req of
        ["articles"] -> req |>
            [ (GET, getArticles)
            ]
        _            -> pure notFound

dispatch :: Request -> Endpoint -> Server Response
dispatch req ept = case parseMethod reqMethod of
    Left unknown   -> pure $ badRequest unknown
    Right stdMethod -> case lookup stdMethod ept of
        Nothing     -> pure $ notAllowed stdMethod ept
        Just action -> action req
  where
    reqMethod = requestMethod req

(|>) = dispatch

getArticles :: Action
getArticles req = pure $ responseBuilder status200 [] "Get articles"

badRequest :: Strict.ByteString -> Response
badRequest unknown = responseBuilder badRequest400 [] $
    Builder.byteString $ "Bad request: " <> unknown

notAllowed :: StdMethod -> Endpoint -> Response
notAllowed method ept = responseBuilder methodNotAllowed405 [allow] $
    Builder.byteString $ "Method not allowed: " <> renderMethod (Right method)
  where
    allowedMethods = fst <$> ept
    allowedMethodsBS = Strict.pack . show <$> allowedMethods
    allow = ("Allow", Strict.intercalate ", " allowedMethodsBS)

notFound :: Response
notFound = responseBuilder notFound404 [] "Not found"

internalError :: ServerError -> Response
internalError e = responseBuilder internalServerError500 [] $
    Builder.byteString $ "Internal server error: " <> errBS
  where
    errBS = Strict.pack $ show e
