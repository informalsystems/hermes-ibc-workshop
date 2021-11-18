package keeper

import (
	"github.com/informalsystems/hermes-ibc-workshop/chains/earth/x/earth/types"
)

var _ types.QueryServer = Keeper{}
