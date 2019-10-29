//
//  EventsStore.swift
//  yelp-events
//
//  Created by Derik Flanary on 10/28/19.
//  Copyright © 2019 Derik Flanary. All rights reserved.
//

import Foundation
import Combine

class EventsStore: ObservableObject {
    
    var anyCancelableRequest: AnyCancellable?
    
    @Published var events = [YelpEvent]()
    @Published var searchString: String = ""
    
    
    func fetchEvents(filteredBy locationText: String? = nil) {
        guard let request = Router.Event.getEvents(40.231163, -111.651599, locationText).urlRequest else { return }
        anyCancelableRequest = Network(environment: Environment()).request(request, responseAs: EventsResponse.self)
            .sink(receiveCompletion: { completion in
                print(completion)
            }, receiveValue: { eventsResponse in
                self.events = eventsResponse.events
            })
    }
    
}

struct EventsResponse: Codable {
    
    var events: [YelpEvent]
    
}


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
    let tickets_url: String
    let time_end: String
    let time_start: String
    let location: Location
    
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
    
}


extension String {
    
    func dateConverted() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyy-MM-dd'T'HH:mm:ss-hh:mm"
        guard let date = formatter.date(from: self) else { return "Date not found"}
        formatter.timeZone = TimeZone(identifier: "UTC")
        formatter.dateFormat = "MMM d, h:mm a"
        return formatter.string(from: date)
    }
}
