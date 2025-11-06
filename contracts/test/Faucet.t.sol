// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {Test, console} from "forge-std/Test.sol";
import {Faucet} from "../src/Faucet.sol";

contract FaucetTest is Test {
    Faucet public faucet;
    address public owner;
    address public user1;
    address public user2;

    uint256 constant DRIP_AMOUNT = 1 ether;
    uint256 constant COOLDOWN_TIME = 1 hours;
    uint256 constant INITIAL_BALANCE = 100 ether;

    event Dripped(address indexed recipient, uint256 amount, uint256 timestamp);

    function setUp() public {
        owner = address(this);
        user1 = makeAddr("user1");
        user2 = makeAddr("user2");

        faucet = new Faucet(DRIP_AMOUNT, COOLDOWN_TIME);
        vm.deal(address(faucet), INITIAL_BALANCE);
    }

    function test_InitialState() public view {
        assertEq(faucet.dripAmount(), DRIP_AMOUNT);
        assertEq(faucet.cooldownTime(), COOLDOWN_TIME);
        assertEq(faucet.owner(), owner);
        assertEq(address(faucet).balance, INITIAL_BALANCE);
    }

    function test_Drip() public {
        uint256 balanceBefore = user1.balance;

        vm.prank(user1);
        faucet.drip();

        assertEq(user1.balance, balanceBefore + DRIP_AMOUNT);
        assertEq(faucet.lastDripTime(user1), block.timestamp);
    }

    function test_DripEmitsEvent() public {
        vm.expectEmit(true, true, true, true);
        emit Dripped(user1, DRIP_AMOUNT, block.timestamp);

        vm.prank(user1);
        faucet.drip();
    }

    function test_RevertWhen_DripBeforeCooldown() public {
        vm.startPrank(user1);
        faucet.drip();

        vm.expectRevert();
        faucet.drip();
        vm.stopPrank();
    }

    function test_DripAfterCooldown() public {
        vm.startPrank(user1);
        faucet.drip();

        vm.warp(block.timestamp + COOLDOWN_TIME);
        faucet.drip();
        vm.stopPrank();

        assertEq(user1.balance, DRIP_AMOUNT * 2);
    }

    function test_RevertWhen_InsufficientBalance() public {
        // Drain the faucet
        faucet.withdraw(payable(owner), INITIAL_BALANCE);

        vm.expectRevert();
        vm.prank(user1);
        faucet.drip();
    }

    function test_SetDripAmount() public {
        uint256 newAmount = 2 ether;
        faucet.setDripAmount(newAmount);
        assertEq(faucet.dripAmount(), newAmount);
    }

    function test_SetCooldownTime() public {
        uint256 newCooldown = 30 minutes;
        faucet.setCooldownTime(newCooldown);
        assertEq(faucet.cooldownTime(), newCooldown);
    }

    function test_Withdraw() public {
        uint256 withdrawAmount = 50 ether;
        uint256 balanceBefore = owner.balance;

        faucet.withdraw(payable(owner), withdrawAmount);

        assertEq(owner.balance, balanceBefore + withdrawAmount);
        assertEq(address(faucet).balance, INITIAL_BALANCE - withdrawAmount);
    }

    function test_RevertWhen_WithdrawExceedsBalance() public {
        vm.expectRevert();
        faucet.withdraw(payable(owner), INITIAL_BALANCE + 1 ether);
    }

    function test_TimeUntilNextDrip() public {
        assertEq(faucet.timeUntilNextDrip(user1), 0);

        vm.prank(user1);
        faucet.drip();

        assertEq(faucet.timeUntilNextDrip(user1), COOLDOWN_TIME);

        vm.warp(block.timestamp + 30 minutes);
        assertEq(faucet.timeUntilNextDrip(user1), 30 minutes);

        vm.warp(block.timestamp + 30 minutes);
        assertEq(faucet.timeUntilNextDrip(user1), 0);
    }

    function test_CanDrip() public {
        assertTrue(faucet.canDrip(user1));

        vm.prank(user1);
        faucet.drip();

        assertFalse(faucet.canDrip(user1));

        vm.warp(block.timestamp + COOLDOWN_TIME);
        assertTrue(faucet.canDrip(user1));
    }

    function test_MultipleDifferentUsers() public {
        vm.prank(user1);
        faucet.drip();

        vm.prank(user2);
        faucet.drip();

        assertEq(user1.balance, DRIP_AMOUNT);
        assertEq(user2.balance, DRIP_AMOUNT);
    }

    function testFuzz_Drip(address user, uint96 dripAmt) public {
        vm.assume(user != address(0));
        vm.assume(dripAmt > 0 && dripAmt <= INITIAL_BALANCE);

        faucet.setDripAmount(dripAmt);

        vm.prank(user);
        faucet.drip();

        assertEq(user.balance, dripAmt);
    }

    receive() external payable {}
}
