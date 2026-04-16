--!strict
-- Services
-- Packages
local Iris = require(script.Parent.Iris)
-- Modules
-- Types
export type State<V> = typeof(Iris.State((nil :: any) :: V))
type BaseWidget = {
	ID: string,
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
function toParams(
	key: string,
	args: { [string]: any? }?,
	states: { [string]: State<any>? }?
): ({ any }, { [any]: any }?)
	local outArgs: { [any]: any } = {}
	if args then
		assert(Iris.Args[key], `bad args for "{key}"`)
		for k, symbol in Iris.Args[key] do
			outArgs[symbol] = args[k]
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

Module.Disabled = Iris.Disabled
Module.TemplateConfig = Iris.TemplateConfig

function Module:Connect(callback: () -> ()): () -> ()
	return Iris:Connect(callback)
end

Module.Append = Iris.Append
Module.ComputedState = Iris.ComputedState
Module.ForceRefresh = Iris.ForceRefresh
Module.Init = Iris.Init
Module.PopConfig = Iris.PopConfig
Module.PopId = Iris.PopId
Module.PushConfig = Iris.PushConfig
Module.PushId = Iris.PushId
Module.SetFocusedWindow = Iris.SetFocusedWindow
Module.SetNextWidgetID = Iris.SetNextWidgetID
Module.ShowDemoWindow = Iris.ShowDemoWindow
Module.Shutdown = Iris.Shutdown
Module.State = Iris.State
Module.TableState = Iris.TableState
Module.UpdateGlobalConfig = Iris.UpdateGlobalConfig
Module.VariableState = Iris.VariableState
Module.WeakState = Iris.WeakState

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
		[any]: never,
	},
	States: {
		size: State<Vector2>?,
		position: State<Vector2>?,
		isUncollapsed: State<boolean>?,
		isOpened: State<boolean>?,
		scrollDistance: State<number>?, -- vertical scroll distance, if too short.
		[any]: never,
	}?,
	[any]: never,
}
Module.Widget.Window = function(props: WindowWidgetProperties, fn: (widget: WindowWidget) -> ()): WindowWidget
	local widget = Iris.Window(toParams("Window", props.Arguments, props.States))
	fn(widget)
	Iris.End()
	return widget
end

export type TooltipWidget = BaseWidget & {}
export type TooltipWidgetProperties = {
	Arguments: {
		Text: string,
		[any]: never,
	},
	[any]: never,
}
Module.Widget.Tooltip = function(props: TooltipWidgetProperties): TooltipWidget
	return Iris.Tooltip(toParams("Tooltip", props.Arguments))
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
		[any]: never,
	},
	States: {
		isOpened: State<boolean>?, -- whether the menu is open, including any sub-menus within.
		[any]: never,
	}?,
	[any]: never,
}
Module.Widget.Menu = function(props: MenuWidgetProperties, fn: (widget: MenuWidget) -> ()): MenuWidget
	local widget = Iris.Menu(toParams("Menu", props.Arguments, props.States))
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
		[any]: never,
	},
	[any]: never,
}
Module.Widget.MenuItem = function(props: MenuItemWidgetProperties): MenuItemWidget
	return Iris.MenuItem(toParams("MenuItem", props.Arguments))
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
		[any]: never,
	},
	States: {
		isChecked: State<boolean>?,
		[any]: never,
	}?,
	[any]: never,
}
Module.Widget.MenuToggle = function(props: MenuToggleWidgetProperties): MenuToggleWidget
	return Iris.MenuToggle(toParams("MenuToggle", props.Arguments, props.States))
end

export type SeparatorWidget = BaseWidget & {}
export type SeparatorWidgetProperties = {}
Module.Widget.Separator = function(props: SeparatorWidgetProperties): SeparatorWidget
	return Iris.Separator()
end

export type IndentWidget = BaseWidget & {}
export type IndentWidgetProperties = {
	Arguments: {
		Width: number?,
	}?,
}
Module.Widget.Indent = function(props: IndentWidgetProperties, fn: (widget: IndentWidget) -> ()): IndentWidget
	local widget = Iris.Indent(toParams("Indent", props.Arguments))
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
		[any]: never,
	}?,
	[any]: never,
}
Module.Widget.SameLine = function(props: SameLineWidgetProperties, fn: (widget: SameLineWidget) -> ()): SameLineWidget
	local widget = Iris.SameLine(toParams("SameLine", props.Arguments))
	fn(widget)
	Iris.End()
	return widget
