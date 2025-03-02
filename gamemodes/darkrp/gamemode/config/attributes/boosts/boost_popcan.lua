local BOOST = {}

BOOST.ID = "popcan";

BOOST.Name = "A can of a tasty soda";
BOOST.Desc = "...tastes like semi-cold strawberry?";

BOOST.Amount 	= 5;

BOOST.Duration  = 10;	 -- in seconds
BOOST.Stackable = true;
BOOST.MaxStacks = 10;

AttributeSystem.Boosts[ BOOST.ID ] = BOOST;