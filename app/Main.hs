{-# LANGUAGE OverloadedStrings     #-}
{-# LANGUAGE QuasiQuotes           #-}
{-# LANGUAGE TemplateHaskell       #-}
{-# LANGUAGE TypeFamilies          #-}
import           Data.IORef
import           Control.Monad.IO.Class
import           Yesod
import           Yesod.Static
import           System.Environment     (getEnv)

data HelloWorld = HelloWorld { ref :: IORef Int }

mkYesod "HelloWorld" [parseRoutes|
/ HomeR GET
|]

instance Yesod HelloWorld


getHomeR :: Handler Html
getHomeR = do
    (HelloWorld ref) <- getYesod
    counter <- liftIO $ readIORef ref
    liftIO $ writeIORef ref (counter + 1)
    defaultLayout $ do
        [whamlet|
            <h1>#{show counter}
        |]

main :: IO ()
main = do
    port <- read <$> getEnv "PORT"
    ref <- liftIO $ newIORef 0
    warp port (HelloWorld ref)

