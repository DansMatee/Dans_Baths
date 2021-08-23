MenuData = {}
TriggerEvent("redemrp_menu_base:getData",function(call)
    MenuData = call
end)

local locations = {
    { x=-317.22, y=763.02, z=117.43 }, -- Valentine Baths
    { x= -1811.12, y= -372.63, z= 166.49 }, -- Strawberry
    { x= -824.03, y= -1319.68, z= 43.67 }, -- Blackwater
    { x= 2628.54, y= -1223.11, z= 59.58 }, -- Saint Denis
    { x= 2951.44, y= 1334.80, z= 44.45 }, -- Annesburg
}

local active = false
local ShopPrompt
local hasAlreadyEnteredMarker, lastZone
local currentZone = nil

function SetupShopPrompt()
    Citizen.CreateThread(function()
        local str = 'Baths'
        ShopPrompt = PromptRegisterBegin()
        PromptSetControlAction(ShopPrompt, 0xE8342FF2)
        str = CreateVarString(10, 'LITERAL_STRING', str)
        PromptSetText(ShopPrompt, str)
        PromptSetEnabled(ShopPrompt, false)
        PromptSetVisible(ShopPrompt, false)
        PromptSetHoldMode(ShopPrompt, true)
        PromptRegisterEnd(ShopPrompt)
    end)
end

AddEventHandler('dans_smolstuff_bath:client:hasEnteredMarker', function(zone)
    currentZone = zone
end)

AddEventHandler('dans_smolstuff_bath:client:hasExitedMarker', function(zone)
    if active == true then
        PromptSetEnabled(ShopPrompt, false)
        PromptSetVisible(ShopPrompt, false)
        active = false
    end
	currentZone = nil
end)

Citizen.CreateThread(function()
    SetupShopPrompt()
    while true do
        Citizen.Wait(0)
        local player = PlayerPedId()
        local coords = GetEntityCoords(player)
        local isInMarker, currentZone = false

        for k,v in ipairs(locations) do
            if (Vdist(coords.x, coords.y, coords.z, v.x, v.y, v.z) < 1.5) then
                isInMarker  = true
                currentZone = 'locations'
                lastZone    = 'locations'
            end
        end

		if isInMarker and not hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = true
			TriggerEvent('dans_smolstuff_bath:client:hasEnteredMarker', currentZone)
		end

		if not isInMarker and hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = false
			TriggerEvent('dans_smolstuff_bath:client:hasExitedMarker', lastZone)
		end

    end
end)

Citizen.CreateThread(function()
	while true do
        Citizen.Wait(0)
        if currentZone then
            if active == false then
                PromptSetEnabled(ShopPrompt, true)
                PromptSetVisible(ShopPrompt, true)
                active = true
            end
            if PromptHasHoldModeCompleted(ShopPrompt) then
                Baths()
                         
                PromptSetEnabled(ShopPrompt, false)
                PromptSetVisible(ShopPrompt, false)
                active = false

				currentZone = nil
			end
        else
			Citizen.Wait(500)
		end
	end
end)

function Baths()
    MenuData.CloseAll()
    local elements = {

            {label = "Quick Dip - $0.50", value = 'quick' , desc = "A Quick rinse off."},
            {label = "Deep Clean - $2.50", value = 'deep' , desc = "A full body scrub."},
    }

    MenuData.Open('default', GetCurrentResourceName(), 'dans_bath', {
        title    = 'Baths',                   
        subtext    = '',
        align    = 'top-left',
        elements = elements,
    }, function(data, menu)
                if(data.current.value == 'quick') then
                    local type = 'quick'
                    TriggerServerEvent('dans_smolstuff_bath:server:pay', 0.5, type)
                elseif(data.current.value == 'deep') then                   
                    local type = 'deep'
                    TriggerServerEvent('dans_smolstuff_bath:server:pay', 2.5, type)
                end
        end,
            
        function(data, menu)
            menu.close()
        end)
    
end

RegisterNetEvent('dans_smolstuff_bath:client:clean')	
AddEventHandler('dans_smolstuff_bath:client:clean', function(type)
    if(type == 'quick') then
        ClearPedEnvDirt(GetPlayerPed())
        ClearPedWetness(GetPlayerPed())
    elseif(type == 'deep') then
        ClearPedBloodDamage(GetPlayerPed())
        ClearPedEnvDirt(GetPlayerPed())
        ClearPedWetness(GetPlayerPed())
        ClearPedDamageDecalByZone(GetPlayerPed(), 10, "ALL")
    end
end)

local blips = {
    { name = 'Baths', sprite = 944812202, x= -317.22, y= 763.02, z= 117.43 }, -- Valentine
    { name = 'Baths', sprite = 944812202, x= -1811.12, y= -372.63, z= 166.49 }, -- Strawberry
    { name = 'Baths', sprite = 944812202, x= -824.03, y= -1319.68, z= 43.67 }, -- Blackwater
    { name = 'Baths', sprite = 944812202, x= 2628.54, y= -1223.11, z= 59.58 }, -- Saint Denis
    { name = 'Baths', sprite = 944812202, x= 2951.44, y= 1334.80, z= 44.45 }, -- Annesburg
}

Citizen.CreateThread(function()
	for _, info in pairs(blips) do
        local blip = N_0x554d9d53f696d002(1664425300, info.x, info.y, info.z)
        SetBlipSprite(blip, info.sprite, 1)
		SetBlipScale(blip, 0.2)
		Citizen.InvokeNative(0x9CB1A1623062F402, blip, info.name)
    end  
end)