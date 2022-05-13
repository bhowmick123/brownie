from brownie import FundMe
from scripts.helpful_scripts import get_account


def fund():
    fund_me = FundMe[-1]
    account = get_account()
    entrance_fee = fund_me.leastamountusd()
    print(entrance_fee)
    latest_price=fund_me.getlatestprice()
    print(latest_price)
    print(f"The current entry fee is {entrance_fee}")
    print("Funding")
    fund_me.payme({"from": account, "value": entrance_fee})


def withdraw():
    fund_me = FundMe[-1]
    account = get_account()
    fund_me.withdraw({"from": account})


def main():
    fund()
    withdraw()
