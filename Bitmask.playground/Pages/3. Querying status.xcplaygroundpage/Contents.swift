import Foundation

/// Scenario:
/// You just want to check if a role is contains any user roles or not.

func isUser(_ roles: Roles) -> Bool {
    // We can check specific bit is "on" by using AND operator, and check if the result is zero or not
    return (roles.rawValue & Roles.users.rawValue) > 0
    // or you could use `.intersection()` and `.isEmpty` from SetAlgebra
//    return !roles.intersection(.users).isEmpty
}

/// If I have a role that doesn't include any user, it should return false
let justAnAdmin: Roles = .admin
isUser(justAnAdmin)

/// If I have a role that include all users, it should return true
let boss: Roles = [.users, .admins, .devs]
isUser(boss)

/// If I have a role that include any user role, it also should return true
let richSuperAdmin: Roles = [.premiumUser, .superAdmin]
isUser(richSuperAdmin)
