
-- as per: https://yazi-rs.github.io/docs/tips
-- Smart enter: enter for directory, open for file

return {
	entry = function()
		local h = cx.active.current.hovered
		ya.manager_emit(h and h.cha.is_dir and "enter" or "open", { hovered = true })
	end,
}

