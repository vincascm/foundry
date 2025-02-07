// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.18;

import "ds-test/test.sol";
import "../cheats/Cheats.sol";

contract ShanghaiCompat is DSTest {
    Cheats constant cheats = Cheats(HEVM_ADDRESS);

    function testPush0() public {
        address target = address(uint160(uint256(0xc4f3)));

        bytes memory bytecode = hex"365f5f37365ff3";
        // 36 CALLDATASIZE
        // 5F PUSH0
        // 5F PUSH0
        // 37 CALLDATACOPY -> copies calldata at mem[0..calldatasize]

        // 36 CALLDATASIZE
        // 5F PUSH0
        // F3 RETURN -> returns mem[0..calldatasize]

        cheats.etch(target, bytecode);

        (bool success, bytes memory result) = target.call(bytes("hello PUSH0"));
        assertTrue(success);
        assertEq(string(result), "hello PUSH0");
    }
}
