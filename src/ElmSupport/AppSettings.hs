{-# LANGUAGE DeriveGeneric #-} 
module FrontendSupport.AppSettings where

import ClassyPrelude.Yesod
import Data.Aeson ()
import GHC.Generics ()

data AppConfig = AppConfig {
      todo :: Bool
  } deriving (Show, Generic)

instance FromJSON AppConfig
instance ToJSON AppConfig
