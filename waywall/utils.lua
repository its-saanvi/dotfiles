local waywall = require("waywall")

local M = {}

--- @param options ImageOpts
--- @return fun(enable: boolean): nil
M.make_image = function(options)
	local this = nil

	return function(enable)
		if enable and not this then
			this = waywall.image(options.src, { dst = options.dst })
		elseif this and not enable then
			this:close()
			this = nil
		end
	end
end

--- @param options MirrorOpts
--- @return fun(enable: boolean): nil
M.make_mirror = function(options)
	local this = nil

	return function(enable)
		if enable and not this then
			this = waywall.mirror(options)
		elseif this and not enable then
			this:close()
			this = nil
		end
	end
end

--- @param width number
--- @param height number
--- @param callbacks ResolutionCallbacks
--- @return fun(): nil
M.make_res = function(width, height, callbacks)
	return function()
		local active_width, active_height = waywall.active_res()

		if active_width == width and active_height == height then
			if callbacks.disable_pre then
				callbacks.disable_pre()
			end
			waywall.set_resolution(0, 0)
			if callbacks.disable_post then
				callbacks.disable_post()
			end
		else
			if callbacks.enable_pre then
				callbacks.enable_pre()
			end
			waywall.set_resolution(width, height)
			if callbacks.enable_post then
				callbacks.enable_post()
			end
		end
	end
end

--- @param custom CustomOpts
--- @param eye boolean
--- @param f3 boolean
--- @param tall boolean
--- @param thin boolean
M.show_mirrors = function(custom, eye, f3, tall, thin)
	custom.images.overlay(eye)
	custom.mirrors.eye_measure(eye)

	custom.mirrors.f3_ecount(f3)

	custom.mirrors.thin_pie_blockentities(thin)
	custom.mirrors.thin_pie_blockentities_percent(thin)
	custom.mirrors.thin_pie_entities(thin)
	custom.mirrors.thin_pie_unspecified(thin)
	custom.mirrors.thin_pie_destroyProgress(thin)
	custom.mirrors.tall_pie_blockentities(tall)
	custom.mirrors.tall_pie_blockentities_percent(tall)
	custom.mirrors.tall_pie_entities(tall)
	custom.mirrors.tall_pie_unspecified(tall)
	custom.mirrors.tall_pie_destroyProgress(tall)
end

--- @return boolean?
M.is_ninb_running = function()
	return os.execute("pgrep -f 'NinjaBrain'")
end

--- @param func fun(custom: CustomOpts, state: State)
--- @param custom CustomOpts
--- @param state State
--- @return fun(): nil
M.wrap_function_with_custom_and_state = function(func, custom, state)
	if func == nil then
		return function() end
	end
	return function()
		func(custom, state)
	end
end

--- @param func fun(custom: CustomOpts)
--- @param custom CustomOpts
--- @return fun(): nil
M.wrap_function_with_custom = function(func, custom)
	if func == nil then
		return function() end
	end
	return function()
		func(custom)
	end
end

return M
