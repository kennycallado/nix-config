local wezterm = require("wezterm")
local act = wezterm.action

local color_1 = "#c0c0c0" -- blanco
local color_2 = "#f0f"    -- magenta

local config = {}
if wezterm.config_builder then config = wezterm.config_builder() end

-- QUICK FIX
config.enable_wayland = false -- I need it to be true for wl-screenrec

-- General settings
config.scrollback_lines = 3000
config.adjust_window_size_when_changing_font_size = false

-- Color scheme
-- config.color_scheme = 'Galizur'
config.color_scheme = "Abernathy"
--
-- config.color_scheme = "Tokyo Night"
-- config.color_scheme = "Violet Dark"
-- config.color_scheme = "Argonaut"
-- config.color_scheme = "Atelier Seaside Light (base16)"
-- config.color_scheme = "Atelier Seaside (base16)"
-- config.color_scheme = 'Atelier Sulphurpool Light (base16)'
-- config.color_scheme = 'Atelier Sulphurpool (base16)'
-- config.color_scheme = 'Atelierforest (light) (terminal.sexy)'
-- config.color_scheme = 'Atelierforest (dark) (terminal.sexy)'
-- config.color_scheme = "Ayu Dark (Gogh)"
-- config.color_scheme = 'Ayu Light (Gogh)'
-- config.color_scheme = 'Blue Matrix'
-- config.color_scheme = 'Brogrammer'
-- config.color_scheme = 'Builtin Dark'
-- config.color_scheme = 'Builtin Light'
-- config.color_scheme = 'Chalk'
-- config.color_scheme = 'Colors (base16)'
-- config.color_scheme = 'Cupertino (base16)'
-- config.color_scheme = 'Elementary'
-- config.color_scheme = 'Elio (Gogh)'

-- Window
config.window_background_opacity = 0.7
config.window_decorations = "NONE"
config.window_close_confirmation = "AlwaysPrompt"
config.window_padding = { left = 7, right = 5, top = 5, bottom = 2 }

-- Dim inactive panes
config.inactive_pane_hsb = {
  saturation = 0.7,
  brightness = 0.3
}

