// SPDX-License-Identifier: Unlicensed

pragma solidity ^0.8.7;

contract GettingStarted{
    // owner
    address owner;

    // constructor
    constructor(){
        owner = msg.sender;
    }

    
    // struct for Kids
    struct Kid {
        address payable walletAddress;
        string first_name;
        string last_name;
        uint releaseTime;
        uint amount;
        bool canWithdraw;
    }

    // array of kids
    Kid[] public kids;


    // modifier to check if the sender is the owner
    modifier onlyOwner(){
        require(msg.sender == owner, "You are not the owner of this contract");
        _;
    }

    // function to add a kid
    function addKid(address payable walletAddress, string memory first_name, string memory last_name, uint releaseTime) public onlyOwner {
        kids.push(Kid(
            walletAddress,
            first_name,
            last_name,
            releaseTime,
            0,
            false
        ));
    }

    
    // function to get the index of a kid
    function getIndex(address walletAddress) private view returns (uint){
        for (uint i =0; i< kids.length; i++){
            if (kids[i].walletAddress == walletAddress){
                return i;
            }
        }
        return 999;
    }

    // function to deposit money into a kid's account
    function deposit(address walletAddress) payable public onlyOwner {
        uint i = getIndex(walletAddress);
        kids[i].amount += msg.value;
    }

    // function to check if a kid can withdraw
    function availableToWithdraw(address walletAddress) public returns(bool){
        uint i = getIndex(walletAddress);
        if (kids[i].releaseTime < block.timestamp){
            kids[i].canWithdraw = true;
            return true;
        }
        return false;
    }

    // function to withdraw money from a kid's account
    function withdraw(address payable walletAddress) payable public {
        uint i = getIndex(walletAddress);
        require(msg.sender == kids[i].walletAddress, "You must be the kid to withdraw");
        require(kids[i].canWithdraw, "You can not withdraw at this time");
        kids[i].walletAddress.transfer(kids[i].amount);
    }
}