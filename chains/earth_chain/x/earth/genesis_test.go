package earth_test

import (
	"testing"

	keepertest "github.com/informalsystems/hermes-ibc-workshop/chains/earth/testutil/keeper"
	"github.com/informalsystems/hermes-ibc-workshop/chains/earth/x/earth"
	"github.com/informalsystems/hermes-ibc-workshop/chains/earth/x/earth/types"
	"github.com/stretchr/testify/require"
)

func TestGenesis(t *testing.T) {
	genesisState := types.GenesisState{
		// this line is used by starport scaffolding # genesis/test/state
	}

	k, ctx := keepertest.EarthKeeper(t)
	earth.InitGenesis(ctx, *k, genesisState)
	got := earth.ExportGenesis(ctx, *k)
	require.NotNil(t, got)

	// this line is used by starport scaffolding # genesis/test/assert
}
