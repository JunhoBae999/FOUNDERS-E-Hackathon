pragma solidity ^0.6.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract RemainToken is ERC721 {
    using SafeMath for uint256;

    string private _baseURI = "http://localhost:3000/";

    //Each token belongs to who
    mapping (uint256 => address) internal idToOwner;

    //All tokens
    uint256[] internal allTokens;
    
    //Each address has how many tokens
    mapping (address => uint256[]) internal ownedTokens;

    //Mapping from toekn ID to index of the owner tokens list
    mapping(uint256 => uint256) internal ownedTokensIndex;

    //Mapping from token id to position in the allTokens array
    mapping(uint256 => uint256) internal allTokensIndex;

    //how many ERC721 tokens that we actually own
    mapping(address=>uint256) internal ownedTokensCount;

    //each course number of tokens
    mapping(uint256 => uint256) internal coursesTokens;

    event Transfer(
        address indexed _from,
        address indexed _to,
        uint256 indexed _tokenId
    );

    event Course(
        string indexed _name,
        string indexed _description,
        uint256 indexed _id
    );

    event Locations(
        string indexed _course,
        string indexed _locname,
        string  _description,
        uint256 indexed _id
    );

    mapping(address => mapping(uint256=>uint256[])) public userLocationVerified;

    address public owner;

    uint256[] public courses;

    mapping(uint256=>uint256[]) public courseToLocations;

    constructor() ERC721("RemainToken","REMAINTOKEN") public {
        owner = msg.sender;
    }

    function append(string memory a, string memory b) internal pure returns (string memory) {

    return string(abi.encodePacked(a, b));

    }

    function registerCourse( string memory course, string memory description) external {
        uint256 courseHash = uint256(keccak256(abi.encode(course)));
        courses.push(courseHash);
        emit Course(course,description,courseHash);
    }

    function registerLocations(string memory  _course, string memory _location, string memory description) external {
        uint256 courseHash = uint256(keccak256(abi.encode(_course)));
        uint256 locNumber = uint256(keccak256(abi.encode(_location)));
        courseToLocations[courseHash].push(locNumber);
        emit Locations(_course, _location,description,locNumber);
    }

    function verifyUserLocation(address  _user, string memory _location, string memory _course) external {
        uint256 locNumber = uint256(keccak256(abi.encode(_location)));
        uint256 courseHash = uint256(keccak256(abi.encode(_course)));
        userLocationVerified[_user][courseHash].push(locNumber); 
    }

    function getUserLocationVerified(address _user, string memory _location, string memory _course) external view returns(bool) {
        uint256 locNumber = uint256(keccak256(abi.encode(_location)));
        uint256 courseHash = uint256(keccak256(abi.encode(_course)));
        uint256 length = userLocationVerified[_user][courseHash].length;

        for(uint i=0; i < length; i++ ) {
            uint256 elementHash = uint256(keccak256(abi.encode(userLocationVerified[_user][courseHash][i])));
            if (locNumber == elementHash) {
                return true;
            }
        }

        return false;
    
    }

    function verifyUserCouseToMintToken(address _user, string memory _location, string memory _course) external returns(bool){
        uint256 courseHash = uint256(keccak256(abi.encode(_course)));
    
        uint256 length = userLocationVerified[_user][courseHash].length;
        uint256 savedLength = courseToLocations[courseHash].length;      
        
        if(length != savedLength) {
            return false;
        }

        string memory uname = append(_course,".jpg");

        mint(_course,_user,append(_baseURI,(uname)));
        return true;
        }

    

    function mint(string memory _course, address _user, string memory _tokenURI ) public  {

        uint256 _id;
        
        uint256 courseHash = uint256(keccak256(abi.encode(_course)));
        uint256 userHash = uint256(keccak256(abi.encode(_user)));
               
         _id = courseHash + userHash;

        _mint(msg.sender,_id);
        if(coursesTokens[courseHash] <= 20 ) {
            _setTokenURI(_id, _tokenURI);
        }        
        coursesTokens[courseHash] += 1;
        }

    function _mint( address _to,uint256 _tokenId) internal virtual override{
        require(_to != address(0));
        require(idToOwner[_tokenId] == address(0));

        _addRemainToken(_to, _tokenId);

        emit Transfer(address(0), _to, _tokenId);
    }

    function transferFrom(address _from, address _to, uint256 _tokenId) public override  {
        address tokenOwner = idToOwner[_tokenId];
        require(tokenOwner==_from);
        require(_to != address(0));
        _transfer(_to, _tokenId);
    }

    function _transfer(address _to, uint256 _tokenId) internal {
        address from = idToOwner[_tokenId];
        _removeRemainToken(from, _tokenId);
        _addRemainToken(_to, _tokenId);
        emit Transfer(from, _to, _tokenId);

    }

    function _removeRemainToken(address _from,uint256 _tokenId) internal {
        require(idToOwner[_tokenId] == _from);
        
        ownedTokensCount[_from] = ownedTokensCount[_from] -1;
        delete idToOwner[_tokenId];  
    }

    function _addRemainToken(address _to, uint256 _tokenId) internal {
        idToOwner[_tokenId] = _to;
        ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
    }

    function _getOwnedTokensCount(address _owner) public view returns(uint256) {
        return ownedTokensCount[_owner];
    }

}