end

export type GroupWidget = BaseWidget & {}
export type GroupWidgetProperties = {
	[any]: never,
}
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
		[any]: never,
	}?,
	States: {
		text: State<string>?,
		[any]: never,
	}?,
	[any]: never,
}
Module.Widget.InputText = function(props: InputTextWidgetProperties): InputTextWidget
	return Iris.InputText(toParams("InputText", props.Arguments, props.States))
end

export type SeparatorTextWidget = BaseWidget & {}
export type SeparatorTextWidgetProperties = {
	Arguments: {
		Text: string,
		[any]: never,
	},
	[any]: never,
}
Module.Widget.SeparatorText = function(props: SeparatorTextWidgetProperties): SeparatorTextWidget
	return Iris.SeparatorText(toParams("SeparatorText", props.Arguments))
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
		[any]: never,
	},
	[any]: never,
}
Module.Widget.Text = function(props: TextWidgetProperties): TextWidget
	return Iris.Text(toParams("Text", props.Arguments))
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
		[any]: never,
	},
	[any]: never,
}
Module.Widget.Button = function(props: ButtonWidgetProperties): ButtonWidget
	return Iris.Button(toParams("Button", props.Arguments))
end

export type SmallButtonWidget = ButtonWidget
export type SmallButtonWidgetProperties = ButtonWidgetProperties

Module.Widget.SmallButton = function(props: SmallButtonWidgetProperties): SmallButtonWidget
	return Iris.SmallButton(toParams("SmallButton", props.Arguments))
end

export type CheckboxWidget = BaseWidget & {
	checked: () -> boolean, -- once when checked.
	unchecked: () -> boolean, -- once when unchecked.
	hovered: () -> boolean,
}
export type CheckboxWidgetProperties = {
	Arguments: {
		Text: string,
		[any]: never,
	},
	States: {
		isChecked: State<boolean>?,
		[any]: never,
	}?,
	[any]: never,
}
Module.Widget.Checkbox = function(props: CheckboxWidgetProperties): CheckboxWidget
	return Iris.Checkbox(toParams("Checkbox", props.Arguments, props.States))
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
		[any]: never,
	},
	States: {
		index: State<V>?,
		[any]: never,
	}?,
	[any]: never,
}
Module.Widget.RadioButton = function<V>(props: RadioButtonProperties<V>): RadioButtonWidget<V>
	return Iris.RadioButton(toParams("RadioButton", props.Arguments, props.States))
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
		[any]: never,
	},
	States: {
		isUncollapsed: State<boolean>?, -- whether the widget is collapsed.
		[any]: never,
	}?,
	[any]: never,
}
Module.Widget.Tree = function(props: TreeProperties, fn: (widget: TreeWidget) -> ()): TreeWidget
	local widget = Iris.Tree(toParams("Tree", props.Arguments, props.States))
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
		[any]: never,
	},
	States: {
		isUncollapsed: State<boolean>?, -- whether the widget is collapsed.
		[any]: never,
	}?,
	[any]: never,
}
Module.Widget.CollapsingHeader = function(
	props: CollapsingHeaderProperties,
	fn: (widget: CollapsingHeaderWidget) -> ()
): CollapsingHeaderWidget
	local widget = Iris.CollapsingHeader(toParams("CollapsingHeader", props.Arguments, props.States))
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
		[any]: never,
	}?,
	[any]: never,
}
Module.Widget.TabBar = function(props: TabBarWidgetProperties, fn: (widget: TabBarWidget) -> ()): TabBarWidget
	local widget = Iris.TabBar(toParams("TabBar", nil, props.States))
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
		[any]: never,
	},
	States: {
		isOpened: State<boolean>?, -- whether the widget is collapsed.
		[any]: never,
	}?,
	[any]: never,
}
Module.Widget.Tab = function(props: TabWidgetProperties): TabWidget
	return Iris.Tab(toParams("Tab", props.Arguments, props.States))
