//
//  ViewController.swift
//  VenuesNearby
//
//  Created by Soheil on 30/06/2018.
//  Copyright © 2018 Soheil Novinfard. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		
		ContentService.shared.getTopVenues(success: {
			$0
		}) {
			$0
		}
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

