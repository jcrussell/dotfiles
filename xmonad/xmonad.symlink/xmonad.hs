import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.UrgencyHook
import XMonad.Layout.Grid
import XMonad.Layout.IM
import XMonad.Layout.PerWorkspace
import XMonad.Layout.Reflect
import XMonad.ManageHook
import XMonad.Util.EZConfig
import XMonad.Util.Run
import XMonad.Layout.NoBorders

import Data.Ratio ((%))

myWorkspaces = ["1", "2", "3", "4", "5", "6", "7", "8:chat", "9:mail"]

myManageHooks = composeAll
  [ manageDocks
  , className =? "Pidgin"           --> doShift "8:chat"
  , className =? "Thunderbird"      --> doShift "9:mail"
  , className =? "Evolution"        --> doShift "9:mail"
  ]

myKeys =
  [ ("M-S-z", spawn "xscreensaver-command -lock") -- lock screen
  , ("M-z", spawn "xscreensaver-command -activate") -- enable screen saver
  , ("M-u", focusUrgent)
  ]

pidginLayout = avoidStruts $ reflectHoriz $ withIM (1%5) (Title "Buddy List") Grid

myLayout = onWorkspace "8:chat" pidginLayout

main = do

  xmproc <- spawnPipe "/usr/bin/xmobar ~/.xmonad/xmobarrc"

  xmonad $ withUrgencyHook NoUrgencyHook defaultConfig
    { workspaces = myWorkspaces
    , layoutHook = myLayout $ avoidStruts $ smartBorders $ layoutHook defaultConfig
    , manageHook = myManageHooks <+> manageHook defaultConfig
    , borderWidth = 4
    , normalBorderColor = "#004400"
    , focusedBorderColor = "#00FF00"
    , focusFollowsMouse = False
    , logHook = dynamicLogWithPP $ xmobarPP
      { ppOutput = hPutStrLn xmproc
      , ppTitle = xmobarColor "#00FF00" "" . shorten 100
      , ppCurrent = xmobarColor "#00FF00" "" . wrap "[" "]"
      , ppVisible = xmobarColor "#00FF00" "" . wrap "(" ")"
      , ppHidden = xmobarColor "#00FF00" ""
      , ppUrgent = xmobarColor "#FFA500" "" . xmobarStrip
      , ppHiddenNoWindows = xmobarColor "white" ""
      }
    } `additionalKeysP` myKeys
