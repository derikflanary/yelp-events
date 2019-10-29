//
//  YelpEvent.swift
//  yelp-events
//
//  Created by Derik Flanary on 10/29/19.
//  Copyright © 2019 Derik Flanary. All rights reserved.
//

import Foundation
import EventKit

class YelpEvent: Codable, Identifiable {
    
    let attending_count: Int
    let category: String
    let cost: Decimal?
    let description: String
    let event_site_url: String
    let id: String
    let image_url: String
    let interested_count: Int
    let is_free: Bool
    let is_official: Bool
    let name: String
    let tickets_url: String?
    let time_end: String?
    let time_start: String
    let location: Location
    
    func asCalendarEvent(store: EKEventStore) -> EKEvent {
        let event = EKEvent(eventStore: store)
        event.calendar = store.defaultCalendarForNewEvents
        event.startDate = time_start.asDate()
        event.notes = description
        if let endDate = time_end?.asDate() {
            event.endDate = endDate
        }
        event.title = name
        return event
    }
}

struct Location: Codable {

    let address1: String
    let address2: String?
    let address3: String?
    let city: String
    let zip_code: String
    let country: String
    let state: String
    let display_address: [String]
    
    var addressString: String {
        return display_address.joined(separator: "\n")
    }
}
