{-# LANGUAGE DeriveGeneric #-} 
module FrontendSupport.Elm.AppSettings where

import ClassyPrelude.Yesod
import Data.Aeson ()
import GHC.Generics ()

data LoggerConfig = LoggerConfig {
    on:: Bool
  , logUpdateOn:: Bool
  , logViewOn:: Bool
  , logInitOn:: Bool
  , logNavOn:: Bool
  , logNavLocOn:: Bool -- like Nav model
  , logMsgOn:: Bool
  , logModelOn:: Bool
  , logInputOn:: Bool
  , logOutputOn:: Bool
  , logHtmlOn:: Bool
  , logSubOn:: Bool
  , logFlagsOn:: Bool
} deriving (Show, Generic)

instance FromJSON LoggerConfig
instance ToJSON LoggerConfig

data AppConfig = AppConfig {
      logConfig :: LoggerConfig
    , layout :: String
  } deriving (Show, Generic)

instance FromJSON AppConfig
instance ToJSON AppConfig
