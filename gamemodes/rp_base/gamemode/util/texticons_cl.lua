-- "gamemodes\\rp_base\\gamemode\\util\\texticons_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal

cvar.Register('text_texture_render')
	:SetDefault(true)
	:AddMetadata('State', 'RPMenu')
	:AddMetadata('Menu', translates.Get('Оптимизация текста'))

local cvar_Get = cvar.GetValue

TextIcons       = TextIcons or {};
TextIcons.Cache = TextIcons.Cache or {};

TextIcons.PATH_CACHE = "texticons/";


if not file.IsDir( TextIcons.PATH_CACHE, "DATA" ) then
    file.CreateDir( TextIcons.PATH_CACHE );
end


local renderTarget = GetRenderTargetEx(
    "urf_txticons_renderer" .. SysTime(),
    2048, 2048,
    RT_SIZE_NO_CHANGE,
    MATERIAL_RT_DEPTH_NONE,
    bit.bor(16),
    0,
    IMAGE_FORMAT_RGBA8888
);


local renderThread;
local renderQueue = {};
local proccessQueue = {}

local mat, filepath, r_w, r_h
local white_color = Color(255, 255, 255, 255)
local nil_color = Color(0,0,0,0);

local surface_SetDrawColor = surface.SetDrawColor
local surface_SetMaterial = surface.SetMaterial
local surface_DrawTexturedRect = surface.DrawTexturedRect

local draw_SimpleText = draw.SimpleText
local draw_SimpleTextOutlined = draw.SimpleTextOutlined

local draw_func
local function DefaultDrawer(text, font, outline_width, outline_color)
	draw_func = outline_width and draw_SimpleTextOutlined or draw_SimpleText
	--print(text, font, outline_width, outline_color)
	return draw_func(text, font, 0, 0, white_color, nil, nil, outline_width, outline_color)
end

local function ProcessRenderQueue()
    local k, v = next( renderQueue );

    coroutine.yield();

    if not k then
        hook.Remove( "HUDPaint", "TextIcons::RenderThread" );
    else
        table.remove( renderQueue, k );
        
        local m, w, h = TextIcons.Render( v.text, v.font, v.drawer or DefaultDrawer, v.outline_width, v.outline_color );

        if v.callback then
            v.callback( m, w, h );
        end
    end
end

local function InitializeRenderQueue()
    hook.Add( "HUDPaint", "TextIcons::RenderThread", function()
        if
            not renderThread or
            not coroutine.resume(renderThread)
        then
            renderThread = coroutine.create( ProcessRenderQueue );
            coroutine.resume( renderThread );        
        end
    end );
end

TextIcons.GetFilePath = function( text, font )
    return TextIcons.PATH_CACHE .. util.CRC( text .. font ) .. ".png";
end

TextIcons.Add = function( text, font, callback, drawer, outline_width, outline_color )
    local filepath = TextIcons.GetFilePath( text, font );

	--print("Add", outline_width, outline_color)
	
    table.insert( renderQueue, {
        text			= text,
        font			= font,
		drawer			= drawer,
		outline_width	= outline_width,
		outline_color	= outline_color,
        callback		= callback
    } );

    if #renderQueue == 1 then
        InitializeRenderQueue();
    end
end

TextIcons.Get = function( text, font, callback, forced, drawer, outline_width, outline_color, lifetime )
	if proccessQueue[text .. font] then
        if surface.RegistredFonts[font] then
		    return draw_SimpleText(text, font, 0, 0, nil_color)
        end

        return
	end
	
    local filepath = TextIcons.GetFilePath( text, font );

    if not forced and callback then
        if TextIcons.Cache[filepath] then
			callback(TextIcons.Cache[filepath].material, TextIcons.Cache[filepath].w, TextIcons.Cache[filepath].h)
            return TextIcons.Cache[filepath].w, TextIcons.Cache[filepath].h;
        end

        if file.Exists( filepath, "DATA" ) then
			if lifetime and (os.time() - file.Time( filepath, "DATA" ) > lifetime) then
				return TextIcons.Get( text, font, callback, true, drawer, outline_width, outline_color, lifetime )
			end
			
			local mat = Material( "data/" .. filepath )
			local txt = mat:GetTexture( "$basetexture" )
			
            TextIcons.Cache[filepath] = {
				material = mat,
				w = txt:GetMappingWidth(),
				h = txt:GetMappingHeight(),
			};
			
			callback(TextIcons.Cache[filepath].material, TextIcons.Cache[filepath].w, TextIcons.Cache[filepath].h)
            return txt:GetMappingWidth(), txt:GetMappingHeight();
        end
    end

	--print("Get", outline_width, outline_color)
	
	proccessQueue[text .. font] = true
    TextIcons.Add( text, font, callback, drawer, outline_width, outline_color );

	if surface.RegistredFonts[font] then
        return draw_SimpleText(text, font, 0, 0, nil_color)
    end
