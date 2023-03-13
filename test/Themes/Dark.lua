local ReplicatedStorage = game:GetService("ReplicatedStorage")

local GameComponents = ReplicatedStorage.Packages.GameComponents
local Enums = require(GameComponents.Enums)

local fromHex = Color3.fromHex

local BLACK = fromHex("#000000")
local WHITE = fromHex("#FFFFFF")
local DARK_GREY = fromHex("#555555")
local MID_GREY = fromHex("#AAAAAA")
local LIGHT_GREY = fromHex("#CCCCCC")

local MID_BLUE = fromHex("#00A2FF")
local LIGHT_BLUE = fromHex("#35B5FF")

local LIGHT = fromHex("#404040")
local DARK = fromHex("#222222")
local MID = fromHex("#222222")
local MID_LIGHT = fromHex("#222222")

local PRIMARY_COLOR = fromHex("#2E2E2E")
local SECONDARY_COLOR = fromHex("#252525")
local ACCENT_COLOR = fromHex("#353535")

local ACTIVE_COLOR = fromHex("464646")
local HOVER_COLOR = fromHex("#424242")
local ERROR_COLOR = fromHex("#FF4444")

return {
	Default = true,

	[Enums.GuideColor.Light] = {
		[Enums.GuideModifier.Default] = LIGHT,
	},
	[Enums.GuideColor.Dark] = {
		[Enums.GuideModifier.Default] = DARK,
	},
	[Enums.GuideColor.Mid] = {
		[Enums.GuideModifier.Default] = MID,
	},
	[Enums.GuideColor.Midlight] = {
		[Enums.GuideModifier.Default] = MID_LIGHT,
	},
	[Enums.GuideColor.MainBackground] = {
		[Enums.GuideModifier.Default] = PRIMARY_COLOR,
	},
	[Enums.GuideColor.ViewPortBackground] = {
		[Enums.GuideModifier.Default] = SECONDARY_COLOR,
	},
	[Enums.GuideColor.InputFieldBackground] = {
		[Enums.GuideModifier.Default] = SECONDARY_COLOR,
		[Enums.GuideModifier.Disabled] = ACCENT_COLOR,
		[Enums.GuideModifier.Hover] = HOVER_COLOR,
	},
	[Enums.GuideColor.MainText] = {
		[Enums.GuideModifier.Default] = LIGHT_GREY,
		[Enums.GuideModifier.Selected] = WHITE,
		[Enums.GuideModifier.Disabled] = DARK_GREY,
		[Enums.GuideModifier.Hover] = WHITE,
	},
	[Enums.GuideColor.SubText] = {
		[Enums.GuideModifier.Default] = MID_GREY,
		[Enums.GuideModifier.Disabled] = DARK_GREY,
	},
	[Enums.GuideColor.BrightText] = {
		[Enums.GuideModifier.Default] = fromHex("#E5E5E5"),
	},
	[Enums.GuideColor.DimmedText] = {
		[Enums.GuideModifier.Default] = fromHex("#666666"),
		[Enums.GuideModifier.Selected] = MID_GREY,
	},
	[Enums.GuideColor.WarningText] = {
		[Enums.GuideModifier.Default] = fromHex("#FF8E3C"),
	},
	[Enums.GuideColor.ErrorText] = {
		[Enums.GuideModifier.Default] = ERROR_COLOR,
	},
	[Enums.GuideColor.InfoText] = {
		[Enums.GuideModifier.Default] = fromHex("#80D7FF"),
	},
	[Enums.GuideColor.SensitiveText] = {
		[Enums.GuideModifier.Default] = fromHex("#D15DFF"),
	},
	[Enums.GuideColor.MainButton] = {
		[Enums.GuideModifier.Default] = MID_BLUE,
		[Enums.GuideModifier.Pressed] = fromHex("#0074BD"),
		[Enums.GuideModifier.Hover] = fromHex("#32B5FF"),
	},
	[Enums.GuideColor.Button] = {
		[Enums.GuideModifier.Default] = fromHex("#3C3C3C"),
		[Enums.GuideModifier.Selected] = MID_BLUE,
		[Enums.GuideModifier.Pressed] = fromHex("#292929"),
		[Enums.GuideModifier.Hover] = HOVER_COLOR,
	},
	[Enums.GuideColor.ButtonText] = {
		[Enums.GuideModifier.Default] = LIGHT_GREY,
		[Enums.GuideModifier.Selected] = WHITE,
		[Enums.GuideModifier.Disabled] = DARK_GREY,
	},
	[Enums.GuideColor.Dropdown] = {
		[Enums.GuideModifier.Default] = PRIMARY_COLOR,
	},
	[Enums.GuideColor.Tooltip] = {
		[Enums.GuideModifier.Default] = ACCENT_COLOR,
	},
	[Enums.GuideColor.Notification] = {
		[Enums.GuideModifier.Default] = PRIMARY_COLOR,
	},
	[Enums.GuideColor.ScrollBar] = {
		[Enums.GuideModifier.Default] = fromHex("#383838"),
		[Enums.GuideModifier.Pressed] = ACTIVE_COLOR,
		[Enums.GuideModifier.Disabled] = MID,
		[Enums.GuideModifier.Hover] = ACTIVE_COLOR,
	},
	[Enums.GuideColor.ScrollBarBackground] = {
		[Enums.GuideModifier.Default] = MID,
	},
	[Enums.GuideColor.DropShadow] = {
		[Enums.GuideModifier.Default] = BLACK,
	},
	[Enums.GuideColor.Shadow] = {
		[Enums.GuideModifier.Default] = LIGHT,
	},
	[Enums.GuideColor.Separator] = {
		[Enums.GuideModifier.Default] = MID_LIGHT,
	},
	[Enums.GuideColor.Border] = {
		[Enums.GuideModifier.Default] = MID,
	},
	[Enums.GuideColor.ButtonBorder] = {
		[Enums.GuideModifier.Default] = ACCENT_COLOR,
	},
	[Enums.GuideColor.InputFieldBorder] = {
		[Enums.GuideModifier.Default] = fromHex("#1A1A1A"),
		[Enums.GuideModifier.Selected] = LIGHT_BLUE,
		[Enums.GuideModifier.Disabled] = HOVER_COLOR,
		[Enums.GuideModifier.Hover] = fromHex("#3A3A3A"),
	},
	[Enums.GuideColor.HeaderSection] = {
		[Enums.GuideModifier.Default] = ACCENT_COLOR,
		[Enums.GuideModifier.Pressed] = fromHex("#292929"),
		[Enums.GuideModifier.Hover] = fromHex("#484848"),
	},
	[Enums.GuideColor.StatusBar] = {
		[Enums.GuideModifier.Default] = PRIMARY_COLOR,
	},
}
