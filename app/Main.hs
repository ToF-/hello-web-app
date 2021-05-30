{-# LANGUAGE OverloadedStrings     #-}
{-# LANGUAGE QuasiQuotes           #-}
{-# LANGUAGE TemplateHaskell       #-}
{-# LANGUAGE TypeFamilies          #-}
import           Yesod
import           Yesod.Static
import           System.Environment     (getEnv)

data HelloWorld = HelloWorld { getStatic :: Static }

staticFiles "static"

mkYesod "HelloWorld" [parseRoutes|
/ HomeR GET
/static StaticR Static getStatic
|]

instance Yesod HelloWorld


getHomeR :: Handler Html
getHomeR = do
    defaultLayout $ do
        addStylesheet $ StaticR css_main_css
        [whamlet|
            <h1>Hello World!
            <p>Example page by ToF
        |]

main :: IO ()
main = do
    port <- read <$> getEnv "PORT"
    -- Get the static subsite, as well as the settings it is based on
    static@(Static settings) <- staticDevel "static"
    warp port (HelloWorld static)