end

TextIcons.Render = function( text, font, drawer, outline_width, outline_color )
    filepath = TextIcons.GetFilePath( text, font );
	
    render.PushRenderTarget( renderTarget );
        render.Clear( 0, 0, 0, 0 );
        render.ClearDepth();

        cam.Start2D();
			--print("Render", outline_width, outline_color)
			r_w, r_h = drawer(text, font, outline_width, outline_color)
        cam.End2D();

        file.Write(
            filepath,
            render.Capture( {
                format = "png", x = 0, y = 0, w = r_w, h = r_h
            } )
        );
    render.PopRenderTarget();
	
	--print("Save", filepath)
	
    mat = Material( "data/" .. filepath )
	
    TextIcons.Cache[filepath] = {
		material = mat,
		w = r_w,
		h = r_h,
	};
    
	--print("Unset", text, font)
	
	proccessQueue[text .. font] = nil
	
	--print("Done", mat, r_w, r_h)
	
    return mat, r_w, r_h;
end

draw.TextTexture = function(text, font, x, y, color, xAlign, yAlign, outline_width, outline_color, lifetime)
	if not cvar_Get('text_texture_render') then 
		draw_func = outline_width and draw_SimpleTextOutlined or draw_SimpleText
		return draw_func(text, font, x, y, color, xAlign, yAlign, outline_width, outline_color)
	end
	
	if proccessQueue[text .. font] then return end
	
	x = x or 0
	y = y or 0
	
	color = color or white_color
	
	xAlign = xAlign or TEXT_ALIGN_LEFT
	yAlign = yAlign or TEXT_ALIGN_TOP
	
	return TextIcons.Get(text, font or "DermaDefault", function(m, w, h) 
		x = x - (xAlign == TEXT_ALIGN_RIGHT and w or xAlign == TEXT_ALIGN_CENTER and w * 0.5 or 0)
		y = y - (yAlign == TEXT_ALIGN_BOTTOM and h or yAlign == TEXT_ALIGN_CENTER and h * 0.5 or 0)
		
		surface_SetDrawColor(color)
		surface_SetMaterial(m)
		surface_DrawTexturedRect(x, y, w, h)
	end, nil, nil, outline_width, outline_color, lifetime)
end

draw.CustomTexture = function(uid, x, y, color, func, forced, xAlign, yAlign, lifetime)
	if proccessQueue[uid] then return end
	
	x = x or 0
	y = y or 0
	
	color = color or white_color
	
	xAlign = xAlign or TEXT_ALIGN_LEFT
	yAlign = yAlign or TEXT_ALIGN_TOP
	
	return TextIcons.Get('', uid, function(m, w, h) 
		x = x - (xAlign == TEXT_ALIGN_RIGHT and w or xAlign == TEXT_ALIGN_CENTER and w * 0.5 or 0)
		y = y - (yAlign == TEXT_ALIGN_BOTTOM and h or yAlign == TEXT_ALIGN_CENTER and h * 0.5 or 0)
		
		surface_SetDrawColor(color)
		surface_SetMaterial(m)
		surface_DrawTexturedRect(x, y, w, h)
	end, forced or false, func, nil, nil, lifetime)
end


-- Garbage collector
hook.Add("HUDPaint", "TextIcons::HUDPaint", function()
	hook.Remove("HUDPaint", "TextIcons::HUDPaint")
	
	local images = file.Find( TextIcons.PATH_CACHE .. '*.png', 'DATA' )
	local lifetime = 60 * 60 * 24 * 30;
	
	for k, v in pairs(images) do
		if os.time() - file.Time( TextIcons.PATH_CACHE .. v, "DATA" ) > lifetime then
			file.Delete( TextIcons.PATH_CACHE .. v )
		end
	end
end)
