// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Escrow.sol";
import "@openzeppelin-contracts-5.0.1/token/ERC20/ERC20.sol";

// Mock ERC20 Token
contract MockERC20 is ERC20 {
    constructor() ERC20("Mock USDC", "USDC") {}

    function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }
}

contract MarketplaceEscrowTest is Test {
    MarketplaceEscrow public escrow;
    MockERC20 public usdc;

    address seller = address(0x1);
    address buyer = address(0x2);

    function setUp() public {
        // Deploy mock USDC token
        usdc = new MockERC20();

        // Deploy MarketplaceEscrow contract
        escrow = new MarketplaceEscrow(address(usdc));

        // Mint tokens to buyer
        usdc.mint(buyer, 1000 * 1e18);

        // Approve the escrow contract to spend buyer's tokens
        vm.prank(buyer);
        usdc.approve(address(escrow), 1000 * 1e18);
    }

    function testList() public {
        vm.prank(seller);
        escrow.list("username1", 100 * 1e18);

        (string memory username, uint256 price, address sellerAddress, bool active) = escrow.listings("username1");

        assertEq(username, "username1");
        assertEq(price, 100 * 1e18);
        assertEq(sellerAddress, seller);
        assertTrue(active);
    }

    function testDeposit() public {
        // List an item
        vm.prank(seller);
        escrow.list("username1", 100 * 1e18);

        // Deposit USDC
        vm.prank(buyer);
        escrow.deposit("username1", 100 * 1e18);

        address buyerAddress = escrow.escrow("username1");
        (, , , bool active) = escrow.listings("username1");

        assertEq(buyerAddress, buyer);
        assertFalse(active); // Listing is no longer active
        assertEq(usdc.balanceOf(address(escrow)), 100 * 1e18);
    }

    function testWithdraw() public {
        // List an item
        vm.prank(seller);
        escrow.list("username1", 100 * 1e18);

        // Deposit USDC
        vm.prank(buyer);
        escrow.deposit("username1", 100 * 1e18);

        // Withdraw funds
        vm.prank(buyer);
        escrow.withdraw("username1");

        assertEq(usdc.balanceOf(seller), 100 * 1e18);
        assertEq(escrow.escrow("username1"), address(0)); // Escrow entry deleted
    }
}
