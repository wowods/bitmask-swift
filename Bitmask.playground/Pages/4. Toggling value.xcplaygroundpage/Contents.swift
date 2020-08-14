import Foundation

/// Scenario:
/// Your boss, Squidward, has been iritated because of his neighbors. So, he declared today as the Opposite Day.
/// Your task is to toggle `.premiumUser` and `.superAdmin` value on any roles

func oppositeDay(_ roles: Roles) -> Roles {
    // Set value we want to toggle
    let toggleValue: Roles = [.premiumUser, .superAdmin]
    
    /// Because `1 XOR 1 = 0` and `0 XOR 1 = 1`, we could use XOR operator to toggle specific value.
    /// Meanwhile `Y XOR 0 = 0` so it won't affected other values
    let rawValue = roles.rawValue ^ toggleValue.rawValue
    
    return Roles(rawValue: rawValue)
}

let richSuperAdmin: Roles = [.premiumUser, .superAdmin]
let richSuperAdminOpp = oppositeDay(richSuperAdmin)
/// Will toggle off both `.premiumUser` and `.superAdmin` from this account
richSuperAdminOpp.contains(.premiumUser) // false
richSuperAdminOpp.contains(.superAdmin)  // false

let richDeveloper: Roles = [.premiumUser, .devUser, .devAdmin]
let richDeveloperOpp = oppositeDay(richDeveloper)
/// Will turn-off `.premiumUser`, but turn-on `.superAdmin`
richDeveloperOpp.contains(.premiumUser) // false
richDeveloperOpp.contains(.superAdmin)  // true

let normalAdmins: Roles = [.normalUser, .admin, .superAdmin, .devAdmin]
let normalAdminsOpp = oppositeDay(normalAdmins)
/// Will turn-on `.premiumUser`, but turn-off `.superAdmin`
normalAdminsOpp.contains(.premiumUser) // true
normalAdminsOpp.contains(.superAdmin)  // false

let luckyUser: Roles = [.normalUser, .devUser]
let luckyUserOpp =  oppositeDay(luckyUser)
/// Will toggle on both `.premiumUser` and `.superAdmin`, what a lucky guy
luckyUserOpp.contains(.premiumUser) // true
luckyUserOpp.contains(.superAdmin)  // true
