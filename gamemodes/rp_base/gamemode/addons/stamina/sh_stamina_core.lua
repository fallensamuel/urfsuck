-- "gamemodes\\rp_base\\gamemode\\addons\\stamina\\sh_stamina_core.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
STAMINA_DISABLED = rp.cfg.DisableStamina;

STAMINA_NETMESSAGE = "Stamina.Variable";

STAMINA_DMG   = 0;
STAMINA_MAX   = 1;
STAMINA_VAL   = 2;

STAMINA_RATE = rp.cfg.StaminaRate or 5;
STAMINA_RESTORE_TIME = rp.cfg.StaminaRestoreTime or 5;
STAMINA_MAX_MULTIPLIER = rp.cfg.MaxStamina or 130;
