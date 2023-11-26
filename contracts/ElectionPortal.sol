// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/access/Ownable.sol";


error ElectionPortal__LockTimeError(uint _lock_time);
error ElectionPortal__CandidateAlreadyExist();
error ElectionPortal__CandidateDoesntExist();
error ElectionPortal__YouCantVoteTwice();


contract ElectionPortal is Ownable {

    uint public lock_time; 
    uint256 public candidateCount;
    uint256 public voteCount;
    uint8 public votingTypeCount;

    struct votingType {
        uint8 id;
        string position;
    }

    struct votingDetails {
        uint id;
        string name;
        address voter;
        address candidate;
        bool vote;
    }

    /**struct votingRecordByCandidate {
        uint vote_count;
    }*/



    struct Candidate {
        uint256 id;
        address candidate;
        string name;
        uint256 vote_number;
        string party;
        uint8 position;
        bool reEnter;
    }

    event RegisterEvent(
        uint256 indexed id,
        address indexed candidate,
        string indexed name,
        string party,
        uint position
    );

    event VotinTypeEvent(
        uint8 indexed id,
        string indexed position
    );


    event VotingEvent(
        uint256 indexed id,
        address indexed voter,
        string name,
        address indexed candidate,
        string year,
        bool vote
    );


    mapping (string => mapping (uint8 => mapping (address => votingDetails))) public s_election_data;
    //mapping (string => mapping (uint8 => mapping (address => votingRecordByCandidate))) public s_candidate_data;
    mapping (address => Candidate) public s_candidates;
    mapping (uint8 => votingType) public s_voting_type;

    modifier onlyFutureTime(
        uint _lock_time
    ){
        if(block.timestamp > _lock_time){
            revert ElectionPortal__LockTimeError(_lock_time);
        }
        _;
    }

    modifier candidateDoesntExist(
        address _candidate
    ){
        //Candidate memory candidate = s_candidates[id];
       if(s_candidates[_candidate].reEnter){
            revert ElectionPortal__CandidateDoesntExist();
        }
        _;
    }


    modifier candidateAlreadyExist(
        address _candidate
    ){
       if(s_candidates[_candidate].reEnter){
            revert ElectionPortal__CandidateAlreadyExist();
        }
        _;
    }

    modifier cantVoteForTheSameCandidateTwice(
        address _candidate,
        address _voter,
        string memory _year,
        uint8 _position
    ) {
        bool exist = s_election_data[_year][_position][_voter].vote;
        if(exist){
            revert ElectionPortal__YouCantVoteTwice();
        }
        _;

    }


    constructor(uint _lock_time) 
        onlyFutureTime(_lock_time) 
    {
        lock_time = _lock_time;
    }
    

    function registerCandidate(
        string memory _name,
        uint8 _position,
        string memory _party
    )
        public 
        candidateAlreadyExist(msg.sender)
    {
        s_candidates[msg.sender] = Candidate(candidateCount, msg.sender, _name, 0, _party, _position, true);
        emit RegisterEvent(candidateCount, msg.sender, _name, _party, _position);
        candidateCount++;
    }

    function registerVote (
        string memory _name,
        address _candidate,
        string memory _year,
        uint8 _position
    ) 
        public 
        candidateDoesntExist(_candidate)
        cantVoteForTheSameCandidateTwice(_candidate, msg.sender, _year, _position)
    {
        s_election_data[_year][_position][msg.sender] = votingDetails(voteCount, _name,msg.sender, _candidate, true);
        s_candidates[_candidate].vote_number ++;
        emit VotingEvent(voteCount, msg.sender, _name, _candidate,_year, true);
        voteCount++;
    }

    function addPosition(
        string memory _position
    ) 
    public 
    onlyOwner()
    {
        s_voting_type[votingTypeCount] = votingType(votingTypeCount, _position);
        emit VotinTypeEvent(votingTypeCount, _position);
        votingTypeCount++;
    }

    function getCandidateInformation(address _candidate) 
        public 
        view  
        returns(Candidate memory) {
        Candidate memory candidate = s_candidates[_candidate];
        return candidate;
    }

    function getVotingRecord(string memory _year, uint8 _position) public view returns(votingDetails memory) {
        votingDetails memory voting_detail = s_election_data[_year][_position][msg.sender];
        return voting_detail;
    }


    function getPostion(uint8 id) public view returns(votingType memory) {
        votingType memory voting_type = s_voting_type[id];
        return voting_type;
    }

}