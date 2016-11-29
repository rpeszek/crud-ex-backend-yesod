module FrontendSupport.Thing.FrontendRoutes (FrontendRoute(..), toHashUrlFragment) where

import Import
import Database.Persist.Sql (fromSqlKey)  

data FrontendRoute = ListThingsR | 
                CreateThingR |
                ViewThingR ThingId | 
                EditThingR ThingId 
              deriving Show

toHashUrlFragment :: FrontendRoute -> Text
toHashUrlFragment ListThingsR     = ""
toHashUrlFragment CreateThingR    = "thingscreate"
toHashUrlFragment (ViewThingR tId) = "thingsview/" ++ (pack . show . fromSqlKey $ tId)
toHashUrlFragment (EditThingR tId) = "thingsedit/" ++ (pack . show . fromSqlKey $ tId)