end

export type ImageWidget = BaseWidget & {
	hovered: () -> boolean,
}
export type ImageWidgetProperties = {
	Arguments: {
		Image: string, -- the texture asset id
		Size: UDim2,
		Rect: Rect?, -- Rect structure which is used to determine the offset or size. An empty, zeroed rect is equivalent to nil
		ScaleType: Enum.ScaleType?, -- used to determine whether the TileSize, SliceCenter and SliceScale arguments are used
		ResampleMode: Enum.ResamplerMode?,
		TileSize: UDim2?, -- only used if the ScaleType is set to Tile
		SliceCenter: Rect?, -- only used if the ScaleType is set to Slice
		SliceScale: number?, -- only used if the ScaleType is set to Slice
		[any]: never,
	},
	[any]: never,
}
Module.Widget.Image = function(props: ImageWidgetProperties): ImageWidget
	return Iris.Image(toParams("Image", props.Arguments))
end

export type ImageButtonWidget = BaseWidget & {
	clicked: () -> boolean,
	rightClicked: () -> boolean,
	doubleClicked: () -> boolean,
	ctrlClicked: () -> boolean, -- when the control key is down and clicked.
	hovered: () -> boolean,
}
export type ImageButtonWidgetProperties = {
	Arguments: {
		Image: string, -- the texture asset id
		Size: UDim2,
		Rect: Rect?, -- Rect structure which is used to determine the offset or size. An empty, zeroed rect is equivalent to nil
		ScaleType: Enum.ScaleType?, -- used to determine whether the TileSize, SliceCenter and SliceScale arguments are used
		ResampleMode: Enum.ResamplerMode?,
		TileSize: UDim2?, -- only used if the ScaleType is set to Tile
		SliceCenter: Rect?, -- only used if the ScaleType is set to Slice
		SliceScale: number?, -- only used if the ScaleType is set to Slice
		[any]: never,
	},
	[any]: never,
}
Module.Widget.ImageButton = function(props: ImageButtonWidgetProperties): ImageButtonWidget
	return Iris.ImageButton(toParams("ImageButton", props.Arguments))
end

export type InputNumWidget = BaseWidget & {
	numberChanged: () -> boolean,
	hovered: () -> boolean,
}
export type InputNumWidgetProperties = {
	Arguments: {
		Text: string?,
		Increment: number?,
		Min: number?,
		Max: number?,
		Format: string? | { string }?, -- Iris will dynamically generate an approriate format.
		NoButtons: boolean?, -- whether to display + and - buttons next to the input box.
		[any]: never,
	}?,
	States: {
		number: State<number>?,
		editingText: State<boolean>?,
		[any]: never,
	}?,
	[any]: never,
}
Module.Widget.InputNum = function(props: InputNumWidgetProperties): InputNumWidget
	return Iris.InputNum(toParams("InputNum", props.Arguments, props.States))
end

export type InputVector2Widget = BaseWidget & {
	numberChanged: () -> boolean,
	hovered: () -> boolean,
}
export type InputVector2WidgetProperties = {
	Arguments: {
		Text: string?,
		Increment: Vector2?,
		Min: Vector2?,
		Max: Vector2?,
		Format: string? | { string }?, -- Iris will dynamically generate an approriate format.
		[any]: never,
	}?,
	States: {
		number: State<Vector2>?,
		editingText: State<boolean>?,
		[any]: never,
	}?,
	[any]: never,
}
Module.Widget.InputVector2 = function(props: InputVector2WidgetProperties): InputVector2Widget
	return Iris.InputVector2(toParams("InputVector2", props.Arguments, props.States))
end

export type InputVector3Widget = BaseWidget & {
	numberChanged: () -> boolean,
	hovered: () -> boolean,
}
export type InputVector3WidgetProperties = {
	Arguments: {
		Text: string?,
		Increment: Vector3?,
		Min: Vector3?,
		Max: Vector3?,
		Format: string? | { string }?, -- Iris will dynamically generate an approriate format.
		[any]: never,
	}?,
	States: {
		number: State<Vector3>?,
		editingText: State<boolean>?,
		[any]: never,
	}?,
}
Module.Widget.InputVector3 = function(props: InputVector3WidgetProperties): InputVector3Widget
	return Iris.InputVector3(toParams("InputVector3", props.Arguments, props.States))
