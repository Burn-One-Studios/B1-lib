function B1.requestAnimDict(animDict)
    if HasAnimDictLoaded(animDict) then return end
    if type(animSet) ~= "string" then B1.log("warn", ("expected animDict type to be 'string'. (received: %s)"):format(type(animDict))) return end

	RequestAnimDict(animDict)
	while not HasAnimDictLoaded(animDict) do Wait(0) end
end

function B1.requestAnimSet(animSet)
    if HasAnimSetLoaded(animSet) then return end
    if type(animSet) ~= "string" then B1.log("warn", ("expected animSet type to be 'string'. (received: %s)"):format(type(animSet))) return end

	RequestAnimSet(animSet)
	while not HasAnimSetLoaded(animSet) do Wait(0) end
end

function B1.requestModel(model)
    if type(model) ~= "number" then model = joaat(model) end
    if HasModelLoaded(model) then return end
    if not IsModelValid(model) then B1.log("warn", ("attempt to request an invalid model (%s)"):format(model)) return end

    RequestModel(model)
	while not HasAnimSetLoaded(animSet) do Wait(0) end
end

function B1.requestPtfxAsset(ptFx)
    if HasNamedPtfxAssetLoaded(ptFx) then return end
    if type(ptFx) ~= "string" then B1.log("warn", ("expected ptFx type to be 'string'. (received: %s)"):format(type(ptFx))) return end

    RequestNamedPtfxAsset(ptFx)
	while not HasNamedPtfxAssetLoaded(ptFx) do Wait(0) end
end

function B1.requestScaleformMovie(scaleform)
    if HasScaleformMovieLoaded(scaleform) then return end
    if type(scaleform) ~= "string" then B1.log("warn", ("expected scaleform type to be 'string'. (received: %s)"):format(type(scaleform))) return end

    RequestScaleformMovie(scaleform)
	while not HasScaleformMovieLoaded(scaleform) do Wait(0) end
end

function B1.requestStreamedTextureDict(textureDict)
    if HasStreamedTextureDictLoaded(textureDict) then return end
    if type(textureDict) ~= "string" then B1.log("warn", ("expected textureDict type to be 'string'. (received: %s)"):format(type(textureDict))) return end

    RequestStreamedTextureDict(textureDict)
	while not HasStreamedTextureDictLoaded(textureDict) do Wait(0) end
end