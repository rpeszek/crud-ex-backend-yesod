module BuzLogic.Thing where

import Import 
--import qualified Database.Persist.Class.PersistEntity as DbEnity

type ThingPersitence = ReaderT (PersistEntityBackend Thing)

findAllThings :: (MonadIO m) => ThingPersitence m [Entity Thing] 
findAllThings =  selectList [] [] 

getThing :: (MonadIO m) => ThingId -> ThingPersitence m (Maybe (Thing))
getThing = get

getThingEntity :: (MonadIO m) => ThingId -> ThingPersitence m (Maybe (Entity Thing))
getThingEntity tId = do
      maybething <- get tId
      return $ maybe Nothing (\thing -> Just $ Entity tId thing) maybething   

insertThing :: (MonadIO m) => Maybe UserId -> Thing -> ThingPersitence m (Key Thing)
insertThing maybeUserId = do
          insert . (adjustForUser maybeUserId)

replaceThing :: (MonadIO m) => Maybe UserId -> ThingId -> Thing -> ThingPersitence m ()
replaceThing maybeUserId thingId = do
          (replace thingId) . (adjustForUser maybeUserId)

deleteThing :: (MonadIO m) => ThingId -> ThingPersitence m ()
deleteThing = delete

adjustForUser :: Maybe UserId -> Thing -> Thing
adjustForUser maybeUserId thing =
            maybe thing (\user -> thing {thingUserId = Just user}) maybeUserId
        
