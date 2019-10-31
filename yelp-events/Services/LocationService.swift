//
//  LocationService.swift
//  yelp-events
//
//  Created by Derik Flanary on 10/29/19.
//  Copyright © 2019 Derik Flanary. All rights reserved.
//

import Foundation
import CoreLocation

class LocationService: NSObject, ObservableObject {
    
    var eventsStore: EventsService?
    let locationManager = CLLocationManager()
    
    init(eventsStore: EventsService) {
        self.eventsStore = eventsStore
        super.init()
        locationManager.delegate = self
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    func findCurrentLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
}

extension LocationService: CLLocationManagerDelegate {
 
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard locations.count > 0 else { return }
        locationManager.stopUpdatingLocation()
        let userLocation: CLLocation = locations[0] as CLLocation
        let currentLocation = Coordinate(latitude: Decimal(userLocation.coordinate.latitude), longitude: Decimal(userLocation.coordinate.longitude))
        eventsStore?.fetchEvents(coordinate: currentLocation)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        default:
            break
        }
    }
    
}

struct Coordinate: Equatable {
    
    let latitude: Decimal
    let longitude: Decimal
    
}
