import XMonad
import XMonad.Actions.CycleWS
import XMonad.Actions.GridSelect
import XMonad.Actions.WorkspaceNames
import XMonad.Actions.NoBorders
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
import XMonad.Util.Dmenu
import XMonad.Util.EZConfig
import XMonad.Util.Replace
import XMonad.Util.Run
import XMonad.Layout.NoBorders
import XMonad.Hooks.SetWMName

import Control.Monad
import System.Exit

import qualified XMonad.StackSet as W

myWorkspaces = ["1:www", "2", "3", "4", "5", "6", "7", "8", "9", "0"]

myManageHooks = composeAll
  [ manageDocks
  , className =? "Keepassx"         --> doShift "8"
  , manageHook defaultConfig
  ]

-- Quit after confirmation
myQuit = do
  answer <- dmenu ["cancel", "quit"]
  when (answer == "quit") (io exitSuccess)

myKeys =
  [ ("M-S-z", spawn "xscreensaver-command -lock") -- lock screen
  , ("M-z",   spawn "xscreensaver-command -activate") -- enable screen saver
  , ("M-S-q", myQuit)
  , ("M-u",   focusUrgent)
  , ("M-g",   goToSelected defaultGSConfig)
  , ("M-n",   renameWorkspace defaultXPConfig)
  , ("M-s",   swapNextScreen)
  , ("M-S-h", swapTo Prev)
  , ("M-S-l", swapTo Next)
  , ("M-f",   sendMessage ToggleStruts)
  , ("M-S-f", withFocused toggleBorder)
  , ("<XF86AudioLowerVolume>", spawn "amixer -c 0 set Master 4dB-")
  , ("<XF86AudioRaiseVolume>", spawn "amixer -c 0 set Master 4dB+")
  ] ++
  [ (otherModMasks ++ "M-" ++ [key], action tag)
    | (tag, key) <- zip myWorkspaces "1234567890"
    , (otherModMasks, action) <- [ ("", windows . W.view), ("S-", windows . W.shift)]
  ]

myLayout = standardLayout
  where
    tall     = Tall nmaster delta ratio
    column   = Column height

    nmaster  = 1
    delta    = 3/100
    ratio    = 1/2
    height   = 1

    standardLayout = avoidStruts $ smartBorders $ tall ||| column ||| Full

myLogHook xmobarPipe = workspaceNamesPP xmobarPP
  { ppOutput = hPutStrLn xmobarPipe
  , ppTitle = xmobarColor "#00FF00" "" . shorten 100
  , ppCurrent = xmobarColor "#00FF00" "" . wrap "[" "]"
  , ppVisible = xmobarColor "#00FF00" "" . wrap "(" ")"
  , ppHidden = xmobarColor "#00FF00" ""
  , ppUrgent = xmobarColor "#FFA500" "" . xmobarStrip
  , ppHiddenNoWindows = xmobarColor "white" ""
  } >>= dynamicLogWithPP

main = do
  replace

  xmobarPipe <- spawnPipe "/usr/bin/xmobar ~/.xmonad/xmobarrc"

  xmonad $ withUrgencyHook NoUrgencyHook $ docks defaultConfig
    { workspaces = myWorkspaces
    , layoutHook = myLayout
    , manageHook = myManageHooks
    , borderWidth = 2
    , terminal = "xterm"
    , normalBorderColor = "#004400"
    , focusedBorderColor = "#00FF00"
    , focusFollowsMouse = False
    , modMask = mod4Mask
    , logHook = myLogHook xmobarPipe
    , startupHook = setWMName "LG3D"
    } `additionalKeysP` myKeys
