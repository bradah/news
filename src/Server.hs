{-# LANGUAGE FlexibleInstances          #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE MultiParamTypeClasses      #-}
{-# LANGUAGE RecordWildCards            #-}
{-# LANGUAGE TypeSynonymInstances       #-}

module Server where

import           Data.Aeson
import qualified Data.ByteString.Lazy       as Lazy
import           Data.Text
import           Data.Word                  (Word16)

import           Control.Concurrent.STM
import           Control.Monad.Except
import           Control.Monad.Reader
import           Database.PostgreSQL.Simple
import           Network.Wai

data Config = Config
    { confDbName     :: String
    , confDbUser     :: String
    , confDbPassword :: String
    , confDbHost     :: String
    , confDbPort     :: Word16
    , confDbConn     :: TVar Connection
    }

data ServerError
    = ServerError String
    deriving Show

instance FromJSON Config where
    parseJSON = withObject "Config" $ \o -> do
        confDbName <- o .: "db_name"
        confDbUser <- o .: "db_user"
        confDbPassword <- o .: "db_password"
        confDbHost <- o .: "db_host"
        confDbPort <- o .: "db_port"
        pure Config {..}

load :: FilePath -> IO Config
load path = do
    content <- Lazy.readFile path
    case eitherDecode content of
        Left e     -> error e
        Right conf@Config {..} -> do
            let connectInfo = ConnectInfo
                    { connectHost = confDbHost
                    , connectPort = confDbPort
                    , connectUser = confDbUser
                    , connectPassword = confDbPassword
                    , connectDatabase = confDbName
                    }
            conn <- connect connectInfo
            connTVar <- newTVarIO conn
            pure $ conf { confDbConn = connTVar }

newtype Server a = Server
    { unServer :: ReaderT Config (ExceptT ServerError IO) a
    } deriving (Functor, Applicative, Monad, MonadReader Config)

type Action = Request -> Server Response
instance Show Action where
    show _ = ""

runServer :: Server a -> Config -> IO (Either ServerError a)
runServer serv conf = runExceptT $ runReaderT (unServer serv) conf
