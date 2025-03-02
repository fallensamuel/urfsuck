rp.AddToCraftTable("rpitem_guns_meh", {
	rp.CraftableItem("rpitem_metal", 2),
	rp.CraftableItem("rpitem_steel", 1),
}, Angle(0, -180, 0))

rp.AddToCraftTable("rpitem_toolkit", {
	rp.CraftableItem("rpitem_metal", 2),
	rp.CraftableItem("rpitem_accum", 1),
}, Angle(0, 90, 0))

rp.AddToCraftTable("lockpick", {
	rp.CraftableItem("rpitem_metal", 2),
	rp.CraftableItem("rpitem_steel", 1),
}, Angle(0.227, 0.358, 48.893))

rp.AddToCraftTable("keypad_cracker", {
	rp.CraftableItem("rpitem_metal", 2),
	rp.CraftableItem("rpitem_steel", 1),
	rp.CraftableItem("rpitem_accum", 1),
}, Angle(0.000, 90.000, 0.000))

rp.AddToCraftTable("swb_pistol", {
	rp.CraftableItem("rpitem_steel", 1),
	rp.CraftableItem("rpitem_guns_meh", 2),
}, Angle(0.000, -180.000, 90.000))

rp.AddToCraftTable("swb_357", {
	rp.CraftableItem("swb_pistol", 1),
	rp.CraftableItem("rpitem_steel", 2),
	rp.CraftableItem("rpitem_guns_meh", 2),
}, Angle(-0.000, -179.994, 90.000))

rp.AddToCraftTable("swb_smg", {
	rp.CraftableItem("swb_pistol", 1),
	rp.CraftableItem("rpitem_guns_meh", 2),
}, Angle(0.000, 90.000, 90.000))

rp.AddToCraftTable("swb_oicw_v2", {
	rp.CraftableItem("swb_smg", 1),
	rp.CraftableItem("rpitem_guns_meh", 5),
}, Angle(-0.000, -180.000, 90.000))

rp.AddToCraftTable("swb_ar2", {
	rp.CraftableItem("rpitem_guns_meh", 3),
	rp.CraftableItem("rpitem_comb_list", 1),
	rp.CraftableItem("rpitem_comb_caps", 1),
	rp.CraftableItem("rpitem_comb_procc", 1),
}, Angle(1.044, -179.734, 90.342))

rp.AddToCraftTable("swb_shotgun", {
	rp.CraftableItem("swb_smg", 1),
	rp.CraftableItem("rpitem_guns_meh", 5),
}, Angle(-1.200, -172.742, 89.979))

rp.AddToCraftTable("swb_ar3", {
	rp.CraftableItem("swb_ar2", 1),
	rp.CraftableItem("rpitem_guns_meh", 4),
	rp.CraftableItem("rpitem_comb_caps", 1),
}, Angle(0.283, -177.954, 69.496))