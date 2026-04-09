--!strict
-- Services
-- Packages
local Iris = require(script.Parent.Iris)
-- Modules
-- Types
export type State<V> = typeof(Iris.State((nil :: any) :: V))
type BaseWidget = {
	ID: any,
	type: string,
	lastCycleTick: number,
	parentWidget: BaseWidget,
	Instance: GuiObject,
	ZIndex: number,
	arguments: { [string]: any },
}
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

Module.Widget = {}

export type WindowWidget = BaseWidget & {
	opened: () -> boolean, -- once when opened.
	closed: () -> boolean, -- once when closed.
	collapsed: () -> boolean, -- once when collapsed.
	uncollapsed: () -> boolean, -- once when uncollapsed.
	hovered: () -> boolean, -- fires when the mouse hovers over any of the window.
}
Module.Widget.Window = function(
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
	fn: (widget: WindowWidget) -> ()
): WindowWidget
	local widget = Iris.Window(toParams(props.Arguments, props.States))
	fn(widget)
	Iris.End()
	return widget
end

export type TooltipWidget = BaseWidget & {}
Module.Widget.Tooltip = function(props: {
	Arguments: {
		Text: string,
	},
}): TooltipWidget
	return Iris.Tooltip(toParams(props.Arguments))
end

export type MenuBarWidget = BaseWidget & {
	clicked: () -> boolean,
	opened: () -> boolean, -- once when opened.
	closed: () -> boolean, -- once when closed.
	hovered: () -> boolean,
}
Module.Widget.MenuBar = function(props: {}, fn: (widget: MenuBarWidget) -> ()): MenuBarWidget
	local widget = Iris.MenuBar()
	fn(widget)
	Iris.End()
	return widget
end
export type MenuWidget = BaseWidget & {
	clicked: () -> boolean,
	opened: () -> boolean, -- once when opened.
	closed: () -> boolean, -- once when closed.
	hovered: () -> boolean,
}
Module.Widget.Menu = function(
	props: {
		Arguments: {
			Text: string,
		},
		States: {
			isOpened: State<boolean>?, -- whether the menu is open, including any sub-menus within.
		}?,
	},
	fn: (widget: MenuWidget) -> ()
): MenuWidget
	local widget = Iris.Menu(toParams(props.Arguments, props.States))
	fn(widget)
	Iris.End()
	return widget
end

export type MenuItemWidget = BaseWidget & {
	clicked: () -> boolean,
	hovered: () -> boolean,
}
Module.Widget.MenuItem = function(props: {
	Arguments: {
		Text: string,
		KeyCode: Enum.KeyCode?,
		ModifierKey: Enum.KeyCode?,
	},
}): MenuItemWidget
	return Iris.MenuItem(toParams(props.Arguments))
end

export type MenuToggleWidget = BaseWidget & {
	checked: () -> boolean, -- once on check.
	unchecked: () -> boolean, -- once on uncheck.
	hovered: () -> boolean,
}
Module.Widget.MenuToggle = function(props: {
	Arguments: {
		Text: string,
		KeyCode: Enum.KeyCode?,
		ModifierKey: Enum.KeyCode?,
	},
	States: {
		isChecked: State<boolean>?,
	}?,
}): MenuItemWidget
	return Iris.MenuToggle(toParams(props.Arguments))
end

export type SeparatorWidget = BaseWidget & {}
Module.Widget.Separator = function(props: {}): SeparatorWidget
	return Iris.Separator()
end

export type IndentWidget = BaseWidget & {}
Module.Widget.Indent = function(
	props: {
		Arguments: {
			Width: number?,
		}?,
	},
	fn: (widget: IndentWidget) -> ()
): IndentWidget
	local widget = Iris.Indent(toParams(props.Arguments))
	fn(widget)
	Iris.End()
	return widget
end

export type SameLineWidget = BaseWidget & {}
Module.Widget.SameLine = function(
	props: {
		Arguments: {
			Width: number?,
			VerticalAlignment: Enum.VerticalAlignment?,
			HorizontalAlignment: Enum.HorizontalAlignment?,
		}?,
	},
	fn: (widget: SameLineWidget) -> ()
): SameLineWidget
	local widget = Iris.SameLine(toParams(props.Arguments))
	fn(widget)
	Iris.End()
	return widget
end

export type GroupWidget = BaseWidget & {}
Module.Widget.Group = function(props: {}, fn: (widget: GroupWidget) -> ()): GroupWidget
	local widget = Iris.Group()
	fn(widget)
	Iris.End()
	return widget
end

export type InputTextWidget = BaseWidget & {
	textChanged: () -> boolean, -- whenever the textbox looses focus and a change was made.
	hovered: () -> boolean,
}
Module.Widget.InputText = function(
	props: {
		Arguments: {
			Text: string?,
			TextHint: string?, -- a hint to display when the text box is empty.
			ReadOnly: boolean?,
			MultiLine: boolean?,
		}?,
		States: {
			text: State<string>?,
		}?,
	}
): InputTextWidget
	return Iris.InputTextWidget(toParams(props.Arguments, props.States))
end

export type SeparatorTextWidget = BaseWidget & {}
Module.Widget.SeparatorText = function(props: {
	Arguments: {
		Text: string,
	},
}): SeparatorTextWidget
	return Iris.InputTextWidget(toParams(props.Arguments))
end

export type Text = BaseWidget & {
	hovered: () -> boolean,
}
Module.Widget.Text = function(
	props: {
		Arguments: {
			Text: string,
			Wrapped: boolean?, -- whether the text will wrap around inside the parent container. If not specified, then equal to the config
			Color: Color3?, -- the color of the text.
			RichText: boolean?, -- enable RichText. If not specified, then equal to the config
		},
	}
): SeparatorTextWidget
	return Iris.InputTextWidget(toParams(props.Arguments))
end

return Module
