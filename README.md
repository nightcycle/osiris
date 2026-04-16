# Osiris

Opinionated Strict [Iris](https://github.com/SirMallard/Iris).

## Why make this?

Iris is very useful but I feel the syntax of Dear ImGui (the project it's based on + the direct source of most API syntax) is built around an ecosystem with better tooling and a more robust language. We're on Roblox, we can't be as clever. I spoke with the dev of Iris a while back, they're making something really cool - but my project is not meant to be as groundbreaking, it's meant to give me what I want in a couple of hours while utilizing the quality provided generously by them to the community.

## What'd you do?

I implemented two specific changes in the pursuit of type safety and auto indenting support.

### React / Fusion Style Property Tables

No more mis-indexing fields.
```luau
Osiris.Widget.Text({
	Arguments = {
		Text = "Hello!", -- removing this will send you to red line hell
	},
	States = {
		text = textState,
	}
})
```
It also returns the handle with widget specific type annotations if you want to use events.

### Death to .End()

I consistently forget to place this damn thing, and even when I do I always had to but `do` / `end` blocks to get the auto code formatter to not flatten out my entire tree. So instead, when the widget has children, there's a mandatory callback function which runs between the construction of the widget and the .End() call internally. Now it formats cleanly, and it even passes itself in as a parameter!
```luau
Osiris.Widget.Window({
	Arguments = {
		Title = "Abc123",
	},
	States = {
		isOpened = isOpenState,
	},
}, function(windowWidget)
	Osiris.Widget.Text({
		Arguments = {
			Text = "Hello!",
		},
		States = {
			text = textState,
		}
	})
end)
```
I'll be honest though, I usually just assign the internal parameter to `_`.

## Goals

My goal is to never crash Iris again with a type error, and to have nice and clean hierarchies of components - thus allowing me to code quicker in a tool where the main selling point is speed of iteration.

## Future

I'll probably use this internally, I'll update it as I like. Once the next Iris version comes out I might scrap it as I know it implements some of the stuff I added here.
