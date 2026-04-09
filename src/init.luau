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
export type WindowWidgetProperties = {
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
}
Module.Widget.Window = function(props: WindowWidgetProperties, fn: (widget: WindowWidget) -> ()): WindowWidget
	local widget = Iris.Window(toParams(props.Arguments, props.States))
	fn(widget)
	Iris.End()
	return widget
end

export type TooltipWidget = BaseWidget & {}
export type TooltipWidgetProperties = {
	Arguments: {
		Text: string,
	},
}
Module.Widget.Tooltip = function(props: TooltipWidgetProperties): TooltipWidget
	return Iris.Tooltip(toParams(props.Arguments))
end

export type MenuBarWidget = BaseWidget & {
	clicked: () -> boolean,
	opened: () -> boolean, -- once when opened.
	closed: () -> boolean, -- once when closed.
	hovered: () -> boolean,
}
export type MenuBarProperties = {}
Module.Widget.MenuBar = function(props: MenuBarProperties, fn: (widget: MenuBarWidget) -> ()): MenuBarWidget
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
export type MenuWidgetProperties = {
	Arguments: {
		Text: string,
	},
	States: {
		isOpened: State<boolean>?, -- whether the menu is open, including any sub-menus within.
	}?,
}
Module.Widget.Menu = function(props: MenuWidgetProperties, fn: (widget: MenuWidget) -> ()): MenuWidget
	local widget = Iris.Menu(toParams(props.Arguments, props.States))
	fn(widget)
	Iris.End()
	return widget
end

export type MenuItemWidget = BaseWidget & {
	clicked: () -> boolean,
	hovered: () -> boolean,
}
export type MenuItemWidgetProperties = {
	Arguments: {
		Text: string,
		KeyCode: Enum.KeyCode?,
		ModifierKey: Enum.KeyCode?,
	},
}
Module.Widget.MenuItem = function(props: MenuItemWidgetProperties): MenuItemWidget
	return Iris.MenuItem(toParams(props.Arguments))
end

export type MenuToggleWidget = BaseWidget & {
	checked: () -> boolean, -- once on check.
	unchecked: () -> boolean, -- once on uncheck.
	hovered: () -> boolean,
}
export type MenuToggleWidgetProperties = {
	Arguments: {
		Text: string,
		KeyCode: Enum.KeyCode?,
		ModifierKey: Enum.KeyCode?,
	},
	States: {
		isChecked: State<boolean>?,
	}?,
}
Module.Widget.MenuToggle = function(props: MenuToggleWidgetProperties): MenuItemWidget
	return Iris.MenuToggle(toParams(props.Arguments))
end

export type SeparatorWidget = BaseWidget & {}
export type SeparatorWidgetProperties = {}
Module.Widget.Separator = function(props: SeparatorTextWidgetProperties): SeparatorWidget
	return Iris.Separator()
end

export type IndentWidget = BaseWidget & {}
export type IndentWidgetProperties = {
	Arguments: {
		Width: number?,
	}?,
}
Module.Widget.Indent = function(props: IndentWidgetProperties, fn: (widget: IndentWidget) -> ()): IndentWidget
	local widget = Iris.Indent(toParams(props.Arguments))
	fn(widget)
	Iris.End()
	return widget
end

export type SameLineWidget = BaseWidget & {}
export type SameLineWidgetProperties = {
	Arguments: {
		Width: number?,
		VerticalAlignment: Enum.VerticalAlignment?,
		HorizontalAlignment: Enum.HorizontalAlignment?,
	}?,
}
Module.Widget.SameLine = function(props: SameLineWidgetProperties, fn: (widget: SameLineWidget) -> ()): SameLineWidget
	local widget = Iris.SameLine(toParams(props.Arguments))
	fn(widget)
	Iris.End()
	return widget
end

export type GroupWidget = BaseWidget & {}
export type GroupWidgetProperties = {}
Module.Widget.Group = function(props: GroupWidgetProperties, fn: (widget: GroupWidget) -> ()): GroupWidget
	local widget = Iris.Group()
	fn(widget)
	Iris.End()
	return widget
end

