package keeper

import (
	"github.com/informalsystems/hermes-ibc-workshop/chains/mars/x/mars/types"
)

var _ types.QueryServer = Keeper{}
