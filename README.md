# GameComponents
GameComponents is a plugin framework to make plugin development easier.

## Why should you use GameComponents
---

GameComponents is used to write plugins that can easily interact with other plugins by
adding ways to allow developers to write code which would interact with other
plugins that use GameComponents.

Roblox's Plugin market is extremely unprofitable due to high rates which are hard
to fix on Roblox's side. By using GameComponents, it becomes easy to integrate new features
into your plugin code through the use of other plugins. This means you could write
a plugin to convert instances into Instance.new calls, then have another plugin which
adds the ability for the previous plugin to convert instances into Fusion.New calls or
Roact.createElement calls. This allows users to pay only for what they need, saving them
money, while also allowing you to produce more features for your plugin that users
can choose if they want to get or not and pay extra for.

GameComponents's main benefit comes with writing a basic "Lite" plugin, that gives a small amount
of features, then having multiple small feature packs for that Lite plugin that expands it
into a very powerful full-sized tool.

## That's cool, but what is developing plugins like?
---

GameComponents is designed around the concept of "interconnecting" with other GameComponents plugins.
We'll have to write code in a way that makes it easy to expand. Your plugin has to consist
of Services and Components.

Services should be used to handle all of the main logic in your plugin. This ranges from
just saving some data to reading chunks of voxels. You'll also only be able to interact
with Services from other plugins, so make sure that you write services that allow you to
inject a user interface into your plugin UI to allow for other plugins to expand upon that.

Components are written using Fusion. GameComponents already provides a suite of components to be
used with your plugins. It's recommended to design your UI around reflecting the state of
a Service, rather than maintaining internal state and passing that to other components.

There is no proper way for other plugins to implement user interface into the plugin it
is injecting into, other than having a service that injects it manually.
Currently, we are planning to introduce a Export "" SpecialKey to Fusion which allows the
exporting of state.

```lua

New "Frame" {
	
	Name = "Tabs",
	
	Position = UDim2.new(0, 0, 0, 24),
	Size = UDim2.new(1, 0, 0, 32),
	
	BackgroundColor3 = Theme:GetColor(Enums.GuideColor.Background),
	
	[Children] = TabsService:GetTabs()
	[Export "Tabs"] = {StateObject<any>}
	
}

```

This is still a experimental thing and has to be expanded upon.

Projects should probably be structured like the following:

- src/
	- services/
	- modules/
	- components/
	- buttons.json

GameComponents is available on Wally, and comes with multiple other libraries installed with it.

## Inspiration
--

I've written multiple plugin frameworks before, all designed around the idea to write a
plugin which can interconnect with other plugins. Each one of these frameworks usually comes
with a flaw that makes it inconvenient to use.

I'll list all my previous prototype frameworks before:
- Interconnect
	Interconnect is a plugin framework built around the idea to write plugins completely
	interconnected with eachother. This came with the flaw that we have to install a external
	plugin, which would then proceed to serve as the core engine and framework, which is
	inconvenient for plugin developers.
- HeavyFramework
	HeavyFramework (or rather Interconnect2) is a expansion on the original Interconnect idea,
	bringing the framework into the core package. This was great, but it was unintuitive to
	write and was built around the idea that a test would initiate the code. You could actually
- PluginFramework3
	PluginFramework3 failed because it was ultimately not what I wanted. It contained a ton of
	the features you would see in GameComponents, but unlike GameComponents, PluginFramework3 lacked proper full
	interconnect functionality. It also had UI built and completely designed upon a buggy, experimental
	library that didn't function well with the plugins I wrote.

## 