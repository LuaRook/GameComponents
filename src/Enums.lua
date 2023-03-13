local Packages = script.Parent.Parent

local EnumList = require(Packages.EnumList)

return {
	GuideColor = EnumList.new("GuideColor", {
		"Light",
		"Dark",
		"Mid",
		"Midlight",
		"MainBackground",
		"ViewPortBackground",
		"InputFieldBackground",
		"MainText",
		"SubText",
		"BrightText",
		"DimmedText",
		"WarningText",
		"ErrorText",
		"InfoText",
		"SensitiveText",
		"MainButton",
		"Button",
		"ButtonText",
		"Dropdown",
		"Tooltip",
		"Notification",
		"ScrollBar",
		"ScrollBarBackground",
		"DropShadow",
		"Shadow",
		"Separator",
		"Border",
		"ButtonBorder",
		"InputFieldBorder",
		"HeaderSection",
		"StatusBar",
	}),

	GuideModifier = EnumList.new("GuideModifier", {
		"Default",
		"Selected",
		"Pressed",
		"Disabled",
		"Hover",
	}),
}
