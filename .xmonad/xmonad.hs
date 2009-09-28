{- xmonad.hs
 - Author: Jelle 
 -}

-- Import stuff
import XMonad
import qualified XMonad.StackSet as W 
import qualified Data.Map as M
import XMonad.Util.EZConfig(additionalKeys)
import System.Exit
import Graphics.X11.Xlib
import System.IO


-- actions
import XMonad.Actions.CycleWS
import XMonad.Actions.WindowGo
import qualified XMonad.Actions.Search as S
import XMonad.Actions.Search
import qualified XMonad.Actions.Submap as SM
import XMonad.Actions.UpdatePointer


-- utils
import XMonad.Util.Run(spawnPipe)
import qualified XMonad.Prompt 		as P
import XMonad.Prompt.Shell
import XMonad.Prompt


-- hooks
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.UrgencyHook
import XMonad.Hooks.ManageHelpers

-- layouts
import XMonad.Layout.Grid
import XMonad.Layout.NoBorders
import XMonad.Layout.ResizableTile
import XMonad.Layout.Tabbed
import XMonad.Layout.PerWorkspace



-- Main --

main = do
        xmproc <- spawnPipe "xmobar"  -- start xmobar
    	xmonad 	$ withUrgencyHook NoUrgencyHook $ defaultConfig
        	{ manageHook = myManageHook
        	, layoutHook = layoutHook'   
		, borderWidth = borderWidth'
		, normalBorderColor = normalBorderColor'
                , logHook = logHook' xmproc >> updatePointer (Relative 1 1)
		, focusedBorderColor = focusedBorderColor'
		, keys = keys'
        	, modMask = modMask'  
        	, terminal = terminal'
		, workspaces = workspaces'
		}


 
-- hooks
-- automaticly switching app to workspace 
myManageHook :: ManageHook
myManageHook = composeAll . concat $
                [[isFullscreen                  --> doFullFloat
		, className =? "Firefox" --> doFullFloat 
		, className =? "Xmessage" --> doFloat 
                , className =? "Gimp"           --> doFloat 
                , className =? "MPlayer"        --> doShift "3:vid"
                , className =? "Uzbl"  --> doShift "2:web"]
		]
		where
			myIgnores = ["trayer"]
			myFloats  = []
			myOtherFloats = []


--logHookk
logHook' :: Handle -> X ()
logHook' h = dynamicLogWithPP $ customPP { ppOutput = hPutStrLn h }





-------------------------------------------------------------------------------
---- Looks --
---- bar
customPP :: PP
customPP = defaultPP { 
     			    ppHidden = xmobarColor "#393939" ""
			  , ppCurrent = xmobarColor "#FFFFFF" "" . wrap "[" "]"
			  , ppUrgent = xmobarColor "#FF0000" "" . wrap "*" "*"
                          , ppLayout = xmobarColor "#FFFFFF" ""
                          , ppTitle = xmobarColor "#FFFFFF" "" . shorten 80
                         , ppSep = "<fc=#429942> | </fc>"
                    }

-- some nice colors for the prompt windows to match the dzen status bar.
myXPConfig = defaultXPConfig                                    
    { 
	font  = "-*-terminus-*-*-*-*-12-*-*-*-*-*-*-u" 
	,fgColor = "#00FFFF"
	, bgColor = "#000000"
	, bgHLight    = "#000000"
	, fgHLight    = "#FF0000"
	, position = Top
    }


-- My Theme For Tabbed layout
myTheme = defaultTheme { decoHeight = 12
                        , activeColor = "#141414"
                        , activeBorderColor = "#141414"
                        , activeTextColor = "#ffffff"
                        , inactiveBorderColor = "#000000"
                        , inactiveColor = "#000000"
                        , inactiveTextColor = "#ffffff"
                        , fontName = "-*-dejavu sans-medium-r-*-*-11-*-*-*-*-*-*-*"
                        }


--layoutHook
layoutHook'  =  avoidStruts $ tabbed shrinkText myTheme ||| noBorders Full ||| smartBorders tiled ||| smartBorders (Mirror tiled) ||| Grid 
   where
	tiled = ResizableTall 1 (2/100) (1/2) []

-------------------------------------------------------------------------------
---- Terminal --
terminal' :: String
terminal' = "xterm"

-------------------------------------------------------------------------------
-- Keys/Button bindings --
-- modmask
modMask' :: KeyMask
modMask' = mod4Mask



-- borders
borderWidth' :: Dimension
borderWidth' = 1
--  
normalBorderColor', focusedBorderColor' :: String
normalBorderColor' = "#000000"
focusedBorderColor' = "#000000"
--


--Workspaces
workspaces' :: [WorkspaceId]
workspaces' = ["1:irc", "2:web", "3:vid", "4:misc"] 
--

-- Switch to the "web" workspace
viewWeb = windows (W.greedyView "2:web")                           -- (0,0a)
--

