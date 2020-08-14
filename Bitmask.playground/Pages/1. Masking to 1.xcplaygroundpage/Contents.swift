import Foundation

/// Scenario:
/// This weeks we are having a promo, all user will be getting premium account until the end of the week.
/// You need to set `premiumUser` value to 1 for everybody.

let freeUser: Roles = [.normalUser]           // 0000 0001
let boss: Roles = [.premiumUser, .superAdmin] // 0001 0010

// You can masking spesific bit to 1 using `OR` operator
let freeUserMasked = Roles(rawValue: freeUser.rawValue | Roles.premiumUser.rawValue)
// or you could using .union from SetAlgebra
// let freeUserMasked = freeUser.union(.premiumUser)

let bossMasked = Roles(rawValue: boss.rawValue | Roles.premiumUser.rawValue)
// let bossMasked = boss.union(.premiumUser) // you could also using .union


freeUser.rawValue.binaryDescription       // 0000 0001
freeUserMasked.rawValue.binaryDescription // 0000 0011

boss.rawValue.binaryDescription           // 0001 0010
bossMasked.rawValue.binaryDescription     // 0001 0010
