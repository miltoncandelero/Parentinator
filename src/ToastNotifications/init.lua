-- Original notification from J00SAN (ImJoosan)
local TweenService = game:GetService("TweenService")
local DebrisService = game:GetService("Debris")
local Toast = require(script.Toast)
local module = {}

function AnimateToast(toast: any, anim)
	local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local open = anim == "open"

	local imgParams = { ImageTransparency = open and 0 or 1 }
	local txtParams = { TextTransparency = open and 0 or 1 }
	TweenService:Create(toast, tweenInfo, {
		Size = open and UDim2.new(0, 326, 0, 58) or UDim2.new(0, 80, 0, 58),
		ImageTransparency = open and 0.4 or 1,
	}):Play()
	TweenService:Create(toast.IconBuffer.Icon, tweenInfo, imgParams):Play()
	TweenService:Create(toast.TextBuffer.Upper, tweenInfo, txtParams):Play()
	TweenService:Create(toast.TextBuffer.Lower, tweenInfo, txtParams):Play()

	if not open then
		DebrisService:AddItem(toast, 0.25)
	end
end

function GetGui(): ScreenGui
	-- local Player = game.Players.LocalPlayer
	local coreGui = game:GetService("CoreGui")
	local gui = (coreGui:FindFirstChild("Toasts") :: ScreenGui) or Instance.new("ScreenGui")
	gui.Parent = coreGui
	gui.DisplayOrder = 2147483647
	gui.Name = "Toasts"

	return gui
end

module.CreateToast = function(ToastId, TopText, BottomText, IconId, DisplayTime)
	-- local newToast = script.Toast:Clone() -- TODO: Move this to code only
	local newToast: any = Toast()
	newToast.TextBuffer.Upper.Text = TopText
	newToast.TextBuffer.Lower.Text = BottomText
	newToast.IconBuffer.Icon.Image = IconId
	newToast.Name = ToastId

	local oldToast: ImageLabel = GetGui():FindFirstChild(ToastId) :: ImageLabel
	local run = false

	if oldToast then
		run = oldToast.ImageTransparency < 0.4
	end

	if not run then
		if DisplayTime > 0 then
			task.delay(DisplayTime, function()
				AnimateToast(newToast, "cancel")
			end)
		end
		AnimateToast(newToast, "open")
		newToast.Parent = GetGui()

		return {
			CancelToast = function()
				AnimateToast(newToast, "cancel")
			end,
			DestroyToast = function(delaytime: "optional")
				DebrisService:AddItem(newToast, delaytime or 0)
			end,
			HideToast = function()
				newToast.Visible = false
			end,
			ShowToast = function()
				newToast.Visible = true
			end,
		}
	else
		return { CancelToast = empty(), DestroyToast = empty(), HideToast = empty(), ShowToast = empty() }
	end
end

function empty()
	return function() end
end

module.GetToast = function(id)
	local gui = GetGui()
	local toast = gui:FindFirstChild(id) :: ImageLabel

	if toast then
		return {
			CancelToast = function()
				AnimateToast(toast, "cancel")
			end,
			DestroyToast = function(delaytime: "optional")
				DebrisService:AddItem(toast, delaytime or 0)
			end,
			HideToast = function()
				toast.Visible = false
			end,
			ShowToast = function()
				toast.Visible = true
			end,
		}
	else
		return { CancelToast = empty(), DestroyToast = empty(), HideToast = empty(), ShowToast = empty() }
	end
end

module.CancelAllToasts = function()
	for i, toast in pairs(GetGui():GetChildren()) do
		AnimateToast(toast, "cancel")
	end
end

return module
