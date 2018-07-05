//
//  ParserScheme.swift
//  VenuesNearby
//
//  Created by Soheil on 01/07/2018.
//  Copyright © 2018 Soheil Novinfard. All rights reserved.
//

import Foundation

struct  Spot {
	let venue: Venue
	let reasons: [Reason]
}

struct Reason {
	let summary: String?
	let type: String?
	let reasonName: String?
}

struct Venue {
	let name: String
	let location: Location?
	let id: String?
	let categories: [CategoryObject]?
}

struct Location {
	let state: String?
	let city: String?
	let postalCode: String?
	let lng: Double?
	let lat: Double?
	let formattedAddress: Array<String>?
	let distance: Int?
	let address: String?
}

struct CategoryObject {
	let name: String
	let primary: Bool?
	let id:	String?
	let pluralName: String?
	let shortName: String?
}