--Search engines to be selected :  [google (g), wikipedia (w) , youtube (y) , maps (m), dictionary (d) , wikipedia (w), bbs (b) ,aur (r), wiki (a) , TPB (t), mininova (n), isohunt (i) ]
--keybinding: hit mod + s + <searchengine>
searchEngineMap method = M.fromList $
       [ ((0, xK_g), method S.google )
       , ((0, xK_y), method S.youtube )
       , ((0, xK_m), method S.maps )
       , ((0, xK_d), method S.dictionary )
       , ((0, xK_w), method S.wikipedia )
       , ((0, xK_b), method $ S.searchEngine "archbbs" "http://bbs.archlinux.org/search.php?action=search&keywords=")
       , ((0, xK_r), method $ S.searchEngine "AUR" "http://aur.archlinux.org/packages.php?O=0&L=0&C=0&K=")
       , ((0, xK_a), method $ S.searchEngine "archwiki" "http://wiki.archlinux.org/index.php/Special:Search?search=")
       , ((0, xK_t), method $ S.searchEngine "thepiratebay" "http://thepiratebay.org/search/" )
       , ((0, xK_n), method $ S.searchEngine "mininova" "http://www.mininova.org/search" )
       , ((0, xK_i), method $ S.searchEngine "isohunt" "http://www.isohunt.com/" )
       ]



-- keys
keys' :: XConfig Layout -> M.Map (KeyMask, KeySym) (X ())
keys' conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $
    -- launching and killing programs
    [ ((modMask, xK_c), spawn $ XMonad.terminal conf)
    , ((modMask .|. shiftMask, xK_c ), kill)
    , ((modMask, xK_u ), spawn "uzbl")
    , ((modMask .|. shiftMask, xK_u ), spawn "sh ~/.config/uzbl/scripts/sessionuzbl -r")
    , ((modMask, xK_Prior ), spawn "ossvol -i 1")
    , ((modMask, xK_Next ), spawn "ossvol -d 1")
    , ((modMask, xK_a ), spawn "swarp 1360 768")


    -- opening program launcher / search engine
    , ((modMask , xK_s ), SM.submap $ searchEngineMap $ S.promptSearch myXPConfig)
    , ((modMask .|. shiftMask , xK_s ), SM.submap $ searchEngineMap $ S.selectSearch) 
    ,((modMask , xK_space), shellPrompt myXPConfig)

    -- layouts
    , ((modMask .|. shiftMask, xK_space ), sendMessage NextLayout)
    , ((modMask, xK_b ), sendMessage ToggleStruts)
 
    -- floating layer stuff
    , ((modMask, xK_t ), withFocused $ windows . W.sink)
 
    -- refresh'
    , ((modMask, xK_n ), refresh)
 
    -- focus
    , ((modMask, xK_Tab ), windows W.focusDown)
    , ((modMask, xK_k ), windows W.focusDown)
    , ((modMask, xK_j ), windows W.focusUp)
    , ((modMask, xK_m ), windows W.focusMaster)
 
    -- swapping
    , ((modMask .|. shiftMask, xK_Return), windows W.swapMaster)
    , ((modMask .|. shiftMask, xK_j ), windows W.swapDown )
    , ((modMask .|. shiftMask, xK_k ), windows W.swapUp )
 
    -- increase or decrease number of windows in the master area
    , ((modMask , xK_comma ), sendMessage (IncMasterN 1))
    , ((modMask , xK_period), sendMessage (IncMasterN (-1)))
 
    -- resizing
    , ((modMask, xK_h ), sendMessage Shrink)
    , ((modMask, xK_l ), sendMessage Expand)
    , ((modMask .|. shiftMask, xK_h ), sendMessage MirrorShrink)
    , ((modMask .|. shiftMask, xK_l ), sendMessage MirrorExpand)
 
    -- mpd controls
    , ((0 			, 0x1008ff16 ), spawn "mpc prev")
    , ((0 			, 0x1008ff17 ), spawn "mpc next")
    , ((0 			, 0x1008ff14 ), spawn "mpc toggle")
    , ((0 			, 0x1008ff15 ), spawn "mpc stop")

    -- volume control
    , ((0 			, 0x1008ff13 ), spawn "amixer -q set Master 2dB+")
    , ((0 			, 0x1008ff11 ), spawn "amixer -q set Master 2dB-")
    , ((0 			, 0x1008ff12 ), spawn "amixer -q set Master toggle")
    , ((0 			, 0x1008ff16 ), spawn "mpc prev")
    , ((0 			, 0x1008ff17 ), spawn "mpc next")
    , ((0 			, 0x1008ff14 ), spawn "mpc toggle")
    , ((0 			, 0x1008ff15 ), spawn "mpc stop")
    , ((modMask 		, xK_Print   ), spawn "scrot -e 'mv $f ~/Afbeeldingen/Screenshots'")
 
    -- quit, or restart
    , ((modMask .|. shiftMask, xK_q ), io (exitWith ExitSuccess))
    , ((modMask , xK_q ), restart "xmonad" True)
    ]
    ++
    -- mod-[1..9] %! Switch to workspace N
    -- mod-shift-[1..9] %! Move client to workspace N
    [((m .|. modMask, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++
    -- mod-[w,e] %! switch to twinview screen 1/2
    -- mod-shift-[w,e] %! move window to screen 1/2
    [((m .|. modMask, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
