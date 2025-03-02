local surface = surface;

surface.RegistredFonts = {};

surface.RegisterFont = surface.RegisterFont or surface.CreateFont;

surface.CreateFont = function( Name, CFontData )
    surface.RegistredFonts[Name] = CFontData;
    surface.RegisterFont( Name, CFontData );
end