-----------
-- utils --
-----------

local wezterm = require 'wezterm'

local utils = {}

-- merge tablesr recursively
function utils.merge_tables(t1, t2)
    local result = {}
    for k, v in pairs(t1) do
        if type(v) == "table" and type(t2[k]) == "table" then
            result[k] = utils.merge_tables(v, t2[k])
        else
            result[k] = v
        end
    end
    for k, v in pairs(t2) do
        if result[k] == nil then
            result[k] = v
        end
    end
    return result
end

function utils.merge_seq_of_tables(t1, t2)
    local merged = {}
    for i, v in ipairs(t1) do
        merged[i] = v
    end
    for i, v in ipairs(t2) do
        merged[#t1 + i] = v
    end
    return merged
end

function utils.is_windows()
    return wezterm.target_triple:find("windows") ~= nil
end

return utils
