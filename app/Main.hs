{-# LANGUAGE DeriveGeneric     #-}
{-# LANGUAGE OverloadedStrings #-}

module Main where

import           Data
import           Database.PostgreSQL.Simple
import           Database.PostgreSQL.Simple.Time
import           GHC.Generics

import           Network.HTTP.Types
import           Network.Wai
import           Network.Wai.Handler.Warp

main :: IO ()
main = do
    run 8000 app

data API
    = Root
    | News

routine :: Request -> API
routine req = undefined

app :: Application
app req respond = do
    conn <- connect connInfo
    respond $ responseLBS
        status200
        [("Content-Type", "text/plain")]
        "Hello, web!"
  where
    connInfo = defaultConnectInfo
        { connectUser = "lad"
        , connectPassword = "oi"
        , connectDatabase = "test"
        }

data Person = Person
    { id               :: Int
    , first_name       :: String
    , last_name        :: String
    , email            :: Maybe String
    , gender           :: String
    , date_of_birth    :: Date
    , country_of_birth :: String
    } deriving (Show, Generic)

instance FromRow Person where
