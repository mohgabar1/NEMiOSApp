
import Foundation

func Base32Encode(data: NSData) -> String {
	let alphabet = [ "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "2", "3", "4", "5", "6", "7"]
	return Base32Encode(data, alphabet)
}

func Base32HexEncode(data: NSData) -> String {
	let alphabet = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V"]
	return Base32Encode(data, alphabet)
}

func Base32Decode(data: String) -> NSData? {
	let characters = [ "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "2", "3", "4", "5", "6", "7"]
	let __ = 255
	let alphabet = [
		__,__,__,__, __,__,__,__, __,__,__,__, __,__,__,__,  // 0x00 - 0x0F
		__,__,__,__, __,__,__,__, __,__,__,__, __,__,__,__,  // 0x10 - 0x1F
		__,__,__,__, __,__,__,__, __,__,__,__, __,__,__,__,  // 0x20 - 0x2F
		__,__,26,27, 28,29,30,31, __,__,__,__, __, 0,__,__,  // 0x30 - 0x3F
		__, 0, 1, 2,  3, 4, 5, 6,  7, 8, 9,10, 11,12,13,14,  // 0x40 - 0x4F
		15,16,17,18, 19,20,21,22, 23,24,25,__, __,__,__,__,  // 0x50 - 0x5F
		__, 0, 1, 2,  3, 4, 5, 6,  7, 8, 9,10, 11,12,13,14,  // 0x60 - 0x6F
		15,16,17,18, 19,20,21,22, 23,24,25,__, __,__,__,__,  // 0x70 - 0x7F
		__,__,__,__, __,__,__,__, __,__,__,__, __,__,__,__,  // 0x80 - 0x8F
		__,__,__,__, __,__,__,__, __,__,__,__, __,__,__,__,  // 0x90 - 0x9F
		__,__,__,__, __,__,__,__, __,__,__,__, __,__,__,__,  // 0xA0 - 0xAF
		__,__,__,__, __,__,__,__, __,__,__,__, __,__,__,__,  // 0xB0 - 0xBF
		__,__,__,__, __,__,__,__, __,__,__,__, __,__,__,__,  // 0xC0 - 0xCF
		__,__,__,__, __,__,__,__, __,__,__,__, __,__,__,__,  // 0xD0 - 0xDF
		__,__,__,__, __,__,__,__, __,__,__,__, __,__,__,__,  // 0xE0 - 0xEF
		__,__,__,__, __,__,__,__, __,__,__,__, __,__,__,__,  // 0xF0 - 0xFF
	]
	return Base32Decode(data, alphabet, characters)
}

//func Base32HexDecode(data: String) -> NSData? {
//	let alphabet = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V"]
//	return Base32Decode(data, alphabet)
//}

func Base32Encode(data: NSData, alphabet: Array<String>) -> String {
	let numberOfBlocks = Int(ceil(Double(data.length) / Double(5)))
	
	var result = String()
	
	let bytes = UnsafePointer<UInt8>(data.bytes)
	for byteIndex in stride(from: 0, to: data.length, by: 5) {
		let maxOffset = (byteIndex + 5 >= data.length) ? data.length : byteIndex + 5
		let numberOfBytes = maxOffset - byteIndex
		
		var byte0: UInt8 = 0
		var byte1: UInt8 = 0
		var byte2: UInt8 = 0
		var byte3: UInt8 = 0
		var byte4: UInt8 = 0
		
		switch numberOfBytes {
		case 5:
			byte4 = UInt8(bytes[byteIndex + 4])
			fallthrough
		case 4:
			byte3 = UInt8(bytes[byteIndex + 3])
			fallthrough
		case 3:
			byte2 = UInt8(bytes[byteIndex + 2]) 
			fallthrough
		case 2:
			byte1 = UInt8(bytes[byteIndex + 1]) 
			fallthrough
		case 1:
			byte0 = UInt8(bytes[byteIndex + 0]) 
			fallthrough
		default:
			break
		}
		
		var encodedByte0 = "="
		var encodedByte1 = "="
		var encodedByte2 = "="
		var encodedByte3 = "="
		var encodedByte4 = "="
		var encodedByte5 = "="
		var encodedByte6 = "="
		var encodedByte7 = "="
		
		switch numberOfBytes {
		case 5:
			encodedByte7 = alphabet[Int( byte4 & 0x1F )]
			fallthrough;
		case 4:
			encodedByte6 = alphabet[Int( ((byte3 << 3) & 0x18) | ((byte4 >> 5) & 0x07) )]
			encodedByte5 = alphabet[Int( ((byte3 >> 2) & 0x1F) )]			
			fallthrough
		case 3:
			encodedByte4 = alphabet[Int( ((byte2 << 1) & 0x1E) | ((byte3 >> 7) & 0x01) )]
			fallthrough
		case 2:
			encodedByte2 = alphabet[Int( ((byte1 >> 1) & 0x1F) )]
			encodedByte3 = alphabet[Int( ((byte1 << 4) & 0x10) | ((byte2 >> 4) & 0x0F) )]
			fallthrough
		case 1:
			encodedByte0 = alphabet[Int( ((byte0 >> 3) & 0x1F) )]
			encodedByte1 = alphabet[Int( ((byte0 << 2) & 0x1C) | ((byte1 >> 6) & 0x03)  )]
			fallthrough
		default:
			break
		}
		
		result += encodedByte0 + encodedByte1 + encodedByte2 + encodedByte3 + encodedByte4 + encodedByte5 + encodedByte6 + encodedByte7
	}
	
	return result
}

func Base32Decode(data: String, alphabet: Array<Int>, characters: Array<String>) -> NSData? {
	var processingData = ""

	for char in data.uppercaseString {
		let str = String(char)
		if contains(characters, str) {
			processingData += str
		} else if !contains(characters, str) && str != "=" {
			return nil
		}
	}
	
	if let base32Data = processingData.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: false) {
		// how much space do we need
		let fullGroups = base32Data.length / 8
		var bytesInPartialGroup: Int = 0
		switch base32Data.length % 8 {
		case 0:
			bytesInPartialGroup = 0
		case 2:
			bytesInPartialGroup = 1
		case 4:
			bytesInPartialGroup = 2
		case 5:
			bytesInPartialGroup = 3
		case 7:
			bytesInPartialGroup = 4
		default:
			return nil
		}
		let totalNumberOfBytes = fullGroups * 5 + bytesInPartialGroup
		
		// allocate a buffer big enough for our decode
		let buffer = UnsafeMutablePointer<UInt8>.alloc(totalNumberOfBytes)
		let base32Bytes = UnsafePointer<UInt8>(base32Data.bytes)
		
		var decodedByteIndex = 0;
		for byteIndex in stride(from: 0, to: base32Data.length, by: 8) {
			let maxOffset = (byteIndex + 8 >= base32Data.length) ? base32Data.length : byteIndex + 8
			let numberOfBytes = maxOffset - byteIndex
			
			var encodedByte0: UInt8 = 0
			var encodedByte1: UInt8 = 0
			var encodedByte2: UInt8 = 0
			var encodedByte3: UInt8 = 0
			var encodedByte4: UInt8 = 0
			var encodedByte5: UInt8 = 0
			var encodedByte6: UInt8 = 0
			var encodedByte7: UInt8 = 0
			
			switch numberOfBytes {
			case 8:
				encodedByte7 = UInt8(alphabet[Int( base32Bytes[byteIndex + 7] )])
				fallthrough
			case 7:
				encodedByte6 = UInt8(alphabet[Int( base32Bytes[byteIndex + 6] )])
				fallthrough
			case 6:
				encodedByte5 = UInt8(alphabet[Int( base32Bytes[byteIndex + 5] )])
				fallthrough
			case 5:
				encodedByte4 = UInt8(alphabet[Int( base32Bytes[byteIndex + 4] )])
				fallthrough
			case 4:
				encodedByte3 = UInt8(alphabet[Int( base32Bytes[byteIndex + 3] )])
				fallthrough
			case 3:
				encodedByte2 = UInt8(alphabet[Int( base32Bytes[byteIndex + 2] )])
				fallthrough
			case 2:
				encodedByte1 = UInt8(alphabet[Int( base32Bytes[byteIndex + 1] )])
				fallthrough
			case 1:
				encodedByte0 = UInt8(alphabet[Int( base32Bytes[byteIndex + 0] )])
				fallthrough
			default:
				break;
			}
			
			buffer[decodedByteIndex + 0] = ((encodedByte0 << 3) & 0xF8) | ((encodedByte1 >> 2) & 0x07)
			buffer[decodedByteIndex + 1] = ((encodedByte1 << 6) & 0xC0) | ((encodedByte2 << 1) & 0x3E) | ((encodedByte3 >> 4) & 0x01)
			buffer[decodedByteIndex + 2] = ((encodedByte3 << 4) & 0xF0) | ((encodedByte4 >> 1) & 0x0F)
			buffer[decodedByteIndex + 3] = ((encodedByte4 << 7) & 0x80) | ((encodedByte5 << 2) & 0x7C) | ((encodedByte6 >> 3) & 0x03)
			buffer[decodedByteIndex + 4] = ((encodedByte6 << 5) & 0xE0) | (encodedByte7 & 0x1F)
			
			decodedByteIndex += 5
		}
		
		return NSData(bytesNoCopy: buffer, length: totalNumberOfBytes, freeWhenDone: true)
	}
	return nil
}

extension String {
	var base32EncodedString: String? {
		get {
			if let data = (self as NSString).dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
				return Base32Encode(data)
			} else {
				return nil
			}
		}
	}
	
	var base32DecodedData: NSData? {
		get {
			return Base32Decode(self)
		}
	}
	
	func base32DecodedString(encoding: NSStringEncoding = NSUTF8StringEncoding) -> String? {
		if let data = self.base32DecodedData {
			return NSString(data: data, encoding: encoding)! as String
		} else {
			return nil
		}
	}
}