-- keywords for HammerText expansion
local keywords = {
    ["xdt"] = function() return os.date("%Y-%m-%d") end,
    ["xts"] = function() return os.date("%Y-%m-%dT%H:%M:%S") end,
    ["xtid"] = function() return os.date("%Y%m%d%H%M%S") end,
    ["xutc"] = function() return os.date("!%Y-%m-%dT%H:%M:%S") end,
    ["jdh"] = function() return '# ' .. os.date("%Y-%m-%d") end,
    ["jth"] = function() return '## ' .. os.date("%H:%M") end,
    ["hh1"] = "#",
    ["hh2"] = "##",
    ["hh3"] = "###",
    ["hh4"] = "####",
    ["hh5"] = '#####'
}
return keywords
