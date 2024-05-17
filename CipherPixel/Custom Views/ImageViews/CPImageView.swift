//
//  CPImageView.swift
//  CipherPixel
//
//  Created by serhat on 17.02.2024.
//

import UIKit

class CPImageView: UIImageView {
    
//    let placeholderImage = UIImage(systemName: "square.and.arrow.down.fill")
//    let placeholderImage = UIImage(systemName: "dock.arrow.down.rectangle.fill")
    let placeholderImage = UIImage(systemName: "arrow.down.app.fill")

    
    let numberOfEmbeddedDataBits = 4    // How many least significant bits will used in 8 bits layer of pixel
    let imageIndex = [0xFE, 0xFD, 0xFB, 0xF7]
    let finishFlagBinaryArray: [UInt8] = [0, 1, 1, 0, 0, 0, 0, 1, 0, 1, 1, 0, 0, 0, 1, 0, 0, 1, 1, 0, 0, 0, 1, 1, 0, 1, 1, 0, 0, 1, 0, 0] // 32
    let startFlagBinaryArray: [UInt8]  = [1, 1, 0, 0, 0, 0, 1, 0, 1, 0, 1, 0, 1, 1, 1, 0] // registered sign  - 16
    var sizeErrorFlag = false
    var canDecode     = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setImage(_ image: UIImage){
        self.image         = image
        self.sizeErrorFlag = false
        self.canDecode     = true
    }
    
    
    private func configure() {
        tintColor           = .systemGreen
        contentMode         = .scaleAspectFit
        clipsToBounds       = true
        image               = placeholderImage
        translatesAutoresizingMaskIntoConstraints = false
    }
    
}


extension CPImageView {
    
