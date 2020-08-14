import Foundation

public struct Roles: OptionSet {
    public let rawValue: UInt8
    
    public init(rawValue: UInt8) {
        self.rawValue = rawValue
    }

    public static let normalUser = Roles(rawValue: 1 << 0)  // 0000 0001
    public static let premiumUser = Roles(rawValue: 1 << 1) // 0000 0010
    public static let devUser = Roles(rawValue: 1 << 2)     // 0000 0100
    public static let admin = Roles(rawValue: 1 << 3)       // 0000 1000
    public static let superAdmin = Roles(rawValue: 1 << 4)  // 0001 0000
    public static let devAdmin = Roles(rawValue: 1 << 5)    // 0010 0000

    // Group of roles
    public static let empty: Roles = [] // 0000 0000
    public static let users: Roles = [.normalUser, .premiumUser, .devUser] // 0000 0111
    public static let admins: Roles = [.admin, .superAdmin, .devAdmin]     // 0011 1000
    public static let devs: Roles = [.devUser, .devAdmin]                  // 0010 0100
}
