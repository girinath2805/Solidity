// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract LimitPaymnet{
    
    mapping (address => uint8) public userLevel;
    mapping (uint8 => uint256) public userLimit;
    address public admin;
    event AddUser(address indexed user,uint8 userLevel);
    event Limitexceeded(address indexed _from,uint8 userLevel,uint256 _amount);
    
    constructor(){
        admin = msg.sender;
        userLevel[admin] = 0;
        userLimit[0] = 2**256-1;

}

    modifier onlyAdmin{
        require(msg.sender == admin,"You are not authorised.Can only be done by Admin");
        _;
    }

    function createUser(address _userAddress,uint8 _userLevel) public onlyAdmin{
        require (_userAddress!=admin,"Cannot make Admin as user");
        require(_userLevel>userLevel[admin],"Invalid level");
        userLevel[_userAddress] = _userLevel;

        emit AddUser(_userAddress,_userLevel);

    }

    function setLimit(uint8 _userLevel, uint256 _userLimit) public onlyAdmin{
        require (_userLevel!=0,"Cannot set limits for Admin");
        userLimit[_userLevel] = _userLimit;
    }

    function Transaction(address payable _to, uint256 _amount) public {
        uint8 senderLevel = userLevel[msg.sender];
        require(_amount<=userLimit[senderLevel],"Transaction limit exceeded");
        _to.transfer(_amount);
        if(_amount>userLimit[senderLevel]){
            emit Limitexceeded(msg.sender,senderLevel,_amount);
        }


    }
}
