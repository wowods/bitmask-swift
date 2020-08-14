import Foundation

/// Scenario:
/// In production server, you want to avoid any user to accidentally accessing developer feature.
/// You need to set `devUser` and `devAdmin` to 0 for everybody.

func setNoDeveloper(_ roles: Roles) -> Roles {
    /// `Roles.devs` contains data where developer roles has value `1`
    // Roles.devs.rawValue -> 0010 0100
    
    /// Since we want to masking `devs` value to 0, we need to reverse its value (make a complement)
    let notDevs = Roles(rawValue: ~Roles.devs.rawValue) // 1101 1011
    
    return Roles(rawValue: roles.rawValue & notDevs.rawValue)
    // or you could use `.intersection` from SetAlgebra
//    return roles.intersection(notDevs)
}

// Create some set data
let notDeveloper: Roles = [.normalUser, .admin]
let userTester: Roles = [.devUser]
let premiumDeveloper: Roles = [.premiumUser, .devUser, .devAdmin]

// All result most not contains any developer roles

let notDeveloperTest = setNoDeveloper(notDeveloper)
notDeveloperTest.contains(.devUser)
notDeveloperTest.contains(.devAdmin)
/// It won't changes anything if user doesn't have developer roles
notDeveloper.rawValue.binaryDescription // 0000 1001
notDeveloper.rawValue.binaryDescription // 0000 1001

let userTesterTest = setNoDeveloper(userTester)
userTesterTest.contains(.devUser)
userTesterTest.contains(.devAdmin)
/// It will revoke all developer roles
userTester.rawValue.binaryDescription     // 0000 0100
userTesterTest.rawValue.binaryDescription // 0000 0000

let premiumDeveloperTest = setNoDeveloper(premiumDeveloper)
premiumDeveloperTest.contains(.devUser)
premiumDeveloperTest.contains(.devAdmin)
/// But, it won't changes others roles beside `.devUser` and `.devAdmin`
premiumDeveloper.rawValue.binaryDescription     // 0010 0110
premiumDeveloperTest.rawValue.binaryDescription // 0000 0010