end

export type InputUDimWidget = BaseWidget & {
	numberChanged: () -> boolean,
	hovered: () -> boolean,
	[any]: never,
}
export type InputUDimWidgetProperties = {
	Arguments: {
		Text: string?,
		Increment: UDim?,
		Min: UDim?,
		Max: UDim?,
		Format: string? | { string }?, -- Iris will dynamically generate an approriate format
		[any]: never,
	}?,
	States: {
		number: State<UDim>?,
		editingText: State<boolean>?,
		[any]: never,
	}?,
	[any]: never,
}
Module.Widget.InputUDim = function(props: InputUDimWidgetProperties): InputUDimWidget
	return Iris.InputUDim(toParams("InputUDim", props.Arguments, props.States))
end

export type InputUDim2Widget = BaseWidget & {
	numberChanged: () -> boolean,
	hovered: () -> boolean,
}
export type InputUDim2WidgetProperties = {
	Arguments: {
		Text: string?,
		Increment: UDim2?,
		Min: UDim2?,
		Max: UDim2?,
		Format: string? | { string }?, -- Iris will dynamically generate an approriate format
		[any]: never,
	}?,
	States: {
		number: State<UDim2>?,
		editingText: State<boolean>?,
		[any]: never,
	}?,
	[any]: never,
}
Module.Widget.InputUDim2 = function(props: InputUDim2WidgetProperties): InputUDim2Widget
	return Iris.InputUDim2(toParams("InputUDim2", props.Arguments, props.States))
end

export type InputRectWidget = BaseWidget & {
	numberChanged: () -> boolean,
	hovered: () -> boolean,
}
export type InputRectWidgetProperties = {
	Arguments: {
		Text: string?,
		Increment: Rect?,
		Min: Rect?,
		Max: Rect?,
		Format: string? | { string }?, -- Iris will dynamically generate an approriate format.
		[any]: never,
	}?,
	States: {
		number: State<Rect>?,
		editingText: State<boolean>?,
		[any]: never,
	}?,
	[any]: never,
}
Module.Widget.InputRect = function(props: InputRectWidgetProperties): InputRectWidget
	return Iris.InputRect(toParams("InputRect", props.Arguments, props.States))
end

export type InputColor3Widget = BaseWidget & {
	numberChanged: () -> boolean,
	hovered: () -> boolean,
}
export type InputColor3WidgetProperties = {
	Arguments: {
		Text: string?,
		UseFloats: boolean?, -- constrain the values between floats 0 and 1 or integers 0 and 255.
		UseHSV: boolean?, -- input using HSV instead.
		Format: string? | { string }?, -- Iris will dynamically generate an approriate format.
		[any]: never,
	}?,
	States: {
		color: State<Color3>?,
		editingText: State<boolean>?,
		[any]: never,
	}?,
	[any]: never,
}
Module.Widget.InputColor3 = function(props: InputColor3WidgetProperties): InputColor3Widget
	return Iris.InputColor3(toParams("InputColor3", props.Arguments, props.States))
end

export type InputColor4Widget = BaseWidget & {
	numberChanged: () -> boolean,
	hovered: () -> boolean,
}
export type InputColor4WidgetProperties = {
	Arguments: {
		Text: string?,
		UseFloats: boolean?, -- constrain the values between floats 0 and 1 or integers 0 and 255.
		UseHSV: boolean?, -- input using HSV instead.
		Format: string? | { string }?, -- Iris will dynamically generate an approriate format.
		[any]: never,
	}?,
	States: {
		color: State<Color3>?,
		transparency: State<number>?,
		editingText: State<boolean>?,
		[any]: never,
	}?,
	[any]: never,
}
Module.Widget.InputColor4 = function(props: InputColor4WidgetProperties): InputColor4Widget
	return Iris.InputColor4(toParams("InputColor4", props.Arguments, props.States))
