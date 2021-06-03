{-# LANGUAGE DeriveGeneric     #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards   #-}

module Main where

import           Data
import           Database.PostgreSQL.Simple
import           Database.PostgreSQL.Simple.Time
import           GHC.Generics

import           Network.HTTP.Types
import           Network.Wai
import           Network.Wai.Handler.Warp
import           Network.Wai.Middleware.RequestLogger

import           API
import           Server

main :: IO ()
main = do
    conf <- load "config.json"
    run 8000 $ logStdoutDev $ app conf

app :: Config -> Application
app conf req send = do
    eitherResp <- runServer (server req) conf 
    either (send . internalError) send eitherResp