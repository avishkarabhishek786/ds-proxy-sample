// SPDX-License-Identifier: MIT
// https://rinkeby.etherscan.io/address/0xCa77db118de2698383649b6649CF359FAf06a132
pragma solidity ^0.8.4;

interface IERC20 {
    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `from` to `to` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);
}

interface IPunk is IERC20 {
    function mint(address to, uint256 amount) external;
}

interface ISample {
    function setX(uint256 _x) external;
    function getX() external view returns(uint256);
}

contract Target {

    // Here DSProxy acts as spender for owner's fund. Owner should first approve DSProxy 
    function ownerToRecvr(address punk, address owner, address recvr,uint256 amount) public payable {
        IPunk(punk).transferFrom(owner, recvr, amount);
        if(msg.value>0) {
            payable(address(recvr)).transfer(msg.value);
        }
    }

    // Here DSProxy can be used as wallet. Owner should first send tokens to DSProxy
    function proxyToRecvr(address punk, address recvr,uint256 amount) public payable {
        IPunk(punk).transfer(recvr, amount);
        if(msg.value>0) {
            payable(address(recvr)).transfer(msg.value);
        }
    }

    function setingX(address sample, uint256 amount) public {
        ISample(sample).setX(amount);
    }

    function fooSetX(address sample, address punk, address owner, address recvr, uint256 amount) external payable {
        IPunk(punk).transferFrom(owner, recvr, amount);
        ISample(sample).setX(amount);   
        if(msg.value>0) {
            payable(address(recvr)).transfer(msg.value);
        }
    }

}