use aiken/builtin
use aiken/collection/list
use aiken/crypto.{VerificationKeyHash}
use aiken/interval.{Finite}
use aiken/math/rational.{ceil, from_int}
use cardano/transaction.{
  InlineDatum, Input, Output, OutputReference, Transaction, ValidityRange,
}
use types.{POSIXtime}

pub fn datum_tagging_hash(output: Output, out_ref: OutputReference) -> Bool {
  let datum_tag =
    out_ref
      |> builtin.serialise_data
      |> builtin.blake2b_256
      |> InlineDatum

  output.datum == datum_tag
}

pub fn must_be_signed_by(
  transaction: Transaction,
  vk: VerificationKeyHash,
) -> Bool {
  list.has(transaction.extra_signatories, vk)
}

// // Get input from the script.
pub fn find_own_input(out_ref: OutputReference, self: Transaction) -> Input {
  let Transaction { inputs, .. } = self

  //expect and input from the out_ref.
  expect Some(input) =
    inputs
      |> transaction.find_input(out_ref)

  input
}

pub fn must_start_after(
  range: ValidityRange,
  lock_expiration_time: POSIXtime,
) -> Bool {
  when range.lower_bound.bound_type is {
    Finite(tx_earliest_time) -> lock_expiration_time <= tx_earliest_time
    _ -> False
  }
}

pub fn must_complete_before(
  range: ValidityRange,
  lock_expiration_time: POSIXtime,
) -> Bool {
  when range.upper_bound.bound_type is {
    Finite(tx_latest_time) -> lock_expiration_time > tx_latest_time
    _ -> False
  }
}

pub fn time_remaining_before_dealine(
  range: ValidityRange,
  lock_expiration_time: POSIXtime,
) -> POSIXtime {
  when range.upper_bound.bound_type is {
    Finite(tx_latest_time) -> lock_expiration_time - tx_latest_time
    _ -> fail
  }
}

pub fn divide_ceil_int(num1: Int, num2: Int) -> Int {
  expect Some(temp_div) = rational.div(from_int(num1), from_int(num2))

  ceil(temp_div)
}

test test_divide1() {
  divide_ceil_int(5, 2) == 3
}

test test_divide2() fail {
  divide_ceil_int(5, 2) == 2
}
