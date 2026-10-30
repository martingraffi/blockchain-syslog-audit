// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract LogRegistry {
    struct LogBatch {
        bytes32 merkleRoot;
        uint256 timestamp;
        uint256 logCount;
    }

    mapping(uint256 => LogBatch) public batches;
    uint256 public batchCount;
    address public owner;

    event LogBatchRegistered(uint256 indexed batchId, bytes32 merkleRoot, uint256 logCount);

    constructor() {
        owner = msg.sender;
    }

    function registerBatch(bytes32 _merkleRoot, uint256 _logCount) public {
        require(msg.sender == owner, "No autorizado");
        batchCount++;
        batches[batchCount] = LogBatch(_merkleRoot, block.timestamp, _logCount);
        emit LogBatchRegistered(batchCount, _merkleRoot, _logCount);
    }
}
