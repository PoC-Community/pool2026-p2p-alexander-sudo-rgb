// Step 0.04 - Advanced Types

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SmartContract {
    // --- Step 0.08 ---
    address private owner;

    constructor() {
        owner = msg.sender; // Celui qui déploie devient le propriétaire
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _; 
    }

    // --- Public variables ---
    uint256 public halfAnswerOfLife = 21;
    address public myEthereumContractAddress = address(this);
    address public myEthereumAddress = msg.sender;
    bytes32 public whoIsTheBest = "It's Sunless"; 
    string public PoCIsWhat = "PoC is good, PoC is life.";
    mapping(string => uint256) public myGrades;
    string[5] public myPhoneNumber;
    enum roleEnum { STUDENT, TEACHER }

    // --- Step 0.11 ---
    event BalanceUpdated(address indexed user, uint256 newBalance);
    error InsufficientBalance(uint256 available, uint256 requested);
    // Internal
    bool internal _areYouABadPerson = false;
    // Private
    int256 private _youAreACheater = -42;

    // Define the struct
    struct Person {
        string name;
        uint8 age;
    }
    // Create a structure
    struct informations {
        string firstName;
        string lastName;
        uint8 age;
        string city;
        roleEnum role;
    }

    // Create an instance
    informations public myInformations = informations({
        firstName : "Alexander",
        lastName : "Salazar",
        age : 18,
        city :"Puteaux",
        role : roleEnum.STUDENT
    });

    Person public alice = Person({
        name: "Alice",
        age: 25
    });

    // --- Functions (Steps 0.05 - 0.07) ---

    function getNumber() public view returns (uint256) {
        return halfAnswerOfLife;
    }

    function add(uint256 a, uint256 b) public pure returns (uint256) {
        return a + b;
    }

    function getHalfAnswerOfLife() public view returns (uint256) {
        return halfAnswerOfLife;
    }

    function _getMyEthereumContractAddress() internal view returns (address) {
        return myEthereumContractAddress;
    }

    function getPoCIsWhat() external view returns (string memory) {
        return PoCIsWhat;
    }

    function _setAreYouABadPerson(bool _value) internal {
        _areYouABadPerson = _value;
    }

    // Step 0.07 - Data Location
    function editMyCity(string calldata _newCity) public {
        myInformations.city = _newCity;
    }

    function getMyFullName() public view returns (string memory) {
        return string(abi.encodePacked(myInformations.firstName, " ", myInformations.lastName));
    }

    // --- Function Step 0.08 ---
    function completeHalfAnswerOfLife() public onlyOwner {
        halfAnswerOfLife = halfAnswerOfLife + 21;
    }

    // --- Function task 0.09 ---
    function hashMyMessage(string calldata _message) public pure returns (bytes32) {
        return keccak256(bytes(_message));
    }

    // --- Step 0.10 - ETH Management ---
    mapping(address => uint256) public balances;

    function getMyBalance() public view returns (uint256) {
        return balances[msg.sender];
    }

    // --- Step 0.11 - Logic & Events ---

    // Cette fonction remplit les objectifs du Step 0.10 ET du Step 0.11
    function addToBalance() public payable {
        balances[msg.sender] += msg.value; // Step 0.10 : On ajoute l'ETH
        emit BalanceUpdated(msg.sender, balances[msg.sender]); // Step 0.11 : On prévient la blockchain
    }

    // Cette fonction remplit les objectifs du Step 0.10, 0.11 ET 0.12
    function withdrawFromBalance(uint256 _amount) public {
        // 1. Vérifier le solde avec l'erreur personnalisée (Step 0.12)
        if (balances[msg.sender] < _amount) {
            revert InsufficientBalance(balances[msg.sender], _amount);
        }

        // 2. Soustraire de la balance d'abord (Sécurité Step 0.10 - Patterns Checks-Effects-Interactions)
        balances[msg.sender] -= _amount;

        // 3. Envoyer l'ETH (Step 0.10)
        (bool success, ) = msg.sender.call{value: _amount}("");

        // 4. Vérifier que le transfert a réussi (Step 0.10)
        require(success, "Transfer failed");

        // 5. On imprime le ticket de caisse (Step 0.11)
        emit BalanceUpdated(msg.sender, balances[msg.sender]);
    }
}