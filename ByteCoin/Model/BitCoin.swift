//
//  BitCoin.swift
//  ByteCoin
//
//  Created by Bhishak Sanyal on 30/10/22.
//  Copyright © 2022 The App Brewery. All rights reserved.
//

import Foundation

struct BitCoin: Codable {
    let time: String
    let asset_id_base: String
    let asset_id_quote: String
    let rate: Double
}
