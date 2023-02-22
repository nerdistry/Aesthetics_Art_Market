
// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

interface IERC20Token {
  function transfer(address, uint256) external returns (bool);
  function approve(address, uint256) external returns (bool);
  function transferFrom(address, address, uint256) external returns (bool);
  function totalSupply() external view returns (uint256);
  function balanceOf(address) external view returns (uint256);
  function allowance(address, address) external view returns (uint256);

  event Transfer(address indexed from, address indexed to, uint256 value);
  event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract discover_aesthetics {

    uint internal media_length = 0; // Represents how many art products stored and can be used as an index of next art.
    address internal cUsdTokenAddress = 0x874069Fa1Eb16D44d622F2e0Ca25eeA172369bC1;
    address public seller_address;

    struct art_medium{
        address payable owner; // Allows my contract to send tokens to this address.
        /*String because they will never be negative.*/
        string art_type;
        string name;
        string image;
        string description;
        bool licensed;
        string location;
        uint price;
        uint sold;
    }

    modifier is_licensed(uint _index){
        require(art_media[_index].licensed == true, "This masterpiece has not been licensed.");
        _;
        
    }

    modifier art_owner(){
        require(seller_address == msg.sender,"Modification rights revoked, you are not the owner. ");
        _;
    }

    mapping (uint => art_medium) public art_media;

    function write_art_medium(
        // uint _index,
        string memory _art_type,
        string memory _name,
        string memory _image,
        string memory _description,
        string memory _location,
        uint _price
    ) public {
        require(bytes(_art_type).length > 0, "Kindly specify the type of art.");
        require(bytes(_name).length > 0, "Your masterpiece should have a name.");
        require(bytes(_image).length > 0, "Kindly input a valid URL.");
        require(bytes(_description).length > 10, "Kindly give a detailed description of your art.");
        require(_price > 0, "Kindly input a valid price.");
        uint _sold = 0; // Tracks the number of times the art product was sold.
        bool _licensed = false;


        art_media[media_length] = art_medium(
            payable(msg.sender), // Returns the address of the entity that is making the call.
            _art_type,
            _name,
            _image,
            _description,
            _licensed,
            _location,
            _price,
            _sold
        );
        media_length++;
    }

    function read_art_medium(uint _index) public view returns (
        address payable,
        string memory,
        string memory,
        string memory,
        string memory,
        bool
     
    ) {
        return (
            art_media[_index].owner,
            art_media[_index].art_type,
            art_media[_index].name,
            art_media[_index].image,
            art_media[_index].description,
            art_media[_index].licensed
       
        );
    }

    // Trying to solve the stack too deep error.

    function read_another_art_medium(uint _index) public view returns (
  
        string memory,
        uint, 
        uint
    ) {
        return (
        
            art_media[_index].location,
            art_media[_index].price,
            art_media[_index].sold
        );
    }

    function buy_masterpiece(uint _index) public payable{
                require(art_media[_index].owner != address(0), "Please input a valid index!");

        require(
             IERC20Token(cUsdTokenAddress).transferFrom(
			msg.sender,
            art_media[_index].owner,
            art_media[_index].price
        ),
        "Transaction has failed, sorry."
        );
        art_media[_index].sold++;
    }

    function get_media_length() public view returns (uint){
        return (media_length);
    }
}
