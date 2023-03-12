
local GameComponents = script.Parent.Parent
local Packages = GameComponents.Parent
local Components = GameComponents.Components

local Fusion = require(Packages.Fusion)

local Background = require(Components.Decoration.Background)
local Pane = require(Components.Decoration.Pane)
local Border = require(Components.Decoration.Border)
local BaseTextInput = require(Components.Interactable.BaseTextInput)
local TextInput = require(Components.Interactable.TextInput)

local Children = Fusion.Children

return function(target)
	
	local background = Background {
		Parent = target,
		
		[Children] = {
			
			Pane {
				PaneText = "TextInputs",
				
				[Children] = {
					
					BaseTextInput {
						
						Size = UDim2.new(1, 0, 0, 24),
						
						PlaceholderText = "placeholder",
						
						[Children] = Border {}
						
					},
					
					TextInput {
						
						Size = UDim2.new(1, 0, 0, 24),
						
						PlaceholderText = "placeholder"
						
					},
					
					TextInput {
						
						Size = UDim2.new(0, 300, 0, 24),
						
						PlaceholderText = "placeholder"
						
					},
					
					TextInput {
						
						Size = UDim2.new(0, 300, 0, 24),
						
						PlaceholderText = "Limited",
						
						Validator = function(text)
							local size = #text
							
							return size <= 20, `{size}/20`
						end
						
					},
					
					TextInput {
						
						Size = UDim2.new(0, 300, 0, 24),
						
						PlaceholderText = "Numbers Only Validator",
						ErrorLocation = "Bottom",
						
						Validator = function(text)
							local ok = not not tonumber(text) or text == ""
							return ok, if not ok then "Only numbers allowed" else ""
						end
						
					},
					
					TextInput {
						
						Size = UDim2.new(0, 300, 0, 24),
						
						PlaceholderText = "Numbers Only Validator",
						
						Validator = function(text)
							local ok = not not tonumber(text) or text == ""
							return ok, if not ok then "Only numbers allowed" else "All numbers 👍"
						end
						
					},
					
					TextInput {
						
						Size = UDim2.new(0, 300, 0, 24),
						
						PlaceholderText = "Numbers Only Filter",
						
						Filter = function(text, oldText)
							if text == "" then return "" end
							return if not tonumber(text) then oldText else text 
						end
						
					},
					
					TextInput {
						
						Size = UDim2.new(0, 300, 0, 24),
						
						MultiLine = true,
						PlaceholderText = "multi-line"
						
					},
					
					TextInput {
						
						Size = UDim2.new(0, 300, 0, 24),
						
						MultiLine = true,
						PlaceholderText = "multi-line limit",
						
						Validator = function(text)
							local size = #text
							
							return size <= 200, `{size}/200`
						end
						
					},
					
				}
				
			}
			
		}
		
	}
	
	return function()
		
		background:Destroy()
		
	end
	
end