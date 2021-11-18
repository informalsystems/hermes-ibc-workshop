package mars_test

import (
	"testing"

	keepertest "github.com/informalsystems/hermes-ibc-workshop/chains/mars/testutil/keeper"
	"github.com/informalsystems/hermes-ibc-workshop/chains/mars/x/mars"
	"github.com/informalsystems/hermes-ibc-workshop/chains/mars/x/mars/types"
	"github.com/stretchr/testify/require"
)

func TestGenesis(t *testing.T) {
	genesisState := types.GenesisState{
		// this line is used by starport scaffolding # genesis/test/state
	}

	k, ctx := keepertest.MarsKeeper(t)
	mars.InitGenesis(ctx, *k, genesisState)
	got := mars.ExportGenesis(ctx, *k)
	require.NotNil(t, got)

	// this line is used by starport scaffolding # genesis/test/assert
}
