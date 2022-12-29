pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/math/SafeMath.sol";

// Set the name, symbol, and total supply for the token
string public name = "Alt-F4 Token";
string public symbol = "AF4T";
uint256 public totalSupply = 1000000000;

// Use 18 decimal places
uint8 public decimals = 18;

// Use the SafeERC20 and SafeMath libraries
using SafeERC20 for IERC20;
using SafeMath for uint256;

// The contract is owned by the contract creator
address public owner;

// Mapping from addresses to balances
mapping(address => uint256) public balanceOf;

// Events for transfer and approval
event Transfer(address indexed from, address indexed to, uint256 value);
event Approval(address indexed owner, address indexed spender, uint256 value);

// Initialize the contract with the owner set to the contract creator
constructor() public {
    owner = msg.sender;
    balanceOf[owner] = totalSupply;
}

// Transfer tokens from one address to another
function transfer(address to, uint256 value) public {
    require(value <= balanceOf[msg.sender], "Insufficient balance");
    balanceOf[msg.sender] = balanceOf[msg.sender].sub(value);
    balanceOf[to] = balanceOf[to].add(value);
    emit Transfer(msg.sender, to, value);
}

// Allow another address to spend a certain amount of tokens on behalf of the owner
function approve(address spender, uint256 value) public {
    require(value <= balanceOf[msg.sender], "Insufficient balance");
    address owner = msg.sender;
    if (value == 0 && allowance[owner][spender] != 0) {
        // Reset the allowance to 0 if value is 0 (revoke approval)
        allowance[owner][spender] = 0;
    } else {
        allowance[owner][spender] = value;
    }
    emit Approval(owner, spender, value);
}

// Transfer tokens on behalf of the owner
function transferFrom(address from, address to, uint256 value) public {
    require(value <= balanceOf[from], "Insufficient balance");
    require(value <= allowance[from][msg.sender], "Insufficient allowance");
    balanceOf[from] = balanceOf[from].sub(value);
    balanceOf[to] = balanceOf[to].add(value);
    allowance[from][msg.sender] = allowance[from][msg.sender].sub(value);
    emit Transfer(from, to, value);
}

// Get the current balance of an address
function getBalance(address owner) public view returns (uint256) {
    return balanceOf[owner];
}