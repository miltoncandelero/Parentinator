local ChangeHistoryService = game:GetService("ChangeHistoryService")
local Selection = game:GetService("Selection")
local StarterPlayer = game:GetService("StarterPlayer")
local StudioService = game:GetService("StudioService")
local ToastNotifications = require(script.Parent.ToastNotifications)
local PICK_PARENT_ICON = "rbxassetid://17176191402"
local MOVE_TO_SERVICE_ICON = "rbxassetid://17184424315"
local MOVE_TO_PARENT_ICON = "rbxassetid://17184421347"
local COPY_TO_PARENT_ICON = "rbxassetid://17184422140"
local COPY_TO_SERVICE_ICON = "rbxassetid://17184423270"
local THONK_ICON = "rbxassetid://17183855759"
local CANCEL_ICON = "rbxassetid://17194156539"

local toolbar = plugin:CreateToolbar("Parentinator")
local recording: string? = nil

local function MoveObjectsToParent(objects: { Instance }, parent: Instance, clone: boolean)
	local toBeMoved = {}
	if #objects > 0 then
		for _, o in ipairs(objects) do
			local auxp = o.Parent
			local shouldMove = true
			while auxp do
				if table.find(objects, auxp) then
					shouldMove = false
					break
				end
				auxp = auxp.Parent
			end
			if shouldMove then
				table.insert(toBeMoved, o)
			end
		end
	end

	if recording then
		warn("found previous recording, rolling back")
		ChangeHistoryService:FinishRecording(recording, Enum.FinishRecordingOperation.Cancel)
	end
	recording = ChangeHistoryService:TryBeginRecording("Parentinator", "Parentinator: Changing parents")
	if not recording then
		warn("Failed to create the undo recording?")
		return
	end
	local success, err = pcall(function()
		for _, m in toBeMoved do
			if clone then
				m:Clone().Parent = parent
			else
				m.Parent = parent
			end
		end
	end)

	if not success then
		warn("Parentinator Error: ", err)
		ChangeHistoryService:FinishRecording(recording, Enum.FinishRecordingOperation.Cancel)
		ToastNotifications.CreateToast("ErrorToast", "Something went wrong", err, THONK_ICON, 7)
	else
		ChangeHistoryService:FinishRecording(recording, Enum.FinishRecordingOperation.Commit)
	end
	recording = nil
end

local MoveToServiceButton =
	toolbar:CreateButton("Move selection to Service", "Move the selected instances to a service", MOVE_TO_SERVICE_ICON)
local CopyToServiceButton =
	toolbar:CreateButton("Copy selection to Service", "Copy the selected instances to a service", COPY_TO_SERVICE_ICON)
local MoveToParentButton =
	toolbar:CreateButton("Move selection to Parent", "Move the selected instances to a parent", MOVE_TO_PARENT_ICON)
local CopyToParentButton =
	toolbar:CreateButton("Copy selection to Parent", "Copy the selected instances to a parent", COPY_TO_PARENT_ICON)

MoveToServiceButton.ClickableWhenViewportHidden = true
CopyToServiceButton.ClickableWhenViewportHidden = true
MoveToParentButton.ClickableWhenViewportHidden = true
CopyToParentButton.ClickableWhenViewportHidden = true

local CancelButton: PluginToolbarButton

local Services = {
	"Workspace",
	"Lighting",
	"MaterialService",
	"ReplicatedFirst",
	"ReplicatedStorage",
	"ServerScriptService",
	"ServerStorage",
	"StarterGui",
	"StarterPack",
	"StarterPlayer",
	"StarterPlayer/StarterCharacterScripts",
	"StarterPlayer/StarterPlayerScripts",
	"Teams",
	"SoundService",
	"TextChatService",
}
local ServicesMenu = plugin:CreatePluginMenu("ParentinatorMenu", "Parentinator")

for _, s in ipairs(Services) do
	local serviceName = string.split(s, "/")[1]
	ServicesMenu:AddNewAction(s, serviceName, StudioService:GetClassIcon(serviceName).Image)
end

