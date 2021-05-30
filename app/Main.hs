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
        addScript $ StaticR js_segmentdisplay_js
        addScript $ StaticR js_initdisplay_js
        addStylesheet $ StaticR css_main_css
        [whamlet|
            <body onload=initDisplay('-17.2')>
                <h1>Room
                <p>
                <div style="padding: 50px 100px">
                      <div style="width: 216px; height: 126px; position: relative; background: transparent url(static/images/plexiglas.png) no-repeat top left">
                            <div style="position: absolute; left: 38px; top: 33px; width: 120px; height: 34px">
                              <canvas id="display" width="120" height="34">
        |]

main :: IO ()
main = do
    port <- read <$> getEnv "PORT"
    -- Get the static subsite, as well as the settings it is based on
    static@(Static settings) <- staticDevel "static"
    warp port (HelloWorld static)

