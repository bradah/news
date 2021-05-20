module Data where

import           Data.Text
import           Data.Time.Calendar

data User = User
    { user'id            :: Int
    , user'name          :: Text
    , user'surname       :: Text
    , user'photo         :: Photo
    , user'login         :: Text
    , user'password      :: Text
    , user'creation_date :: Day
    , user'is_admin      :: Bool
    } deriving (Show)

data Photo = Photo
    { photo'id   :: Int
    , photo'link :: Text
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
    { article'id               :: Int
    , article'title            :: Text
    , article'creation_date    :: Day
    , article'author           :: Author
    , article'category_id      :: Int
    , article'tags             :: [Tag]
    , article'text             :: Text
    , article'main_photo       :: Photo
    , article'secondary_photos :: [Photo]
    , article'comments         :: [Comment]
    , article'templates        :: [Template]
    } deriving (Show)

data Comment = Comment
    { comment'id         :: Int
    , comment'user_id    :: Int
    , comment'article_id :: Int
    , comment'text       :: Text
    } deriving (Show)

-- type Template = Article
data Template = Template
    { template'title            :: Text
    , template'creation_date    :: Day
    , template'author           :: Author
    , template'category         :: Category
    , template'tags             :: [Tag]
    , template'text             :: Text
    , template'main_photo       :: Photo
    , template'secondary_photos :: [Photo]
    , template'comments         :: [Comment]
    } deriving (Show)
