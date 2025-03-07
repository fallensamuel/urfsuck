
-- Copyright (c) 2018-2020 TFA Base Devs

-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:

-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.

-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.

--[[Bow Ammo]]
--
game.AddAmmoType({
	name = "tfbow_arrow",
	dmgtype = DMG_CLUB,
	tracer = 0,
	minsplash = 5,
	maxsplash = 5
})
game.AddAmmoType({
	name = "tfbow_bolt",
	dmgtype = DMG_CLUB,
	tracer = 0,
	minsplash = 5,
	maxsplash = 5
})

if CLIENT then
	language.Add("tfbow_arrow_ammo", "Arrows")
	language.Add("tfbow_bolt_ammo", "Bolts")

	if language.GetPhrase("SniperPenetratedRound_ammo") == "SniperPenetratedRound_ammo" then
		language.Add("SniperPenetratedRound_ammo", "Sniper Ammo")
	end

	if language.GetPhrase("AirboatGun_ammo") == "AirboatGun_ammo" then
		language.Add("AirboatGun_ammo", "Winchester Ammo")
	end
end

