//
//  ContentService.swift
//  VenuesNearby
//
//  Created by Soheil on 01/07/2018.
//  Copyright © 2018 Soheil Novinfard. All rights reserved.
//

import Foundation
import SwiftyJSON

class ContentService: NSObject {
	static let shared = ContentService()
	
	enum contentError: Error {
		case invalidData
		case invalidServiceFetch
	}
	
	func getTopVenues(placeName: String, locationLL: String?, success: @escaping (_ spot: [Spot]?)-> Void, failure: @escaping(_ error: Error)-> Void) {
		
		let llString = locationLL ?? "40.7,-74"
		let parameters = [
			"ll"	: llString,
			"near"	: placeName
		]
		
		print(parameters)
		
		BackendService.shared.callNetwork(httpMethod: .get, params: parameters, url: ApiUrl.explore, onSuccess: { jsonData in
			guard let jsonData = jsonData else {
				failure(contentError.invalidData)
				return
			}
			do {
				let json = try JSON(data: jsonData)
				print(json)
				if json["meta"]["code"].intValue == 200 {
					success(self.parseSpots(json: json))
					
				} else {
					failure(contentError.invalidServiceFetch)
				}
			} catch let error as NSError {
				failure(error)
			}
			
			
			
		}) { error in
			failure(error)
		}
	}
	
	private func parseSpots(json: JSON) -> [Spot] {
		var results = [Spot]()
//		print (json)
		for spot in json["response"]["groups"][0]["items"].arrayValue {
			let venueTemp = spot["venue"]
			let locTemp = venueTemp["location"]
			let location = Location(
				state: locTemp["state"].stringValue,
				city: locTemp["city"].stringValue,
				postalCode: locTemp["postalCode"].stringValue,
				lng: locTemp["lng"].doubleValue,
				lat: locTemp["lat"].doubleValue,
				formattedAddress: locTemp["formattedAddress"].arrayValue.map { $0.stringValue},
				distance: locTemp["distance"].intValue,
				address: locTemp["address"].stringValue)
			var categories = [CategoryObject]()
			for cat in venueTemp["categories"].arrayValue {
				let category = CategoryObject(
					name: cat["name"].stringValue,
					primary: cat["primary"].boolValue,
					id: cat["id"].stringValue,
					pluralName: cat["pluralName"].stringValue,
					shortName: cat["shortName"].stringValue
				)
				categories.append(category)
			}
			let venueItem = Venue(name: venueTemp["name"].stringValue, location: location, id: venueTemp["id"].stringValue, categories: categories)
			
			var reasons = [Reason]()
			for rs in spot["reasons"]["items"].arrayValue {
				let reasonItem = Reason(
					summary: rs["summary"].stringValue,
					type: rs["type"].stringValue,
					reasonName: rs["reasonName"].stringValue
				)
				reasons.append(reasonItem)
			}
			let spotItem = Spot(venue: venueItem, reasons: reasons)
			results.append(spotItem)
		}
		
		return results
	}
}

