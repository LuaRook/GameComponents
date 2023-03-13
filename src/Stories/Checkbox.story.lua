local GameComponents = script.Parent.Parent
local Packages = GameComponents.Parent
local Components = GameComponents.Components

local Fusion = require(Packages.Fusion)

local Checkbox = require(Components.Interactable.Checkbox)
local Background = require(Components.Decoration.Background)
local Text = require(Components.Display.Text)

local Children = Fusion.Children

return function(target)
	local background = Background({

		Parent = target,

		[Children] = {

			Checkbox({

				[Children] = {
					Text({
						Text = "Hello.",
						LayoutOrder = -1,
					}),
				},
			}),

			Checkbox({

				[Children] = {
					Text({
						Text = "Hello.",
						LayoutOrder = -1,
					}),
				},
			}),

			Checkbox({

				Size = UDim2.fromScale(1, 0),

				[Children] = {
					Text({
						Text = "Long one",
						LayoutOrder = -1,
					}),
				},
			}),
		},
	})

	return function()
		background:Destroy()
	end
end
