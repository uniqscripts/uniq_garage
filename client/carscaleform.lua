-- all credits to: https://gist.github.com/ihyajb/3c518c56b3c5b2dd63e96b91e93f3277

local VehicleNames = lib.load('config.vehicles')
local VehInfo = lib.load('config.general').VehicleScaleFormInfo

if not VehInfo then return end

local BeginScaleformMovieMethod = BeginScaleformMovieMethod
local PushScaleformMovieMethodParameterString = PushScaleformMovieMethodParameterString
local PushScaleformMovieFunctionParameterFloat = PushScaleformMovieFunctionParameterFloat
local PushScaleformMovieFunctionParameterInt = PushScaleformMovieFunctionParameterInt
local PushScaleformMovieMethodParameterBool = PushScaleformMovieMethodParameterBool
local EndScaleformMovieMethod = EndScaleformMovieMethod

local DrawScaleformMovie_3dSolid = DrawScaleformMovie_3dSolid
local GetEntityCoords = GetEntityCoords
local GetFinalRenderedCamRot = GetFinalRenderedCamRot


--? [BRAND] = YTD_NAME (Support for custom logos and shit)?--
local RandomBrands = {
    ['LCC'] = 'MPCarHUD2',
    ['GROTTI_2'] = 'MPCarHUD2',
    ['PROGEN'] = 'MPCarHUD2',
    ['RUNE'] = 'MPCarHUD2',

    ['VYSSER'] = 'MPCarHUD3',
    ['MAXWELL'] = 'MPCarHUD4',
}

local RequestedYTDs = {'MPCarHUD', 'MPCarHUD2', 'MPCarHUD3', 'MPCarHUD4'}

local function LocateBrandYTD(model)
    local YTD = 'MPCarHUD'
    local brand = GetLabelText(GetMakeNameFromVehicleModel(model))

    --! Stupid Failsafe or whatever !--
    if brand == 'NULL' then
        return {
            YTD = '',
            name = ''
        }
    end

    if RandomBrands[brand] then YTD = RandomBrands[brand] end

    return {
        YTD = YTD,
        name = brand
    }
end

--? I have no idea if any of this is right lol
local function func_7045(vehicle)
    local VehicleData = {}
    local model = GetEntityModel(vehicle)

    VehicleData.MaxSpeed = GetVehicleEstimatedMaxSpeed(vehicle) * 2.236936 / 1.2
    VehicleData.MaxAcceleration = GetVehicleAcceleration(vehicle) * 200
    VehicleData.MaxBreaking = GetVehicleMaxBraking(vehicle) * 100 / 2.5
    VehicleData.Traction = GetVehicleMaxTraction(vehicle) * 100 / 3.5
    VehicleData.Name = GetLabelText(GetDisplayNameFromVehicleModel(model))
    VehicleData.Brand = LocateBrandYTD(model)

    if VehicleData.Name == 'NULL' then
        if VehicleNames[model] then
            VehicleData.Name = VehicleNames[model].name
        end
    end

    if VehicleData.Brand.name == '' then
        if VehicleNames[model] then
            VehicleData.Brand.name = VehicleNames[model].brand
        end
    end

    return VehicleData
end

local function CallScaleformMethod(scaleform, method, ...)
	local t
	local args = { ... }

	BeginScaleformMovieMethod(scaleform, method)
	for k, v in ipairs(args) do
		t = type(v)
		if t == 'string' then
			PushScaleformMovieMethodParameterString(v)
		elseif t == 'number' then
			if string.match(tostring(v), "%.") then
				PushScaleformMovieFunctionParameterFloat(v)
			else
				PushScaleformMovieFunctionParameterInt(v)
			end
		elseif t == 'boolean' then
			PushScaleformMovieMethodParameterBool(v)
		end
	end
	EndScaleformMovieMethod()
end

local function GetStatSlot(a)
    local base = 'MP_CAR_STATS_'
    local offset = '0'
    if a >= 10 then
        offset = ''
    end
    return tostring(base..''..offset..''..a)
end

local function UnloadAll(VehicleArray)
    for i = 1, #VehicleArray, 1 do
        SetScaleformMovieAsNoLongerNeeded(VehicleArray.scaleform)
    end

    for _, v in ipairs(RequestedYTDs) do
        SetStreamedTextureDictAsNoLongerNeeded(v)
    end
end

local ScaleForm = {}
local VehicleArray = {}


function ScaleForm.VehicleStatus(vehicles)
    for _, v in ipairs(RequestedYTDs) do
        RequestStreamedTextureDict(v, false)
    end

    for i = 1, #vehicles do
        VehicleArray[#VehicleArray + 1] = {
            entity = vehicles[i],
            data = func_7045(vehicles[i]),
            scaleform = lib.requestScaleformMovie(GetStatSlot(i))
        }
    end

    ScaleForm.interval = SetInterval(function()
        for i = 1, #VehicleArray, 1 do
            if DoesEntityExist(VehicleArray[i].entity) then
                local vehicleCoords = GetEntityCoords(VehicleArray[i].entity)
                local dist = #(GetEntityCoords(cache.ped) - vehicleCoords)

                if dist < 3 then
                    local CamRot = GetFinalRenderedCamRot(2)
                    CallScaleformMethod(VehicleArray[i].scaleform,
                        'SET_VEHICLE_INFOR_AND_STATS',
                        VehicleArray[i].data.Brand.name..
                        ' '
                        ..VehicleArray[i].data.Name,
                        ' ',
                        VehicleArray[i].data.Brand.YTD,
                        VehicleArray[i].data.Brand.name,
                        "Top Speed",
                        "Acceleration",
                        "Braking",
                        "Traction",
                        VehicleArray[i].data.MaxSpeed,
                        VehicleArray[i].data.MaxAcceleration,
                        VehicleArray[i].data.MaxBreaking,
                        VehicleArray[i].data.Traction
                    )
                    DrawScaleformMovie_3dSolid(VehicleArray[i].scaleform,
                        vehicleCoords.x, vehicleCoords.y, vehicleCoords.z + 3,
                        CamRot.x, 0.0, CamRot.z,
                        0.0, 1.0, 0.0,
                        6.0, 4.0, 5.0,
                        0
                    )
                end
            end
        end
    end)
end

function ScaleForm.HideVehicleStatus()
    if ScaleForm.interval then
        ClearInterval(ScaleForm.interval)
        UnloadAll(VehicleArray)

        ScaleForm.interval = nil
        VehicleArray = {}
    end
end

return ScaleForm