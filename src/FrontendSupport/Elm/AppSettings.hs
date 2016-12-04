{-# LANGUAGE DeriveGeneric #-} 
module FrontendSupport.Elm.AppSettings where

import ClassyPrelude.Yesod
import Data.Aeson ()
import GHC.Generics ()

data LoggerFlag = 
     LApp 
   | LIn 
   | LOut 
   | LUpdate
   | LView
   | LInit 
   | LNav 
   | LMsg 
   | LModel 
   | LNavLoc  -- like Nav model
   | LHtml 
   | LSub 
   | LFlags 
 deriving (Show, Generic)

instance FromJSON LoggerFlag
instance ToJSON LoggerFlag

data LoggerLevel = 
      Info
    | Std
    | Crit
 deriving (Show, Generic)

instance FromJSON LoggerLevel
instance ToJSON LoggerLevel

data LoggerConfig = LoggerConfig {
    logLevel :: LoggerLevel
  , logFlags :: [LoggerFlag]
} deriving (Show, Generic)

instance FromJSON LoggerConfig
instance ToJSON LoggerConfig

data AppConfig = AppConfig {
      logConfig :: LoggerConfig
    , layout :: String
  } deriving (Show, Generic)

instance FromJSON AppConfig
instance ToJSON AppConfig
