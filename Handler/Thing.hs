module Handler.Thing where

import Import
import Text.Julius (RawJS (..))
import qualified BuzLogic.Thing as Bzl
import qualified FrontendSupport.Thing.FrontendRoutes as ERoute
import qualified FrontendSupport as Elm
--TODO error handling

postThingsR :: Handler Value
postThingsR = do
    corsSupport
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
   provideRep $ do
           corsSupport 
           fmap thingEntitiesToJSON $ runDB $ Bzl.findAllThings
   provideRep $  defaultLayout $ do
           master <- getYesod
           let appConfig = frontendAppSettings $ appSettings master
           liftIO $ print $ toJSON appConfig
           let elmProg = thingsElmProg
           addScript $ StaticR js_elm_app_js
           setTitle "Things"
           $(widgetFile "elmpage")


getThingR :: ThingId -> Handler TypedContent
getThingR thingId = selectRep $ do        
   provideRep $ do
        corsSupport
        fmap toJSON $ runDB $ Bzl.getThing thingId
   provideRepType typeHtml 
        $ fmap asHtml 
        $ redirect 
        $ ThingsR :#: (ERoute.toHashUrlFragment $ ERoute.ViewThingR thingId)

putThingR :: ThingId -> Handler Value
putThingR thingId = do
   corsSupport  -- support for CORS
   thing <- (requireJsonBody :: Handler Thing)
   maybeUserId <- maybeAuthId
   runDB $ Bzl.replaceThing maybeUserId thingId thing 
   return $ toJSON thing

-- support for CORS, needed for elm-reactor test developement
optionsThingR :: ThingId -> Handler RepPlain
optionsThingR _ = do
    corsSupport
    addHeader "Access-Control-Allow-Methods" "GET, PUT, DELETE, OPTIONS"
    return $ RepPlain $ toContent ("" :: Text)

deleteThingR :: ThingId -> Handler Value
deleteThingR thingId = do
   corsSupport
   runDB $ Bzl.deleteThing thingId
   return $ object [ 
            "status" .= ("success" :: Text),
            "id" .= thingId
          ]


-- helpers
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

corsSupport :: Handler ()
corsSupport = do
    isDev <- isDevelopment
    if isDev  
     then do 
            addHeader "Access-Control-Allow-Origin" "*"
            addHeader "Access-Control-Allow-Headers" "Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With"
     else return ()
