hs.application.enableSpotlightForNameSearches(true)
local term_app = "kitty"
local browser = "chrome"
local obsidian = "obsidian"

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
toggle_app(obsidian, {"ctrl"}, "o")
