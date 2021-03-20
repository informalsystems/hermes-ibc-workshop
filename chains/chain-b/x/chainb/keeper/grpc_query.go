package keeper

import (
	"github.com/andynog/chainb/x/chainb/types"
)

var _ types.QueryServer = Keeper{}
