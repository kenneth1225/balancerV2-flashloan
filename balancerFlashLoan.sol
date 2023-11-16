// SPDX-License-Identifier: UNLICENSED
import "@balancer-labs/v2-interfaces/contracts/vault/IVault.sol";
import "@balancer-labs/v2-interfaces/contracts/vault/IFlashLoanRecipient.sol";
pragma solidity 0.8.7;
contract balancerFlashLoan is IFlashLoanRecipient {

    IERC20 private constant WETH = IERC20(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
    IVault private constant vault = IVault(0xBA12222222228d8Ba445958a75a0704d566BF2C8);
    address private owner;
    constructor() {
        owner = msg.sender;
    }

    receive() external payable {}

    modifier onlyOwner() {
        require(msg.sender == owner, "not owner");
        _;
    }

    function startFlashLoan() external onlyOwner{
        IERC20[] memory tokens = new IERC20[](1);
        uint256[] memory amounts = new uint256[](1);
        bytes memory userData = "";
        tokens[0] = WETH;
        amounts[0] = 999 * (10 ** 18);
        vault.flashLoan(
            this, tokens, amounts, userData
        );
    }

    function receiveFlashLoan(
        IERC20[] memory tokens,
        uint256[] memory amounts,
        uint256[] memory feeAmounts,
        bytes memory userData
    ) external override {
        require(msg.sender == address(vault), "not vault");
        //logic
        userData = "";
        uint256 totalAmount = amounts[0] + feeAmounts[0];
        tokens[0].transfer(address(vault), totalAmount);
    }

}

