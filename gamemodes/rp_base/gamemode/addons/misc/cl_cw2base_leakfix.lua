-- "gamemodes\\rp_base\\gamemode\\addons\\misc\\cl_cw2base_leakfix.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
timer.Create("Cw2_W8_Loading", 1, 0, function()
    if not CustomizableWeaponry then return end
    timer.Remove("Cw2_W8_Loading")

    timer.Simple(5, function()
        local table_remove = table.remove
        CustomizableWeaponry.cmodels = CustomizableWeaponry.cmodels or {}
        CustomizableWeaponry.cmodels.curModels = CustomizableWeaponry.cmodels.curModels or {}
        local bad_mds = {"upgrades", "attachments", "models/c_cod4", "models/v_cod4", "models/c_fas2", "models/v_fas2", "v_cw_fraggrenade", "models/loyalists/codol/public", "models/loyalists/codol/arms", "_vm.mdl", "models/v_", "models/weapons/v_"}

        function CustomizableWeaponry.cmodels:add(model, wep, args)
            model.wepParent = wep
            self.curModels[#self.curModels + 1] = model

            model.is_attachment = args and args[3]
        end
        
        local function IsShietMdl(model)
            local swep = model.wepParent
            local ply = IsValid(swep) and swep.Owner

            if IsValid(ply) and ply ~= LocalPlayer() then
                if model.is_attachment then return true end
                local mdl = model:GetModel()

                for _, bad in pairs(bad_mds) do
                    if string.find(mdl, bad) then return true end
                end
            end

            return false
        end

        function CustomizableWeaponry.cmodels:validate()
            local removalIndex = 1 -- increment the removalIndex value every time we don't remove an index, since table.remove reorganizes the table

            for i = 1, #self.curModels do
                local cmodel = self.curModels[removalIndex]

                if not IsValid(cmodel.wepParent) or IsShietMdl(cmodel) then
                    --print("Removed: ", cmodel:GetModel(), "Valid: ", IsValid(swep))
                    SafeRemoveEntity(cmodel)
                    table_remove(self.curModels, removalIndex)
                else
                    removalIndex = removalIndex + 1
                end
            end
        end

        timer.Create("Customizable Weaponry 2.0 CModel Manager", 15, 0, function()
            CustomizableWeaponry.cmodels:validate()
        end)
    end)
end)