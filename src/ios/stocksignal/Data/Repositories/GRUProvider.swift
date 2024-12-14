//
//  GruProvider.swift
//  stocksignal
//
//  Created by 신예빈 on 11/28/24.
//

import Foundation
import CoreML

class GRUProvider {
    let model = try! GruModel(configuration: MLModelConfiguration())
    
    var maxItem = 0
    var minItem = 0
    var maxVolume = 1000000000
    var minVolume = 0
    
    public func predict(items: [Dates]) -> [Int] {
        var result:[Int] = []
        
        let input = try! MLMultiArray(shape: [1, 100, 5], dataType: .float32)
        
        for i in 0...99 {
            if items[i].startPrice > maxItem {
                maxItem = items[i].startPrice
            }
            
            if items[i].highPrice > maxItem {
                maxItem = items[i].highPrice
            }
            
            if items[i].lowPrice > maxItem {
                maxItem = items[i].lowPrice
            }
            
            if items[i].closePrice > maxItem {
                maxItem = items[i].closePrice
            }
            
            if items[i].tradingVolume > maxVolume {
                maxVolume = items[i].tradingVolume
            }
            
            if items[i].startPrice < minItem {
                maxItem = items[i].startPrice
            }
            
            if items[i].highPrice < minItem {
                maxItem = items[i].highPrice
            }
            
            if items[i].lowPrice < minItem {
                maxItem = items[i].lowPrice
            }
            
            if items[i].closePrice < minItem {
                maxItem = items[i].closePrice
            }
            
            if items[i].tradingVolume < minVolume {
                minVolume = items[i].tradingVolume
            }
        }
        
        for i in 0...99 {
            input[i * 5]     = Float(items[i].startPrice - minItem)      / Float(maxItem - minItem) as NSNumber
            input[i * 5 + 1] = Float(items[i].highPrice - minItem)       / Float(maxItem - minItem) as NSNumber
            input[i * 5 + 2] = Float(items[i].lowPrice - minItem)        / Float(maxItem - minItem) as NSNumber
            input[i * 5 + 3] = Float(items[i].closePrice - minItem)      / Float(maxItem - minItem) as NSNumber
            input[i * 5 + 4] = Float(items[i].tradingVolume - minVolume) / Float(maxVolume - minVolume) as NSNumber
        }
        
        var gruInput = GruModelInput(x_1: input)
        
        var out = try! model.prediction(input: gruInput)
        
        
        for _ in 1...29 {
            for i in 0...494 {
                input[i] = input[i+5]
            }
            
            for i in 0...4 {
                input[i + 495] = out.linear_36[i]
            }
            
            gruInput = GruModelInput(x_1: input)
            
            out = try! model.prediction(input: gruInput)
            
            let convPrice = Float(truncating: out.linear_36[0]) * Float(maxItem - minItem) + Float(minItem)
            let convPrice2 = Int(convPrice / Float(getUnit(price: maxItem))) * getUnit(price: maxItem)
            result.append(convPrice2)
        }
        
        return result
    }
    
    public func getUnit(price: Int) -> Int {
        if (price < 2000) {
            return 1
        }
        else if (price < 5000) {
            return 5
        }
        else if (price < 20000) {
            return 10
        }
        else if (price < 50000) {
            return 50
        }
        else if (price < 200000) {
            return 100
        }
        else if (price < 500000) {
            return 500
        }
        else {
            return 1000
        }
    }
}

