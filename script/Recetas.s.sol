// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";
import "../src/Recetas.sol";

contract DeployScript is Script {
    function run() external {
        vm.startBroadcast();

        Recetas contrato = new Recetas();

        vm.stopBroadcast();
    }
}
