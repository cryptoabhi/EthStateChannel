pragma solidity ^0.5.0;

/**
 * @title StateChannel
 * 
 * @dev Extremely Simplistic State Channel
 */
contract StateChannel {
  // Keep track of what phase allows an action
  // Order annotated below forces timeline
  enum ChannelStatus {
    // 1.
    Setup,
    // 2.
    Commit,
    // 3a.
    Reveal,
    // 3b.
    Dispute
  }

  uint256 public stakeAmount;
  uint8 public currentStatus;
  address[] public participants;
  // Stores pre-hashed data that is submitted with stake
  // Later, when salt is revealed, hash is validated
  mapping(address => bytes32) hashDataList;

  /// @dev initialize contract with default state
  constructor() public payable {
    require(msg.value > 1 wei, "stake amount must be > 1 wei");
    stakeAmount = msg.value;
    participants.push(msg.sender);
    currentStatus = uint8(ChannelStatus.Setup);
  }

  function stake(bytes32 _hashedMessage) external payable {
    require(msg.value > 1 wei, "stake must exist");
    require(msg.value == stakeAmount, "stake must equal initial value");
    participants.push(msg.sender);

    // Important: Store committed data, for later proof!
    hashDataList[msg.sender] = _hashedMessage;

    // Update status: ready for votes
    if (
      currentStatus != uint8(ChannelStatus.Reveal) &&
      currentStatus != uint8(ChannelStatus.Dispute)
    ) {
      currentStatus = uint8(ChannelStatus.Commit);
    }
  }

  /// @dev return hash based on inputs
  function getHashedValue(uint256 _value, uint256 _salt, address _sender) public pure returns (bytes32 message) {
    return keccak256(abi.encodePacked(_value, _salt, _sender));
  }

  /// @dev Check if inputs match original hash
  function isHashMessageValid(uint256 _value, uint256 _salt, address _sender, bytes32 _hashedMessage) external view returns (bool) {
    return this.getHashedValue(_value, _salt, _sender) == _hashedMessage;
  }

  // Reveal state
  function reveal(
    address payable _claimer,
    uint256 _value,
    uint256 _salt,
    address _sender,
    bytes32 _hashedMessage
  ) external {
    bool _valid = this.isHashMessageValid(_value, _salt, _sender, _hashedMessage);
    require(_valid == true, "Final state is invalid");

    // Finally, send stake fees to claimer
    selfdestruct(_claimer);
  }

  /// @dev Helper functions for understanding current channel status
  function isStatusSetup() public view returns (bool) {
    return currentStatus == uint8(ChannelStatus.Setup);
  }
  function isStatusCommit() public view returns (bool) {
    return currentStatus == uint8(ChannelStatus.Commit);
  }
  function isStatusReveal() public view returns (bool) {
    return currentStatus == uint8(ChannelStatus.Reveal);
  }
  function isStatusDispute() public view returns (bool) {
    return currentStatus == uint8(ChannelStatus.Dispute);
  }
}
