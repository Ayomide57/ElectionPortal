// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

error ElectionPortal__LockTimeError(uint _lock_time);
error ElectionPortal__CandidateAlreadyExist();
error ElectionPortal__CandidateDoesntExist();
error ElectionPortal__YouCantVoteTwice();


contract ElectionPortal {

    uint public lock_time; 
    uint256 public candidateCount;
    uint256 public voteCount;

    struct Voting {
        uint256 id;
        address voter;
        string name;
        address candidate;
        string year;
        bool vote;
    }

    struct Candidate {
        uint256 id;
        address candidate;
        string name;
        uint256 vote_number;
        bool isValue;
        string party;
        string position;
    }

    event RegisterEvent(
        uint256 indexed id,
        address indexed candidate,
        string indexed name
    );

    event VotingEvent(
        uint256 indexed id,
        address indexed voter,
        string name,
        address indexed candidate,
        bool vote
    );


    mapping(uint256 => Voting) public s_election_data;
    mapping (address => Candidate) public s_candidates;

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
       if(s_candidates[_candidate].isValue){
            revert ElectionPortal__CandidateDoesntExist();
        }
        _;
    }


    modifier candidateAlreadyExist(
        address _candidate
    ){
       if(s_candidates[_candidate].isValue){
            revert ElectionPortal__CandidateAlreadyExist();
        }
        _;
    }

   /** modifier cantVoteForTheSameCandidateTwice(
        address _candidate,
        address _voter,
        string memory _year
    ) {
        bool exist = getVotingRecord(_candidate, _voter, _year);
        if(exist){
            revert ElectionPortal__YouCantVoteTwice();
        }
        _;

    }**/

    /**function getVotingRecord(
        address _candidate, 
        address _voter,
        string memory _year
    ) 
    public
    pure
    returns (bool) {
        for(uint i = 0; i < s_election_data[_candidate].length; i++) {
            if(s_election_data[_candidate][i].voter == _voter){
                return true;
            }
        }
    }*/



    constructor(uint _lock_time) 
        onlyFutureTime(_lock_time) 
    {
        lock_time = _lock_time;
    }
    

    function registerCandidate(
        string memory _name,
        string memory _position,
        string memory _party
    )
        private 
        candidateAlreadyExist(msg.sender)
    {
        candidateCount++;
        s_candidates[msg.sender] = Candidate(candidateCount, msg.sender, _name, 0, true, _party, _position);
        emit RegisterEvent(candidateCount, msg.sender, _name);
    }

    function registerVote (
        string memory _name,
        address _candidate,
        string memory _year
    ) 
        private 
        candidateDoesntExist(_candidate)
        //cantVoteForTheSameCandidateTwice(_candidate, msg.sender, _year)
    {
        voteCount++;
        s_election_data[voteCount] = Voting(voteCount, msg.sender, _name, _candidate, _year, true);
        s_candidates[_candidate].vote_number ++;
        emit VotingEvent(voteCount, msg.sender, _name, _candidate, true);
    }

    function getCandidateInformation(address _candidate) 
        external 
        view  
        returns(Candidate memory) {
        Candidate memory candidate = s_candidates[_candidate];
        return candidate;
    }

}