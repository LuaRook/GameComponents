
local GameComponents = script.Parent.Parent
local Packages = GameComponents.Parent
local Components = GameComponents.Components

local Fusion = require(Packages.Fusion)

local Expandable = require(Components.Utility.Expandable)
local Background = require(Components.Decoration.Background)
local Button = require(Components.Interactable.Button)
local Text = require(Components.Display.Text)

local New = Fusion.New
local Value = Fusion.Value
local OnEvent = Fusion.OnEvent
local Children = Fusion.Children

return function(target)
	
	local expanded = Value(false)
	
	local background = Background {
		
		Parent = target,
		
		[Children] = {
			
			Expandable {
				
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0),
				
				BackgroundTransparency = 0.5,
				
				Expanded = expanded,
				
				[Children] = {
					
					Text {
						Text = "goodmorning everyone how are yall\nbecause i am doing GREAT!"
						
					},
					
					New "UIPadding" {
						PaddingTop = UDim.new(0, 32),
						PaddingBottom = UDim.new(0, 32)
						
					}
					
				}
				
			},
			
			Button {
		
				Position = UDim2.new(0.5, 0, 1, -32),
				AnchorPoint = Vector2.new(0.5, 1),
				
				Text = "Expand/Unexpand",
				
				[OnEvent "Activated"] = function()
					print("updated to", not expanded:get())
					expanded:set(not expanded:get())
				end
				
			}
			
		}
		
	}
	
	
	return function()
		
		background:Destroy()
		
	end
	
end