export PYLONSD_P2P_PERSISTENT_PEERS="762470be4082ae197feb82e50f7c50bfd79a0db8@141.95.65.26:44657,2bebe6b738e849ad7355c05c4b645c381e76b774@65.108.203.219:26656"
set -eo pipefail

cd proto
buf mod update
cd ..

# Function updates the config based on a jq argument as a string
update_test_genesis () {
    # EX: update_test_genesis '.consensus_params["block"]["max_gas"]="100000000"'
    cat $HOME/config/genesis.json | jq --arg DENOM "$2" "$1" > $HOME/config/tmp_genesis.json && mv $HOME/config/tmp_genesis.json $HOME/config/genesis.json
}
# Allocate genesis accounts (cosmos formatted addresses)
$BINARY add-genesis-account $KEY "1000000000000${DENOM}" --keyring-backend $KEYRING --home $HOME

$BINARY add-genesis-account $KEY1 "1000000000000${DENOM}" --keyring-backend $KEYRING --home $HOME
