import XMonad
import Data.IORef
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.SetWMName
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Util.NamedActions
import XMonad.Util.Run (runProcessWithInput)
import XMonad.Util.SpawnOnce
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Layout.NoBorders
import System.IO (writeFile)

main :: IO ()
main = xmonad $ ewmhFullscreen $ ewmh $ docks def
 { modMask = mod4Mask
 , workspaces = ["1:term", "2:emacs", "3:chromium", "4:ide", "5:scratchpad", "6", "7:network", "8:games", "9"]
 , layoutHook = avoidStruts $ layoutHook def
 , manageHook = myManageHook <+> manageHook def
 , focusedBorderColor = "#7a3e9d"
 , focusFollowsMouse = False
 , startupHook = myStartupHook
 , terminal = "terminator"
 }
 `additionalKeysP`
  [ ("M-r", spawn "dmenu_run")
  , ("M-p", togglePanelAndStruts)
  , ("M-S-p", toggleStruts)
  ]

myManageHook = composeAll
 [ className =? "Xfce4-panel" --> doIgnore
   -- , appName =? "fworlds" --> doShift "8:games"
 , stringProperty "WM_CLASS" =? "steam_app_.*" --> doFullFloat
 , isDialog --> doCenterFloat
 ]

myStartupHook = do
 setWMName "LG3D"
 spawnOnce "xfsettingsd"
 spawnOnce "nm-applet"
 spawnOnce "volumeicon"
 spawnOnce "xsetroot -cursor_name left_ptr"

togglePanelAndStruts :: X ()
togglePanelAndStruts = do
  result <- io $ runProcessWithInput "toggle-panel" [] ""
  io $ writeFile "/tmp/xmonad-debug.log" ("Result from toggle-panel: " ++ show result ++ "\n")
  if result == "visible\n"
    then sendMessage $ SetStruts [minBound .. maxBound] []
    else sendMessage $ SetStruts [] [minBound .. maxBound]

toggleStruts :: X ()
toggleStruts = sendMessage ToggleStruts
