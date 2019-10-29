//
//  EventsStore.swift
//  yelp-events
//
//  Created by Derik Flanary on 10/28/19.
//  Copyright © 2019 Derik Flanary. All rights reserved.
//

import Foundation
import Combine
import EventKit

class EventsStore: ObservableObject {
    
    private let ekEventStore = EKEventStore()
    private var cancelableNetworkRequest: AnyCancellable?
    
    @Published var events = [YelpEvent]()
    @Published var searchString: String = ""
    @Published var eventSavedToCalendar = false
    @Published var isSearching = false
    
    
    func fetchEvents(filteredBy locationText: String? = nil, coordinate: Coordinate? = nil) {
        guard let request = Router.Event.getEvents(coordinate, locationText).urlRequest else { return }
        isSearching = true
        cancelableNetworkRequest?.cancel()
        cancelableNetworkRequest = Network(environment: Environment()).request(request, responseAs: EventsResponse.self)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                self.isSearching = false
            }, receiveValue: { eventsResponse in
                self.events = eventsResponse.events.sorted(by: { (firstEvent, secondEvent) -> Bool in
                    guard let firstDate = firstEvent.time_start.asDate(), let secondDate = secondEvent.time_start.asDate() else { return false }
                    return (firstDate as NSDate).earlierDate(secondDate) == firstDate
                })
            })
    }
    
    func insertEventIntoCalcendar(_ yelpEvent: YelpEvent) {
        switch EKEventStore.authorizationStatus(for: .event) {
        case .authorized:
            saveEvent(yelpEvent.asCalendarEvent(store: ekEventStore))
        case .denied:
            print("access denied")
        case .notDetermined:
            ekEventStore.requestAccess(to: .event, completion: { [weak self] (granted: Bool, error: Error?) -> Void in
                  if granted {
                    let event = yelpEvent.asCalendarEvent(store: self!.ekEventStore)
                    self!.saveEvent(event)
                  } else {
                        print("Access denied")
                  }
            })
        default:
            print("restricted")
        }
    }
    
    func saveEvent(_ event: EKEvent) {
        do {
            try ekEventStore.save(event, span: .thisEvent)
            eventSavedToCalendar = true
        } catch {
            print(error)
            print("failed to save event")
        }
    }
    
}

struct EventsResponse: Codable {
    
    var events: [YelpEvent]
    
}
