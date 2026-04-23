-- keywords for HammerText expansion
local keywords = {
    ["xdt"] = function() return os.date("%Y-%m-%d") end,
    ["xdts"] = function() return os.date("%Y-%m-%dT%H:%M:%S") end,
    ["xutc"] = function() return os.date("!%Y-%m-%dT%H:%M:%S") end,
    ["jdh"] = function() return '# ' .. os.date("%Y-%m-%d") end,
    ["jth"] = function() return '## ' .. os.date("%H:%M") end,
    ["hh3"] = "###"
}
return keywords
