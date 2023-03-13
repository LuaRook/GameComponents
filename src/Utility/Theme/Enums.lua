local Packages = script.Parent.Parent.Parent.Parent

local EnumList = require(Packages.EnumList)

return {
	GuideColors = EnumList.new("GuideColor", {
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
		"LinkText",
		"WarningText",
		"ErrorText",
		"InfoText",
		"SensitiveText",
		"MainButton",
		"Button",
		"Dropdown",
		"Tooltip",
		"Notification",
		"ScrollBar",
		"ScrollBarBackground",
		"Item",
		"TableItem",
		"CategoryItem",
		"DropShadow",
		"Shadow",
		"ChatIncomingBgColor",
		"ChatIncomingTextColor",
		"ChatOutgoingBgColor",
		"ChatOutgoingTextColor",
		"ChatModeratedMessageColor",
		"Separator",
		"Border",
		"ButtonBorder",
		"InputFieldBorder",
		"HeaderSection",
		"StatusBar",
		"InfoBarWarningBackground",
		"InfoBarWarningText",
	}),

	GuideModifier = EnumList.new("GuideModifier", {
		"Default",
		"Selected",
		"Pressed",
		"Disabled",
		"Hover",
	}),
}
