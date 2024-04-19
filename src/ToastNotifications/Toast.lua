local function ToastComponent()
	-- Toast
	local Toast = Instance.new("ImageLabel")
	Toast["ZIndex"] = 2
	Toast["BorderSizePixel"] = 0
	Toast["SliceCenter"] = Rect.new(3, 3, 3, 3)
	Toast["ScaleType"] = Enum.ScaleType.Slice
	Toast["ImageTransparency"] = 1
	Toast["ImageColor3"] = Color3.fromRGB(33, 33, 33)
	Toast["AnchorPoint"] = Vector2.new(0.5, 0)
	Toast["Image"] = "rbxasset://textures/ui/Camera/CameraToast9Slice.png"
	Toast["ImageRectSize"] = Vector2.new(6, 6)
	Toast["Size"] = UDim2.new(0, 80, 0, 58)
	Toast["ClipsDescendants"] = true
	Toast["BackgroundTransparency"] = 1
	Toast["Name"] = "Toast"
	Toast["Position"] = UDim2.new(0.5, 0, 0, 8)

	-- Toast.IconBuffer
	local IconBuffer = Instance.new("Frame")
	IconBuffer.Parent = Toast
	IconBuffer["ZIndex"] = 2
	IconBuffer["BorderSizePixel"] = 0
	IconBuffer["Size"] = UDim2.new(0, 80, 1, 0)
	IconBuffer["Name"] = "IconBuffer"
	IconBuffer["BackgroundTransparency"] = 1

	-- Toast.IconBuffer.Icon
	local Icon = Instance.new("ImageLabel")
	Icon.Parent = IconBuffer
	Icon["ZIndex"] = 3
	Icon["ImageTransparency"] = 1
	Icon["ImageColor3"] = Color3.fromRGB(201, 201, 201)
	Icon["AnchorPoint"] = Vector2.new(0.5, 0.5)
	Icon["Image"] = "rbxasset://textures/ui/Camera/CameraToastIcon.png"
	Icon["Size"] = UDim2.new(0, 48, 0, 48)
	Icon["BackgroundTransparency"] = 1
	Icon["Name"] = "Icon"
	Icon["Position"] = UDim2.new(0.5, 0, 0.5, 0)

	-- Toast.TextBuffer
	local TextBuffer = Instance.new("Frame")
	TextBuffer.Parent = Toast
	TextBuffer["ZIndex"] = 2
	TextBuffer["BorderSizePixel"] = 0
	TextBuffer["ClipsDescendants"] = true
	TextBuffer["Size"] = UDim2.new(1, -80, 1, 0)
	TextBuffer["Position"] = UDim2.new(0, 80, 0, 0)
	TextBuffer["Name"] = "TextBuffer"
	TextBuffer["BackgroundTransparency"] = 1

	-- Toast.TextBuffer.Upper
	local Upper = Instance.new("TextLabel")
	Upper.Parent = TextBuffer
	Upper["ZIndex"] = 3
	Upper["TextXAlignment"] = Enum.TextXAlignment.Left
	Upper["TextTransparency"] = 1
	Upper["TextSize"] = 19
	Upper["FontFace"] =
		Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
	Upper["TextColor3"] = Color3.fromRGB(201, 201, 201)
	Upper["BackgroundTransparency"] = 1
	Upper["AnchorPoint"] = Vector2.new(0, 1)
	Upper["Size"] = UDim2.new(1, 0, 0, 19)
	Upper["Text"] = "Upper text"
	Upper["Name"] = "Upper"
	Upper["Position"] = UDim2.new(0, 0, 0.5, 0)

	-- Toast.TextBuffer.Lower
	local Lower = Instance.new("TextLabel")
	Lower.Parent = TextBuffer
	Lower["TextTruncate"] = Enum.TextTruncate.SplitWord
	Lower["ZIndex"] = 3
	Lower["TextXAlignment"] = Enum.TextXAlignment.Left
	Lower["TextTransparency"] = 1
	Lower["TextSize"] = 15
	Lower["FontFace"] =
		Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
	Lower["TextColor3"] = Color3.fromRGB(201, 201, 201)
	Lower["BackgroundTransparency"] = 1
	Lower["Size"] = UDim2.new(1, 0, 0, 15)
	Lower["Text"] = "Lower text"
	Lower["Name"] = "Lower"
	Lower["Position"] = UDim2.new(0, 0, 0.5, 3)

	return Toast
end
return ToastComponent
