# TODO : stuffs in todo list
{
  config,
  lib,
  pkgs-list,
  parentPathAsList,
  tools,
  ...
}: let
  defaultsParams = builtins.fromJSON (builtins.readFile ./klassy/defaults/params.json);
  definedOrNull = fullAttrs: subAttrPath: let
    subAttrPathList = lib.splitString "." subAttrPath;
    first = lib.lists.last (lib.lists.take 1 subAttrPathList);
    subAttrPathWithoutFirst = lib.lists.drop 1 subAttrPathList;
  in
    if fullAttrs != null && builtins.isAttrs fullAttrs && builtins.hasAttr first fullAttrs
    then
      if subAttrPathWithoutFirst == []
      then fullAttrs.${first}
      else definedOrNull fullAttrs.${first} (lib.concatStringsSep "." subAttrPathWithoutFirst)
    else null;
  getDefault = defaults: path: let
    subAttrPathList = lib.splitString "." path;
    first = lib.lists.last (lib.lists.take 1 subAttrPathList);
    subAttrPathWithoutFirst = lib.lists.drop 1 subAttrPathList;
  in
    if subAttrPathWithoutFirst == []
    then defaults.${first}
    else getDefault defaults.${first} (lib.concatStringsSep "." subAttrPathWithoutFirst);
  defaultIfUndefined = params: defaults: path: let
    value = definedOrNull params path;
    default = getDefault defaults path;
  in
    if value != null
    then value
    else default;
  boolToString = value:
    if value == true
    then "true"
    else "false";
  parseDefaultOverrides = counter: settings: defaultSettings: let
    Enabled = defaultIfUndefined settings defaultSettings "enabled";
  in ''
    [Default Windeco Exception ${toString counter}]
    Enabled=${boolToString Enabled}
  '';

  parseUserSpecificOverride = counter: settings: defaultSettings: let
    Enabled = defaultIfUndefined settings defaultSettings "enabled";
    windowIdenticationSettingsPath = "window_identification";
    ExceptionWindowPropertyType = defaultIfUndefined settings defaultSettings "${windowIdenticationSettingsPath}.window_property";
    ExceptionWindowPropertyPattern = defaultIfUndefined settings defaultSettings "${windowIdenticationSettingsPath}.regex";
    windecoOptionsSettingsPath = "windeco_options";
    borderSizeSettingsPath = "${windecoOptionsSettingsPath}.border_size";
    ExceptionBorder = defaultIfUndefined settings defaultSettings "${borderSizeSettingsPath}.enabled";
    BorderSize = defaultIfUndefined settings defaultSettings "${borderSizeSettingsPath}.value";
    ExceptionMatchTitleBarToApplicationColor = defaultIfUndefined settings defaultSettings "${windecoOptionsSettingsPath}.match_titlebar_colour_to_application";
    HideTitleBar = defaultIfUndefined settings defaultSettings "${windecoOptionsSettingsPath}.hide_window_titlebar";
    OpaqueTitleBar = defaultIfUndefined settings defaultSettings "${windecoOptionsSettingsPath}.opaque_titlebar";
    presetSettingsPath = "${windecoOptionsSettingsPath}.preset";
    enablePreset = defaultIfUndefined settings defaultSettings "${presetSettingsPath}.enabled";

    ExceptionPreset =
      if enablePreset
      then defaultIfUndefined settings defaultSettings "${presetSettingsPath}.value"
      else "";

    applicationStyleOptionsSettingsPath = "application_style_options";
    ExceptionProgramNamePattern = defaultIfUndefined settings defaultSettings "${applicationStyleOptionsSettingsPath}.application_name_regex";
    PreventApplyOpacityToHeader = defaultIfUndefined settings defaultSettings "${applicationStyleOptionsSettingsPath}.opaque_header";
  in ''
    [Windeco Exception ${toString counter}]
    Enabled=${boolToString Enabled}
    ExceptionWindowPropertyType=${toString ExceptionWindowPropertyType}
    ExceptionWindowPropertyPattern=${toString ExceptionWindowPropertyPattern}
    ExceptionBorder=${boolToString ExceptionBorder}
    BorderSize=${toString BorderSize}
    ExceptionMatchTitleBarToApplicationColor=${boolToString ExceptionMatchTitleBarToApplicationColor}
    HideTitleBar=${toString HideTitleBar}
    OpaqueTitleBar=${boolToString OpaqueTitleBar}
    ExceptionPreset=${ExceptionPreset}
    ExceptionProgramNamePattern=${ExceptionProgramNamePattern}
    PreventApplyOpacityToHeader=${boolToString PreventApplyOpacityToHeader}
  '';
  parseParams = settings: let
    KlassySettings = settings.klassy;
    styleSettingsPath = "style";
    decorationSettingsPath = "window_decoration";
    windowSettingsPath = "${decorationSettingsPath}.window";
    titlebarSettingsPath = "${decorationSettingsPath}.titlebar";
    buttonsSettingsPath = "${decorationSettingsPath}.buttons";
    animationsSettingsPath = "${decorationSettingsPath}.animations";
    windowSpecificOverridesSettingsPath = "${decorationSettingsPath}.window_specific_overrides";

    Windeco = let
      ButtonIconStyle = defaultIfUndefined KlassySettings defaultsParams "${buttonsSettingsPath}.icons";
      ButtonShape = defaultIfUndefined KlassySettings defaultsParams "${buttonsSettingsPath}.shape";
      IconSize = defaultIfUndefined KlassySettings defaultsParams "${buttonsSettingsPath}.icon_size";
      BoldButtonIcons = defaultIfUndefined KlassySettings defaultsParams "${buttonsSettingsPath}.bold_icons";

      BoldTitle = defaultIfUndefined KlassySettings defaultsParams "${titlebarSettingsPath}.on_active_window.make_title_bold";

      ColorizeWindowOutlineWithButton = defaultIfUndefined KlassySettings defaultsParams "${windowSettingsPath}.thin_window_outline.colourize_with_higlighted_buttons_colour";
      RoundAllCornersWhenNoBorders = defaultIfUndefined KlassySettings defaultsParams "${windowSettingsPath}.corners.round_corners_when_no_borders";
      WindowCornerRadius = defaultIfUndefined KlassySettings defaultsParams "${windowSettingsPath}.corners.corner_radius";
      AnimationsEnabled = defaultIfUndefined KlassySettings defaultsParams "${animationsSettingsPath}.enable";
      AnimationsSpeedRelativeSystem = defaultIfUndefined KlassySettings defaultsParams "${animationsSettingsPath}.animations_speed";
      DrawBackgroundGradient = defaultIfUndefined KlassySettings defaultsParams "${titlebarSettingsPath}.on_active_window.draw_titlebar_background_gradient";
      DrawTitleBarSeparator = defaultIfUndefined KlassySettings defaultsParams "${titlebarSettingsPath}.on_active_window.draw_separator_under_titlebar";
      MatchTitleBarToApplicationColor = defaultIfUndefined KlassySettings defaultsParams "${titlebarSettingsPath}.match_titlebar_colour_to_application";
    in ''
      ButtonIconStyle=${ButtonIconStyle}
      ButtonShape=${ButtonShape}
      IconSize=${IconSize}
      BoldButtonIcons=${boolToString BoldButtonIcons}
      BoldTitle=${boolToString BoldTitle}
      ColorizeWindowOutlineWithButton=${boolToString ColorizeWindowOutlineWithButton}
      RoundAllCornersWhenNoBorders=${boolToString RoundAllCornersWhenNoBorders}
      WindowCornerRadius=${toString WindowCornerRadius}
      AnimationsEnabled=${boolToString AnimationsEnabled}
      AnimationsSpeedRelativeSystem=${toString AnimationsSpeedRelativeSystem}
      # SystemIconSize= : find the parameter that determines this
      DrawBackgroundGradient=${boolToString DrawBackgroundGradient}
      DrawTitleBarSeparator=${boolToString DrawTitleBarSeparator}
      MatchTitleBarToApplicationColor=${boolToString MatchTitleBarToApplicationColor}
    '';
    ButtonColors = let
      buttonSettingsPath = "${buttonsSettingsPath}.button_colours";

      LockButtonColorsActiveInactive = defaultIfUndefined KlassySettings defaultsParams "${buttonSettingsPath}.lock_active_inactive";

      buttonsColoursActiveSettingsPath = "${buttonSettingsPath}.active_window";
      buttonsIconColoursActiveSettingsPath = "${buttonsColoursActiveSettingsPath}.icon_colours";

      ButtonIconColorsActive = defaultIfUndefined KlassySettings defaultsParams "${buttonsIconColoursActiveSettingsPath}.choice";
      CloseButtonIconColorActive =
        if defaultIfUndefined KlassySettings defaultsParams "${buttonsIconColoursActiveSettingsPath}.close_button_icon_colour" == ButtonIconColorsActive
        then "AsSelected"
        else defaultIfUndefined KlassySettings defaultsParams "${buttonsIconColoursActiveSettingsPath}.close_button_icon_colour";
      ButtonIconOpacityActive = defaultIfUndefined KlassySettings defaultsParams "${buttonsIconColoursActiveSettingsPath}.opacity";

      buttonsColoursActiveContrastSettingsPath = "${buttonsIconColoursActiveSettingsPath}.contrast";

      OnPoorIconContrastActive = defaultIfUndefined KlassySettings defaultsParams "${buttonsColoursActiveContrastSettingsPath}.when_poor_contrast_detected";
      PoorIconContrastThresholdActive = defaultIfUndefined KlassySettings defaultsParams "${buttonsColoursActiveContrastSettingsPath}.threshold";

      buttonsBackground_N_OutlineColoursActiveSettingsPath = "${buttonsColoursActiveSettingsPath}.background_n_outline_colours";

      ButtonBackgroundColorsActive = defaultIfUndefined KlassySettings defaultsParams "${buttonsBackground_N_OutlineColoursActiveSettingsPath}.choice";
      UseHoverAccentActive = defaultIfUndefined KlassySettings defaultsParams "${buttonsBackground_N_OutlineColoursActiveSettingsPath}.use_hover_colour_from_colour_scheme";
      ButtonBackgroundOpacityActive = defaultIfUndefined KlassySettings defaultsParams "${buttonsBackground_N_OutlineColoursActiveSettingsPath}.opacity";

      buttonsBackgroundActiveContrastSettingsPath = "${buttonsBackground_N_OutlineColoursActiveSettingsPath}.contrast";

      AdjustBackgroundColorOnPoorContrastActive = defaultIfUndefined KlassySettings defaultsParams "${buttonsBackgroundActiveContrastSettingsPath}.adjust_colour_when_poor_contrast_detected";
      PoorBackgroundContrastThresholdActive = defaultIfUndefined KlassySettings defaultsParams "${buttonsBackgroundActiveContrastSettingsPath}.threshold";

      ############ Inactive window buttons settings

      buttonsColoursInactiveSettingsPath = "${buttonSettingsPath}.inactive_window";

      ButtonColorsInactiveSameHoverPress = defaultIfUndefined KlassySettings defaultsParams "${buttonsColoursInactiveSettingsPath}.use_same_hover_n_press_colours_as_active_window";

      buttonsIconColoursInactiveSettingsPath = "${buttonsColoursInactiveSettingsPath}.icon_colours";

      ButtonIconColorsInactive =
        if LockButtonColorsActiveInactive
        then ButtonIconColorsActive
        else defaultIfUndefined KlassySettings defaultsParams "${buttonsIconColoursInactiveSettingsPath}.choice";
      CloseButtonIconColorInactive =
        if LockButtonColorsActiveInactive
        then CloseButtonIconColorActive
        else defaultIfUndefined KlassySettings defaultsParams "${buttonsIconColoursInactiveSettingsPath}.close_button_icon_colour";
      ButtonIconOpacityInactive =
        if LockButtonColorsActiveInactive
        then ButtonIconOpacityActive
        else defaultIfUndefined KlassySettings defaultsParams "${buttonsIconColoursInactiveSettingsPath}.opacity";

      buttonsColoursInactiveContrastSettingsPath = "${buttonsIconColoursInactiveSettingsPath}.contrast";

      OnPoorIconContrastInactive =
        if LockButtonColorsActiveInactive
        then OnPoorIconContrastActive
        else defaultIfUndefined KlassySettings defaultsParams "${buttonsColoursInactiveContrastSettingsPath}.when_poor_contrast_detected";
      PoorIconContrastThresholdInactive =
        if LockButtonColorsActiveInactive
        then PoorIconContrastThresholdActive
        else defaultIfUndefined KlassySettings defaultsParams "${buttonsColoursInactiveContrastSettingsPath}.threshold";

      buttonsBackground_N_OutlineColoursInactiveSettingsPath = "${buttonsColoursInactiveSettingsPath}.background_n_outline_colours";

      ButtonBackgroundColorsInactive =
        if LockButtonColorsActiveInactive
        then ButtonBackgroundColorsActive
        else defaultIfUndefined KlassySettings defaultsParams "${buttonsBackground_N_OutlineColoursInactiveSettingsPath}.choice";
      UseHoverAccentInactive =
        if LockButtonColorsActiveInactive
        then UseHoverAccentActive
        else defaultIfUndefined KlassySettings defaultsParams "${buttonsBackground_N_OutlineColoursInactiveSettingsPath}.use_hover_colour_from_colour_scheme";
      ButtonBackgroundOpacityInactive =
        if LockButtonColorsActiveInactive
        then ButtonBackgroundOpacityActive
        else defaultIfUndefined KlassySettings defaultsParams "${buttonsBackground_N_OutlineColoursInactiveSettingsPath}.opacity";

      buttonsBackgroundInactiveContrastSettingsPath = "${buttonsBackground_N_OutlineColoursInactiveSettingsPath}.contrast";

      AdjustBackgroundColorOnPoorContrastInactive =
        if LockButtonColorsActiveInactive
        then AdjustBackgroundColorOnPoorContrastActive
        else defaultIfUndefined KlassySettings defaultsParams "${buttonsBackgroundInactiveContrastSettingsPath}.adjust_colour_when_poor_contrast_detected";
      PoorBackgroundContrastThresholdInactive =
        if LockButtonColorsActiveInactive
        then PoorBackgroundContrastThresholdActive
        else defaultIfUndefined KlassySettings defaultsParams "${buttonsBackgroundInactiveContrastSettingsPath}.threshold";
      # TODO : Parse ultra personalization settings
    in ''
      AdjustBackgroundColorOnPoorContrastActive=${boolToString AdjustBackgroundColorOnPoorContrastActive}
      AdjustBackgroundColorOnPoorContrastInactive=${boolToString AdjustBackgroundColorOnPoorContrastInactive}
      ButtonBackgroundColorsActive=${ButtonBackgroundColorsActive}
      ButtonBackgroundColorsInactive=${ButtonBackgroundColorsInactive}
      ButtonBackgroundOpacityActive=${toString ButtonBackgroundOpacityActive}
      ButtonBackgroundOpacityInactive=${toString ButtonBackgroundOpacityInactive}
      ButtonColorsInactiveSameHoverPress=${boolToString ButtonColorsInactiveSameHoverPress}
      LockButtonColorsActiveInactive=${boolToString LockButtonColorsActiveInactive}
      #TODO NegativeCloseBackgroundHoverPressActive=
      #TODO NegativeCloseBackgroundHoverPressInactive=
      ButtonIconColorsActive=${ButtonIconColorsActive}
      ButtonIconColorsInactive=${ButtonIconColorsInactive}
      CloseButtonIconColorActive=${CloseButtonIconColorActive}
      CloseButtonIconColorInactive=${CloseButtonIconColorInactive}
      #TODO ButtonOverrideColorsActiveClose=
      #TODO ButtonOverrideColorsInactiveClose=
      OnPoorIconContrastActive=${boolToString OnPoorIconContrastActive}
      OnPoorIconContrastInactive=${boolToString OnPoorIconContrastInactive}
      #TODO ButtonOverrideColorsActiveApplicationMenu=
      #TODO ButtonOverrideColorsActiveContextHelp=
      #TODO ButtonOverrideColorsActiveKeepAbove=
      #TODO ButtonOverrideColorsActiveKeepBelow=
      #TODO ButtonOverrideColorsActiveMaximize=
      #TODO ButtonOverrideColorsActiveMenu=
      #TODO ButtonOverrideColorsActiveMinimize=
      #TODO ButtonOverrideColorsActiveOnAllDesktops=
      #TODO ButtonOverrideColorsActiveShade=
      #TODO ButtonOverrideColorsInactiveApplicationMenu=
      #TODO ButtonOverrideColorsInactiveContextHelp=
      #TODO ButtonOverrideColorsInactiveKeepAbove=
      #TODO ButtonOverrideColorsInactiveKeepBelow=
      #TODO ButtonOverrideColorsInactiveMaximize=
      #TODO ButtonOverrideColorsInactiveMenu=
      #TODO ButtonOverrideColorsInactiveMinimize=
      #TODO ButtonOverrideColorsInactiveOnAllDesktops=
      #TODO ButtonOverrideColorsInactiveShade=
      #TODO ButtonOverrideColorsLockStatesInactive=
      PoorBackgroundContrastThresholdActive=${toString PoorBackgroundContrastThresholdActive}
      PoorBackgroundContrastThresholdInactive=${toString PoorBackgroundContrastThresholdInactive}
      PoorIconContrastThresholdActive=${toString PoorIconContrastThresholdActive}
      PoorIconContrastThresholdInactive=${toString PoorIconContrastThresholdInactive}
      #TODO ButtonOverrideColorsLockStatesActive=
      ButtonIconOpacityActive=${toString ButtonIconOpacityActive}
      ButtonIconOpacityInactive=${toString ButtonIconOpacityInactive}
      UseHoverAccentActive=${boolToString UseHoverAccentActive}
      UseHoverAccentInactive=${boolToString UseHoverAccentInactive}
    '';
    ButtonBehaviour = let
      buttonBehaviourSettingsPath = "${buttonsSettingsPath}.button_behaviour";
      UnisonHovering = defaultIfUndefined KlassySettings defaultsParams "${buttonBehaviourSettingsPath}.unison_hovering";

      activeWindowSettingsPath = "${buttonBehaviourSettingsPath}.active_window";
      LockButtonBehaviourActiveInactive = defaultIfUndefined KlassySettings defaultsParams "${activeWindowSettingsPath}.lock_active_inactive";
      LockCloseButtonBehaviourActive = defaultIfUndefined KlassySettings defaultsParams "${activeWindowSettingsPath}.lock_to_make_same_changes_to_normal_button_and_closse_button";
      activeNormalButtonsSettingsPath = "${activeWindowSettingsPath}.normal_buttons";
      ButtonStateCheckedActive = defaultIfUndefined KlassySettings defaultsParams "${activeNormalButtonsSettingsPath}.state_to_use_for_checked_buttons";
      activeNormalIconsSettingsPath = "${activeNormalButtonsSettingsPath}.icons";
      ShowIconNormallyActive = defaultIfUndefined KlassySettings defaultsParams "${activeNormalIconsSettingsPath}.show_normally";
      ShowIconOnHoverActive = defaultIfUndefined KlassySettings defaultsParams "${activeNormalIconsSettingsPath}.show_on_hover";
      ShowIconOnPressActive = defaultIfUndefined KlassySettings defaultsParams "${activeNormalIconsSettingsPath}.show_on_press";
      VaryColorIconActive = defaultIfUndefined KlassySettings defaultsParams "${activeNormalIconsSettingsPath}.vary_color_on_state";
      activeNormalBackgroundsSettingsPath = "${activeNormalButtonsSettingsPath}.backgrounds";
      ShowBackgroundNormallyActive = defaultIfUndefined KlassySettings defaultsParams "${activeNormalBackgroundsSettingsPath}.show_normally";
      ShowBackgroundOnHoverActive = defaultIfUndefined KlassySettings defaultsParams "${activeNormalBackgroundsSettingsPath}.show_on_hover";
      ShowBackgroundOnPressActive = defaultIfUndefined KlassySettings defaultsParams "${activeNormalBackgroundsSettingsPath}.show_on_press";
      VaryColorBackgroundActive = defaultIfUndefined KlassySettings defaultsParams "${activeNormalBackgroundsSettingsPath}.vary_color_on_state";
      activeNormalOutlinesSettingsPath = "${activeNormalButtonsSettingsPath}.outlines";
      ShowOutlineNormallyActive = defaultIfUndefined KlassySettings defaultsParams "${activeNormalOutlinesSettingsPath}.show_normally";
      ShowOutlineOnHoverActive = defaultIfUndefined KlassySettings defaultsParams "${activeNormalOutlinesSettingsPath}.show_on_hover";
      ShowOutlineOnPressActive = defaultIfUndefined KlassySettings defaultsParams "${activeNormalOutlinesSettingsPath}.show_on_press";
      VaryColorOutlineActive = defaultIfUndefined KlassySettings defaultsParams "${activeNormalOutlinesSettingsPath}.vary_color_on_state";

      activeCloseButtonSettingsPath = "${activeWindowSettingsPath}.close_button";
      activeCloseIconsSettingsPath = "${activeCloseButtonSettingsPath}.icons";
      ShowCloseIconNormallyActive =
        if LockCloseButtonBehaviourActive
        then ShowIconNormallyActive
        else defaultIfUndefined KlassySettings defaultsParams "${activeCloseIconsSettingsPath}.show_normally";
      ShowCloseIconOnHoverActive =
        if LockCloseButtonBehaviourActive
        then ShowIconOnHoverActive
        else defaultIfUndefined KlassySettings defaultsParams "${activeCloseIconsSettingsPath}.show_on_hover";
      ShowCloseIconOnPressActive =
        if LockCloseButtonBehaviourActive
        then ShowIconOnPressActive
        else defaultIfUndefined KlassySettings defaultsParams "${activeCloseIconsSettingsPath}.show_on_press";
      VaryColorCloseIconActive =
        if LockCloseButtonBehaviourActive
        then VaryColorIconActive
        else defaultIfUndefined KlassySettings defaultsParams "${activeCloseIconsSettingsPath}.vary_color_on_state";
      activeCloseBackgroundsSettingsPath = "${activeCloseButtonSettingsPath}.backgrounds";
      ShowCloseBackgroundNormallyActive =
        if LockCloseButtonBehaviourActive
        then ShowBackgroundNormallyActive
        else defaultIfUndefined KlassySettings defaultsParams "${activeCloseBackgroundsSettingsPath}.show_normally";
      ShowCloseBackgroundOnHoverActive =
        if LockCloseButtonBehaviourActive
        then ShowBackgroundOnHoverActive
        else defaultIfUndefined KlassySettings defaultsParams "${activeCloseBackgroundsSettingsPath}.show_on_hover";
      ShowCloseBackgroundOnPressActive =
        if LockCloseButtonBehaviourActive
        then ShowBackgroundOnPressActive
        else defaultIfUndefined KlassySettings defaultsParams "${activeCloseBackgroundsSettingsPath}.show_on_press";
      VaryColorCloseBackgroundActive =
        if LockCloseButtonBehaviourActive
        then VaryColorBackgroundActive
        else defaultIfUndefined KlassySettings defaultsParams "${activeCloseBackgroundsSettingsPath}.vary_color_on_state";
      activeCloseOutlinesSettingsPath = "${activeCloseButtonSettingsPath}.outlines";
      ShowCloseOutlineNormallyActive =
        if LockCloseButtonBehaviourActive
        then ShowOutlineNormallyActive
        else defaultIfUndefined KlassySettings defaultsParams "${activeCloseOutlinesSettingsPath}.show_normally";
      ShowCloseOutlineOnHoverActive =
        if LockCloseButtonBehaviourActive
        then ShowOutlineOnHoverActive
        else defaultIfUndefined KlassySettings defaultsParams "${activeCloseOutlinesSettingsPath}.show_on_hover";
      ShowCloseOutlineOnPressActive =
        if LockCloseButtonBehaviourActive
        then ShowOutlineOnPressActive
        else defaultIfUndefined KlassySettings defaultsParams "${activeCloseOutlinesSettingsPath}.show_on_press";
      VaryColorCloseOutlineActive =
        if LockCloseButtonBehaviourActive
        then VaryColorOutlineActive
        else defaultIfUndefined KlassySettings defaultsParams "${activeCloseOutlinesSettingsPath}.vary_color_on_state";

      inactiveWindowSettingsPath = "${buttonBehaviourSettingsPath}.inactive_window";
      LockCloseButtonBehaviourInactive =
        if LockButtonBehaviourActiveInactive
        then LockCloseButtonBehaviourActive
        else defaultIfUndefined KlassySettings defaultsParams "${inactiveWindowSettingsPath}.lock_to_make_same_changes_to_normal_button_and_closse_button";
      inactiveNormalButtonsSettingsPath = "${inactiveWindowSettingsPath}.normal_buttons";
      ButtonStateCheckedInactive =
        if LockButtonBehaviourActiveInactive
        then ButtonStateCheckedActive
        else defaultIfUndefined KlassySettings defaultsParams "${inactiveNormalButtonsSettingsPath}.state_to_use_for_checked_buttons";
      inactiveNormalIconsSettingsPath = "${inactiveNormalButtonsSettingsPath}.icons";
      ShowIconNormallyInactive =
        if LockButtonBehaviourActiveInactive
        then ShowIconNormallyActive
        else defaultIfUndefined KlassySettings defaultsParams "${inactiveNormalIconsSettingsPath}.show_normally";
      ShowIconOnHoverInactive =
        if LockButtonBehaviourActiveInactive
        then ShowIconOnHoverActive
        else defaultIfUndefined KlassySettings defaultsParams "${inactiveNormalIconsSettingsPath}.show_on_hover";
      ShowIconOnPressInactive =
        if LockButtonBehaviourActiveInactive
        then ShowIconOnPressActive
        else defaultIfUndefined KlassySettings defaultsParams "${inactiveNormalIconsSettingsPath}.show_on_press";
      VaryColorIconInactive =
        if LockButtonBehaviourActiveInactive
        then VaryColorIconActive
        else defaultIfUndefined KlassySettings defaultsParams "${inactiveNormalIconsSettingsPath}.vary_color_on_state";
      inactiveNormalBackgroundsSettingsPath = "${inactiveNormalButtonsSettingsPath}.backgrounds";
      ShowBackgroundNormallyInactive =
        if LockButtonBehaviourActiveInactive
        then ShowBackgroundNormallyActive
        else defaultIfUndefined KlassySettings defaultsParams "${inactiveNormalBackgroundsSettingsPath}.show_normally";
      ShowBackgroundOnHoverInactive =
        if LockButtonBehaviourActiveInactive
        then ShowBackgroundOnHoverActive
        else defaultIfUndefined KlassySettings defaultsParams "${inactiveNormalBackgroundsSettingsPath}.show_on_hover";
      ShowBackgroundOnPressInactive =
        if LockButtonBehaviourActiveInactive
        then ShowBackgroundOnPressActive
        else defaultIfUndefined KlassySettings defaultsParams "${inactiveNormalBackgroundsSettingsPath}.show_on_press";
      VaryColorBackgroundInactive =
        if LockButtonBehaviourActiveInactive
        then VaryColorBackgroundActive
        else defaultIfUndefined KlassySettings defaultsParams "${inactiveNormalBackgroundsSettingsPath}.vary_color_on_state";
      inactiveNormalOutlinesSettingsPath = "${inactiveNormalButtonsSettingsPath}.outlines";
      ShowOutlineNormallyInactive =
        if LockButtonBehaviourActiveInactive
        then ShowOutlineNormallyActive
        else defaultIfUndefined KlassySettings defaultsParams "${inactiveNormalOutlinesSettingsPath}.show_normally";
      ShowOutlineOnHoverInactive =
        if LockButtonBehaviourActiveInactive
        then ShowOutlineOnHoverActive
        else defaultIfUndefined KlassySettings defaultsParams "${inactiveNormalOutlinesSettingsPath}.show_on_hover";
      ShowOutlineOnPressInactive =
        if LockButtonBehaviourActiveInactive
        then ShowOutlineOnPressActive
        else defaultIfUndefined KlassySettings defaultsParams "${inactiveNormalOutlinesSettingsPath}.show_on_press";
      VaryColorOutlineInactive =
        if LockButtonBehaviourActiveInactive
        then VaryColorOutlineActive
        else defaultIfUndefined KlassySettings defaultsParams "${inactiveNormalOutlinesSettingsPath}.vary_color_on_state";

      inactiveCloseButtonSettingsPath = "${activeWindowSettingsPath}.close_button";
      inactiveCloseIconsSettingsPath = "${inactiveCloseButtonSettingsPath}.icons";
      ShowCloseIconNormallyInactive =
        if LockCloseButtonBehaviourInactive
        then ShowIconNormallyInactive
        else defaultIfUndefined KlassySettings defaultsParams "${inactiveCloseIconsSettingsPath}.show_normally";
      ShowCloseIconOnHoverInactive =
        if LockCloseButtonBehaviourInactive
        then ShowIconOnHoverInactive
        else defaultIfUndefined KlassySettings defaultsParams "${inactiveCloseIconsSettingsPath}.show_on_hover";
      ShowCloseIconOnPressInactive =
        if LockCloseButtonBehaviourInactive
        then ShowIconOnPressInactive
        else defaultIfUndefined KlassySettings defaultsParams "${inactiveCloseIconsSettingsPath}.show_on_press";
      VaryColorCloseIconInactive =
        if LockCloseButtonBehaviourInactive
        then VaryColorCloseIconActive
        else defaultIfUndefined KlassySettings defaultsParams "${inactiveCloseIconsSettingsPath}.vary_color_on_state";
      inactiveCloseBackgroundsSettingsPath = "${inactiveCloseButtonSettingsPath}.backgrounds";
      ShowCloseBackgroundNormallyInactive =
        if LockCloseButtonBehaviourInactive
        then ShowCloseBackgroundNormallyActive
        else defaultIfUndefined KlassySettings defaultsParams "${inactiveCloseBackgroundsSettingsPath}.show_normally";
      ShowCloseBackgroundOnHoverInactive =
        if LockCloseButtonBehaviourInactive
        then ShowCloseBackgroundOnHoverActive
        else defaultIfUndefined KlassySettings defaultsParams "${inactiveCloseBackgroundsSettingsPath}.show_on_hover";
      ShowCloseBackgroundOnPressInactive =
        if LockCloseButtonBehaviourInactive
        then ShowCloseBackgroundOnPressActive
        else defaultIfUndefined KlassySettings defaultsParams "${inactiveCloseBackgroundsSettingsPath}.show_on_press";
      VaryColorCloseBackgroundInactive =
        if LockCloseButtonBehaviourInactive
        then VaryColorCloseBackgroundActive
        else defaultIfUndefined KlassySettings defaultsParams "${inactiveCloseBackgroundsSettingsPath}.vary_color_on_state";
      inactiveCloseOutlinesSettingsPath = "${inactiveCloseButtonSettingsPath}.outlines";
      ShowCloseOutlineNormallyInactive =
        if LockCloseButtonBehaviourInactive
        then ShowCloseOutlineNormallyActive
        else defaultIfUndefined KlassySettings defaultsParams "${inactiveCloseOutlinesSettingsPath}.show_normally";
      ShowCloseOutlineOnHoverInactive =
        if LockCloseButtonBehaviourInactive
        then ShowCloseOutlineOnHoverActive
        else defaultIfUndefined KlassySettings defaultsParams "${inactiveCloseOutlinesSettingsPath}.show_on_hover";
      ShowCloseOutlineOnPressInactive =
        if LockCloseButtonBehaviourInactive
        then ShowCloseOutlineOnPressActive
        else defaultIfUndefined KlassySettings defaultsParams "${inactiveCloseOutlinesSettingsPath}.show_on_press";
      VaryColorCloseOutlineInactive =
        if LockCloseButtonBehaviourInactive
        then VaryColorCloseOutlineActive
        else defaultIfUndefined KlassySettings defaultsParams "${inactiveCloseOutlinesSettingsPath}.vary_color_on_state";
    in ''
      UnisonHovering=${boolToString UnisonHovering}
      LockButtonBehaviourActiveInactive=${boolToString LockButtonBehaviourActiveInactive}
      ButtonStateCheckedActive=${toString ButtonStateCheckedActive}
      ShowIconNormallyActive=${boolToString ShowIconNormallyActive}
      ShowIconOnHoverActive=${boolToString ShowIconOnHoverActive}
      ShowIconOnPressActive=${boolToString ShowIconOnPressActive}
      VaryColorIconActive=${VaryColorIconActive}
      ShowBackgroundNormallyActive=${boolToString ShowBackgroundNormallyActive}
      ShowBackgroundOnHoverActive=${boolToString ShowBackgroundOnHoverActive}
      ShowBackgroundOnPressActive=${boolToString ShowBackgroundOnPressActive}
      VaryColorBackgroundActive=${VaryColorBackgroundActive}
      ShowOutlineNormallyActive=${boolToString ShowOutlineNormallyActive}
      ShowOutlineOnHoverActive=${boolToString ShowOutlineOnHoverActive}
      ShowOutlineOnPressActive=${boolToString ShowOutlineOnPressActive}
      VaryColorOutlineActive=${VaryColorOutlineActive}
      LockCloseButtonBehaviourActive=${boolToString LockCloseButtonBehaviourActive}
      ShowCloseIconNormallyActive=${boolToString ShowCloseIconNormallyActive}
      ShowCloseIconOnHoverActive=${boolToString ShowCloseIconOnHoverActive}
      ShowCloseIconOnPressActive=${boolToString ShowCloseIconOnPressActive}
      VaryColorCloseIconActive=${VaryColorCloseIconActive}
      ShowCloseBackgroundNormallyActive=${boolToString ShowCloseBackgroundNormallyActive}
      ShowCloseBackgroundOnHoverActive=${boolToString ShowCloseBackgroundOnHoverActive}
      ShowCloseBackgroundOnPressActive=${boolToString ShowCloseBackgroundOnPressActive}
      VaryColorCloseBackgroundActive=${VaryColorCloseBackgroundActive}
      ShowCloseOutlineNormallyActive=${boolToString ShowCloseOutlineNormallyActive}
      ShowCloseOutlineOnHoverActive=${boolToString ShowCloseOutlineOnHoverActive}
      ShowCloseOutlineOnPressActive=${boolToString ShowCloseOutlineOnPressActive}
      VaryColorCloseOutlineActive=${VaryColorCloseOutlineActive}
      ButtonStateCheckedInactive=${boolToString ButtonStateCheckedInactive}
      ShowIconNormallyInactive=${boolToString ShowIconNormallyInactive}
      ShowIconOnHoverInactive=${boolToString ShowIconOnHoverInactive}
      ShowIconOnPressInactive=${boolToString ShowIconOnPressInactive}
      VaryColorIconInactive=${VaryColorIconInactive}
      ShowBackgroundNormallyInactive=${boolToString ShowBackgroundNormallyInactive}
      ShowBackgroundOnHoverInactive=${boolToString ShowBackgroundOnHoverInactive}
      ShowBackgroundOnPressInactive=${boolToString ShowBackgroundOnPressInactive}
      VaryColorBackgroundInactive=${VaryColorBackgroundInactive}
      ShowOutlineNormallyInactive=${boolToString ShowOutlineNormallyInactive}
      ShowOutlineOnHoverInactive=${boolToString ShowOutlineOnHoverInactive}
      ShowOutlineOnPressInactive=${boolToString ShowOutlineOnPressInactive}
      VaryColorOutlineInactive=${VaryColorOutlineInactive}
      LockCloseButtonBehaviourInactive=${boolToString LockCloseButtonBehaviourInactive}
      ShowCloseIconNormallyInactive=${boolToString ShowCloseIconNormallyInactive}
      ShowCloseIconOnHoverInactive=${boolToString ShowCloseIconOnHoverInactive}
      ShowCloseIconOnPressInactive=${boolToString ShowCloseIconOnPressInactive}
      VaryColorCloseIconInactive=${VaryColorCloseIconInactive}
      ShowCloseBackgroundNormallyInactive=${boolToString ShowCloseBackgroundNormallyInactive}
      ShowCloseBackgroundOnHoverInactive=${boolToString ShowCloseBackgroundOnHoverInactive}
      ShowCloseBackgroundOnPressInactive=${boolToString ShowCloseBackgroundOnPressInactive}
      VaryColorCloseBackgroundInactive=${VaryColorCloseBackgroundInactive}
      ShowCloseOutlineNormallyInactive=${boolToString ShowCloseOutlineNormallyInactive}
      ShowCloseOutlineOnHoverInactive=${boolToString ShowCloseOutlineOnHoverInactive}
      ShowCloseOutlineOnPressInactive=${boolToString ShowCloseOutlineOnPressInactive}
      VaryColorCloseOutlineInactive=${VaryColorCloseOutlineInactive}
    '';
    ButtonSizing = let
      buttonSizingAndSpacingSettingsPath = "${buttonsSettingsPath}.button_size_n_spacing";
      buttonSizingSettingsPath = "${buttonSizingAndSpacingSettingsPath}.button_sizing";
      LockFullHeightButtonWidthMargins = defaultIfUndefined KlassySettings defaultsParams "${buttonSizingSettingsPath}.same_left_n_right_hand_buttons_width_margins";
      FullHeightButtonWidthMarginLeft = defaultIfUndefined KlassySettings defaultsParams "${buttonSizingSettingsPath}.left_hand_buttons_width_margins";
      FullHeightButtonWidthMarginRight =
        if LockFullHeightButtonWidthMargins
        then FullHeightButtonWidthMarginLeft
        else defaultIfUndefined KlassySettings defaultsParams "${buttonSizingSettingsPath}.right_hand_buttons_width_margins";
      CloseFullHeightButtonWidthMarginRelative = defaultIfUndefined KlassySettings defaultsParams "${buttonSizingSettingsPath}.close_button_width_margins";
      SpacerButtonWidthRelative = defaultIfUndefined KlassySettings defaultsParams "${buttonSizingSettingsPath}.spacer_button_width";
      ScaleTouchMode = defaultIfUndefined KlassySettings defaultsParams "${buttonSizingSettingsPath}.scale_touch_mode_buttons";
      buttonSpacingSettingsPath = "${buttonSizingAndSpacingSettingsPath}.button_spacing";
      LockFullHeightButtonSpacingLeftRight = defaultIfUndefined KlassySettings defaultsParams "${buttonSpacingSettingsPath}.same_spacing_between_left_hand_buttons_n_right_hand_buttons";
      FullHeightButtonSpacingLeft = defaultIfUndefined KlassySettings defaultsParams "${buttonSpacingSettingsPath}.spacing_between_left_hand_buttons";
      FullHeightButtonSpacingRight =
        if LockFullHeightButtonSpacingLeftRight
        then FullHeightButtonSpacingLeft
        else defaultIfUndefined KlassySettings defaultsParams "${buttonSpacingSettingsPath}.spacing_between_right_hand_buttons";
      IntegratedRoundedRectangleBottomPadding = defaultIfUndefined KlassySettings defaultsParams "${buttonSpacingSettingsPath}.bottom_padding";
      buttonCornerRadiusSettingsPath = "${buttonSizingAndSpacingSettingsPath}.button_corner_radius";
      ButtonCornerRadius = defaultIfUndefined KlassySettings defaultsParams "${buttonCornerRadiusSettingsPath}.choice";
      ButtonCustomCornerRadius =
        if ButtonCornerRadius == getDefault defaultsParams "${buttonCornerRadiusSettingsPath}.choice"
        then ""
        else defaultIfUndefined KlassySettings defaultsParams "${buttonCornerRadiusSettingsPath}.value";
    in ''
      ButtonCornerRadius=${ButtonCornerRadius}
      ButtonCustomCornerRadius=${toString ButtonCustomCornerRadius}
      CloseFullHeightButtonWidthMarginRelative=${toString CloseFullHeightButtonWidthMarginRelative}
      FullHeightButtonSpacingLeft=${toString FullHeightButtonSpacingLeft}
      FullHeightButtonSpacingRight=${toString FullHeightButtonSpacingRight}
      FullHeightButtonWidthMarginLeft=${toString FullHeightButtonWidthMarginLeft}
      FullHeightButtonWidthMarginRight=${toString FullHeightButtonWidthMarginRight}
      IntegratedRoundedRectangleBottomPadding=${toString IntegratedRoundedRectangleBottomPadding}
      LockFullHeightButtonSpacingLeftRight=${boolToString LockFullHeightButtonSpacingLeftRight}
      LockFullHeightButtonWidthMargins=${boolToString LockFullHeightButtonWidthMargins}
      ScaleTouchMode=${toString ScaleTouchMode}
      SpacerButtonWidthRelative=${toString SpacerButtonWidthRelative}
    '';
    TitleBarSpacing = let
      titleBarSpacingSettingsPath = "${titlebarSettingsPath}.spacing";
      TitleAlignment = defaultIfUndefined KlassySettings defaultsParams "${titleBarSpacingSettingsPath}.title_alignment";
      TitleSidePadding = defaultIfUndefined KlassySettings defaultsParams "${titleBarSpacingSettingsPath}.title_side_padding";
      PercentMaximizedTopBottomMargins = defaultIfUndefined KlassySettings defaultsParams "${titleBarSpacingSettingsPath}.title_top_n_bottom_margins_for_maximized_windows";
      LockTitleBarLeftRightMargins = defaultIfUndefined KlassySettings defaultsParams "${titleBarSpacingSettingsPath}.same_titlebar_left_n_right_margins";
      TitleBarLeftMargin = defaultIfUndefined KlassySettings defaultsParams "${titleBarSpacingSettingsPath}.titlebar_left_margins";
      TitleBarRightMargin =
        if LockTitleBarLeftRightMargins
        then TitleBarLeftMargin
        else defaultIfUndefined KlassySettings defaultsParams "${titleBarSpacingSettingsPath}.titlebar_right_margins";
      LockTitleBarTopBottomMargins = defaultIfUndefined KlassySettings defaultsParams "${titleBarSpacingSettingsPath}.same_titlebar_top_n_bottom_margins";
      TitleBarTopMargin = defaultIfUndefined KlassySettings defaultsParams "${titleBarSpacingSettingsPath}.title_bar_top_margins";
      TitleBarBottomMargin =
        if LockTitleBarTopBottomMargins
        then TitleBarTopMargin
        else defaultIfUndefined KlassySettings defaultsParams "${titleBarSpacingSettingsPath}.title_bar_bottom_margins";
    in ''
      PercentMaximizedTopBottomMargins=${toString PercentMaximizedTopBottomMargins}
      TitleAlignment=${TitleAlignment}
      TitleBarBottomMargin=${toString TitleBarBottomMargin}
      TitleBarLeftMargin=${toString TitleBarLeftMargin}
      TitleBarRightMargin=${toString TitleBarRightMargin}
      TitleBarTopMargin=${toString TitleBarTopMargin}
      TitleSidePadding=${toString TitleSidePadding}
      LockTitleBarLeftRightMargins=${boolToString LockTitleBarLeftRightMargins}
      LockTitleBarTopBottomMargins=${boolToString LockTitleBarTopBottomMargins}
    '';
    TitleBarOpacity = let
      titleBarOpacitySettingsPath = "${titlebarSettingsPath}.opacity";
      ActiveTitleBarOpacity = defaultIfUndefined KlassySettings defaultsParams "${titleBarOpacitySettingsPath}.active_window";
      InactiveTitleBarOpacity = defaultIfUndefined KlassySettings defaultsParams "${titleBarOpacitySettingsPath}.inactive_window";
      OpaqueMaximizedTitleBars = defaultIfUndefined KlassySettings defaultsParams "${titleBarOpacitySettingsPath}.always_make_titlebar_opaque_when_maximized";
    in ''
      ActiveTitleBarOpacity=${toString ActiveTitleBarOpacity}
      InactiveTitleBarOpacity=${toString InactiveTitleBarOpacity}
      OpaqueMaximizedTitleBars=${boolToString OpaqueMaximizedTitleBars}
    '';
    WindowOutlineStyle = let
      thinWindowOutlineStyleSettingsPath = "${windowSettingsPath}.thin_window_outline";
      windowOutlineStyleSettingsPath = "${thinWindowOutlineStyleSettingsPath}.window_outline_style";
      WindowOutlineThickness = defaultIfUndefined KlassySettings defaultsParams "${windowOutlineStyleSettingsPath}.window_outline_thickness";
      WindowOutlineSnapToWholePixel = defaultIfUndefined KlassySettings defaultsParams "${windowOutlineStyleSettingsPath}.snap_to_whole_pixel";
      WindowOutlineOverlap = defaultIfUndefined KlassySettings defaultsParams "${windowOutlineStyleSettingsPath}.overlap";
      LockWindowOutlineStyleActiveInactive = defaultIfUndefined KlassySettings defaultsParams "${windowOutlineStyleSettingsPath}.same_active_n_inactive_window_outline";
      activeWindowSettingsPath = "${windowOutlineStyleSettingsPath}.active_window";
      WindowOutlineStyleActive = defaultIfUndefined KlassySettings defaultsParams "${activeWindowSettingsPath}.window_outline_style";
      activeOpacitySettingsPath = "${activeWindowSettingsPath}.opacity";
      activeOpacityParamsName =
        if WindowOutlineStyleActive == "WindowOutlineNone"
        then ""
        else defaultIfUndefined KlassySettings defaultsParams "${activeOpacitySettingsPath}.${WindowOutlineStyleActive}.name";
      activeOpacityParametersValue = rec {
        value =
          if (definedOrNull KlassySettings "${activeWindowSettingsPath}.opacity") == null
          then getDefault defaultsParams "${activeOpacitySettingsPath}.${WindowOutlineStyleActive}.value"
          else definedOrNull KlassySettings "${activeWindowSettingsPath}.opacity";
        isNone = WindowOutlineStyleActive == "WindowOutlineNone";
        name =
          if isNone
          then ""
          else activeOpacityParamsName;
      };
      ActiveOpacityParametersString =
        if activeOpacityParametersValue.isNone
        then ""
        else ''
          ${activeOpacityParametersValue.name}=${toString activeOpacityParametersValue.value}
        '';
      activeCustomColorSettingsPath = "${activeWindowSettingsPath}.color";
      LockWindowOutlineCustomColorActiveInactive = defaultIfUndefined KlassySettings defaultsParams "${activeCustomColorSettingsPath}.lock_custom_colour_active_inactive";
      WindowOutlineCustomColorActive = defaultIfUndefined KlassySettings defaultsParams "${activeCustomColorSettingsPath}.choice";
      inactiveWindowSettingsPath = "${windowOutlineStyleSettingsPath}.inactive_window";
      WindowOutlineStyleInactive =
        if LockWindowOutlineStyleActiveInactive
        then WindowOutlineStyleActive
        else defaultIfUndefined KlassySettings defaultsParams "${inactiveWindowSettingsPath}.window_outline_style";
      inactiveOpacitySettingsPath = "${inactiveWindowSettingsPath}.opacity";
      inactiveOpacityParamsName =
        if LockWindowOutlineStyleActiveInactive
        then activeOpacityParamsName
        else if WindowOutlineStyleInactive == "WindowOutlineNone" || (WindowOutlineStyleInactive == "WindowOutlineShadowColor" && WindowOutlineStyleInactive == WindowOutlineStyleActive)
        then ""
        else defaultIfUndefined KlassySettings defaultsParams "${inactiveOpacitySettingsPath}.${WindowOutlineStyleInactive}.name";
      inactiveOpacityParametersValue = rec {
        value =
          if (WindowOutlineStyleInactive == WindowOutlineStyleActive && WindowOutlineStyleActive == "WindowOutlineShadowColor")
          then activeOpacityParametersValue.value
          else if (definedOrNull KlassySettings "${inactiveWindowSettingsPath}.opacity") == null
          then getDefault defaultsParams "${inactiveOpacitySettingsPath}.${WindowOutlineStyleInactive}.value"
          else definedOrNull KlassySettings "${inactiveWindowSettingsPath}.opacity";
        isNone =
          if LockWindowOutlineStyleActiveInactive
          then activeOpacityParametersValue.isNone
          else WindowOutlineStyleInactive == "WindowOutlineNone";
        name =
          if LockWindowOutlineStyleActiveInactive
          then activeOpacityParametersValue.name
          else if isNone
          then ""
          else inactiveOpacityParamsName;
      };
      InactiveOpacityParametersValue =
        if inactiveOpacityParametersValue.isNone || (WindowOutlineStyleInactive == "WindowOutlineShadowColor" && WindowOutlineStyleInactive == WindowOutlineStyleActive)
        then ""
        else ''
          ${inactiveOpacityParametersValue.name}=${toString inactiveOpacityParametersValue.value}
        '';
      inactiveCustomColorSettingsPath = "${inactiveWindowSettingsPath}.color";
      WindowOutlineCustomColorInactive =
        if LockWindowOutlineCustomColorActiveInactive && (WindowOutlineStyleActive == "WindowOutlineCustomColor" || WindowOutlineStyleActive == "WindowOutlineCustomWithContrast")
        then WindowOutlineCustomColorActive
        else defaultIfUndefined KlassySettings defaultsParams "${inactiveCustomColorSettingsPath}.choice";
    in ''
      LockWindowOutlineStyleActiveInactive=${boolToString LockWindowOutlineStyleActiveInactive}
      WindowOutlineStyleActive=${WindowOutlineStyleActive}
      ${ActiveOpacityParametersString}WindowOutlineStyleInactive=${WindowOutlineStyleInactive}
      ${InactiveOpacityParametersValue}${
        if WindowOutlineStyleActive == "WindowOutlineCustomColor" || WindowOutlineStyleActive == "WindowOutlineCustomWithContrast"
        then ''
          WindowOutlineCustomColorActive=${toString WindowOutlineCustomColorActive}
        ''
        else ""
      }${
        if WindowOutlineStyleInactive == "WindowOutlineCustomColor" || WindowOutlineStyleInactive == "WindowOutlineCustomWithContrast"
        then ''
          WindowOutlineCustomColorInactive=${toString WindowOutlineCustomColorInactive}
        ''
        else ""
      }WindowOutlineThickness=${toString WindowOutlineThickness}
      WindowOutlineSnapToWholePixel=${boolToString WindowOutlineSnapToWholePixel}
      WindowOutlineOverlap=${boolToString WindowOutlineOverlap}
      LockWindowOutlineCustomColorActiveInactive=${boolToString LockWindowOutlineCustomColorActiveInactive}
    '';
    ShadowStyle = let
      shadowSettingsPath = "${windowSettingsPath}.shadow";
      ShadowColor = defaultIfUndefined KlassySettings defaultsParams "${shadowSettingsPath}.colour";
      ShadowSize = defaultIfUndefined KlassySettings defaultsParams "${shadowSettingsPath}.size";
      ShadowStrength = defaultIfUndefined KlassySettings defaultsParams "${shadowSettingsPath}.strength";
    in ''
      ShadowColor=${toString ShadowColor}
      ShadowSize=${toString ShadowSize}
      ShadowStrength=${toString ShadowStrength}
    '';
    Global = let
      Version = "6.5.3"; #TODO : fix
      LookAndFeelSet = "org.kde.klassykisweetdarkbottompanel.desktop"; #TODO : find the parameter that determines this.
    in ''
      LookAndFeelSet=${LookAndFeelSet}
      RefreshedConfig=${Version}
    '';
    Style = let
      generalSettingsPath = "${styleSettingsPath}.general";
      framesSettingsPath = "${styleSettingsPath}.frames";
      scrollbarsSettingsPath = "${styleSettingsPath}.scrollbars";
      transparencySettingsPath = "${styleSettingsPath}.transparency";
      DockWidgetDrawFrame = defaultIfUndefined KlassySettings defaultsParams "${framesSettingsPath}.draw_frame_around_dockable_panels";
      MenuItemDrawStrongFocus = ! defaultIfUndefined KlassySettings defaultsParams "${framesSettingsPath}.draw_a_thin_line_to_indicate_focus_in_menubars";
      SidePanelDrawFrame = defaultIfUndefined KlassySettings defaultsParams "${framesSettingsPath}.draw_frame_around_side_panels";
      SplitterProxyEnabled = defaultIfUndefined KlassySettings defaultsParams "${generalSettingsPath}.enable_extended_resize_handles";
      ButtonGradient = defaultIfUndefined KlassySettings defaultsParams "${generalSettingsPath}.show_button_gradient_effects";
      MenuOpacity = defaultIfUndefined KlassySettings defaultsParams "${transparencySettingsPath}.value";
      WindowDragMode = defaultIfUndefined KlassySettings defaultsParams "${generalSettingsPath}.windows_drag_mode";
      MnemonicsMode = defaultIfUndefined KlassySettings defaultsParams "${generalSettingsPath}.keyboard_accelerator_visibility";
      FrameCornerRadius = defaultIfUndefined KlassySettings defaultsParams "${generalSettingsPath}.corner_radius.choice";
      FrameCustomCornerRadius =
        if FrameCornerRadius == getDefault defaultsParams "${generalSettingsPath}.corner_radius.choice"
        then ""
        else defaultIfUndefined KlassySettings defaultsParams "${generalSettingsPath}.corner_radius.value";
      TabBarDrawCenteredTabs = defaultIfUndefined KlassySettings defaultsParams "${generalSettingsPath}.center_tabbar_tabs";
      SliderDrawTickMarks = defaultIfUndefined KlassySettings defaultsParams "${generalSettingsPath}.draw_sliders_ticks_marks";
      ToolBarDrawItemSeparator = defaultIfUndefined KlassySettings defaultsParams "${generalSettingsPath}.draw_toolbar_item_separators";
      ViewDrawFocusIndicator = defaultIfUndefined KlassySettings defaultsParams "${generalSettingsPath}.draw_focus_indicator_in_lists";
      ScrollBarSeparator = defaultIfUndefined KlassySettings defaultsParams "${scrollbarsSettingsPath}.draw_scroll_bar_separator";
      ScrollBarTopBottomMargins = defaultIfUndefined KlassySettings defaultsParams "${scrollbarsSettingsPath}.scrollbar_top_n_bottom_margins";
      arrowButtonsSettingsPath = "${scrollbarsSettingsPath}.arrow_buttons";
      ScrollBarAutoHideArrows = defaultIfUndefined KlassySettings defaultsParams "${arrowButtonsSettingsPath}.auto_hide_arrows";
      grooveSettingsPath = "${scrollbarsSettingsPath}.groove_or_slider";
      ScrollBarSliderThicknessMouseOver = defaultIfUndefined KlassySettings defaultsParams "${grooveSettingsPath}.slider_thickness_when_mouse_over";
      ScrollBarSliderThicknessMouseNotOverPercent = defaultIfUndefined KlassySettings defaultsParams "${grooveSettingsPath}.slider_thickness_when_mouse_not_over";
      ScrollBarSliderPadding = defaultIfUndefined KlassySettings defaultsParams "${grooveSettingsPath}.slider_side_padding";
      ScrollBarMinSliderHeight = defaultIfUndefined KlassySettings defaultsParams "${grooveSettingsPath}.slider_minimum_height";
      topArrowButtonSettingsPath = "${arrowButtonsSettingsPath}.top_arrow_button";
      ScrollBarSubLineButtons = defaultIfUndefined KlassySettings defaultsParams "${topArrowButtonSettingsPath}.type";
      ScrollBarTopOneButtonSpacing =
        if ScrollBarSubLineButtons == 1
        then let
          defined = definedOrNull KlassySettings "${topArrowButtonSettingsPath}.space_between_arrow_button_and_groove";
          defaultOrDefined = defaultIfUndefined KlassySettings defaultsParams "${topArrowButtonSettingsPath}.space_between_arrow_button_and_groove";
        in
          if defined != null
          then defaultOrDefined
          else defaultOrDefined.${toString ScrollBarSubLineButtons}
        else "";
      ScrollBarTopTwoButtonSpacing =
        if ScrollBarSubLineButtons == 2
        then let
          defined = definedOrNull KlassySettings "${topArrowButtonSettingsPath}.space_between_arrow_button_and_groove";
          defaultOrDefined = defaultIfUndefined KlassySettings defaultsParams "${topArrowButtonSettingsPath}.space_between_arrow_button_and_groove";
        in
          if defined != null
          then defaultOrDefined
          else defaultOrDefined.${toString ScrollBarSubLineButtons}
        else "";
      bottomArrowButtonSettingsPath = "${arrowButtonsSettingsPath}.bottom_arrow_button";
      ScrollBarAddLineButtons = defaultIfUndefined KlassySettings defaultsParams "${bottomArrowButtonSettingsPath}.type";
      ScrollBarBottomOneButtonSpacing =
        if ScrollBarAddLineButtons == 1
        then
          if ScrollBarAddLineButtons == ScrollBarSubLineButtons
          then ScrollBarTopOneButtonSpacing
          else let
            defined = definedOrNull KlassySettings "${bottomArrowButtonSettingsPath}.space_between_arrow_button_and_groove";
            defaultOrDefined = defaultIfUndefined KlassySettings defaultsParams "${bottomArrowButtonSettingsPath}.space_between_arrow_button_and_groove";
          in
            if defined != null
            then defaultOrDefined
            else defaultOrDefined.${toString ScrollBarAddLineButtons}
        else "";
      ScrollBarBottomTwoButtonSpacing =
        if ScrollBarAddLineButtons == 2
        then
          if ScrollBarAddLineButtons == ScrollBarSubLineButtons
          then ScrollBarTopTwoButtonSpacing
          else let
            defined = definedOrNull KlassySettings "${bottomArrowButtonSettingsPath}.space_between_arrow_button_and_groove";
            defaultOrDefined = defaultIfUndefined KlassySettings defaultsParams "${bottomArrowButtonSettingsPath}.space_between_arrow_button_and_groove";
          in
            if defined != null
            then defaultOrDefined
            else defaultOrDefined.${toString ScrollBarAddLineButtons}
        else "";
    in ''
      DockWidgetDrawFrame=${boolToString DockWidgetDrawFrame}
      MenuItemDrawStrongFocus=${boolToString MenuItemDrawStrongFocus}
      SidePanelDrawFrame=${boolToString SidePanelDrawFrame}
      SplitterProxyEnabled=${boolToString SplitterProxyEnabled}
      ButtonGradient=${boolToString ButtonGradient}
      FrameCornerRadius=${FrameCornerRadius}
      FrameCustomCornerRadius=${FrameCustomCornerRadius}
      MnemonicsMode=${MnemonicsMode}
      ScrollBarAutoHideArrows=${boolToString ScrollBarAutoHideArrows}
      ScrollBarAddLineButtons=${toString ScrollBarAddLineButtons}
      ScrollBarBottomTwoButtonSpacing=${toString ScrollBarBottomTwoButtonSpacing}
      ScrollBarMinSliderHeight=${toString ScrollBarMinSliderHeight}
      ScrollBarSeparator=${boolToString ScrollBarSeparator}
      ScrollBarSliderPadding=${toString ScrollBarSliderPadding}
      ScrollBarSliderThicknessMouseNotOverPercent=${toString ScrollBarSliderThicknessMouseNotOverPercent}
      ScrollBarSliderThicknessMouseOver=${toString ScrollBarSliderThicknessMouseOver}
      ScrollBarSubLineButtons=${toString ScrollBarSubLineButtons}
      ScrollBarTopBottomMargins=${toString ScrollBarTopBottomMargins}
      ScrollBarTopTwoButtonSpacing=${toString ScrollBarTopTwoButtonSpacing}
      SliderDrawTickMarks=${boolToString SliderDrawTickMarks}
      TabBarDrawCenteredTabs=${boolToString TabBarDrawCenteredTabs}
      ToolBarDrawItemSeparator=${boolToString ToolBarDrawItemSeparator}
      ViewDrawFocusIndicator=${boolToString ViewDrawFocusIndicator}
      WindowDragMode=${WindowDragMode}
      MenuOpacity=${toString MenuOpacity}
      ScrollBarBottomOneButtonSpacing=${toString ScrollBarBottomOneButtonSpacing}
      ScrollBarTopOneButtonSpacing=${toString ScrollBarTopOneButtonSpacing}
    '';
    SystemIconGeneration = let
      systemIconGenerationSettingsPath = "${buttonsSettingsPath}.system_icon_generation";
      KlassyDarkIconThemeInherits = defaultIfUndefined KlassySettings defaultsParams "${systemIconGenerationSettingsPath}.klassy_dark_icon_theme_inherits_from";
      KlassyIconThemeInherits = defaultIfUndefined KlassySettings defaultsParams "${systemIconGenerationSettingsPath}.klassy_icon_theme_inherits_from";
    in ''
      KlassyDarkIconThemeInherits=${KlassyDarkIconThemeInherits}
      KlassyIconThemeInherits=${KlassyIconThemeInherits}
    '';
    WindowDefaultExceptions = let
      windowDefaultExceptionsSettingsPath = "${windowSpecificOverridesSettingsPath}.defaults_overrides";
      defaultOverridesDefaults = getDefault defaultsParams windowDefaultExceptionsSettingsPath;
      defaultExceptionList =
        if (definedOrNull KlassySettings windowDefaultExceptionsSettingsPath) == null
        then []
        else
          builtins.filter (exception: builtins.isAttrs exception) (
            if builtins.isAttrs (defaultIfUndefined KlassySettings defaultsParams windowDefaultExceptionsSettingsPath)
            then []
            else defaultIfUndefined KlassySettings defaultsParams windowDefaultExceptionsSettingsPath
          );
    in
      lib.strings.concatLines
      (lib.foldl' (acc: exception:
          acc
          // {
            result = acc.result ++ [(parseDefaultOverrides acc.counter exception defaultOverridesDefaults)];
            counter = acc.counter + 1;
          }) {
          result = [];
          counter = 0;
        }
        defaultExceptionList).result;
    WindowUserSpecificOverrides = let
      userDefaultExceptionsSettingsPath = "${windowSpecificOverridesSettingsPath}.user_specific_overrides";
      userOverridesDefaults = getDefault defaultsParams userDefaultExceptionsSettingsPath;
      userExceptionList =
        if (definedOrNull KlassySettings userDefaultExceptionsSettingsPath) == null
        then []
        else
          builtins.filter (exception: builtins.isAttrs exception) (
            if builtins.isAttrs (defaultIfUndefined KlassySettings defaultsParams userDefaultExceptionsSettingsPath)
            then []
            else defaultIfUndefined KlassySettings defaultsParams userDefaultExceptionsSettingsPath
          );
    in
      lib.strings.concatLines
      (lib.foldl' (acc: exception:
          acc
          // {
            result = acc.result ++ [(parseUserSpecificOverride acc.counter exception userOverridesDefaults)];
            counter = acc.counter + 1;
          }) {
          result = [];
          counter = 0;
        }
        userExceptionList).result;
  in ''
    ${WindowDefaultExceptions}[Windeco]
    ${Windeco}
    [ButtonColors]
    ${ButtonColors}
    [ButtonBehaviour]
    ${ButtonBehaviour}
    [ButtonSizing]
    ${ButtonSizing}
    [TitleBarSpacing]
    ${TitleBarSpacing}
    [TitleBarOpacity]
    ${TitleBarOpacity}
    [WindowOutlineStyle]
    ${WindowOutlineStyle}
    [ShadowStyle]
    ${ShadowStyle}
    [SystemIconGeneration]
    ${SystemIconGeneration}
    [Global]
    ${Global}
    [Style]
    ${Style}
    ${WindowUserSpecificOverrides}'';

  parsePreset = preset: let
    name =
      if lib.isPath preset
      then lib.lists.last (lib.lists.take 1 (lib.splitString "." (builtins.baseNameOf preset)))
      else preset.name;
    content =
      if lib.isPath preset
      then builtins.readFile preset
      else preset.content;
    contentLines =
      if lib.isString content
      then lib.splitString "\n" content
      else let attrNames = lib.attrNames content; in map (attrName: "${attrName}=${content.${attrName}}") attrNames;
    cleanedContentLines =
      if lib.isPath preset
      then lib.lists.drop 4 contentLines
      else contentLines;
  in ''
    [Windeco Preset ${name}]
    ${lib.trim (lib.strings.concatLines cleanedContentLines)}
  '';

  parsePresets = presets: defaultsPresets: let
    presetsContent = map parsePreset presets;
    defaultsPresetsContent = builtins.readFile defaultsPresets;
  in ''
    ${defaultsPresetsContent}
    ${lib.strings.concatLines presetsContent}
  '';
  params.klassy = {
    style = {
      general = {
        enable_extended_resize_handles = true;
      };
      frames = {
        draw_frame_around_dockable_panels = true;
        draw_frame_around_side_panels = true;
        draw_a_thin_line_to_indicate_focus_in_menubars = true; #Attention inversion
      };
    };
    window_decoration = {
      buttons = {
        icons = "StyleMetro";
        button_colours = {
          lock_active_inactive = true;
          active_window = {
            icon_colours = rec {
              choice = "AccentTrafficLights";
              close_button_icon_colour = choice;
            };
            background_n_outline_colours = {
              choice = "AccentTrafficLights";
            };
          };
          inactive_window = {
            use_same_hover_n_press_colours_as_active_window = true;
          };
        };
        button_behaviour = {
          active_window = {
            normal_buttons = {
              backgrounds = {
                vary_color_on_state = "Transparent";
              };
              outlines = {
                show_on_hover = false;
                vary_color_on_state = "Opaque";
              };
            };
          };
        };
      };
      titlebar = {
        on_active_window = {
          make_title_bold = true;
          draw_titlebar_background_gradient = false;
          draw_separator_under_titlebar = false;
        };
        match_titlebar_colour_to_application = true;
      };
      window = {
        corners = {
          round_corners_when_no_borders = false;
          corner_radius = 0.0;
        };
        thin_window_outline = {
          colourize_with_higlighted_buttons_colour = false;
        };
      };
      window_specific_overrides = {
        defaults_overrides = [
          {
            enabled = true;
          }
        ];
        user_specific_overrides = [
          {
            enabled = true;
            window_identification = {
              window_property = 0;
              regex = "com.mitchellh.ghostty";
            };
            windeco_options = {
              preset = {
                enabled = true;
                value = "CleanTranslucid";
              };
              hide_window_titlebar = 0;
              match_titlebar_colour_to_application = true;
              opaque_titlebar = false;
              border_size = {
                enabled = true;
                value = 0;
              };
            };
            application_style_options = {
              application_name_regex = "";
              opaque_header = false;
            };
          }
        ];
      };
    };
  };
  presets = [
    ./klassy/presets/Clean.klpw
    ./klassy/presets/CleanTranslucid.klpw
  ];
  defaultsPreset = ./klassy/defaults/presets.klpw;
  moduleParams = tools.moduleParams rec {
    inherit config lib pkgs-list parentPathAsList tools;
    name = "klassy";
    main-repo = "others";
    branch = "customPkgs";
    options = {
      enable = lib.mkEnableOption "Enables ${name} program and related settings.";
    };
  };
in (tools.fullModule rec {
  inherit (moduleParams) config lib pkgs-list parentPathAsList tools;
  inherit (moduleParams) name togglable subfolder main-repo branch extras imports specialImports options settings;
  inherit (moduleParams) packages currentPathAsList currentDirPath cfg inheritedSettings Common;
  Home = let
    configFile = pkgs-list.nix.latest.writeText "klassyrc" (parseParams params);
    presetFile = pkgs-list.nix.latest.writeText "windecopresetsrc" (parsePresets presets defaultsPreset);
  in {
    home.packages = with packages; [
      klassy
    ];

    home.activation = {
      ${name} = lib.mkBefore ''
        mkdir -p ${config.xdg.configHome}/klassy
        cp ${configFile} ${config.xdg.configHome}/klassy/klassyrc
        cp ${presetFile} ${config.xdg.configHome}/klassy/windecopresetsrc
        chmod 600 ${config.xdg.configHome}/klassy/klassyrc
        chmod 600 ${config.xdg.configHome}/klassy/windecopresetsrc
      '';
    };
  };
})
