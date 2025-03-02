-- "gamemodes\\rp_base\\gamemode\\util\\materialdownloader_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local file, Material, Fetch, find = file, Material, http.Fetch, string.find;

local errorMat = Material( "error" );
local WebImageCache = {};

function http.DownloadMaterial( url, path, callback, retry_count )
    if WebImageCache[url] then
        return callback( WebImageCache[url] );
    end

    local data_path = "data/" .. path;

    if file.Exists( path, "DATA" ) then
        local mat = Material( data_path, "smooth noclamp" );

        if not mat:IsError() then
            WebImageCache[url] = mat;
            return callback( mat );
        end
    end

    Fetch( url, function( img )
        if img == nil or find( img, "<!DOCTYPE HTML>", 1, true ) then
            return callback( errorMat );
        end

        file.Write( path, img );

        local mat = Material( data_path, "smooth noclamp" );

        if mat:IsError() and retry_count and retry_count > 0 then
            http.DownloadMaterial( url, path, callback, retry_count - 1 );
            return
        end

        WebImageCache[url] = mat;
        callback( mat );
    end, function()
        if retry_count and retry_count > 0 then
            http.DownloadMaterial( url, path, callback, retry_count - 1 );
            return
        end

        callback( errorMat );
    end );
end