[ x ] Make klassy configurable from nix file raw in klassy module
    [ x ] Win decorations
        [ x ] Implement parsing of Windeco section of config file
            [ ] SystemIconSize ? WTF (not essential)
        [ x ] Implement parsing of ButtonColors section of config file
            [ ] Manage ULTRA PERSONALIZATION (later)
        [ x ] Implement parsing of ButtonBehaviour section of config file
        [ x ] Implement parsing of ButtonSizing section of config file
        [ x ] Implement parsing of TitleBarSpacing section of config file
        [ x ] Implement parsing of TitleBarOpacity section of config file
        [ x ] WindowOutlineStyle section of config file
        [ x ] ShadowStyle section of config file
            [ x ] Define all options in menu
            [ x ] Find defaults
            [ x ] Implement parsing of ShadowStyle section of config file
        [ x ] Implement parsing of ShadowStyle section of config file
    [ x ] Windeco Exception
        [ x ] Defaults
        [ x ] Users
    [ x ] Style
        [ x ] Define all options in menu
        [ x ] Find defaults
            [ ] keyboard_accelerator_visibility (not that important)
            [ ] 
            windows_drag_mode (not that important)
        [ x ] Implement parsing of Style section of config file
    [ x ] Presets
        [ x ] Importing exising presets as files
        [ ] Creating presets from nix config files (later)
[ x ] Fix Nvidia
[ ] Make Dolphin a configurable module #Project
[ ] Fix plasma-manager Module #Project
    [ ] Separate monitor configuration from plasma configuration
    [ ] Allow nested paramaters in applets configuration
    [ ] Make system tray configuration more understandable
[ ] Pedro Plymouth
    [ x ] Enable plymouth on boot
    [ x ] Add pedro plymouth theme
    [ ] Optimize kernelParams
    [ ] Fix plymouth theme freezes and is not that smooth on boot.
[ ] Fixing icons missing in titlebar when as user
    [ ] Fixing icons missing in titlebar for office apps -> report to upstream
    [ ] Fixing icons missing in titlebar for virt-manager -> report to upstream
    [ x ] Fixing icons missing in titlebar for most apps
[ ] Fixing Gparted unlunchable from luncher
    [ x ] Trying to fix by mysef 
        [ x ] Adding to sudoers file
        [ x ] Adding sudo to command of launcher
    [ ] report to upstream
[ ] Adding "Open in VSCode" contexte menu
    [ ] In Dolphin
    [ ] In desktop
[ ] Making fstab declarative
[ ] Making Bitwarden a configurable module #Project
[ ] Declare splash screen in nix file