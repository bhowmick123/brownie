from brownie import accounts,network,FundMe,exceptions
import pytest
from scripts.helpful_scripts import get_account,LOCAL_BLOCKCHAIN_ENVIRONMENTS
from scripts.deploy import deploy_fund_me
def test_can_fund_and_withdraw():
    account=get_account()
    fund_me=deploy_fund_me()
    entrancefee=fund_me.leastamountusd()
    tx=fund_me.payme({"from":account,"value":entrancefee})
    tx.wait(1)
    assert fund_me.amountfundedarray(account.address)==entrancefee
    tx2=fund_me.withdraw({"from":account})
    tx2.wait(1)
    assert fund_me.amountfundedarray(account.address)==0
def test_only_owner_can_withdraw():
    if network.show_active() not in LOCAL_BLOCKCHAIN_ENVIRONMENTS:
        pytest.skip("only for local testing")
    fund_me = deploy_fund_me()
    bad_actor = accounts.add()
    fund_me.withdraw({"from": bad_actor})
    with pytest.raises(exceptions.VirtualMachineError):
        fund_me.withdraw({"from":bad_actor})