    func modifyLastBit(embed message: inout String) -> UIImage? {
        
        //Convert image to PNG Image
        self.convertSelfImageToPNGImage()
        
        guard let cgImage = self.image?.cgImage else { return nil }
        
        var data = textToBinary(text: &message)
        data.insert(contentsOf: self.startFlagBinaryArray, at: 0)
        data.append(contentsOf: self.finishFlagBinaryArray)
        
        let width            = cgImage.width
        let height           = cgImage.height
        let bitsPerComponent = 8                                      //  cgImage.bitsPerComponent
        let bytesPerRow      = cgImage.bytesPerRow
        let colorSpace       = CGColorSpaceCreateDeviceRGB()          //  cgImage.colorSpace!
        let bitmapInfo       = CGImageAlphaInfo.noneSkipLast.rawValue //  cgImage.bitmapInfo.rawValue
        
        guard let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo) else {
            return nil }
        
        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        if let imageData = context.data?.bindMemory(to: UInt8.self, capacity: width * height * 4) {
            let bytesPerPixel        = 4    // RGBA channels
            let pixelsPerLayer       = width * height
            let dataSize             = data.count
            let maxNumberBitsOfPhoto = pixelsPerLayer * 3 * self.numberOfEmbeddedDataBits
            
            guard dataSize <= maxNumberBitsOfPhoto else {
                self.sizeErrorFlag = true
                return nil
            }
            
            var dataIndex = 0
            for significant in 0..<self.numberOfEmbeddedDataBits {
                for layer in 0..<3 {
                    for y in 0..<height {
                        for x in 0..<width {
                            let pixelOffset = y * bytesPerRow + x * bytesPerPixel
                            
                            let colorPixel = (imageData[pixelOffset + layer] &  UInt8(imageIndex[significant]) )
                            let settedBits = UInt8(data[dataIndex]) << significant
                            imageData[pixelOffset + layer] = colorPixel | settedBits    // Red-Green-Blue Channel Manipulated.
                            
                            dataIndex = dataIndex + 1
                            if dataIndex == (dataSize) { break }
                        }
                        if dataIndex == (dataSize) { break }
                    }
                    if dataIndex == (dataSize) { break }
                }
                if dataIndex == (dataSize) { break }
            }
            
            
            // Create a CGImage from modified pixel data
            if let modifiedCGImage = context.makeImage() {
                // Create a UIImage from the modified CGImage
                let modifiedImage = UIImage(cgImage: modifiedCGImage)
                // Return the UIImage
                return modifiedImage
            }
            
        }
        return nil
    }
    
    
    
    func getHiddenMessage() -> String? {
        
        guard let cgImage = self.image?.cgImage else {
            print("Failed to get CGImage from UIImage")
            return nil
        }
        
        let width            = cgImage.width
        let height           = cgImage.height
        let bitsPerComponent = cgImage.bitsPerComponent
        let bytesPerRow      = cgImage.bytesPerRow
        let colorSpace       = CGColorSpaceCreateDeviceRGB()                    //cgImage.colorSpace ?? CGColorSpaceCreateDeviceRGB()
        let bitmapInfo       = cgImage.bitmapInfo.rawValue
        
        guard let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo) else {
            return nil }
        
        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        if let imageData = context.data?.bindMemory(to: UInt8.self, capacity: width * height * 4)  {
            let bytesPerPixel          = 4    // RGBA channels
            var finishFlag             = false
            var dataIndex              = 0
            var messageBinary: [UInt8] = []
            var compareFinishFlag      = Array(repeating: UInt8(0), count: 32)
//            var compareStartFlag       = Array(repeating: UInt8(0), count: 16)
            
            for significant in 0..<self.numberOfEmbeddedDataBits {
                for layer in 0..<3 {
                    for y in 0..<height {
                        for x in 0..<width {
                            
                            let pixelOffset = y * bytesPerRow + x * bytesPerPixel
                            let message = ( imageData[pixelOffset + layer] >> significant ) & 0x01
                            messageBinary.append(UInt8(message))
                            processArray(&compareFinishFlag, newValue: UInt8(message))
                            if compareFinishFlag == self.finishFlagBinaryArray {
                                finishFlag = true
                                break
                            }
                            dataIndex = dataIndex + 1
                            //Check start flag.
                            if dataIndex == self.startFlagBinaryArray.count {
                                let cmp = Array(compareFinishFlag.suffix(16))
                                if cmp != self.startFlagBinaryArray {
                                    self.canDecode = false
                                    return nil
                                }
                            }
                            if finishFlag { break }
                        }
                        if finishFlag { break }
                    }
                    if finishFlag { break }
                }
                if finishFlag { break }
            }
            messageBinary.removeFirst(self.startFlagBinaryArray.count)
            messageBinary.removeLast(self.finishFlagBinaryArray.count)
            let secretMessage = binaryToText(binaryArray: &messageBinary)
            return secretMessage
        }else {
            return nil
        }
    }
    
}




extension CPImageView {
    
    private func convertSelfImageToPNGImage() {
        if let imageData = self.image?.png() {
            self.image = UIImage(data: imageData)
        }
    }
    
    
    private func processArray(_ array: inout [UInt8], newValue: UInt8) {
        array.removeFirst()
        array.append(newValue)
    }
    
    
    func textToBinary(text: inout String) -> [UInt8] {
        guard let data = text.data(using: .utf8) else {
            return [] // Empty array if unable to get data from text
        }
        var binaryArray = [UInt8]()
        
        for byte in data {
            var bits = [UInt8](repeating: 0, count: 8)
            var num = byte
            var index = 7
            
            while num > 0 {
                bits[index] = num % 2
                num /= 2
                index -= 1
            }
            binaryArray.append(contentsOf: bits)
        }
        return binaryArray
    }
    
    
    func binaryToText(binaryArray: inout [UInt8]) -> String? {
        var byteArray = [UInt8]()
        var byte: UInt8 = 0
        var bitCount = 0
        
        for bit in binaryArray {
            byte = (byte << 1) | bit
            bitCount += 1
            
            if bitCount == 8 {
                byteArray.append(byte)
                byte = 0
                bitCount = 0
            }
        }
        guard let text = String(bytes: byteArray, encoding: .utf8) else {
            return nil
        }
        
        return text
    }
    
}





