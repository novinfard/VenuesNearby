//
//  ViewController.swift
//  VenuesNearby
//
//  Created by Soheil on 30/06/2018.
//  Copyright © 2018 Soheil Novinfard. All rights reserved.
//

import UIKit
import MBProgressHUD
import CoreLocation

class ViewController: UIViewController {
	@IBOutlet weak var searchBar: UISearchBar!
	@IBOutlet weak var tableView: UITableView!
	
	var spots: [Spot]?
	let locationManager = CLLocationManager()
	var currentLocationLL: String?
	private var searchTimer: Timer?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView.dataSource = self
		tableView.delegate = self
		searchBar.delegate = self
		
		requestLocation()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	@objc func loadVenues(timer: Timer) {
		let placeName = timer.userInfo as! String
		guard placeName.count >= 3 else {
			return
		}

		var llString: String?
		if let currentLoc = currentLocationLL {
			llString = currentLoc
		}
		
		ContentService.shared.getTopVenues(placeName: placeName, locationLL: llString, success: { spotItems in
			self.spots = spotItems
			DispatchQueue.main.async {
				self.tableView.reloadData()
			}
		}) { error in
			print(error)
		}
	}
	
	private func startLoader() {
		let loadingNotification = MBProgressHUD.showAdded(to: view, animated: true)
		loadingNotification.mode = MBProgressHUDMode.indeterminate
		loadingNotification.label.text = "Loading"
	}
	
	private func endLoader() {
		MBProgressHUD.hide(for: self.view, animated: true)
	}
	
	private func requestLocation() {
		locationManager.delegate = self
		locationManager.desiredAccuracy = kCLLocationAccuracyBest
		locationManager.requestWhenInUseAuthorization()
		locationManager.requestLocation()
	}
}

extension ViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return spots?.count ?? 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "spotCell", for: indexPath) as! SpotTableViewCell
		
		if let spots = spots {
			let spot = spots[indexPath.row]
			
			cell.name.text = spot.venue.name
			cell.categories.text = spot.venue.categories?.map{$0.name}.joined(separator: ", ")
			if let address = spot.venue.location?.address {
				cell.address.text = address
			}
			if let distance = spot.venue.location?.distance {
				cell.distance.text = "\(distance) meters"
			}
		}
		
		return cell
	}
}

extension ViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 100
	}
	
	func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
		searchBar.resignFirstResponder()
	}
}

extension ViewController: UISearchBarDelegate {
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		searchBar.endEditing(true)
	}
	
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		if let searchTimer = searchTimer {
			searchTimer.invalidate()
		}
		
		if let text: String = searchBar.text {
			searchTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(ViewController.loadVenues(timer:)), userInfo: text, repeats: false)
		}

	}
}

extension ViewController : CLLocationManagerDelegate {
	
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		print("error:: \(error.localizedDescription)")
	}
	
	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		if status == .authorizedWhenInUse {
			locationManager.requestLocation()
		}
	}
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
		currentLocationLL = "\(locValue.latitude),\(locValue.longitude)"
	}
}

