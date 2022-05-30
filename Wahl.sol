pragma solidity ^0.8.7;
//"SPDX-License-Identifier: 1324252135321541"
contract Wahl {

    address public OfficialAddress;      
    string public OfficialName;
    string public proposal;
    string public Endergebnis = "Die Wahl ist noch nicht beendet";
    uint public StimmenTrue = 0;
    uint public StimmenFalse = 0;
    uint public totalVoter = 0;
    uint public totalVote = 0;


    //Ein Vote besteht aus der Adresse des Wählers und seiner Wahl also True oder False
    struct vote{
        address voterAdresse;
        bool choice;
    }
    
    //Wird ein Voter angelegt besteht er aus einem Namen und der Information ob er bereits gewählt hat oder nicht
    struct voter{
        string voterName;
        bool voted;
    }
    
    //Votes werden im Mapping votes gespeichert jedoch private dass nicht von außen auf die Votes zugegriffen werden kann
    mapping(uint => vote) private votes;
    //Voters und ob sie noch wählen können wird ebenfalls als Mapping gespeichert und ist für alle Voter zugänglich
    mapping(address => voter) public voterRegister;
    
    //Die Wahl hat 3 Zustände: Created(Die Wahl wurde angelegt es gibt einen Owner und es können nun Voter Registriert werden; Voting (Die Wahlphase ist eröffnet es 
    //können keine Voter mehr registriert werden; Ended (Das Voting ist geschlossen und es gibt ein Endergebnis
    enum Status { Created, Voting, Ended }
	Status public status;
	
	//Neue Wahl wird erstellt
	constructor(
        string memory _OfficialName,
        string memory _proposal) public {
        OfficialAddress = msg.sender;
        OfficialName = _OfficialName;
        proposal = _proposal;
        
        status = Status.Created;
    }
    
    //Methode zum Prüfen ob die Funktion vom Ersteller der Wahl aufgerufen wird
	modifier isOwner() {
		require(msg.sender ==OfficialAddress);
		_;
	}

    //Methode um den aktuellen Status der Wahl abzurufen
	modifier currentState(Status _status) {
		require(status == _status);
		_;
	}

    

    //Voting eröffnen abjetzt können Voter eine Stimme abgeben
    function startVoting()
        public
        currentState(Status.Created)
        isOwner
    {
        status = Status.Voting; 
    }

    //Voting beenden und Endergebnis speichern / berechnen
    function endVoting()
    public
    currentState(Status.Voting)
    isOwner
    {
        status = Status.Ended;
       if(StimmenTrue<StimmenFalse)
       {
            Endergebnis="Die Wahl endete mit True";
       }else if (StimmenTrue>StimmenFalse)
       {
            Endergebnis="Die Wahl endete mit False";
       }else if(StimmenFalse==StimmenTrue)
       {
            Endergebnis="Die Wahl endete Unentschieden";

       }
    }
    

    //Voter registrieren und dem Register hinzufügen
    function registerVoter(address _voterAdresse, string memory _voterName)
    public
    currentState(Status.Created)
    isOwner
    {
        voter memory v;
        v.voterName = _voterName;
        v.voted = false;
        voterRegister[_voterAdresse] = v;
        totalVoter++;
    }

    //Registrierte Voter können mit dieser Methode ihre Stimme einmal Abgeben also True oder False
    function processVote(bool _choice)
        public
        currentState(Status.Voting)
        returns (bool voted)
    {
        bool found = false;

        if (bytes(voterRegister[msg.sender].voterName).length != 0 
        && voterRegister[msg.sender].voted == false){
            voterRegister[msg.sender].voted = true;
            vote memory v;
            v.voterAdresse = msg.sender;
            v.choice = _choice;
            
            if (_choice==true){
                StimmenTrue++;
                found = true;

            }else
            {
                StimmenFalse++;
                found = false;
            }
            votes[totalVote] = v;
            totalVote++;
        }
        return found;
    }

    
    
}
