pragma solidity ^0.5.0;

import "openzeppelin-solidity/contracts/cryptography/ECDSA.sol";
import "openzeppelin-solidity/contracts/math/SafeMath.sol";

/**
 * @title VotingBallot
 * @author Trevor Clarke (gitlab.com/trevorjtclarke)
 *
 * @dev A system for multi-participant voting using a
 *    State Channel approach to remove fees, and speed
 *    up individual voting input transfer.
 *    This contract is a single "channel" for simplicity,
 *    all functionality is simplified to reveal timeline
 *    & functionality needed for a state channel implementation.
 *    NOTE: This is NOT production ready, only used for example!
 */
contract VotingBallot {
  using ECDSA for bytes32;
  using SafeMath for uint256;

  /**
   * Events & Variables
   */
  event ChannelConnected(bytes32 indexed channelId, address indexed leader, uint expiration, uint voterTotal);
  event ChannelDisconnected(bytes32 indexed channelId, address indexed leader);
  event VoterSentFunds(address sender, uint value, uint balance);

  // Keep track of what phase allows an action
  // Order annotated below forces timeline
  enum ChannelStatus {
    // 1.
    Setup,
    // 2.
    Voting,
    // 3a.
    Reveal,
    // 3b.
    Dispute
  }

  struct Proposal {
    uint id;
    uint no;
    uint yes;
    uint nonce;
  }

  struct Voter {
    bool voted;
    uint8 totalVotes;
    uint256 salt;
  }

  /// @dev NOTE: These variables could be changed to a struct,
  ///      to allow multiple channels for a single contract
  address leader;
  uint expiration;
  uint8 currentStatus;
  uint256 totalVoters;
  bytes32 channelId;
  mapping(address => Voter) voters;
  address[] public voterAddresses;
  Proposal[] public proposals;

  /// @dev initialize contract with default single channel state
  constructor() public payable {
    /* require(msg.value > 1 wei, "stake must exist"); */
    leader = msg.sender;
    expiration = now + 1337 minutes;
    channelId = keccak256(abi.encodePacked(expiration, leader));

    // initialize default data, NOTE: This is just example!
    voterAddresses.push(leader);
    proposals.push(Proposal(1, 0, 0, now));
    proposals.push(Proposal(2, 0, 0, now));
    proposals.push(Proposal(3, 0, 0, now));
    proposals.push(Proposal(4, 0, 0, now));
    proposals.push(Proposal(5, 0, 0, now));

    emit ChannelConnected(channelId, leader, expiration, proposals.length);
  }

  /// @dev Check that sender is leader
  modifier isLeaderOnly() {
    require(leader == msg.sender, 'Must be Leader!');
    _;
  }

  // allow funds to be sent to the contract
  // This initializes the voter's ability, based on their stake!
  function stake(uint256 _salt) external payable {
    require(msg.value > 1 wei, "stake must exist");
    emit VoterSentFunds(msg.sender, msg.value, address(this).balance);

    Voter memory _voter;
    _voter.voted = false;
    _voter.totalVotes = 0;
    _voter.salt = _salt;
    voters[msg.sender] = _voter;
    voterAddresses.push(msg.sender);
    totalVoters = totalVoters.add(1);

    // Update status: ready for votes
    if (
      currentStatus != uint8(ChannelStatus.Reveal) &&
      currentStatus != uint8(ChannelStatus.Dispute)
    ) {
      currentStatus = uint8(ChannelStatus.Voting);
    }
  }

  function getHashedValue(uint256 _value, uint256 _salt, address _signer) public pure returns (bytes32 message) {
    return keccak256(abi.encodePacked(_value, _salt, _signer));
  }

  /// @dev Function to check state signer
  function checkHashedValidity(uint256 _value, uint256 _salt, address _signer, bytes32 _signedMessage) external view returns (bool) {
    return this.getHashedValue(_value, _salt, _signer) == _signedMessage;
  }

  // TODO: Safely save state and post onchain, enable withdraw
  // NOTE: Instead of serializing data, reduced to 2 proposals for brevity & example
  function reveal(uint _no0, uint _yes0, uint _no1, uint _yes1) isLeaderOnly public {
    require(currentStatus != uint8(ChannelStatus.Reveal), "Cannot reveal twice");
    currentStatus = uint8(ChannelStatus.Reveal);

    emit ChannelDisconnected(channelId, leader);

    // Commit state change
    // TODO: Sender is leader, submitting final tally for each proposal
    Proposal memory p0 = proposals[0];
    p0.no = _no0;
    p0.yes = _yes0;
    Proposal memory p1 = proposals[1];
    p1.no = _no1;
    p1.yes = _yes1;

    proposals[0] = p0;
    proposals[1] = p1;

    // TODO: Check that revealed state matches signedMessage!
  }

  function getProposalByIndex(uint256 _idx) external view returns (
    uint id,
    uint no,
    uint yes
  ) {
    Proposal memory p = proposals[_idx];
    return (
      p.id,
      p.no,
      p.yes
    );
  }

  /// @dev used by leader, to reveal & tally all votes.
  // TODO: Do i need this?
  function getSaltForVoter(uint _idx) isLeaderOnly external view returns (
    uint salt
  ) {
    address _voterAddress = voterAddresses[_idx];
    return voters[_voterAddress].salt;
  }

  /// @dev Helper functions for understanding current channel status
  function isStatusSetup() public view returns (bool) {
    return currentStatus == uint8(ChannelStatus.Setup);
  }
  function isStatusVoting() public view returns (bool) {
    return currentStatus == uint8(ChannelStatus.Voting);
  }
  function isStatusReveal() public view returns (bool) {
    return currentStatus == uint8(ChannelStatus.Reveal);
  }

  /* function checkSigner(uint256 _value, bytes calldata _signedMessage) external view returns (address) {
    bytes32 message = ECDSA.toEthSignedMessageHash(keccak256(abi.encodePacked(address(this), _value)));

    // check that the signature is from the sender
    return message.recover(_signedMessage);
  } */
}
