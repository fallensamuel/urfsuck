
if not rp.cfg.Skybox then return end

local day = rp.cfg.Skybox.Day
local night = rp.cfg.Skybox.Night

local SourceSkyname = rp.cfg.Skybox[game.GetMap()] and rp.cfg.Skybox[game.GetMap()].Default or 'skybox/sky24';

local SourceSkyPre  = SourceSkyPre or {"lf","ft","rt","bk","dn","up",}
local SourceSkyMat  = SourceSkyMat or {

    Material(SourceSkyname.."lf"),

    Material(SourceSkyname.."ft"),

    Material(SourceSkyname.."rt"),

    Material(SourceSkyname.."bk"),

    Material(SourceSkyname.."dn"),

    Material(SourceSkyname.."up"),

}

function changeSkybox(skyboxname)
    for i = 1,6 do
        SourceSkyMat[i]:SetTexture("$basetexture", skyboxname.. SourceSkyPre[i])
        SourceSkyMat[i]:SetTexture("$hdrbaseTexture", skyboxname.. SourceSkyPre[i])
        SourceSkyMat[i]:SetTexture("$hdrcompressedTexture", skyboxname.. SourceSkyPre[i])
    end
end

function updateSkybox()
	if nw.GetGlobal('IsDay') then
		changeSkybox(day)
	else
		changeSkybox(night)
	end
end

//updateSkybox()
//hook.Add("DayNightChanged", updateSkybox)