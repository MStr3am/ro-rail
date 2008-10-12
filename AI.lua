-- Before anything else, remove potentially harmful functions
if os then
	os.remove = nil
	os.rename = nil
end

-- Create a RAIL object (to be populated later)
if not RAIL then
	RAIL = {}
end

-- Now auto-detect where RAIL is located
do
	local req = require

	FileExists = function(filename)
		-- Try to open the file
		local file = io.open(filename)
		if file then
			file:close()
			return true
		end
		return false
	end

	local ScriptLocation

	-- Check the current directory for the main RAIL logic script
	if FileExists("./MainRAIL.lua") then
		ScriptLocation = "./"

	-- Check the AI sub directory
	elseif FileExists("./AI/MainRAIL.lua") then
		ScriptLocation = "./AI/"

	-- Check the USER_AI directory
	elseif FileExists("./AI/USER_AI/MainRAIL.lua") then
		ScriptLocation = "./AI/USER_AI/"

	-- If all else failed, make sure the RO client doesn't crash
	else
		TraceAI("RAIL failed to locate script directory.")
		RAIL.NoScripts = true
		AI = function() end
	end

	require = function(filename)
		if FileExists(filename) then
			return req(filename)
		end

		return req(ScriptLocation .. filename)
	end
end

-- Only continue if autodetection worked
if not RAIL.NoScripts then
	-- The only difference between AI_M.lua and AI.lua is this following line
	RAIL.Mercenary = false
	require "MainRAIL.lua"
end