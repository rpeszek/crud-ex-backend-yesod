module Handler.ThingSpec (spec) where

import TestImport
import Data.Aeson

spec :: Spec
spec = withApp $ do
    describe "valid request" $ do
        it "gives a 200" $ do
            get HomeR
            statusIs 200

            let message = "My message" :: Text
                name = "Test" :: Text
                body = object [ 
                     "name" .= name
                     , "description" .= message ]
                encoded = encode body

            request $ do
                setMethod "POST"
                setUrl ThingsR
                setRequestBody encoded
                addRequestHeader ("Content-Type", "application/json")

            statusIs 200

            [Entity _id comment] <- runDB $ selectList [ThingDescription ==. message] []
            assertEq "Should have " comment (Thing name message Nothing)

    describe "invalid requests" $ do
        it "400s when the JSON body is invalid" $ do
            get HomeR

            let body = object [ "foo" .= ("My message" :: Value) ]

            request $ do
                setMethod "POST"
                setUrl ThingsR
                setRequestBody $ encode body
                addRequestHeader ("Content-Type", "application/json")

            statusIs 400
