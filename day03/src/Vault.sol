// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v5.4.0) (token/ERC20/IERC20.sol)

pragma solidity >=0.4.16;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol"; 
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract VaultContract is ReentrancyGuard, Ownable{
using SafeERC20 for IERC20;

IERC20 internal immutable assets;
uint256 public totalShares;

mapping(address=>uint256)public sharesOf;
constructor (IERC20 _assets) Ownable(msg.sender) {
    assets = _assets;
    
}

event RewardAdded(uint256 amount);
event Deposit(address indexed user, uint256 assets, uint256 shares);
event Withdraw(address indexed user, uint256 assets, uint256 shares);

error ZeroAmount();
error InsufficientShares();
error ZeroShares();



 function _convertToShares (uint256 assetsAmount) internal view returns (uint256) {
    uint256 totalAssets = assets.balanceOf(address(this));
    if (totalShares == 0) {
        return assetsAmount;
    }
    else return (assetsAmount * totalShares) / totalAssets;
 }

 function _convertToAssets (uint256 sharesAmount) internal view returns (uint256){
    uint256 totalAssets = assets.balanceOf(address(this));
    if (totalShares == 0){
        return (0);
    }
    else return (sharesAmount * totalAssets) / totalShares;
 }

 //-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function deposit(uint256 amount) external nonReentrant returns (uint256 shares) {
    // 1. CHECKS (Vérifications)
    if (amount == 0) revert ZeroAmount();

    shares = _convertToShares(amount);
    
    if (shares == 0) revert ZeroShares();

    // 2. EFFECTS (Changements d'état internes)
    sharesOf[msg.sender] += shares;
    totalShares += shares;

    // 3. INTERACTIONS (Appels externes vers les tokens)
    // Ici "assets" est le contrat IERC20 et "amount" est le chiffre
    assets.safeTransferFrom(msg.sender, address(this), amount);
    
    emit Deposit(msg.sender, amount, shares);
}

function withdraw(uint256 shares) public nonReentrant returns (uint256 assetsAmount) {
    if(shares == 0) revert ZeroAmount();
    if(sharesOf[msg.sender] < shares) revert InsufficientShares();
    
    assetsAmount = _convertToAssets(shares);
    
    sharesOf[msg.sender] -= shares;
    totalShares -= shares;

    assets.safeTransfer(msg.sender, assetsAmount);
    emit Withdraw(msg.sender, assetsAmount, shares);
}

function withdrawAll() public returns (uint256) {
    return withdraw(sharesOf[msg.sender]);
}

function previewDeposit(uint256 amount) external view returns (uint256) {
    return _convertToShares(amount);
}

function previewWithdraw(uint256 shares) external view returns (uint256) {
    return _convertToAssets(shares);
}

function totalAssets() public view returns (uint256) {
    return assets.balanceOf(address(this));
}

function currentRatio() external view returns (uint256) {
    if (totalShares == 0) return 1e18;
    return (totalAssets() * 1e18) / totalShares;
}

function assetsOf(address user) external view returns (uint256) {
    return _convertToAssets(sharesOf[user]);
}

function addReward(uint256 amount) external onlyOwner nonReentrant {
    if (amount == 0) revert ZeroAmount();
    if (totalShares == 0) revert ZeroShares();

    assets.safeTransferFrom(msg.sender, address(this), amount);
    
    emit RewardAdded(amount);
}

}