hs.application.enableSpotlightForNameSearches(true)
local term_app = "alacritty"
local browser = "chrome"
local slack = "slack"
local music = "music"

local toggle_app = function(app_name, modifier, keys)
    hs.hotkey.bind(modifier, keys, function()
      local app = hs.application.find(app_name)
      if app then
          local is_frontmost = app:isFrontmost()
          if is_frontmost then
            app:hide()
          else
              app:activate()
          end
      else
          hs.application.launchOrFocus(app_name)
      end
    end)
end

toggle_app(term_app, {"ctrl"}, "\\")
toggle_app(browser, {"ctrl"}, "`")
toggle_app(slack, {"ctrl"}, "/")
toggle_app(music, {"ctrl"}, ".")

hs.hotkey.bind({"ctrl", "alt"}, "Right", function()
  local app = hs.application.frontmostApplication()
  local win = app:focusedWindow()
  win:moveOneScreenEast()
end)

hs.hotkey.bind({"ctrl", "alt"}, "Left", function()
  local app = hs.application.frontmostApplication()
  local win = app:focusedWindow()
  win:moveOneScreenWest()
end)

hs.hotkey.bind({"ctrl", "alt"}, "Return", function()
  hs.window.focusedWindow():maximize()
end)
