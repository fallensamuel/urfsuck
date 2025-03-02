local DATA = {}

DATA.Name = "Melee Combination"
DATA.HoldType = "melee-combo"
DATA.BaseHoldType = "normal"
DATA.Translations = {}

DATA.Translations[ ACT_MP_STAND_IDLE ]					= "wave"
DATA.Translations[ ACT_MP_WALK ]						= "wave"
--DATA.Translations[ ACT_MP_RUN ]							= 2685
--DATA.Translations[ ACT_MP_CROUCH_IDLE ]					= ACT_HL2MP_IDLE_CROUCH_KNIFE 
--DATA.Translations[ ACT_MP_CROUCHWALK ]					= ACT_HL2MP_WALK_CROUCH_KNIFE
----DATA.Translations[ ACT_MP_ATTACK_STAND_PRIMARYFIRE ]	= 2688
--DATA.Translations[ ACT_MP_ATTACK_CROUCH_PRIMARYFIRE ]	= ACT_HL2MP_GESTURE_RANGE_ATTACK_KNIFE 
--DATA.Translations[ ACT_MP_RELOAD_STAND ]				= IdleActivity + 6
--DATA.Translations[ ACT_MP_RELOAD_CROUCH ]				= IdleActivity + 6
--DATA.Translations[ ACT_MP_JUMP ]						= 3160
--DATA.Translations[ ACT_MP_SWIM ]						= IdleActivity + 9
--DATA.Translations[ ACT_LAND ]							= ACT_LAND

wOS.AnimExtension:RegisterHoldtype( DATA )