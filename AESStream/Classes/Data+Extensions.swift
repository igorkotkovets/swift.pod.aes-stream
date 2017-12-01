//
//  Data+Extensions.swift
//  Pods
//
//  Created by Igor Kotkovets on 11/5/17.
//

import Foundation

extension Data {
    var hexString: String {
        var result = ""

        var bytes = [UInt8](repeating: 0, count: count)
        copyBytes(to: &bytes, count: count)

        for byte in bytes {
            result += String(format: "%02x", UInt(byte))
        }

        return result
    }

    public init?(hex string: String) {
        // Convert 0 ... 9, a ... f, A ...F to their decimal value,
        // return nil for all other input characters
        func decodeNibble(character: UInt16) -> UInt8? {
            switch character {
            case 0x30 ... 0x39: // 0..9
                return UInt8(character - 0x30)
            case 0x41 ... 0x46: // A..F
                return UInt8(character - 0x41 + 10)
            case 0x61 ... 0x66: // a..f
                return UInt8(character - 0x61 + 10)
            default:
                return nil
            }
        }

        self.init(capacity: string.utf16.count/2)
        var even = true
        var byte: UInt8 = 0
        for c in string.utf16 {
            guard let val = decodeNibble(character: c) else { return nil }
            if even {
                byte = val << 4
            } else {
                byte += val
                self.append(byte)
            }
            even = !even
        }
        guard even else { return nil }
    }
}
