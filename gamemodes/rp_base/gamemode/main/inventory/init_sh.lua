rp.meta = rp.meta or {}
rp.meta.item = rp.meta.item or {}
rp.meta.inventory = rp.meta.inventory or {}
rp.db = rp.db or {}
rp.net = rp.net or {}

rp.item = rp.item or {}
rp.item.shop = {}

rp.include_dir("main/inventory/hooks")
rp.include_dir("main/inventory/derma")

rp.include(GM.FolderName.."/gamemode/main/inventory/libs/makethings_sh.lua")
rp.include(GM.FolderName.."/gamemode/main/inventory/libs/makethings_sv.lua")
rp.include(GM.FolderName.."/gamemode/main/inventory/libs/char_sh.lua")
rp.include(GM.FolderName.."/gamemode/main/inventory/libs/netstream2_sh.lua")
rp.include(GM.FolderName.."/gamemode/main/inventory/libs/networking_cl.lua")
rp.include(GM.FolderName.."/gamemode/main/inventory/libs/networking_sv.lua")
rp.include(GM.FolderName.."/gamemode/main/inventory/libs/datebase_sv.lua")
rp.include(GM.FolderName.."/gamemode/main/inventory/libs/util_sh.lua")
rp.include(GM.FolderName.."/gamemode/main/inventory/libs/item_sh.lua")

rp.include_dir("main/inventory/meta")