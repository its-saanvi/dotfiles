--- @class State
--- @field tall_after_thin boolean
local State = {}

--- @class CustomOpts
--- @field input Input
--- @field mirrors Mirrors
--- @field startup_mirrors StartupMirrors
--- @field images Images
--- @field resolutions Resolutions
--- @field theme table<string, any>
--- @field experimental table<string, any>
--- @field ninb_path string
--- @field tmpfs_clear_path string
--- @field shaders Shaders
local CustomOpts = {}

--- @class Input
--- @field sensitivity Sensitivity
--- @field remaps table<string, string>
--- @field layout Layout
--- @field confine_pointer boolean
--- @field repeat_delay number
--- @field repeat_rate number
local Input = {}

--- @class Layout
--- @field primary string
--- @field secondary string
local Layout = {}

--- @class Sensitivity
--- @field normal number
--- @field tall number
local Sensitivity = {}

--- @class Mirrors
--- @field eye_measure fun(enable: boolean): nil
--- @field f3_ecount fun(enable: boolean): nil
--- @field thin_pie_blockentities fun(enable: boolean): nil
--- @field thin_pie_blockentities_percent fun(enable: boolean): nil
--- @field thin_pie_entities fun(enable: boolean): nil
--- @field thin_pie_unspecified fun(enable: boolean): nil
--- @field thin_pie_destroyProgress fun(enable: boolean): nil
--- @field tall_pie_blockentities fun(enable: boolean): nil
--- @field tall_pie_blockentities_percent fun(enable: boolean): nil
--- @field tall_pie_entities fun(enable: boolean): nil
--- @field tall_pie_unspecified fun(enable: boolean): nil
--- @field tall_pie_destroyProgress fun(enable: boolean): nil
--- @field fire_res_mirror fun(enable: boolean): nil
local Mirrors = {}

--- @class Shaders
local Shaders = {}

--- @class ShaderOpts
--- @field vertex string?
--- @field fragment string?
local ShaderOpts = {}

--- @class StartupMirrors
local StartupMirrors = {}

--- @class Images
--- @field overlay fun(enable: boolean): nil
local Images = {}

--- @class Resolutions
--- @field thin ResolutionOpts
--- @field tall ResolutionOpts
--- @field wide ResolutionOpts
local Resolutions = {}

--- @class ResolutionOpts
--- @field w number
--- @field h number
--- @field enable_pre fun() | nil
--- @field enable_post fun() | nil
--- @field disable_pre fun() | nil
--- @field disable_post fun() | nil
local ResolutionOpts = {}

--- @class ResolutionCallbacks
--- @field enable_pre fun() | nil
--- @field enable_post fun() | nil
--- @field disable_pre fun() | nil
--- @field disable_post fun() | nil
local ResolutionCallbacks = {}

--- @class ImageOpts
--- @field src string
--- @field dst table<string, any>
local ImageOpts = {}

--- @class MirrorOpts
--- @field src table<string, any>
--- @field dst table<string, any>
--- @field color_key table<string, any> | nil
--- @field shader string | nil
local MirrorOpts = {}
