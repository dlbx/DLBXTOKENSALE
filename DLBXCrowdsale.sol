pragma solidity ^0.4.15;

/**
 * DealBox Crowdsale Contract
 *
 * This is the crowdsale contract for the DLBX Token. It utilizes Majoolr's
 * CrowdsaleLib library to reduce custom source code surface area and increase
 * overall security.Majoolr provides smart contract services and security reviews
 * for contract deployments in addition to working on open source projects in the
 * Ethereum community.
 * For further information: dlbx.io, majoolr.io
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
 * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
 * CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
 * TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
 * SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

import "./DirectCrowdsaleLib.sol";
import "./CrowdsaleToken.sol";

contract DLBXCrowdsale {
  using DirectCrowdsaleLib for DirectCrowdsaleLib.DirectCrowdsaleStorage;

  DirectCrowdsaleLib.DirectCrowdsaleStorage sale;
  uint256 public discountEndTime;

  function DLBXCrowdsale(
                address owner,
                uint256[] saleData,           // [1509937200, 65, 0]
                uint256 fallbackExchangeRate, // 28600
                uint256 capAmountInCents,     // 30000000000
                uint256 endTime,              // 1516417200
                uint8 percentBurn,            // 100
                uint256 _discountEndTime,     // 1513738800
                CrowdsaleToken token)         // 0xabe9ce5be54de2d588665b8a4f8c5489d8d51502
  {
  	sale.init(owner, saleData, fallbackExchangeRate, capAmountInCents, endTime, percentBurn, token);
    discountEndTime = _discountEndTime;
  }

  //Events
  event LogTokensBought(address indexed buyer, uint256 amount);
  event LogAddressCapExceeded(address indexed buyer, uint256 amount, string Msg);
  event LogErrorMsg(uint256 amount, string Msg);
  event LogTokenPriceChange(uint256 amount, string Msg);
  event LogTokensWithdrawn(address indexed _bidder, uint256 Amount);
  event LogWeiWithdrawn(address indexed _bidder, uint256 Amount);
  event LogOwnerEthWithdrawn(address indexed owner, uint256 amount, string Msg);
  event LogNoticeMsg(address _buyer, uint256 value, string Msg);

  // fallback function can be used to buy tokens
  function () payable {
    sendPurchase();
  }

  function sendPurchase() payable returns (bool) {
    if (now > discountEndTime){
      if(msg.value < 17480000000000000000){
        sale.base.saleData[sale.base.milestoneTimes[0]][0] = 75;
      } else {
        sale.base.saleData[sale.base.milestoneTimes[0]][0] = 50;
      }
    } else {
      if(msg.value < 15035000000000000000){
        sale.base.saleData[sale.base.milestoneTimes[0]][0] = 65;
      } else {
        sale.base.saleData[sale.base.milestoneTimes[0]][0] = 43;
      }
    }
  	return sale.receivePurchase(msg.value);
  }

  function withdrawTokens() returns (bool) {
  	return sale.withdrawTokens();
  }

  function withdrawLeftoverWei() returns (bool) {
    return sale.withdrawLeftoverWei();
  }

  function withdrawOwnerEth() returns (bool) {
    return sale.withdrawOwnerEth();
  }

  function crowdsaleActive() constant returns (bool) {
    return sale.crowdsaleActive();
  }

  function crowdsaleEnded() constant returns (bool) {
    return sale.crowdsaleEnded();
  }

  function setTokenExchangeRate(uint256 _exchangeRate) returns (bool) {
    return sale.setTokenExchangeRate(_exchangeRate);
  }

  function setTokens() returns (bool) {
    return sale.setTokens();
  }

  function getOwner() constant returns (address) {
    return sale.base.owner;
  }

  function getTokensPerEth() constant returns (uint256) {
    if (now > discountEndTime){
      return 382;
    } else {
      return 440;
    }
  }

  function getExchangeRate() constant returns (uint256) {
    return sale.base.exchangeRate;
  }

  function getCapAmount() constant returns (uint256) {
      return sale.base.capAmount;
  }

  function getStartTime() constant returns (uint256) {
    return sale.base.startTime;
  }

  function getEndTime() constant returns (uint256) {
    return sale.base.endTime;
  }

  function getEthRaised() constant returns (uint256) {
    return sale.base.ownerBalance;
  }

  function getContribution(address _buyer) constant returns (uint256) {
  	return sale.base.hasContributed[_buyer];
  }

  function getTokenPurchase(address _buyer) constant returns (uint256) {
  	return sale.base.withdrawTokensMap[_buyer];
  }

  function getLeftoverWei(address _buyer) constant returns (uint256) {
    return sale.base.leftoverWei[_buyer];
  }

  function getSaleData() constant returns (uint256) {
    if (now > discountEndTime){
      return 75;
    } else {
      return 65;
    }
  }

  function getTokensSold() constant returns (uint256) {
    return sale.base.startingTokenBalance - sale.base.withdrawTokensMap[sale.base.owner];
  }

  function getPercentBurn() constant returns (uint256) {
    return sale.base.percentBurn;
  }
}
