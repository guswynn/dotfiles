local wezterm = require 'wezterm';

-- From Wez's config
-- A helper function for my fallback fonts
function font_with_fallback(name, params)
  local names = { name, "Noto Color Emoji", "JetBrains Mono" }
  return wezterm.font_with_fallback(names, params)
end

return {
  -- Iosevka font, with very explicit sub-fonts to deal with previous bugs.
  font = font_with_fallback("Iosevka Term Light"),
  font_rules = {
    {
      italic = true,
      intensity = "Bold",
      font = font_with_fallback("Iosevka Term", { bold = true, italic = true }),
    },
    {
      italic = true,
      font = font_with_fallback("Iosevka Term Light Italic"),
    },
    {
      intensity = "Bold",
      font = font_with_fallback("Iosevka Term", { bold = true }),
    },
    {
      intensity = "Half",
      font = font_with_fallback("Iosevka Term Extralight"),
    },
  },
  bold_brightens_ansi_colors = true,
  -- both my normal usernames
  font_dirs = { "/Users/azw/Library/Fonts", "/Users/gus/Library/Fonts" },

  -- Good defaults for my monitor(s), before I zoom in and out.
  dpi = 110.0,
  font_size = 13,

  -- no ligatures
  harfbuzz_features = { "calt=0", "clig=0", "liga=0" },

  -- Looks good with NeoVim 0.10's `wildcharm`
  color_scheme = "Harper",
  -- Slightly darker
  -- color_scheme = "LiquidCarbonTransparent",

  -- Middle mouse button pastes the primary selection.
  mouse_bindings = {
    -- See https://github.com/wez/wezterm/issues/119
    --
    -- Change the default click behavior so that it only selects
    -- text and doesn't open hyperlinks
    {
      event = { Up = { streak = 1, button = "Left" } },
      mods = "NONE",
      action = wezterm.action { CompleteSelection = "Clipboard" },
    },
    -- and make CTRL-Click open hyperlinks
    {
      event = { Up = { streak = 1, button = "Left" } },
      mods = "CTRL",
      action = "OpenLinkAtMouseCursor",
    },
  },

  -- https://wezfurlong.org/wezterm/config/lua/config/selection_word_boundary.html#selection_word_boundary
  -- include punctuation
  selection_word_boundary = " \t\n{}[]()\"'`,;:|│",
  scrollback_lines = 3500,
  audible_bell = "Disabled",

  front_end = "WebGpu",
}
