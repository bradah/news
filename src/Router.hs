{-# LANGUAGE GADTs #-}

module Router where

import           Data.ByteString
import           Network.Wai

data Verb
    = Get
    | Post
    deriving Show

newtype Path = Path ByteString
    deriving Show

data Action a where
    Action :: Monad m => (Request -> m a) -> Action a

data Router a = Router
    { verb   :: Verb
    , path   :: Path
    , action :: Action a
    }

route :: Monad m => Request -> Router a -> m a
route = undefined
