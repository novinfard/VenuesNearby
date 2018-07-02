//
//  ContentService.swift
//  VenuesNearby
//
//  Created by Soheil on 01/07/2018.
//  Copyright © 2018 Soheil Novinfard. All rights reserved.
//

import Foundation
class ContentService: NSObject {
	static let shared = ContentService()
	
	func getTopVenues(success: @escaping (_ vanues: [Venue]?)-> Void, failure: @escaping(_ error: Error)-> Void) {
		let parameters = [
			"ll"	: "40.7,-74",
			"near"	: "NYC"
		]
	
		BackendService.shared.callNetwork(httpMethod: .get, params: parameters, url: ApiUrl.explore, onSuccess: { jsonData in
//			if let jsonData = jsonData {
//				let vanues = try? JSONDecoder().decode(VenueResponse.self, from: jsonData)
//				success(vanues)
//			}
		}) { error in
			failure(error)
		}
	}
}
