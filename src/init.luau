--!strict
-- Services
-- Packages
local Iris = require(script.Parent.Iris)
-- Modules
-- Types
export type State<V> = typeof(Iris.State((nil :: any) :: V))
-- Constants
-- Variables
-- References
-- Private Functions
function toParams(args: { [string]: any? }?, states: { [string]: State<any>? }?): ({ any }, { [any]: any }?)
	local outArgs: { [any]: any } = {}
	if args then
		for k, symbol in Iris.Args.Window do
			outArgs[symbol] = outArgs[k]
		end
	end
	local stateCount = 0
	local outStates: { [any]: any } = {}
	if states then
		for k, state in states do
			outStates[k] = state
			stateCount += 1
		end
	end
	return outArgs, if stateCount > 0 then outStates else nil
end
-- Class
local Module = {}

type WindowHandle = {
	opened: () -> boolean, -- once when opened.
	closed: () -> boolean, -- once when closed.
	collapsed: () -> boolean, -- once when collapsed.
	uncollapsed: () -> boolean, -- once when uncollapsed.
	hovered: () -> boolean, -- fires when the mouse hovers over any of the window.
}
Module.Window = function(
	props: {
		Arguments: {
			Title: string,
			NoTitleBar: boolean?,
			NoBackground: boolean?, -- the background behind the widget container.
			NoCollapse: boolean?,
			NoClose: boolean?,
			NoMove: boolean?,
			NoScrollbar: boolean?, -- the scrollbar if the window is too short for all widgets.
			NoResize: boolean?,
			-- NoNav: boolean?, -- unimplemented.
			NoMenu: boolean?, -- whether the menubar will show if created.
		},
		States: {
			size: State<Vector2>?,
			position: State<Vector2>?,
			isUncollapsed: State<boolean>?,
			isOpened: State<boolean>?,
			scrollDistance: State<number>?, -- vertical scroll distance, if too short.
		}?,
	},
	fn: (component: WindowHandle) -> ()
): WindowHandle
	local handle = Iris.Window(toParams(props.Arguments, props.States))
	fn(handle)
	Iris.End()
	return handle
end

type TooltipHandle = {}
Module.Tooltip = function(props: {
	Arguments: {
		Text: string,
	},
}): TooltipHandle
	return Iris.Tooltip(toParams(props.Arguments))
end

type MenuBarHandle = {
	clicked: () -> boolean,
	opened: () -> boolean, -- once when opened.
	closed: () -> boolean, -- once when closed.
	hovered: () -> boolean,
}
Module.MenuBar = function(
	props: {
		Arguments: {
			Text: string,
		},
		States: {
			isOpened: State<boolean>?, -- whether the menu is open, including any sub-menus within.
		}?,
	},
	fn: (component: MenuBarHandle) -> ()
): WindowHandle
	local handle = Iris.MenuBar(toParams(props.Arguments, props.States))
	fn(handle)
	Iris.End()
	return handle
end

return Module
