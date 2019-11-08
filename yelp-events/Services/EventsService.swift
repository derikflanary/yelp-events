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
import NetworkStackiOS

class EventsService: ObservableObject {
    
    private let ekEventStore = EKEventStore()
    private var cancelableRequests = Set<AnyCancellable>()
    private let fetchEventsPublisher = PassthroughSubject<(String?, Coordinate?), APIError>()
    
    @Published var events = [YelpEvent]()
    @Published var searchString: String = ""
    @Published var eventSavedToCalendar = false
    @Published var isSearching = false
    
    init() {
        fetchEventsPublisher
            .debounce(for: .milliseconds(500), scheduler: RunLoop.current)
            .removeDuplicates(by: { first, second -> Bool in
                let bool = first.0 == second.0 && first.1 == second.1
                return bool
            })
            .tryMap{ (location, coordinate) -> URLRequest in
                guard let request = Router.Event.getEvents(coordinate, location).urlRequest else { throw APIError.unsuccessfulRequest(nil) }
                self.isSearching = true
                return request
            }
            .flatMap { request in
                return Network(environment: YelpEventsProtectedApiEnvironment()).request(request, responseAs: EventsResponse.self)
            }
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                self.isSearching = false
                print(completion)
            }, receiveValue: { eventsResponse in
                self.isSearching = false
                self.events = eventsResponse.events.filter { $0.is_official }.sorted(by: { (firstEvent, secondEvent) -> Bool in
                    guard let firstDate = firstEvent.time_start.asDate(), let secondDate = secondEvent.time_start.asDate() else { return false }
                    return (firstDate as NSDate).earlierDate(secondDate) == firstDate
                })
            })
            .store(in: &cancelableRequests)
    }
    
    func fetchEvents(filteredBy locationText: String? = nil, coordinate: Coordinate? = nil) {
        fetchEventsPublisher.send((locationText, coordinate))
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
    
    private func saveEvent(_ event: EKEvent) {
        do {
            try ekEventStore.save(event, span: .thisEvent)
            eventSavedToCalendar = true
        } catch {
            print(error)
        }
    }
    
}
