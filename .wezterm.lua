local wezterm = require 'wezterm';

-- From Wez's config
-- A helper function for my fallback fonts
function font_with_fallback(name, params)
  local names = {name, "Noto Color Emoji", "JetBrains Mono"}
  return wezterm.font_with_fallback(names, params)
end

return {
  -- Iosevka font
  font = font_with_fallback("Iosevka Term Light"),
  font_rules = {
    {
      italic = true,
      intensity = "Bold",
      font = font_with_fallback("Iosevka Term", {bold=true, italic=true}),
    },
    {
      italic = true,
      font = font_with_fallback("Iosevka Term Light Italic"),
    },
    {
      intensity = "Bold",
      font = font_with_fallback("Iosevka Term", {bold=true}),
    },
    {
      intensity = "Half",
      font = font_with_fallback("Iosevka Term Extralight"),
    },
  },
  font_dirs = {"/Users/azw/Library/Fonts", "/Users/gus/Library/Fonts"},
  -- Better for my monitor
  dpi = 110.0,
  font_size = 16,

  bold_brightens_ansi_colors = true,
  -- no ligatures
  harfbuzz_features = {"calt=0", "clig=0", "liga=0"},

  -- color_scheme = "Galizur",
  -- color_scheme = "Wryan",
  -- color_scheme = "UnderTheSea",
  -- color_scheme = "synthwave",
  -- color_scheme = "Harper",
  color_scheme = "3024 Night",

  -- Middle mouse button pastes the primary selection.
  mouse_bindings = {
    -- See https://github.com/wez/wezterm/issues/119
    --
    -- Change the default click behavior so that it only selects
    -- text and doesn't open hyperlinks
    {
      event={Up={streak=1, button="Left"}},
      mods="NONE",
      action=wezterm.action{CompleteSelection="Clipboard"},
    },
    -- and make CTRL-Click open hyperlinks
    {
      event={Up={streak=1, button="Left"}},
      mods="CTRL",
      action="OpenLinkAtMouseCursor",
    },
  },

  -- https://wezfurlong.org/wezterm/config/lua/config/selection_word_boundary.html#selection_word_boundary
  -- include punctuation
  selection_word_boundary = " \t\n{}[]()\"'`,;:|│",
  scrollback_lines = 3500,
  audible_bell = "Disabled",

  -- if needed: https://wezfurlong.org/wezterm/hyperlinks.html
  -- hyperlink_rules = {
  -- },
}
