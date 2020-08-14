import Foundation

public func printBinary(_ first: UInt8, _ operatorName: String, _ second: UInt8, result: UInt8) {
    let firstLine = first.binaryDescription
    let secondLine = second.binaryDescription
    let thirdLine = "---------- \(operatorName)"
    let resultLine = result.binaryDescription
    
    print(firstLine)
    print(secondLine)
    print(thirdLine)
    print(resultLine)
}

extension BinaryInteger {
    public var binaryDescription: String {
        var binaryString = ""
        var internalNumber = self
        var counter = 0

        for _ in (1...self.bitWidth) {
            binaryString.insert(contentsOf: "\(internalNumber & 1)", at: binaryString.startIndex)
            internalNumber >>= 1
            counter += 1
            if counter % 4 == 0 {
                binaryString.insert(contentsOf: " ", at: binaryString.startIndex)
            }
        }

        return binaryString
    }
}
