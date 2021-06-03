module Data where

import           Data.Text
import           Data.Time.Calendar

data User = User
    { user'id         :: Int
    , user'first_name :: Text
    , user'last_name  :: Text
    , user'photo_id   :: Int
    , user'login      :: Text
    , user'password   :: Text
    , user'created_at :: Day
    , user'is_admin   :: Bool
    } deriving (Show)

data Author = Author
    { author'user_id :: Int
    , author'bio     :: Text
    } deriving (Show)

data Category = Category
    { category'id        :: Int
    , category'name      :: Text
    , category'parent_id :: Maybe Int
    } deriving (Show)

data Tag = Tag
    { tag'id   :: Int
    , tag'name :: Text
    } deriving (Show)

data Article = Article
    { article'id            :: Int
    , article'title         :: Text
    , article'published_at  :: Day
    , article'author_id     :: Int
    , article'category_id   :: Int
    -- , article'tag_ids           :: [Int]
    , article'text          :: Text
    , article'main_photo_id :: Int
    -- , article'content_photo_ids :: [Int]
    } deriving (Show)

data Comment = Comment
    { comment'id         :: Int
    , comment'user_id    :: Int
    , comment'article_id :: Int
    , comment'text       :: Text
    } deriving (Show)

data Template = Template
    { template'id            :: Int
    , template'article_id    :: Maybe Int
    , template'title         :: Text
    , template'created_at    :: Day
    , template'author_id     :: Int
    , template'category_id   :: Int
    , template'text          :: Text
    , template'main_photo_id :: Int
    -- , template'tag_ids :: [Int]
    -- , template'content_photo_ids :: [Int]
    } deriving (Show)

data Token = Token
    { token'user_id :: Int
    , token'token   :: Text
    } deriving (Show)

data Photo = Photo
    { photo'id   :: Int
    , photo'link :: Text
    } deriving (Show)

-- data Template = Template
--     { template'title            :: Text
--     , template'creation_date    :: Day
--     , template'author           :: Author
--     , template'category         :: Category
--     , template'tags             :: [Tag]
--     , template'text             :: Text
--     , template'main_photo       :: Photo
--     , template'secondary_photos :: [Photo]
--     , template'comments         :: [Comment]
--     } deriving (Show)
