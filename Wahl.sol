pragma solidity ^0.5.0;

contract Wahl {

    address public OfficialAddress;      
    string public OfficialName;
    string public proposal;

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
	modifier onlyOwner() {
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
        onlyOwner
    {
        status = Status.Voting;     
    }

    //Voting beenden und Endergebnis speichern / berechnen
    function endVoting()
    public
    {

    }

    //Voter registrieren und dem Register hinzufügen
    function registerVoter()
    public
    {

    }

    //Registrierte Voter können mit dieser Methode ihre Stimme einmal Abgeben also True oder False
    function processVote()
    public
    {

    }
    
}
