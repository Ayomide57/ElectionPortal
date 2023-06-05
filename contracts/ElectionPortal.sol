// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

error ElectionPortal__LockTimeError(uint _lock_time);
error ElectionPortal__CandidateAlreadyExist();
error ElectionPortal__CandidateDoesntExist();


contract ElectionPortal {

    uint public lock_time; 
    uint256 public candidateCount;
    uint256 public voteCount;

    struct Voting {
        address voter;
        string name;
        bool vote;
    }

    struct Candidate {
        uint256 id;
        address candidate;
        string name;
        uint256 vote_number;
        bool isValue;
    }

    event RegisterEvent(
        uint256 indexed id,
        address indexed candidate,
        string indexed name
    );

    event VotingEvent(
        address indexed voter,
        string indexed name,
        bool indexed vote
    );


    mapping (address => Voting) public s_election_data;
    mapping (uint256 => Candidate) public s_candidates;

    modifier onlyFutureTime(
        uint timestamp,
        uint _lock_time
    ){
        if(block.timestamp < _lock_time){
            revert ElectionPortal__LockTimeError(_lock_time);
        }
        _;
    }

    modifier candidateDoesntExist(
        uint256 id
    ){
        //Candidate memory candidate = s_candidates[id];
       if(s_candidates[id].isValue){
            revert ElectionPortal__CandidateDoesntExist();
        }
        _;
    }


    modifier candidateAlreadyExist(
        string memory _name
    ){
        //Candidate memory candidate = s_candidates[_name];
       // if(candidate){
            //revert ElectionPortal__CandidateAlreadyExist();
        //}
        _;
    }



    constructor(uint _lock_time) 
        onlyFutureTime(block.timestamp, _lock_time) 
    {
        lock_time = _lock_time;
    }

    function registerCandidate
    (
        string memory _name
    )
        private 
    {
        candidateCount++;
        s_candidates[candidateCount] = Candidate(candidateCount, msg.sender, _name, 0, true);
        emit RegisterEvent(candidateCount, msg.sender, _name);
    }

    function registerVote 
    (
        string memory _name,
        uint256 _id
    ) 
        private 
        candidateDoesntExist(_id)
    {
        s_election_data[msg.sender] = Voting(msg.sender, _name, true);
        s_candidates[_id].vote_number ++;
        emit VotingEvent(msg.sender, _name, true);
    }


}