local pickingParent = false
local newParentToast: any
local selectionChangedConnection: RBXScriptConnection?
function CancelParentPicking()
	if not pickingParent then
		return
	end
	pickingParent = false
	if newParentToast then
		newParentToast.CancelToast()
		newParentToast = nil
	end
	if selectionChangedConnection then
		selectionChangedConnection:Disconnect()
		selectionChangedConnection = nil
	end
	CancelButton.Enabled = false
	MoveToParentButton.Enabled = false
	MoveToParentButton.Enabled = true
	CopyToParentButton.Enabled = false
	CopyToParentButton.Enabled = true
	MoveToParentButton:SetActive(false)
	CopyToParentButton:SetActive(false)
	MoveToServiceButton.Enabled = false
	MoveToServiceButton.Enabled = true
	CopyToServiceButton.Enabled = false
	CopyToServiceButton.Enabled = true
	MoveToServiceButton:SetActive(false)
	CopyToServiceButton:SetActive(false)
end

CancelButton = toolbar:CreateButton("Cancel picking parent", "Cancel picking the parent for the instances", CANCEL_ICON)
CancelButton.ClickableWhenViewportHidden = true
CancelButton.Enabled = false
CancelButton.Click:Connect(CancelParentPicking)

function ToServiceCallback(clone: boolean)
	local selectedInstances = Selection:Get()
	if #selectedInstances == 0 then
		ToastNotifications.CreateToast(
			"ErrorToast",
			"Select an object first",
			"and then press the button",
			THONK_ICON,
			3
		)
		MoveToServiceButton.Enabled = false
		MoveToServiceButton.Enabled = true
		CopyToServiceButton.Enabled = false
		CopyToServiceButton.Enabled = true
		MoveToServiceButton:SetActive(false)
		CopyToServiceButton:SetActive(false)
		return
	end
	local selected = ServicesMenu:ShowAsync()
	if selected then
		local splitId = selected.ActionId:split("_")
		local serviceId = splitId[#splitId]
		local service = string.split(serviceId, "/")[1]
		local newParent = game:GetService(service)
		if service == "StarterPlayer" then
			local subService = string.split(serviceId, "/")[2]
			if subService ~= nil then
				newParent = (StarterPlayer :: any)[subService]
			end
		end
		MoveObjectsToParent(Selection:Get(), newParent, clone)
	end
	MoveToServiceButton.Enabled = false
	MoveToServiceButton.Enabled = true
	CopyToServiceButton.Enabled = false
	CopyToServiceButton.Enabled = true
	MoveToServiceButton:SetActive(false)
	CopyToServiceButton:SetActive(false)
end

function WaitForNewParentCallback(clone: boolean)
	local selectedInstances = Selection:Get()
	if #selectedInstances == 0 then
		ToastNotifications.CreateToast(
			"ErrorToast",
			"Select an object first",
			"and then press the button",
			THONK_ICON,
			3
		)
		MoveToParentButton.Enabled = false
		MoveToParentButton.Enabled = true
		CopyToParentButton.Enabled = false
		CopyToParentButton.Enabled = true
		MoveToParentButton:SetActive(false)
		CopyToParentButton:SetActive(false)
		return
	end
	newParentToast = ToastNotifications.CreateToast(
		"ParentTooltip",
		"Pick new parent",
		"press esc to cancel",
		PICK_PARENT_ICON,
		5000
	)
	pickingParent = true
	selectionChangedConnection = Selection.SelectionChanged:Connect(function()
		local selected = Selection:Get()
		if #selected > 0 then
			CancelParentPicking()
			MoveObjectsToParent(selectedInstances, selected[1], clone)
		end
	end)
	CancelButton.Enabled = true
	MoveToParentButton.Enabled = false
	CopyToParentButton.Enabled = false
	MoveToServiceButton.Enabled = false
	CopyToServiceButton.Enabled = false
end

MoveToServiceButton.Click:Connect(function()
	ToServiceCallback(false)
end)
CopyToServiceButton.Click:Connect(function()
	ToServiceCallback(true)
end)

MoveToParentButton.Click:Connect(function()
	WaitForNewParentCallback(false)
end)
CopyToParentButton.Click:Connect(function()
	WaitForNewParentCallback(true)
end)

-- local Mouse = plugin:GetMouse()
-- plugin:Activate(true)
-- Mouse.Icon = "rbxasset://SystemCursors/Wait"

-- local selectParentToast =
-- 	ToastNotifications.CreateToast("ParentTooltip", "Pick new parent", "press esc to cancel", PICK_PARENT_ICON, 5000)
-- selectParentToast.HideToast()
