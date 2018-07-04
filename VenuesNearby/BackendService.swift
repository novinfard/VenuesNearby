//
//  BackendService.swift
//  VenuesNearby
//
//  Created by Soheil on 01/07/2018.
//  Copyright © 2018 Soheil Novinfard. All rights reserved.
//

import Foundation
import Alamofire

struct ApiUrl {
	static let explore = "https://api.foursquare.com/v2/venues/explore"
	static let search = "https://api.foursquare.com/v2/venues/search"
}

struct ApiKey {
	static let clientId = "LBFX1G2UYL4BUWX0XKKGAFLV0YPL5QLX5YI55GAZRUC5S3P1"
	static let clientSecret = "1QHM4R4IY2UPVS4DENHQPBCCT34VHB153EE1ULQ3CPUOOQJI"
}

class BackendService: NSObject {
	static let shared = BackendService()
	
	/// This function call network requests with parameters and return the result in its closures
	///
	/// - Parameter httpMethod: The type of HTTP method such as 'get' and 'post'
	/// - Parameter params: The parameters of requests
	/// - Parameter url: The endpoint URL
	/// - Parameter onSuccess: The closure returned in case of successful request
	/// - Parameter onFailure: The closure returned in case of failed request
	func callNetwork( httpMethod: HTTPMethod, params: Dictionary<String, Any>?, url: String, onSuccess success:@escaping (_ data: Data?)->Void, onFailure failure:@escaping (_ error :Error)->Void ) -> Void {
		var requestedParams = params
		// add api key to requests
		if requestedParams != nil {
			let todaysDate = Date()
			let dateFormatter = DateFormatter()
			dateFormatter.dateFormat = "yyyyMMdd"
			let todayString = dateFormatter.string(from: todaysDate)

			requestedParams!["client_id"]		= ApiKey.clientId
			requestedParams!["client_secret"]	= ApiKey.clientSecret
			requestedParams!["v"]				= todayString
		}
		
		let newUrl : String
		if let trailer = String.queryStringFromParameters(parameters: requestedParams as! Dictionary<String, String>) {
			newUrl = url + trailer
		} else {
			newUrl = url
		}
		
		Alamofire.request(newUrl, method: httpMethod, parameters: nil).responseJSON { response in
			// error handling
			guard case let .failure(error) = response.result else {
				// successful
//				print(response)
				success(response.data)
				return
			}
			if let error = error as? AFError {
				failure(error)
			} else if let error = error as? URLError {
				failure(error)
			}
		}
	}
	
}

extension String {
	func URLEncodedString() -> String? {
		let escapedString = self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
		return escapedString
	}
	static func queryStringFromParameters(parameters: Dictionary<String,String>) -> String? {
		if (parameters.count == 0)
		{
			return nil
		}
		var queryString : String? = nil
		for (key, value) in parameters {
			if let encodedKey = key.URLEncodedString() {
				if let encodedValue = value.URLEncodedString() {
					if queryString == nil {
						queryString = "?"
					}
					else {
						queryString! += "&"
					}
					queryString! += encodedKey + "=" + encodedValue
				}
			}
		}
		return queryString
	}
}
