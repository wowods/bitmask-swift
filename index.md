---
layout: article
title: Bit masking in Swift
---

Bit masking is a method to manipulate bit data, which is very useful when you deal with something similar to setting options or a set of rules. On swift, bit masking is implemented using `OptionSet` which will make your life easier to manipulate the data using `SetAlgebra`, rather than handle it manually using bitwise operator.

This article will be divided into three parts:
- Bitwise operator
- `OptionSet`
- `SetAlgebra`
- Some example

## Bitwise operator

There are four common bitwise operators that we'll be using:
- `NOT (~)`
- `AND (&)`
- `OR (|)`
- `XOR (^)`

Be careful, since bitwise operator for `AND` and `OR` is quite similar to its logical operator with the same name `AND (&&)` and `OR (||)`,  the difference is logical operator only receive `Bool` as their input. 

Those bitwise operators will have result:
[ TODO: add images and tables here ]
For further information about bitwise operator, you could check [Swift Docs about Advanced Operators](https://docs.swift.org/swift-book/LanguageGuide/AdvancedOperators.html).

Let's do some example on these operators :
```swift
let initialbit: UInt8 = 0b00110011
print(initialbit)  // 0b 0011 0011 -> 51
print(~initialbit) // 0b 1100 1100 -> 204

let firstbit: UInt8 = 11    // 0b 0000 1011
let secondbit: UInt8 = 5    // 0b 0000 0101

print(firstbit & secondbit) // 0b 0000 0001 -> 1
print(firstbit | secondbit) // 0b 0000 1111 -> 15
print(firstbit ^ secondbit) // 0b 0000 1110 -> 14
```

There are also bitwise operators called `Left-shift operator (<<)` and `right-shift operator (>>)` where they shifting all the bits in a number to the left or right by a certain number (with some rules applied). On this occasion, I will only talk about shifting unsigned integer value, since it's much more simpler and that what we need for now. If you are interesting to learn more about it you could head to [ TODO: Swift Docs link here ].

Shift operator will move any bits to left or right and then fill the gap that it leaves behind with zero. If any value is moving outside the boundary, it just being discarded. For example: 

```swift
let initialbit: UInt8 = 0b00110011
// Remember that after shifting, any `gap` will be filled with zero,
// meanwhile any value that shifted beyond the boundary will be discarded.
initialbit << 1      // 0b 0110 0110 -> the 1s move one place to the left
initialbit >> 1      // 0b 0001 1001 -> the 1s move one place to the right
initialbit >> 3      // 0b 0000 0110 -> the 1s move three places to the right.
```  


## OptionSet

Knowing all these operators won't be useful when we don't have any data to manipulate with. So, in this case, I will introduce you to `OptionSet`, a bit data provided by Swift that we can use easily.

On bit masking, we used to have a bit data which every bit on the data represent different meaning or value (this bit data usually called bit field). For example, I need to handle an account which can have some roles, such as `normal user`, `premium user `, `admin`, or `developer`. We could make an `OptionSet` represent those data :

```swift
struct AccountRoles: OptionSet {
    let rawValue: UInt8
    
    static let normalUser  = AccountRoles(rawValue: 1 << 0) // 0b 0000 0001
    static let premiumUser = AccountRoles(rawValue: 1 << 1) // 0b 0000 0010
    static let devUser     = AccountRoles(rawValue: 1 << 2) // 0b 0000 0100
    static let admin       = AccountRoles(rawValue: 1 << 3) // 0b 0000 1000
    static let superAdmin  = AccountRoles(rawValue: 1 << 4) // 0b 0001 0000
    static let devAdmin    = AccountRoles(rawValue: 1 << 5) // 0b 0010 0000
    
    // We could also declare a group of account roles
    static let users: AccountRoles = [.normalUser, .premiumUser, .devUser]
    static let admins: AccountRoles = [.admin, .superAdmin, .devAdmin]
    static let devs: AccountRoles = [.devUser, .devAdmin]
}
```

The groups just merging all the values that they represent. [ TODO: double check these values]

```swift
print(AccountRoles.users.rawValue)  //  7 aka 0b 0000 0111
print(AccountRoles.admins.rawValue) // 56 aka 0b 0011 1000
print(AccountRoles.devs.rawValue)   // 36 aka 0b 0010 0100

// So we could easily create an `AccountRoles` like this:
let richAdmin: AccountRoles = [.admin, .premiumUser]
```

Since `OptionSet` raw value is a bit data, we could apply bitwise operator on its raw value. For example, when we want to join or merge two roles into one variable, we could apply `&` to `OptionSet` that we want to join.

```swift
let mergeRawValue = AccountRoles.admins | AccountRoles.devs
// .admins -> 0011 1000
// .devs   -> 0010 0100
// --------------------- OR
// result  -> 0011 1100

// Then we could take this raw value result and create an AccountRoles
let adminPlusDev = AccountRoles(rawValue: mergeRawValue)
```

Calling `.rawValue` every time we want to modify the data is quite exhausting, but fortunately `OptionSet` is conforming `SetAlgebra` protocol, so we could use the algebra functions when we want to modify the data. So without further ado, let's check out about `SetAlgebra`.


## SetAlgebra

`SetAlgebra` is a mathematical set operation such as intersection, union, etc. By using `SetAlgebra` function, it could increase our code readability since it's much easier to understand what modification that is being applied to the data compared by using bitwise operator.

Below are some of `SetAlgebra` functions with its illustration and also its equivalent result using bitwise operator.
[ TODO: insert image here ]

You could imagine that each `SetAlgebra` function is doing some bitwise operator with some rules on it. I made some examples of the function using bitwise operator that you could check over here. [ TODO: insert link to GitHub file ]

You could combine `SetAlgebra` function with bitwise operator for more complex operation that you need. In the next part, I will make some examples of implementation for what already we learn before.


## Example

I am referencing Wikipedia [ TODO: add link to Wikipedia ] for some common function on bit masking and will try to make an example with our `AccountRole` that has been declared above.

### Masking bit to `1`

To alter specific bit into `1`, we could use `OR` operator, since
- `Y OR 0 = Y` 
- `Y OR 1 = 1`

so it could change any value `Y` into `1` when it meets with `1`, but will not changes the value when it meets with `0`.

```swift
// For example, we have bit 1001 0110.
// And we want to change bit 1-2-5-6 to `1`, without changing values on bit 3-4-7-8

1001 0110
0011 0011
--------- OR
1011 0111 <-- result
```

So imagine we have a case like this,
> Your apps want to makes a deal for this weekend, so you need to turn-on value `premiumUser` on all accounts. 

We could easily achieve this by masking value `premiumUser` to `1` using `OR` operator.

```swift
let adminWithoutPremium: AccountRoles = [.admin, .normalUser] // 0000 1001

// Now we user `OR` to masking 
let adminNowPremiumValue = adminWithoutPremium.rawValue | AccountRoles.premiumUser
let adminNowPremium = AccountRoles(rawValue: adminNowPremiumValue)
// or you could use .union from SetAlgebra
// let adminNowPremium = adminWithouPremium.union(.premiumUser)

//  0000 1001 <-- adminWithoutPremium
//  0000 0010 <-- .premiumUser
//  ---------- OR
//  0000 1011 <-- result = adminNowPremium
```

You could use this method to mask multiple values at once. 
[ TODO: link to playground page ]

### Masking bit to `0`

Alter bit to `0` or turn-off some bit value could be achieved using `AND` operator, since
- `Y AND 0 = 0`
- `Y AND 1 = Y`

But careful with the operand, because to turn-off a bit, you need value `0` on that position and value `1` when you don't want to change its value. Here's an example:

```swift
// For example, we have bit value 1101 1011.
// And we want to change bit 1-2-5-6 to `0`, without changing values on bit 3-4-7-8

1101 1011
1100 1100
--------- AND
1100 1000 <-- result
```

So, if you get this task:
> You don't want any accounts with `developer` roles are still being active on production build. So you need to turn-off the developer roles for all accounts on production server.

You could do it by using `AND` operator with `AccountRoles.admins`. But remember, we need value `0` on the bits that we want to turn-off, so we need to invert the values of `AccountRoles.admins` first, before doing the operation.

```swift
// TODO: example here
```

Here's the link to playground page for the example. [ TODO: link to playground page ]

### Querying bit value

Querying bit value means you want to check if bit on a specific position is turn-on (having value `1`) or not. You could achieve this with `AND` operator because it only return value `1` when `1 AND 1`.

```swift
// For example, we have bit value 1101 1011.
// And we want to check if any bits on 1-2-3-4 is turn-on or not
1101 1011
0000 1111
--------- AND
0000 1011 <-- // This result tell us that bit 1, 2 and 4 is `ON`.

// And if we check on bit 3 and 6
1101 1011
0010 0100
--------- AND
0000 0000 <-- // Since all the result is 0, that means the bits we check are all `OFF`.
```

So if you get a task to check any value like this,
> You just want to check if an account has role of user or not. It could be any user, either `.normalUser`, `.premiumUser`, `.devUser`, or any combination of it.

Just use `AND` operator and check if the results are all zero or not.

```swift
// TODO: example here
```

Or alternatively, you could use `SetAlgebra` function `.intersection` combine with `.isEmpty`, to get the same result.
[ TODO: link to playground page ]

### Toggling bit value

Toggling bit value means to revert the value from `0` to `1` and vice versa. This looks like combining masking to `0` and masking to `1` to a single operation. This operation can be done using `XOR` operator.

```swift
// For example, we have bit value 1100 0011.
// And we want to toggle all the bits
1100 0011
1111 1111
--------- XOR
0011 1100 <-- result
```

So, imagine that you are in this condition,
> TODO example case

[ TODO: explanation ]

## Conclusion

So, in Swift we could make data for bitmask operation by using `OptionSet` that also conforms to `SetAlgebra` protocol. You could use functions from `SetAlgebra` to do some operation, or just using bitwise operator by getting `rawValue` from the `OptionSet`.

Bit masking could be useful when you want to turning on or off some value on `OptionSet` and also can be used for checking the status of specific data on it.

If you want to check the example or try it by yourself, you could check this GitHub repository that contains Swift Playground for it.

***
