// Copyright © 2022 Planogy Inc. All rights reserved.

import Foundation

struct Card {
  let address: String
  let ens: String?
  let beans: String

  static let example = Card(address: "0x123456789012345678901234567890", ens: "my-friend.eth", beans: "20")

  var shortAddress: String {
    address.prefix(7).lowercased() + "..." + address.suffix(3).lowercased()
  };
}