end

export type DragNumWidget = BaseWidget & {
	numberChanged: () -> boolean,
	hovered: () -> boolean,
}
export type DragNumWidgetProperties = {
	Arguments: {
		Text: string?,
		Increment: number?,
		Min: number?,
		Max: number?,
		Format: string? | { string }?, -- Iris will dynamically generate an approriate format.
		NoButtons: boolean?, -- whether to display + and - buttons next to the input box.
		[any]: never,
	}?,
	States: {
		number: State<number>?,
		editingText: State<boolean>?,
		[any]: never,
	}?,
	[any]: never,
}
Module.Widget.DragNum = function(props: DragNumWidgetProperties): DragNumWidget
	return Iris.DragNum(toParams("DragNum", props.Arguments, props.States))
end

export type DragVector2Widget = BaseWidget & {
	numberChanged: () -> boolean,
	hovered: () -> boolean,
}
export type DragVector2WidgetProperties = {
	Arguments: {
		Text: string?,
		Increment: Vector2?,
		Min: Vector2?,
		Max: Vector2?,
		Format: string? | { string }?, -- Iris will dynamically generate an approriate format.
		[any]: never,
	}?,
	States: {
		number: State<Vector2>?,
		editingText: State<boolean>?,
		[any]: never,
	}?,
	[any]: never,
}
Module.Widget.DragVector2 = function(props: DragVector2WidgetProperties): DragVector2Widget
	return Iris.DragVector2(toParams("DragVector2", props.Arguments, props.States))
end
export type DragVector3Widget = BaseWidget & {
	numberChanged: () -> boolean,
	hovered: () -> boolean,
}
export type DragVector3WidgetProperties = {
	Arguments: {
		Text: string?,
		Increment: Vector3?,
		Min: Vector3?,
		Max: Vector3?,
		Format: string? | { string }?, -- Iris will dynamically generate an approriate format.
		[any]: never,
	}?,
	States: {
		number: State<Vector3>?,
		editingText: State<boolean>?,
		[any]: never,
	}?,
	[any]: never,
}
Module.Widget.DragVector3 = function(props: DragVector3WidgetProperties): DragVector3Widget
	return Iris.DragVector3(toParams("DragVector3", props.Arguments, props.States))
end

export type DragUDimWidget = BaseWidget & {
	numberChanged: () -> boolean,
	hovered: () -> boolean,
}
export type DragUDimWidgetProperties = {
	Arguments: {
		Text: string?,
		Increment: UDim?,
		Min: UDim?,
		Max: UDim?,
		Format: string? | { string }?, -- Iris will dynamically generate an approriate format
		[any]: never,
	}?,
	States: {
		number: State<UDim>?,
		editingText: State<boolean>?,
		[any]: never,
	}?,
	[any]: never,
}
Module.Widget.DragUDim = function(props: DragUDimWidgetProperties): DragUDimWidget
	return Iris.DragUDim(toParams("DragUDim", props.Arguments, props.States))
end

export type DragUDim2Widget = BaseWidget & {
	numberChanged: () -> boolean,
	hovered: () -> boolean,
}
export type DragUDim2WidgetProperties = {
	Arguments: {
		Text: string?,
		Increment: UDim2?,
		Min: UDim2?,
		Max: UDim2?,
		Format: string? | { string }?, -- Iris will dynamically generate an approriate format
		[any]: never,
	}?,
	States: {
		number: State<UDim2>?,
		editingText: State<boolean>?,
		[any]: never,
	}?,
	[any]: never,
}
Module.Widget.DragUDim2 = function(props: DragUDim2WidgetProperties): DragUDim2Widget
	return Iris.DragUDim2(toParams("DragUDim2", props.Arguments, props.States))
end

export type DragRectWidget = BaseWidget & {
	numberChanged: () -> boolean,
	hovered: () -> boolean,
}
export type DragRectWidgetProperties = {
	Arguments: {
		Text: string?,
		Increment: Rect?,
		Min: Rect?,
		Max: Rect?,
		Format: string? | { string }?, -- Iris will dynamically generate an approriate format.
		[any]: never,
	}?,
	States: {
		number: State<Rect>?,
		editingText: State<boolean>?,
		[any]: never,
	}?,
	[any]: never,
}
Module.Widget.DragRect = function(props: DragRectWidgetProperties): DragRectWidget
	return Iris.DragRect(toParams("DragRect", props.Arguments, props.States))
