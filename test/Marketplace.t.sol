pragma solidity ^0.8.13;
// // SPDX-License-Identifier: UNLICENSED
// pragma solidity ^0.8.13;

// import "forge-std/Test.sol";
// import "../src/Marketplace.sol";
// import "@openzeppelin-contracts-5.0.1/token/ERC20/ERC20.sol";

// // Mock USDC Token
// contract MockUSDC is ERC20 {
//     constructor() ERC20("Mock USDC", "mUSDC") {
//         _mint(msg.sender, 1e24); // Mint 1 million tokens for the deployer
//     }

//     // Override decimals to mimic real USDC behavior (6 decimals)
//     function decimals() public view virtual override returns (uint8) {
//         return 6;
//     }
// }

// contract MarketplaceTest is Test {
//     Marketplace marketplace;
//     MockUSDC usdc;
//     address seller = address(0x123);
//     address buyer = address(0x456);
//     address prover = address(0x789);

//     function setUp() public {
//         // Deploy mock USDC and Marketplace contracts
//         usdc = new MockUSDC();
//         marketplace = new Marketplace(prover, address(usdc));

//         // Allocate some tokens to seller and buyer
//         usdc.transfer(seller, 1_000_000 * 10 ** usdc.decimals()); // 1,000,000 USDC
//         usdc.transfer(buyer, 1_000_000 * 10 ** usdc.decimals());  // 1,000,000 USDC
//     }

//     function testListAndDeposit() public {
//     uint256 price = 1000 * 10 ** usdc.decimals();

//     // Seller lists a username
//     vm.startPrank(seller);
//     Proof memory dummyProof = createDummyProof();
//     marketplace.list(dummyProof, "username123", price);
//     vm.stopPrank();

//     // Verify listing details
//     Marketplace.Listing memory listing;
// 		{
// 			// ローカルスコープで値を取得
// 			(string memory username, uint256 listingPrice, address listingSeller, bool isActive) = marketplace.listings("username123");
// 			listing = Marketplace.Listing({
// 				username: username,
// 				price: listingPrice,
// 				seller: listingSeller,
// 				active: isActive
// 			});
// 		}
// 		assertEq(listing.seller, seller);
// 		assertEq(listing.price, price);
// 		assertEq(listing.active, true);

// 		// Buyer approves USDC and deposits
// 		vm.startPrank(buyer);
// 		usdc.approve(address(marketplace), price);
// 		marketplace.deposit("username123", price);
// 		vm.stopPrank();

// 		// Verify escrow details
// 		address escrowBuyer = marketplace.escrow("username123");
// 		assertEq(escrowBuyer, buyer);

// 		// Verify listing is no longer active
// 		Marketplace.Listing memory updatedListing;
// 		{
// 			// ローカルスコープで値を再取得
// 			(string memory updatedUsername, uint256 updatedPrice, address updatedSeller, bool updatedActive) = marketplace.listings("username123");
// 			updatedListing = Marketplace.Listing({
// 				username: updatedUsername,
// 				price: updatedPrice,
// 				seller: updatedSeller,
// 				active: updatedActive
// 			});
// 		}
// 		assertEq(updatedListing.active, false);
// 	}

//     function testWithdraw() public {
//         uint256 price = 1000 * 10 ** usdc.decimals();

//         // Seller lists a username
//         vm.startPrank(seller);
//         Proof memory dummyProof = createDummyProof();
//         marketplace.list(dummyProof, "username123", price);
//         vm.stopPrank();

//         // Buyer approves USDC and deposits
//         vm.startPrank(buyer);
//         usdc.approve(address(marketplace), price);
//         marketplace.deposit("username123", price);
//         vm.stopPrank();

//         // Seller withdraws funds after transfer verification
//         vm.startPrank(seller);
//         marketplace.withdraw(dummyProof, "username123");
//         vm.stopPrank();

//         // Verify seller balance
//         uint256 sellerBalance = usdc.balanceOf(seller);
//         assertEq(sellerBalance, 1_000_000 * 10 ** usdc.decimals() + price); // Initial balance + deposit

//         // Verify escrow is cleared
//         address escrowBuyer = marketplace.escrow("username123");
//         assertEq(escrowBuyer, address(0));
//     }

//     function createDummyProof() internal pure returns (Proof memory) {
//         return Proof({
//             a: [uint256(0), uint256(0)],
//             b: [[uint256(0), uint256(0)], [uint256(0), uint256(0)]],
//             c: [uint256(0), uint256(0)]
//         });
//     }
// }
