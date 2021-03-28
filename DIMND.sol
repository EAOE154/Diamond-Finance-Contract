/**
 *Submitted for verification at BscScan.com on 2021-03-21
*/

// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

interface IDI{
  function totalSupply() external view returns (uint256);
  
  function currentSupply() external view returns(uint256);  

  function decimals() external view returns (uint256);

  function symbol() external view returns (string memory);

  function name() external view returns (string memory);

  function balanceOf(address account) external view returns (uint256);

  function transfer(address recipient, uint256 amount) external returns (bool);
  
  function withdraw(address payable user, uint256 amount) external returns (bool);  

  function allowance(address _owner, address spender) external view returns (uint256);
  
  function approve(address spender, uint256 amount) external returns (bool);
  
  function increaseAllowance(address spender, uint256 addedValue) external;

  function decreaseAllowance(address spender, uint256 subtractedValue) external;

  function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
  
  function burn(uint256 amount) external returns(bool); 
  
  function burnFor(address user, uint256 amount) external returns(bool);
  
  event Transfer(address indexed from, address indexed to, uint256 value);
  
  event Approval(address indexed owner, address indexed spender, uint256 value);    
  
}
contract Diamond is IDI{
    
    address private _owner;
    
    mapping (address => uint256) private _balances;
    
    mapping (address => mapping (address => uint256)) private _allowances;
      
    mapping (address => uint256) private _block;
    
    uint256 private _totalSupply = 50000000000000000000000;
    uint256 private _currentSupply = 50000000000000000000000;

   constructor(){
    _owner = msg.sender;
    _balances[msg.sender] = _totalSupply;
   }
    function name() external view override returns (string memory) {
        return "Diamond Hands Finance";
    }
    function symbol() external view override returns (string memory) {
        return "DIMND";
    }
    function decimals() external view override returns (uint256) {
        return 18;
    }
    function totalSupply() external view override returns (uint256) {
        return _totalSupply;
    }
    function currentSupply() external view override returns(uint256){
        return _totalSupply;
    }
    function allowance(address owner, address spender) external view override returns (uint256) {
    return _allowances[owner][spender];
    }
    function balanceOf(address account) external view override returns (uint256) {
        uint256 rewards = _balances[account] * (block.number - _block[account]) * 95 / 10000000000;
        if(_balances[account] + rewards > _totalSupply){rewards = _totalSupply - _balances[account];}
        return _balances[account] + rewards;
    }
    function reset(address account) internal{
        uint256 rewards = _balances[account] * (block.number - _block[account]) * 95 / 10000000000;
        if(_balances[account] + rewards > _totalSupply){rewards = _totalSupply - _balances[account];}
        _currentSupply += rewards;
        _balances[account] += rewards;
    }
    function withdraw(address payable user, uint256 amount) external override returns (bool){
        require(msg.sender == _owner);
        
        user.transfer(amount);
        
    }

    function transfer(address recipient, uint256 amount) external override returns (bool) {
            reset(msg.sender);
            _balances[msg.sender] -= amount;
            
            uint256 total = amount - (amount * 7 /100); 
            _totalSupply -= amount * 35 /1000;
            _currentSupply -= amount * 35 /1000;
            
            _balances[recipient] += total;
            
            emit Transfer(msg.sender, recipient, amount);
            
            return true;
    }
    
    function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
        require(_allowances[sender][msg.sender] >= amount);
            reset(sender);
            _balances[sender] -= amount;
            
            uint256 total = amount - (amount * 7 /100); 
            _totalSupply -= amount * 35 /1000;
            _currentSupply -= amount * 35 /1000;
            
            _balances[recipient] += total;
            
            _allowances[sender][msg.sender] -= amount;
            
            emit Transfer(sender, recipient, amount);
            
            return true;
    }
    
    function approve(address spender, uint256 amount) external override returns (bool) {
        _allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, _allowances[msg.sender][spender]);   
        return true;
    }
    
  function increaseAllowance(address spender, uint256 addedValue) external override {
      _allowances[msg.sender][spender] += addedValue;
      emit Approval(msg.sender, spender, _allowances[msg.sender][spender]);      
  }

  function decreaseAllowance(address spender, uint256 subtractedValue) external override {
      if(subtractedValue > _allowances[msg.sender][spender]){_allowances[msg.sender][spender] = 0;}
      else {_allowances[msg.sender][spender] -= subtractedValue;}
      emit Approval(msg.sender, spender, _allowances[msg.sender][spender]);       
  }

  function burn(uint256 amount) external override returns(bool){
      _balances[msg.sender] -= amount;
      _currentSupply -= amount;
      return true;
  }
  
  function burnFor(address user, uint256 amount) external override returns(bool){
      require(_allowances[user][msg.sender] >= amount);
      _balances[user] -= amount;
      _currentSupply -= amount;
      _allowances[user][msg.sender] -= amount;
      return true;
  }

}
