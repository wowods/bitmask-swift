import Foundation

/// This is some example using bitwise operator as substitute to `SetAlgebra`, with some example and proof of axioms  based on https://developer.apple.com/documentation/swift/setalgebra
/// I am not encouraging you to using bitwise operator since `SetAlgebra` is much more conveniece and readable to use. This is only for the sake of learning.

// Let's make some roles
let normalPerson: Roles = [.normalUser]             // 0000 0001
let richPerson: Roles = [.normalUser, .premiumUser] // 0000 0011
let masterAdmin: Roles = [.admin, .superAdmin]      // 0001 1000
let richAdmin: Roles = [.admin, .premiumUser]       // 0000 1010
// 0011 1111
let jackofalltrades: Roles = [.normalUser, .premiumUser, .devUser, .admin, .superAdmin, .devAdmin]

// MARK: UNION

extension Roles {
    // bw means bitwise :)
    func bwUnion(_ roles: Roles) -> Roles {
        let rawValue = self.rawValue | roles.rawValue
        return Roles(rawValue: rawValue)
    }
}

/*
 `union` example:
 .normalUser = 0b 0000 0001
 .admin      = 0b 0000 1000
 -> result   = 0b 0000 1001 (9)
 */
Roles.normalUser.bwUnion(.admin).rawValue
Roles.normalUser.union(.admin).rawValue

// x.union(x) == x
Roles.admin.bwUnion(.admin) == Roles.admin

// x.union([]) == x
Roles.admin.bwUnion(.empty) == Roles.admin


// MARK: INTERSECTION

func bwIntersection(_ roles1: Roles, _ roles2: Roles) -> Roles {
    let rawValue = roles1.rawValue & roles2.rawValue
    return Roles(rawValue: rawValue)
}

/*
 `intersection` example:
 masterAdmin = 0b 0001 1000
 richAdmin   = 0b 0000 1010
 -> result   = 0b 0000 1000 (8)
 */
bwIntersection(masterAdmin, richAdmin).rawValue
masterAdmin.intersection(richAdmin).rawValue

// x.intersection(x) == x
bwIntersection(richAdmin, richAdmin) == richAdmin

// x.intersection([]) == []
bwIntersection(richAdmin, .empty) == Roles.empty


// MARK: CONTAINS

extension Roles {
    func bwContains(_ roles: Roles) -> Bool {
        return self.rawValue & roles.rawValue == roles.rawValue
    }
}

/*
 `contains` example :
 richAdmin    = 0b 0000 1010
 .premiumUser = 0b 0000 0010
 -> result    = 0b 0000 0010 (equal to .premiumUser, so it'll return true)
 */
richAdmin.bwContains(.premiumUser)
richAdmin.contains(.premiumUser)
richAdmin.isSuperset(of: .premiumUser)
Roles.premiumUser.isSubset(of: richAdmin)

// x.contains(e) implies x.union(y).contains(e)
richPerson.bwContains(.premiumUser)
richPerson.bwUnion(richAdmin).bwContains(.premiumUser)

// x.union(y).contains(e) implies x.contains(e) || y.contains(e)
normalPerson.bwUnion(.devs).bwContains(.devAdmin)
normalPerson.bwContains(.devAdmin) || Roles.devs.bwContains(.devAdmin)

// x.contains(e) && y.contains(e) if and only if x.intersection(y).contains(e)
richPerson.bwContains(.premiumUser) && richAdmin.bwContains(.premiumUser)
bwIntersection(richPerson, richAdmin).bwContains(.premiumUser)


// MARK: isSubset + isSuperset and isStrictSubset + isStrictSuperset

extension Roles {
    func bwIsSubset(of roles: Roles) -> Bool {
        return self.rawValue & roles.rawValue == self.rawValue
    }
    
    func bwIsStrictSubset(of roles: Roles) -> Bool {
        return self.bwIsSubset(of: roles) && self != roles
    }
    
    func bwIsSuperset(of roles: Roles) -> Bool {
        return self.rawValue & roles.rawValue == roles.rawValue
    }
    
    func bwIsStrictSuperset(of roles: Roles) -> Bool {
        return self.bwIsSuperset(of: roles) && self != roles
    }
}

// x.isSubset(of: y) implies x.union(y) == y
masterAdmin.bwIsSubset(of: .admins)
masterAdmin.bwUnion(.admins) == .admins

// x.isSuperset(of: y) implies x.union(y) == x
jackofalltrades.bwIsSuperset(of: .devs)
jackofalltrades.bwUnion(.devs) == jackofalltrades

// x.isSubset(of: y) if and only if y.isSuperset(of: x)
masterAdmin.bwIsSubset(of: .admins)
Roles.admins.bwIsSuperset(of: masterAdmin)

// x.isStrictSuperset(of: y) if and only if x.isSuperset(of: x) && x != y
masterAdmin.bwIsSuperset(of: masterAdmin) // non-strict should be true
masterAdmin.bwIsStrictSuperset(of: masterAdmin) // should be false

Roles.admins.bwIsSuperset(of: masterAdmin)
Roles.admins.bwIsStrictSuperset(of: masterAdmin)

// x.isStrictSubset(of: y) if and only if x.isSubset(of: x) && x != y
masterAdmin.bwIsSubset(of: masterAdmin) // non-strict should be true
masterAdmin.bwIsStrictSubset(of: masterAdmin) // should be false

masterAdmin.bwIsSubset(of: .admins)
masterAdmin.bwIsStrictSubset(of: .admins)
