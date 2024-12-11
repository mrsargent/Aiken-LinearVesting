use cardano/address.{Address}
use cardano/assets.{AssetName, PolicyId}

//******************************************
//********* standard util types ************
//******************************************
pub type POSIXtime =
  Int

pub type AssetClass {
  policyid: PolicyId,
  tokenName: AssetName,
}

//******************************************
//*********  linear vesting datum ********
//******************************************
pub type VestingDatum {
  beneficiary: Address,
  vestingAsset: AssetClass,
  totalVestingQty: Int,
  vestingPeriodStart: Int,
  vestingPeriodEnd: Int,
  firstUnlockPossibleAfter: Int,
  totalInstallments: Int,
}

pub type VestingRedeemer {
  PartialUnlock
  FullUnlock
}
