module ElmSupport.Thing.ElmRoutes (ElmRoute(..), toElmUrl) where

import Import
import Database.Persist.Sql (fromSqlKey)  

data ElmRoute = ListThingsR | 
                CreateThingR |
                ViewThingR ThingId | 
                EditThingR ThingId 
              deriving Show

toElmUrl :: ElmRoute -> Text
toElmUrl ListThingsR     = ""
toElmUrl CreateThingR    = "things/create"
toElmUrl (ViewThingR tId) = "things/view/" ++ (pack . show . fromSqlKey $ tId)
toElmUrl (EditThingR tId) = "things/edit/" ++ (pack . show . fromSqlKey $ tId)
