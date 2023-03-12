
local GameComponents = script.Parent.Parent
local Packages = GameComponents.Parent
local Components = GameComponents.Components

local Fusion = require(Packages.Fusion)

local Background = require(Components.Decoration.Background)
local Pane = require(Components.Decoration.Pane)

local Children = Fusion.Children

return function(target)
	
	local background = Background {
		Parent = target,
		
		[Children] = {
			
			Pane {
				PaneText = "Hello!"
				
			},
			
			Pane {
				
			}
			
		}
		
	}
	
	return function()
		
		background:Destroy()
		
	end
	
end