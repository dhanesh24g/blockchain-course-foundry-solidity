-include .env

fbuild:
	forge build


deploy-sepolia:
	forge script script/DeployFundMe.s.sol --tc DeployFundMe --rpc-url $(SEPOLIA_RPC_URL) --private-key $(PRIVATE_KEY) --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY) -vvvv