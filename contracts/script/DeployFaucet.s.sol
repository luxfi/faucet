// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {Script, console} from "forge-std/Script.sol";
import {Faucet} from "../src/Faucet.sol";

contract DeployFaucet is Script {
    function run() external returns (Faucet) {
        uint256 dripAmount = vm.envOr("DRIP_AMOUNT", uint256(2 ether));
        uint256 cooldownTime = vm.envOr("COOLDOWN_TIME", uint256(24 hours));
        uint256 initialFunding = vm.envOr("INITIAL_FUNDING", uint256(100 ether));

        vm.startBroadcast();

        Faucet faucet = new Faucet(dripAmount, cooldownTime);

        // Fund the faucet if we have balance
        if (initialFunding > 0 && address(this).balance >= initialFunding) {
            payable(address(faucet)).transfer(initialFunding);
        }

        vm.stopBroadcast();

        console.log("Faucet deployed at:", address(faucet));
        console.log("Drip amount:", dripAmount);
        console.log("Cooldown time:", cooldownTime);
        console.log("Initial funding:", initialFunding);

        return faucet;
    }
}
