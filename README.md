# Foundry fund-me learning source

## Introduction 
I started this project to learn solidity from basic to advance, I followed below youtube url to learn develop this, full thanks goes to Patric.

Youtube : https://www.youtube.com/watch?v=sas02qSFZ74

GitHub : https://github.com/Cyfrin/foundry-full-course-f23

### For only my reference 
install libs 
forge install smartcontractkit/chainlink-brownie-contracts@0.6.1 --no-commit

Run test with console logs

forge test -vv

Deploy a contract to local chain in foundry

forge script script/DeployFundMe.sol

Run a single test function 
forge test --mt testOwnerIsMessageSender   
forge test --mt -vvv testOwnerIsMessageSender   debug
forge test --mt -vv testOwnerIsMessageSender   console

Test Coverage 
forge coverage  --fork-url $SEPOLIA_RPC_URL

Get gas usage report 
forge snapshot 