end

export type SliderNumWidget = BaseWidget & {
	numberChanged: () -> boolean,
	hovered: () -> boolean,
}
export type SliderNumWidgetProperties = {
	Arguments: {
		Text: string?,
		Increment: number?,
		Min: number?,
		Max: number?,
		Format: string? | { string }?, -- Iris will dynamically generate an approriate format.
		NoButtons: boolean?, -- whether to display + and - buttons next to the input box.
		[any]: never,
	}?,
	States: {
		number: State<number>?,
		editingText: State<boolean>?,
		[any]: never,
	}?,
	[any]: never,
}
Module.Widget.SliderNum = function(props: SliderNumWidgetProperties): SliderNumWidget
	return Iris.SliderNum(toParams("SliderNum", props.Arguments, props.States))
end
export type SliderVector2Widget = BaseWidget & {
	numberChanged: () -> boolean,
	hovered: () -> boolean,
}
export type SliderVector2WidgetProperties = {
	Arguments: {
		Text: string?,
		Increment: Vector2?,
		Min: Vector2?,
		Max: Vector2?,
		Format: string? | { string }?, -- Iris will dynamically generate an approriate format.
		[any]: never,
	}?,
	States: {
		number: State<Vector2>?,
		editingText: State<boolean>?,
		[any]: never,
	}?,
	[any]: never,
}
Module.Widget.SliderVector2 = function(props: SliderVector2WidgetProperties): SliderVector2Widget
	return Iris.SliderVector2(toParams("SliderVector2", props.Arguments, props.States))
end

export type SliderVector3Widget = BaseWidget & {
	numberChanged: () -> boolean,
	hovered: () -> boolean,
}
export type SliderVector3WidgetProperties = {
	Arguments: {
		Text: string?,
		Increment: Vector3?,
		Min: Vector3?,
		Max: Vector3?,
		Format: string? | { string }?, -- Iris will dynamically generate an approriate format.
		[any]: never,
	}?,
	States: {
		number: State<Vector3>?,
		editingText: State<boolean>?,
		[any]: never,
	}?,
	[any]: never,
}
Module.Widget.SliderVector3 = function(props: SliderVector3WidgetProperties): SliderVector3Widget
	return Iris.SliderVector3(toParams("SliderVector3", props.Arguments, props.States))
end

export type SliderUDimWidget = BaseWidget & {
	numberChanged: () -> boolean,
	hovered: () -> boolean,
}
export type SliderUDimWidgetProperties = {
	Arguments: {
		Text: string?,
		Increment: UDim?,
		Min: UDim?,
		Max: UDim?,
		Format: string? | { string }?, -- Iris will dynamically generate an approriate format
		[any]: never,
	}?,
	States: {
		number: State<UDim>?,
		editingText: State<boolean>?,
		[any]: never,
	}?,
	[any]: never,
}
Module.Widget.SliderUDim = function(props: SliderUDimWidgetProperties): SliderUDimWidget
	return Iris.SliderUDim(toParams("SliderUDim", props.Arguments, props.States))
end

export type SliderUDim2Widget = BaseWidget & {
	numberChanged: () -> boolean,
	hovered: () -> boolean,
}
export type SliderUDim2WidgetProperties = {
	Arguments: {
		Text: string?,
		Increment: UDim2?,
		Min: UDim2?,
		Max: UDim2?,
		Format: string? | { string }?, -- Iris will dynamically generate an approriate format
		[any]: never,
	}?,
	States: {
		number: State<UDim2>?,
		editingText: State<boolean>?,
		[any]: never,
	}?,
	[any]: never,
}
Module.Widget.SliderUDim2 = function(props: SliderUDim2WidgetProperties): SliderUDim2Widget
	return Iris.SliderUDim2(toParams("SliderUDim2", props.Arguments, props.States))
end

