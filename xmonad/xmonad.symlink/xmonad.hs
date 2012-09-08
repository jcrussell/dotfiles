import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.ManageHook
import XMonad.Util.EZConfig
import XMonad.Util.Run

myWorkspaces = ["1", "2", "3", "4", "5", "6", "7", "8:web", "9:mail"]

myManageHooks = composeAll
  [ className =? "Google-chrome"    --> doShift "8:web"
  , className =? "Evolution"        --> doShift "9:mail"
  , manageDocks
  ]

-- TODO: Add binding to lock screen

main = do

  xmproc <- spawnPipe "/usr/bin/xmobar ~/.xmonad/xmobarrc"

  xmonad $ defaultConfig {
    workspaces = myWorkspaces
    , layoutHook = avoidStruts  $  layoutHook defaultConfig
    , manageHook = myManageHooks <+> manageHook defaultConfig
    , borderWidth = 4
    , normalBorderColor = "#004400"
    , focusedBorderColor = "#00FF00"
    , focusFollowsMouse = False
    , logHook = dynamicLogWithPP $ xmobarPP {
      ppOutput = hPutStrLn xmproc
      , ppTitle = xmobarColor "#00FF00" "" . shorten 100
      , ppCurrent = xmobarColor "#00FF00" "" . wrap "[" "]"
      , ppVisible = xmobarColor "#00FF00" "" . wrap "(" ")"
      , ppHidden = xmobarColor "#00FF00" ""
      , ppHiddenNoWindows = xmobarColor "white" ""
      }
    }
