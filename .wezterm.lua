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
      font = font_with_fallback("Iosevka Term Light", {italic=true}),
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
  font_size = 16.0,
  bold_brightens_ansi_colors = true,
  font_antialias = "Greyscale",

  color_scheme = "Galizur",
}