export type SliderRectWidget = BaseWidget & {
	numberChanged: () -> boolean,
	hovered: () -> boolean,
}
export type SliderRectWidgetProperties = {
	Arguments: {
		Text: string?,
		Increment: Rect?,
		Min: Rect?,
		Max: Rect?,
		Format: string? | { string }?, -- Iris will dynamically generate an approriate format.
		[any]: never,
	}?,
	States: {
		number: State<Rect>?,
		editingText: State<boolean>?,
		[any]: never,
	}?,
	[any]: never,
}
Module.Widget.SliderRect = function(props: SliderRectWidgetProperties): SliderRectWidget
	return Iris.SliderRect(toParams("SliderRect", props.Arguments, props.States))
end

export type SelectableWidget = BaseWidget & {
	selected: () -> boolean,
	unselected: () -> boolean,
	active: () -> boolean,
	clicked: () -> boolean,
	rightClicked: () -> boolean,
	doubleClicked: () -> boolean,
	ctrlClicked: () -> boolean,
	hovered: () -> boolean,
}
export type SelectableWidgetProperties<V> = {
	Arguments: {
		Text: string,
		Index: V, -- index of selectable value.
		NoClick: boolean?, -- prevents the selectable from being clicked by the user.
		[any]: never,
	},
	States: {
		index: State<V>, -- a shared state between all selectables.
		[any]: never,
	},
	[any]: never,
}
Module.Widget.Selectable = function<V>(props: SelectableWidgetProperties<V>): SelectableWidget
	return Iris.Selectable(toParams("Selectable", props.Arguments, props.States))
end

export type ComboWidget = BaseWidget & {
	opened: () -> boolean,
	closed: () -> boolean,
	changed: () -> boolean,
	clicked: () -> boolean,
	hovered: () -> boolean,
}
export type ComboWidgetProperties = {
	Arguments: {
		Text: string,
		NoButton: boolean?, -- hide the dropdown button.
		NoPreview: boolean?, -- hide the preview field.
		[any]: never,
	},
	States: {
		index: State<any>,
		isOpened: State<boolean>?,
		[any]: never,
	},
	[any]: never,
}
Module.Widget.Combo = function(props: ComboWidgetProperties, fn: (widget: ComboWidget) -> ()): ComboWidget
	local widget = Iris.Combo(toParams("Combo", props.Arguments, props.States))
	fn(widget)
	Iris.End()
	return widget
end

export type ComboArrayWidget = BaseWidget & {
	opened: () -> boolean,
	closed: () -> boolean,
	clicked: () -> boolean,
	hovered: () -> boolean,
}
export type ComboArrayWidgetProperties<V> = {
	Arguments: {
		Text: string,
		NoButton: boolean?, -- hide the dropdown button.
		NoPreview: boolean?, -- hide the preview field.
		[any]: never,
	},
	States: {
		index: State<V>,
		isOpened: State<boolean>?,
		[any]: never,
	},
	Extra: {
		selectionArray: { V }, -- the array to generate a combo from.
		[any]: never,
	},
	[any]: never,
}
Module.Widget.ComboArray = function<V>(
	props: ComboArrayWidgetProperties<V>,
	fn: (widget: ComboArrayWidget) -> ()
): ComboArrayWidget
	local widget = Iris.ComboArray(toParams("ComboArray", props.Arguments, props.States), props.Extra.selectionArray)
	fn(widget)
	Iris.End()
	return widget
end

export type ComboEnumWidget = BaseWidget & {
	opened: () -> boolean,
	closed: () -> boolean,
	clicked: () -> boolean,
	hovered: () -> boolean,
}
export type ComboEnumWidgetProperties = {
	Arguments: {
		Text: string,
		NoButton: boolean?, -- hide the dropdown button.
		NoPreview: boolean?, -- hide the preview field.
		[any]: never,
	},
	States: {
		index: State<EnumItem>,
		isOpened: State<boolean>?,
		[any]: never,
	},
	Extra: {
		enumType: Enum, -- the array to generate a combo from.
		[any]: never,
	},
	[any]: never,
}
Module.Widget.ComboEnum = function(
	props: ComboEnumWidgetProperties,
	fn: (widget: ComboEnumWidget) -> ()
): ComboEnumWidget
	local widget = Iris.ComboEnum(toParams("ComboEnum", props.Arguments, props.States), props.Extra.enumType)
	fn(widget)
	Iris.End()
	return widget
