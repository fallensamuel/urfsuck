-- "gamemodes\\rp_base\\gamemode\\util\\errormat_protect_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local function checkErrorMaterial()
    local errorMat = Material( "___error" );
    local errorTex = errorMat:GetTexture( "$basetexture" );

    if errorTex and not errorTex:IsErrorTexture() then
        ErrorNoHalt(
            "[ERROR] Какой-то скрипт перезаписывает эмотекстуру!\n" ..
            "  - " .. tostring( errorMat ) .. "\n" ..
            "  - " .. tostring( errorTex ) .. "\n"
        );
    end
end

if not rp.cfg.NoErrorMatCheck then
	timer.Create( "engine.checkErrorMaterial", 10, 0, function()
		checkErrorMaterial();
	end );
end