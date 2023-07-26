

install libs 
forge install smartcontractkit/chainlink-brownie-contracts@0.6.1 --no-commit

Run test with console logs

forge test -vv

Deploy a contract to local chain in foundry

forge script script/DeployFundMe.sol

Run a single test function 
forge test --mt testOwnerIsMessageSender   

Test Coverage 
forge coverage  --fork-url $SEPOLIA_RPC_URL

