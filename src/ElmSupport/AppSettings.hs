{-# LANGUAGE DeriveGeneric #-} 
module ElmSupport.AppSettings where

import ClassyPrelude.Yesod
import Data.Aeson ()
import GHC.Generics ()

data ElmAppSettings = ElmAppSettings {
      todo :: Bool
  } deriving (Show, Generic)

instance FromJSON ElmAppSettings
instance ToJSON ElmAppSettings
