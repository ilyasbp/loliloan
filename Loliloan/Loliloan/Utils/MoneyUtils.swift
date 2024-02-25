//
//  MoneyUtils.swift
//  Loliloan
//
//  Created by Ilyas Bintang Prayogi on 25/02/24.
//

import Foundation

class MoneyUtils {
    
    static func toRupiah(_ value: String) -> String {
        return toRupiah(Int(value)!)
    }
    
    static func toRupiah(_ value: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "id_ID")
        if var inRupiah = formatter.string(from: NSNumber(value: value)) {
            inRupiah.insert(" ", at: inRupiah.index(inRupiah.startIndex, offsetBy: 2))
            return inRupiah
        }
        return "FAILED"
    }
}
