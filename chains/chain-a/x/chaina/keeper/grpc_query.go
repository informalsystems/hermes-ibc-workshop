package keeper

import (
	"github.com/andynog/chaina/x/chaina/types"
)

var _ types.QueryServer = Keeper{}