export type InputTextWidget = BaseWidget & {
	textChanged: () -> boolean, -- whenever the textbox looses focus and a change was made.
	hovered: () -> boolean,
}
export type InputTextWidgetProperties = {
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
Module.Widget.InputText = function(props: InputTextWidgetProperties): InputTextWidget
	return Iris.InputText(toParams(props.Arguments, props.States))
end

export type SeparatorTextWidget = BaseWidget & {}
export type SeparatorTextWidgetProperties = {
	Arguments: {
		Text: string,
	},
}
Module.Widget.SeparatorText = function(props: SeparatorTextWidgetProperties): SeparatorTextWidget
	return Iris.SeparatorText(toParams(props.Arguments))
end

export type TextWidget = BaseWidget & {
	hovered: () -> boolean,
}
export type TextWidgetProperties = {
	Arguments: {
		Text: string,
		Wrapped: boolean?, -- whether the text will wrap around inside the parent container. If not specified, then equal to the config
		Color: Color3?, -- the color of the text.
		RichText: boolean?, -- enable RichText. If not specified, then equal to the config
	},
}
Module.Widget.Text = function(props: TextWidgetProperties): TextWidget
	return Iris.Text(toParams(props.Arguments))
end

export type ButtonWidget = BaseWidget & {
	clicked: () -> boolean,
	rightClicked: () -> boolean,
	doubleClicked: () -> boolean,
	ctrlClicked: () -> boolean, -- when the control key is down and clicked.
	hovered: () -> boolean,
}
export type ButtonWidgetProperties = {
	Arguments: {
		Text: string,
		Size: UDim2?,
	},
}
Module.Widget.Button = function(props: ButtonWidgetProperties): ButtonWidget
	return Iris.Button(toParams(props.Arguments))
end

export type SmallButtonWidget = ButtonWidget
export type SmallButtonWidgetProperties = ButtonWidgetProperties

Module.Widget.SmallButton = function(props: SmallButtonWidgetProperties): SmallButtonWidget
	return Iris.SmallButton(toParams(props.Arguments))
end

export type CheckboxWidget = BaseWidget & {
	checked: () -> boolean, -- once when checked.
	unchecked: () -> boolean, -- once when unchecked.
	hovered: () -> boolean,
}
export type CheckboxWidgetProperties = {
	Arguments: {
		Text: string,
	},
	State: {
		isChecked: State<boolean>?,
	}?,
}
Module.Widget.Checkbox = function(props: CheckboxWidgetProperties): CheckboxWidget
	return Iris.Checkbox(toParams(props.Arguments, props.State))
end

export type RadioButtonWidget<V> = BaseWidget & {
	selected: () -> boolean,
	unselected: () -> boolean,
	active: () -> boolean, -- if the state index equals the RadioButton's index.
	hovered: () -> boolean,
}
export type RadioButtonProperties<V> = {
	Arguments: {
		Text: string,
		Index: V,
	},
	State: {
		index: State<V>?,
	}?,
}
Module.Widget.RadioButton = function<V>(props: RadioButtonProperties<V>): RadioButtonWidget<V>
	return Iris.RadioButton(toParams(props.Arguments, props.State))
end

export type TreeWidget = BaseWidget & {
	collapsed: () -> boolean,
	uncollapsed: () -> boolean,
	hovered: () -> boolean,
}
export type TreeProperties = {
	Arguments: {
		Text: string,
		SpanAvailWidth: boolean?, -- the tree title will fill all horizontal space to the end its parent container.
		NoIndent: boolean?, -- the child widgets will not be indented underneath.
		DefaultOpen: boolean?, -- initially opens the tree if no state is provided
	},
	States: {
		isUncollapsed: State<boolean>?, -- whether the widget is collapsed.
	}?,
}
Module.Widget.Tree = function(props: TreeProperties, fn: (widget: TreeWidget) -> ()): TreeWidget
	local widget = Iris.Tree(toParams(props.Arguments, props.States))
	fn(widget)
	Iris.End()
	return widget
end

export type CollapsingHeaderWidget = BaseWidget & {
	collapsed: () -> boolean,
	uncollapsed: () -> boolean,
	hovered: () -> boolean,
}
export type CollapsingHeaderProperties = {
	Arguments: {
		Text: string,
		DefaultOpen: boolean?, -- initially opens the tree if no state is provided
	},
	States: {
		isUncollapsed: State<boolean>?, -- whether the widget is collapsed.
	}?,
}
Module.Widget.CollapsingHeader = function(
	props: CollapsingHeaderProperties,
	fn: (widget: CollapsingHeaderWidget) -> ()
): CollapsingHeaderWidget
	local widget = Iris.CollapsingHeader(toParams(props.Arguments, props.States))
	fn(widget)
	Iris.End()
	return widget
end

export type TabBarWidget = BaseWidget & {
	clicked: () -> boolean,
	hovered: () -> boolean,
	selected: () -> boolean,
	unselected: () -> boolean,
	active: () -> boolean,
	opened: () -> boolean,
	closed: () -> boolean,
}
export type TabBarWidgetProperties = {
	States: {
		index: State<number>?, -- whether the widget is collapsed.
	}?,
}
Module.Widget.TabBar = function(props: TabBarWidgetProperties, fn: (widget: TabBarWidget) -> ()): TabBarWidget
	local widget = Iris.TabBar(toParams(nil, props.States))
	fn(widget)
	Iris.End()
	return widget
end

export type TabWidget = BaseWidget & {
	clicked: () -> boolean,
	hovered: () -> boolean,
	selected: () -> boolean,
	unselected: () -> boolean,
	active: () -> boolean,
	opened: () -> boolean,
	closed: () -> boolean,
}
export type TabWidgetProperties = {
	Arguments: {
		Text: string,
		Hideable: boolean?, -- determines whether a tab can be closed/hidden
	},
	States: {
		isOpened: State<boolean>?, -- whether the widget is collapsed.
	}?,
}
Module.Widget.Tab = function(props: TabWidgetProperties): TabWidget
	return Iris.Tab(toParams(props.Arguments, props.States))
end
return Module
