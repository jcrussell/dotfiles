import XMonad
import XMonad.Actions.GridSelect
import XMonad.Actions.WorkspaceNames
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.UrgencyHook
import XMonad.Layout.Column
import XMonad.Layout.Grid
import XMonad.Layout.IM
import XMonad.Layout.PerWorkspace
import XMonad.Layout.Reflect
import XMonad.Layout.ThreeColumns
import XMonad.ManageHook
import XMonad.Prompt
import XMonad.Util.EZConfig
import XMonad.Util.Run
import XMonad.Layout.NoBorders

import qualified XMonad.StackSet as W

myWorkspaces = ["1:www", "2", "3", "4", "5", "6", "7", "8", "9:chat", "0:mail"]

myManageHooks = composeAll
  [ manageDocks
  , className =? "Pidgin"           --> doShift "9:chat"
  , className =? "Thunderbird"      --> doShift "0:mail"
  , className =? "Evolution"        --> doShift "0:mail"
  ]

myKeys =
  [ ("M-S-z", spawn "xscreensaver-command -lock") -- lock screen
  , ("M-z", spawn "xscreensaver-command -activate") -- enable screen saver
  , ("M-u", focusUrgent)
  , ("M-g", goToSelected defaultGSConfig)
  , ("M-r", renameWorkspace defaultXPConfig)
  , ("M-S-h", swapTo Prev)
  , ("M-S-l", swapTo Next)
  ] ++
  [ (otherModMasks ++ "M-" ++ [key], action tag)
    | (tag, key) <- zip myWorkspaces "1234567890"
    , (otherModMasks, action) <- [ ("", windows . W.view), ("S-", windows . W.shift)]
  ]

myLayout = onWorkspace "9:chat" pidginLayout $ standardLayout
  where
    tall     = Tall nmaster delta ratio
    threecol = ThreeCol nmaster delta ratio
    column   = Column height

    nmaster  = 1
    delta    = 3/100
    ratio    = 1/2
    height   = 1

    standardLayout = avoidStruts $ smartBorders $ tall ||| threecol ||| column ||| Full
    pidginLayout = avoidStruts $ reflectHoriz $ withIM (1/5) (Title "Buddy List") Grid

main = do

  xmproc <- spawnPipe "/usr/bin/xmobar ~/.xmonad/xmobarrc"

  xmonad $ withUrgencyHook NoUrgencyHook defaultConfig
    { workspaces = myWorkspaces
    , layoutHook = myLayout
    , manageHook = myManageHooks <+> manageHook defaultConfig
    , borderWidth = 2
    , normalBorderColor = "#004400"
    , focusedBorderColor = "#00FF00"
    , focusFollowsMouse = False
    , modMask = mod4Mask
    , logHook = workspaceNamesPP xmobarPP
      { ppOutput = hPutStrLn xmproc
      , ppTitle = xmobarColor "#00FF00" "" . shorten 100
      , ppCurrent = xmobarColor "#00FF00" "" . wrap "[" "]"
      , ppVisible = xmobarColor "#00FF00" "" . wrap "(" ")"
      , ppHidden = xmobarColor "#00FF00" ""
      , ppUrgent = xmobarColor "#FFA500" "" . xmobarStrip
      , ppHiddenNoWindows = xmobarColor "white" ""
      } >>= dynamicLogWithPP
    } `additionalKeysP` myKeys
