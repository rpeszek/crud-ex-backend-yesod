module Handler.Thing where

import Import
import Text.Julius (RawJS (..))
import qualified BuzLogic.Thing as Bzl
import qualified ElmSupport.Thing.ElmRoutes as ERoute
import qualified ElmSupport as Elm
--TODO error handling

postThingsR :: Handler Value
postThingsR = do
    thing <- (requireJsonBody :: Handler Thing)
    maybeUserId <- maybeAuthId
    insertedThing <- runDB $ Bzl.getThingEntity =<< Bzl.insertThing maybeUserId thing
    return $ thingEntityToJSON insertedThing

thingsElmProg :: Elm.EmbeddedElm
thingsElmProg = Elm.EmbeddedElm {
     programName = "App.Main"
   , elmDivId = "elmDivId"
}
-- longer way would be parising accept header
-- mime <- lookupHeader "accept"

getThingsR :: Handler TypedContent
getThingsR =  selectRep $ do
   provideRep $ fmap thingEntitiesToJSON $ runDB $ Bzl.findAllThings
   provideRep $  defaultLayout $ do
           let elmProg = thingsElmProg
           addScript $ StaticR js_elm_things_js
           setTitle "Things"
           $(widgetFile "elmpage")


getThingR :: ThingId -> Handler TypedContent
getThingR thingId = selectRep $ do        
   provideRep $ fmap toJSON $ runDB $ Bzl.getThing thingId
   provideRepType typeHtml 
        $ fmap asHtml 
        $ redirect 
        $ ThingsR :#: (ERoute.toElmUrl $ ERoute.ViewThingR thingId)

putThingR :: ThingId -> Handler Value
putThingR thingId = do
   addHeader "Access-Control-Allow-Origin" "*"  -- support for CORS
   thing <- (requireJsonBody :: Handler Thing)
   maybeUserId <- maybeAuthId
   runDB $ Bzl.replaceThing maybeUserId thingId thing 
   return $ toJSON thing

-- support for CORS, needed for elm-reactor test developement
optionsThingR :: ThingId -> Handler RepPlain
optionsThingR _ = do
    addHeader "Access-Control-Allow-Origin" "*"
    addHeader "Access-Control-Allow-Methods" "GET, PUT, OPTIONS"
    return $ RepPlain $ toContent ("" :: Text)

deleteThingR :: ThingId -> Handler Value
deleteThingR thingId = do
   runDB $ Bzl.deleteThing thingId
   return $ object [ 
            "status" .= ("success" :: Text),
            "id" .= thingId
          ]

thingEntityToJSON :: Maybe (Entity Thing) -> Value
thingEntityToJSON mthingEntity = case mthingEntity of
   Just thingEntity ->
     object [
       "id" .= entityKey thingEntity,
       "entity" .= entityVal thingEntity
     ]
   Nothing ->
     toJSON mthingEntity

thingEntitiesToJSON :: [Entity Thing] -> Value
thingEntitiesToJSON things = toJSON $ map (thingEntityToJSON . Just) things
