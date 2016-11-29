module Handler.Home where

import Import

getHomeR :: Handler Html
getHomeR = do
    -- master <- getYesod
    -- liftIO (print $ elmAppSettings $ appSettings master)
    defaultLayout $ do
        setTitle "Simple Crud Home"
        $(widgetFile "homepage")
