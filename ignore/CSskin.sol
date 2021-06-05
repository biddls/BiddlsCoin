// todo: Biddls coin
// Implement Chain Link
// [![built-with openzeppelin](https://img.shields.io/badge/built%20with-OpenZeppelin-3677FF)](https://docs.openzeppelin.com/)
// https://api2.foldingathome.org/user/Ytl

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/presets/ERC1155PresetMinterPauser.sol";
//import "@openzeppelin/contracts/access/Ownable.sol";
//import "./@chainlink/contracts/src/v0.8/dev/ChainlinkClient.sol";

contract CSCoin is ERC1155PresetMinterPauser {//, ChainlinkClient {
	uint256[] public skinQuantities;
	uint256 public itemCount = 0;  // the number of items in existence
	uint256 public uniqueSkinCount = 0;  // the number of just skins existence
	uint256 public skinCount = 0; // running total of how many skins the contract manages
	// 0 is biddls coin
	// 1 is case
	// > 1 is everything else
	uint256 public liquidityProviderBiddls = 0;
	uint256 public liquidityProviderCase = 0;
	mapping(string => account) public scores;

	struct account{
		bool isAccount;
		uint256 userScore;
		address outAddress;
	}

//	uint256 public volume;
//	address private oracle = 0x3a56ae4a2831c3d3514b5d7af5578e45ebdb7a40;
//	bytes32 private jobId = "3b7ca0d48c7a4b2da9268456665d11ae";
//	uint256 private fee = 0.01 * 10 ** 18;

	/**
	* Network: Kovan
	* Oracle: 0x3a56ae4a2831c3d3514b5d7af5578e45ebdb7a40
	* Job ID: 3b7ca0d48c7a4b2da9268456665d11ae
	* Fee: 0.01 LINK
	*/
	constructor(uint256 biddls) ERC1155PresetMinterPauser("./api/item/{id}.json") {
		addLiquidity(biddls, 0); // biddls coin
		itemCount++;
		addLiquidity(0, 1); // case
		itemCount++;
//		setPublicChainlinkToken();
	}

	// makes a new skin
	function newSkin(uint256 _amount) public virtual {
		mint(address(this), itemCount, _amount, "");
//		_balances[itemCount][address(this)] += _amount;
		itemCount++;  // increments the number of items in existence
		uniqueSkinCount++;  // increments the number of just skins existence
		skinCount += _amount;
		skinQuantities.push(_amount);
		addLiquidity(_amount, 1);
	}

	// swaps biddls coin and opens the cases
	function swapOpen (uint256 _amount) public {
		uint256 toOpen = swap(_amount); // swaps biddls coin to cases
		OpenCases(toOpen); // return opened cases
	}

	// swaps biddls coin to cases
	function swap (uint256 _amount) public returns (uint256) {
		require(balanceOf(msg.sender, 0) >= _amount, "Not enough coins"); // make sure there is biddls coin
		require(isApprovedForAll(msg.sender, address(this)));
		uint256 toOpen = findSwapAmount(_amount); // find the _amount of cases to give out and updates the AMM values
		require(balanceOf(address(this), 1) >= toOpen, "not enough cases");

		// takes in biddls coin
		safeTransferFrom(msg.sender, address(this), 0, _amount, "");

		// sends out cases
		safeTransferFrom(address(this), msg.sender, 1, toOpen, "");

		return toOpen; // used in another function
	}

	// public function to open their cases with checks
	function OpenCases(uint256 _amount) public {
		require(balanceOf(msg.sender, 1) >= _amount, "need more tokens"); // make sure you have
		privateOpenCases (_amount);
	}

	// This just simulates drawing down the score they ascertain
	function drawDown(string memory _name, uint256 _amount) public returns (uint256 change){
//		bytes32 requestId = requestUserScore();
//		uint256 _amount = fulfill(requestId, 0);
		uint256 _change = updateUser(_name, _amount);
		_mint(msg.sender, 0, _change, "");
		return _change;
	}

	// This just simulates drawing down the score they ascertain but spends the coins on opening cases
	function drawDownOpen(string memory _name, uint256 _score) public { // will need to implement controls here to restrict access
		uint256 _amount = drawDown(_name, _score);
		swapOpen(_amount); // swaps them for cases
	}

	// inits a new user
	function signUp(string memory _name, uint256 _amount) public {
		require(!userExists(_name), "Account no exist"); // make sure its not writing over an account
//		bytes32 requestId = requestUserScore();
//		uint256 _amount = fulfill(requestId, 0);
		scores[_name].userScore = _amount;
		scores[_name].isAccount = true;
	}

	// returns a struct of data about the details tied to a specific user from F@H
	function getUserInfo(string memory _name) public view returns (account memory user){
		require(userExists(_name));
		return scores[_name];
	}

	// opens the cases but without checks
	function privateOpenCases(uint256 _amount) internal virtual {
//		_amount = _amount / 1; // change that 1 too number of decimals
		require(_amount > 0, "Not enough cases"); // make sure that the number of cases you can open is > 0
		uint256[] memory ids = new uint256[](_amount); // inits array to hold IDs
		uint256[] memory amounts = new uint256[](_amount); // inits array to hold quantities of IDs
		_burn(msg.sender, 1, _amount); // delete that number of cases from the users inventory
		for (uint256 _i = 0; _i < _amount; ++_i) { // for each of the cases that can be unlocked
			uint256 _index = random(skinCount); // idk the logic may break down we will see but it'll be long after im dead
			uint256 _temp = 0; // resets the progress counter
			for (uint256 _skinIndex = 0; _skinIndex < skinQuantities.length; ++_skinIndex) { // looks through the array of cases
				_temp += skinQuantities[_skinIndex]; // counts up
				if (_temp >= _index){ // checks if larger
					ids[_i] = _skinIndex + 2; // adds the ID if found to a list of skins
					amounts[_i] = 1; // adds the quantity of skins unboxed of that ID
					skinCount--; // reduces the number of skins in existence
					skinQuantities[_skinIndex]--; // reduces the number of that type of skin
					break; // exists the loop
				}
			}
		}

		// transfers skins to user
		require(ids.length == amounts.length, "ids != amounts");
		require(msg.sender != address(0), "no transfer to 0 address");
		safeBatchTransferFrom(address(this), msg.sender, ids, amounts, "");
//		for (uint256 i = 0; i < ids.length; ++i) {
//			uint256 id = ids[i];
//			uint256 amount = amounts[i];
//
//			uint256 fromBalance = _balances[id][address(this)];
//			require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
//			_balances[id][address(this)] = fromBalance - amount;
//			_balances[id][msg.sender] += amount;
//		}
	}

	// its in the name
	function random(uint256 _max) internal view returns (uint) { // change this to be a better generator
		require(_max > 0);
		uint _randomNumber = uint(keccak256(abi.encodePacked(block.timestamp, block.difficulty, msg.sender, "random"))) % _max;
		return _randomNumber;
	}

	// this mints liquidity to the pair
	function addLiquidity(uint256 _amount, uint256 _id) public { // will need to implement controls here to restrict access
		require(hasRole(MINTER_ROLE, _msgSender()), "must have minter role");
		if (_id == 0) { // if its adding to the
			mint(address(this), 0, _amount, "");
//			_balances[0][address(this)] += _amount;
			liquidityProviderBiddls += _amount;
		} else if (_id == 1) {
			mint(address(this), 1, _amount, "");
//			_balances[1][address(this)] += _amount;
			liquidityProviderCase += _amount;
		}
	}

	// basic AMM math to simulate massively increasing price as the ratios change
	function findSwapAmount (uint256 _amount) internal virtual returns (uint256) {
		uint256 tempToSwap = _amount + liquidityProviderBiddls; // used as a temp variable
		uint256 casesYouGet = (_amount * liquidityProviderCase) / tempToSwap; // calculates how many cases are bought
		require(casesYouGet > 0, "cannot afford 1 case");
		liquidityProviderBiddls += _amount; // adds those biddls coin to the pool
		liquidityProviderCase -= casesYouGet; // removes the cases from the pool
		return casesYouGet;
	}

	// returns TRUE if a user exists and FALSE if not
	function userExists(string memory _name) view internal returns(bool exists) {
		return scores[_name].isAccount;
	}

	// updates the users data
	function updateUser(string memory _name, uint256 _userScore) internal returns (uint256 change) {
		// change user score for a chain link lookup
		require(userExists(_name), "Account no exist");
		uint256 _change = _userScore - scores[_name].userScore;
		require(_change <= _userScore, "Overflow occurred");
		scores[_name].userScore = _userScore;
		return _change;
	}

	/**
    //Create a Chainlink request to retrieve API response, find the target
//	function requestUserScore() public returns (bytes32 requestId) {
//		Chainlink.Request memory request = buildChainlinkRequest(jobId, msg.sender, this.fulfill.selector);
//
//		// string(abi.encodePacked(a, b));
//		// Set the URL to perform the GET request on
//		request.add("get", "https://api2.foldingathome.org/user/Ytl");
//
//		// Set the path to find the desired data in the API response, where the response format is:
//		request.add("path", "score");
//
//		// Sends the request
//		return sendChainlinkRequestTo(oracle, request, fee);
//	}
//
//	//Receive the response in the form of uint256
//	function fulfill(bytes32 _requestId, uint256 _volume) public recordChainlinkFulfillment(_requestId)	{
//		volume = _volume;
//	}*/
}