-- Keys
-- config.leader = { key = "k", mods = "CTRL", timeout_milliseconds = 1000 }
config.leader = { key = "l", mods = "ALT", timeout_milliseconds = 1000 }
config.keys = {
  -- Send C-a when pressing C-a twice
  -- { key = "a",          mods = "LEADER|CTRL", action = act.SendKey { key = "a", mods = "CTRL" } },
  -- { key = "k",          mods = "LEADER|CTRL", action = act.SendKey { key = "k", mods = "CTRL" } },
  { key = "c",          mods = "LEADER", action = act.ActivateCopyMode },
  { key = "phys:Space", mods = "LEADER", action = act.ActivateCommandPalette },

  -- Pane keybindings
  -- {
  --   key = "u",
  --   mods = "LEADER",
  --   action =
  --       wezterm.action_callback(function(win, pane)
  --         -- local tab, window = pane:move_to_new_window()
  --         pane:move_to_new_window()
  --       end),
  -- },

  --
  { key = "u",          mods = "LEADER", action = act.PaneSelect { mode = "Activate" } },
  { key = "U",          mods = "LEADER", action = act.PaneSelect { mode = "SwapWithActive" } },
  { key = "s",          mods = "LEADER", action = act.SplitVertical { domain = "CurrentPaneDomain" } },
  { key = "v",          mods = "LEADER", action = act.SplitHorizontal { domain = "CurrentPaneDomain" } },
  { key = "h",          mods = "LEADER", action = act.ActivatePaneDirection("Left") },
  { key = "j",          mods = "LEADER", action = act.ActivatePaneDirection("Down") },
  { key = "k",          mods = "LEADER", action = act.ActivatePaneDirection("Up") },
  { key = "l",          mods = "LEADER", action = act.ActivatePaneDirection("Right") },
  { key = "q",          mods = "LEADER", action = act.CloseCurrentPane { confirm = true } },
  { key = "z",          mods = "LEADER", action = act.TogglePaneZoomState },
  { key = "o",          mods = "LEADER", action = act.RotatePanes "Clockwise" },
  -- We can make separate keybindings for resizing panes
  -- But Wezterm offers custom "mode" in the name of "KeyTable"
  { key = "r",          mods = "LEADER", action = act.ActivateKeyTable { name = "resize_pane", one_shot = false } },

  -- Tab keybindings
  -- { key = "[",          mods = "LEADER", action = act.ActivateTabRelative(-1) },
  -- { key = "]",          mods = "LEADER", action = act.ActivateTabRelative(1) },
  { key = "t",          mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
  { key = "n",          mods = "LEADER", action = act.ShowTabNavigator },
  {
    key = "e",
    mods = "LEADER",
    action = act.PromptInputLine {
      description = wezterm.format {
        { Attribute = { Intensity = "Bold" } },
        { Foreground = { AnsiColor = "Fuchsia" } },
        { Text = "Renaming Tab Title...:" },
      },
      action = wezterm.action_callback(function(window, pane, line)
        if line then
          window:active_tab():set_title(line)
        end
      end)
    }
  },
  -- Key table for moving tabs around
  -- { key = "{", mods = "LEADER|SHIFT", action = act.MoveTabRelative(-1) },
  -- { key = "}", mods = "LEADER|SHIFT", action = act.MoveTabRelative(1) },
  { key = "m", mods = "LEADER", action = act.ActivateKeyTable { name = "move_tab", one_shot = false } },

  -- Lastly, workspace
  { key = "w", mods = "LEADER", action = act.ShowLauncherArgs { flags = "FUZZY|WORKSPACES" } },

}
-- I can use the tab navigator (LDR t), but I also want to quickly navigate tabs with index
for i = 1, 9 do
  table.insert(config.keys, {
    key = tostring(i),
    mods = "LEADER",
    action = act.ActivateTab(i - 1)
  })
end

config.key_tables = {
  resize_pane = {
    { key = "h",      action = act.AdjustPaneSize { "Left", 1 } },
    { key = "j",      action = act.AdjustPaneSize { "Down", 1 } },
    { key = "k",      action = act.AdjustPaneSize { "Up", 1 } },
    { key = "l",      action = act.AdjustPaneSize { "Right", 1 } },
    { key = "Escape", action = "PopKeyTable" },
    { key = "Enter",  action = "PopKeyTable" },
  },
  move_tab = {
    { key = "h",      action = act.MoveTabRelative(-1) },
    { key = "j",      action = act.MoveTabRelative(-1) },
    { key = "k",      action = act.MoveTabRelative(1) },
    { key = "l",      action = act.MoveTabRelative(1) },
    { key = "Escape", action = "PopKeyTable" },
    { key = "Enter",  action = "PopKeyTable" },
  }
}

-- Tab bar
-- I don't like the look of "fancy" tab bar
config.show_new_tab_button_in_tab_bar = false
config.use_fancy_tab_bar = false
config.status_update_interval = 1000
config.tab_bar_at_bottom = false
config.colors = {
  tab_bar = {
    background = "#0b0022",
    active_tab = {
      bg_color = "#2b2042",
      fg_color = "#c0c0c0",
      intensity = "Bold",
      italic = false,
      strikethrough = false,
    },
    inactive_tab = {
      bg_color = "#1b1032",
      fg_color = "#808080",
      intensity = "Normal",
      underline = "None",
      italic = true,
      strikethrough = false,
    },
    inactive_tab_hover = {
      bg_color = "#1b1032",
      fg_color = "#808080",
      intensity = "Normal",
      underline = "None",
      italic = false,
      strikethrough = false,
    },
  }
}

wezterm.on("update-status", function(window, pane)
  -- set default stat
  local stat = wezterm.nerdfonts.oct_table
  local stat_color = color_2

  -- check if the pane is zoomed
  local is_zoomed = false
  local tab = pane:tab()
  if tab == nil then return end
  for _, p in ipairs(tab:panes_with_info()) do
    is_zoomed = p.is_zoomed
    if is_zoomed then break end
  end

  if window:active_key_table() then
    stat = wezterm.nerdfonts.md_folder
  elseif is_zoomed then
    stat = wezterm.nerdfonts.md_magnify
  end

  -- if window:active_key_table() then
  --   stat = wezterm.nerdfonts.md_folder
  --   stat_color = color_2
  -- end

  if window:leader_is_active() then
    stat = wezterm.nerdfonts.md_lead_pencil
    stat_color = color_2
  end

  -- Current Foreground Process Name
  -- @param s: String
  local cmd_basename = function(s)
    return string.gsub(s, "(.*[/\\])(.*)", "%2")
  end

  -- Current working directory
  -- @param s: Url
  local cwd_basename = function(s)
    return string.gsub(s.path, "(.*[/\\])(.*)", "%2")
  end

  -- Current command
  local cmd = pane:get_foreground_process_name()
  cmd = cmd and cmd_basename(cmd) or ""

  -- Current directory
  local cwd = pane:get_current_working_dir()
  cwd = cwd and cwd_basename(cwd) or ""

  -- Time
  local time = wezterm.strftime("%H:%M")

  -- Left status (left of the tab line)
  window:set_left_status(wezterm.format({
    { Foreground = { Color = stat_color } },
    { Text = " " },
    { Text = stat .. "  " },
    "ResetAttributes",
    { Foreground = { Color = color_1 } },
    { Text = window:active_workspace() },
    { Foreground = { Color = stat_color } },
    { Text = " |" }
  }))

  -- Right status
  window:set_right_status(wezterm.format({
    -- Wezterm has a built-in nerd fonts
    -- https://wezfurlong.org/wezterm/config/lua/wezterm/nerdfonts.html
    { Foreground = { Color = stat_color } },
    { Text = " | " },
    { Foreground = { Color = color_1 } },
    { Text = wezterm.nerdfonts.md_folder .. "  " .. cwd },
    { Text = " | " },
    -- { Foreground = { Color = "#e0af68" } },
    { Foreground = { Color = stat_color } },
    { Text = wezterm.nerdfonts.fa_code .. "  " },
    { Foreground = { Color = color_1 } },
    { Text = cmd },
    { Foreground = { Color = color_1 } },
    { Text = " | " },
    { Text = wezterm.nerdfonts.md_clock .. "  " .. time },
    { Text = "  " },
  }))
end)

return config
