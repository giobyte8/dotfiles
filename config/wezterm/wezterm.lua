local wezterm = require 'wezterm'
local config = {}

-------------------------------------------------------------------------------
-- Color scheme

-- wezterm.gui is not available to the mux server, so take care to
-- do something reasonable when this config is evaluated by the mux
function get_appearance()
  if wezterm.gui then
    return wezterm.gui.get_appearance()
  end
  return 'Dark'
end

function scheme_for_appearance(appearance)
  if appearance:find 'Light' then
    return 'Atelier Cave Light (base16)'
  else
    return 'Rosé Pine (base16)'
  end
end

config.color_scheme = scheme_for_appearance(get_appearance())


-------------------------------------------------------------------------------
-- Fonts

-- config.font = wezterm.font 'CaskaydiaCove Nerd Font'
config.font = wezterm.font 'Cascadia Code PL'
config.font_size = 13
config.line_height = 1.05

-- Enables ligatures
config.font_shaper = "Harfbuzz"
config.harfbuzz_features = { "calt=1", "clig=1", "liga=1" }


-------------------------------------------------------------------------------
-- Custom key mappings

config.keys = {
  
  -- Make Option-Left equivalent to Alt-b which many line editors
  -- interpret as backward-word
  { key="LeftArrow", mods="OPT", action=wezterm.action{SendString="\x1bb" }},
  
  -- Make Option-Right equivalent to Alt-f; forward-word
  { key="RightArrow", mods="OPT", action=wezterm.action{SendString="\x1bf" }},
}


-------------------------------------------------------------------------------
-- Others

config.initial_cols = 95
config.initial_rows = 35
config.default_cursor_style = 'SteadyUnderline'

config.animation_fps = 120
config.window_close_confirmation = 'NeverPrompt'
config.window_decorations = "RESIZE"
config.window_padding = {
  left = 16,
  right = 16,
  top = 16,
  bottom = 16
}


return config
