//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Context.sol";

// this version will assume that everyone is nice... for now
contract users is Context {

    // name => account mapping
    mapping(string => account) internal accounts;

    // Holds data for each user
    struct account{
        bool isAccount;
        uint256 userScore;
        address outAddress;
    }

    // Ensures its not writing over an already existing user
    // Sets the data and then ensures that the user now exists
    // use that kack255 thing to send publicly the password
    // on chain so it can be verified and the user can come into existence
    function signUp(uint256 _score, string memory _id) public {
        require(!userExists(_id), "User exists");
        accounts[_id].userScore = _score;
        accounts[_id].isAccount = true;
        accounts[_id].outAddress = _msgSender();
        require(userExists(_id), "User doesn't exist");
    }

    // changes the score value but makes checks that it all is behaving good
    function _updateScore(uint256 _score, string memory _id) internal returns (uint256){
        require(userExists(_id), "User doesn't exist");
        require(getScore(_id) < _score, "Score too Low/ no change");
        uint256 change = _score - accounts[_id].userScore;
        accounts[_id].userScore = _score;
        return change;
    }

    // Returns a boolean if the user exists or not (false is not)
    function userExists(string memory _id) public view returns (bool){
        return accounts[_id].isAccount;
    }

    // basic functions to get data out of the smart contract easily
    function getScore(string memory _id) public view returns (uint256) {
        require(userExists(_id), "User doesn't exist");
        return accounts[_id].userScore;
    }

    // basic functions to get data out of the smart contract easily
    function getAddress(string memory _id) public view returns (address) {
        require(userExists(_id), "User doesn't exist");
        return accounts[_id].outAddress;
    }
}