end

export type ProgressBarWidget = BaseWidget & {
	hovered: () -> boolean,
	changed: () -> boolean,
	[any]: never,
}
export type ProgressBarWidgetProperties = {
	Arguments: {
		Text: string?,
		Format: string?, -- optional to override with a custom progress such as `29/54`
		[any]: never,
	}?,
	States: {
		progress: State<number>?,
		[any]: never,
	}?,
	[any]: never,
}
Module.Widget.ProgressBar = function(props: ProgressBarWidgetProperties): ProgressBarWidget
	return Iris.ProgressBar(toParams("ProgressBar", props.Arguments, props.States))
end

export type PlotLinesWidget = BaseWidget & {
	hovered: () -> boolean,
}
export type PlotLinesWidgetProperties = {
	Arguments: {
		Text: string?,
		Height: number?,
		Min: number?, -- Iris will use the minimum value from the values
		Max: number?, -- Iris will use the maximum value from the values
		TextOverlay: string?,
		[any]: never,
	}?,
	States: {
		values: State<{ number }>?,
		hovered: State<{ number }>?, -- read-only property
		[any]: never,
	}?,
	[any]: never,
}
Module.Widget.PlotLines = function(props: PlotLinesWidgetProperties): PlotLinesWidget
	return Iris.PlotLines(toParams("PlotLines", props.Arguments, props.States))
end

export type PlotHistogramWidget = BaseWidget & {
	hovered: () -> boolean,
}
export type PlotHistogramWidgetProperties = {
	Arguments: {
		Text: string?,
		Height: number?,
		Min: number?, -- Iris will use the minimum value from the values
		Max: number?, -- Iris will use the maximum value from the values
		TextOverlay: string?,
		BaseLine: number?, -- by default, blocks swap side at 0
		[any]: never,
	}?,
	States: {
		values: State<{ number }>?,
		hovered: State<{ number }>?, -- read-only property
		[any]: never,
	}?,
	[any]: never,
}
Module.Widget.PlotHistogram = function(props: PlotHistogramWidgetProperties): PlotHistogramWidget
	return Iris.PlotHistogram(toParams("PlotHistogram", props.Arguments, props.States))
end

export type TableWidget = BaseWidget & {
	hovered: () -> boolean,
	NextColumn: () -> (),
	NextRow: () -> (),
	SetColumIndex: (index: number) -> (),
	SetRowIndex: (index: number) -> (),
	NextHeaderColumn: () -> (),
	SetHeaderColumnIndex: (index: number) -> (),
	SetColumnWidth: (index: number, width: number) -> (),
}
export type TableWidgetProperties = {
	Arguments: {
		NumColumns: number, -- number of columns in the table, cannot be changed
		Header: boolean?, -- display a header row for each column
		RowBackground: boolean?, -- alternating row background colours
		OuterBorders: boolean?, -- outer border on the entire table
		InnerBorders: boolean?, -- inner bordres on the entire table
		Resizable: boolean?, -- the columns can be resized by dragging or state
		FixedWidth: boolean?, -- columns takes up a fixed pixel width, rather than a proportion of the total available
		ProportionalWidth: boolean?, -- minimises the width of each column individually
		LimitTableWidth: boolean?, -- when a fixed width, cut of any unused space
		[any]: never,
	},
	States: {
		widths: State<{ number }>?, -- the widths of each column if Resizable
		[any]: never,
	}?,
	[any]: never,
}
Module.Widget.Table = function(props: TableWidgetProperties, fn: (widget: TableWidget) -> ()): TableWidget
	local widget = Iris.Table(toParams("Table", props.Arguments, props.States))
	fn(widget)
	Iris.End()
	return widget
end

setmetatable(Module, {
	__newindex = function(self, k: string, v)
		if k == "Disabled" then
			Iris.Disabled = v
			rawset(self, "Disabled", v)
		end
	end,
})

return Module
