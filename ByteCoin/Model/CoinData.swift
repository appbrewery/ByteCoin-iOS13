//
//  CoinData.swift
//  ByteCoin
//
//  Created by Ramon Seoane Martin on 21/4/23.
//  Copyright © 2023 The App Brewery. All rights reserved.
//

import Foundation

struct CoinData: Decodable {
	
	// En realidad solo voy a necesitar el campo "rate"
	
	let time: String
	let asset_id_base: String
	let asset_id_quote: String
	let rate: Double
}
