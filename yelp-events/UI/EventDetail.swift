//
//  EventDetail.swift
//  yelp-events
//
//  Created by Derik Flanary on 10/29/19.
//  Copyright © 2019 Derik Flanary. All rights reserved.
//

import Foundation
import SwiftUI

struct EventDetailView: View {
    
    var event: YelpEvent
    @ObservedObject var eventsStore: EventsService
    
    var body: some View {
        VStack {
            URLImage(url: URL(string: event.image_url)!)
                .frame(maxHeight: 200)
                
            VStack(alignment: .leading) {
                Text(event.name)
                    .font(.title)
                    .lineLimit(4)
                Text(event.time_start.dateConverted())
                    .font(.subheadline)
                    .foregroundColor(Color(UIColor.secondaryLabel))
                    .padding(.top, 16)
                Text(event.description)
                    .padding(.top, 16)
                    .lineLimit(100)
                    .font(.body)
                
                Button(action: {
                    guard let url = LocationService.mapURL(with: self.event.location.addressString) else { return }
                    UIApplication.shared.open(url)
                }) {
                    HStack {
                        Text(event.location.addressString)
                            .font(.callout)
                            .lineLimit(6)
                            .foregroundColor(Color(UIColor.secondaryLabel))
                        Spacer()
                        Text("Open in Maps")
                    }
                }
                .padding()
                
                Spacer()
                EventActionButtonsStack(event: event, eventsStore: eventsStore)
            }
            .padding()
        }
            
        .navigationBarTitle(Text(""), displayMode: .inline)
        
    }
    
}


struct EventActionButtonsStack: View {
    
    var event: YelpEvent
    @ObservedObject var eventsStore: EventsService
    
    var body: some View {
        HStack(spacing: 20) {
            Button(action: {
                guard let url = URL(string: self.event.event_site_url) else { return }
                UIApplication.shared.open(url)
            }) {
                Text("View on Yelp")
                    .padding()
                    .foregroundColor(.white)
                    .background(LinearGradient(gradient: Gradient(colors: [.red, .purple]), startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(40)
            }
            Button(action: {
                self.eventsStore.insertEventIntoCalcendar(self.event)
            }) {
                Text("Add to Calendar")
                    .padding()
                    .foregroundColor(.white)
                    .background(LinearGradient(gradient: Gradient(colors: [.purple, .red]), startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(40)
            }.alert(isPresented: self.$eventsStore.eventSavedToCalendar) {
                Alert(title: Text("Event added to calendar"), message: nil, dismissButton: .default(Text("Got it!")))
            }
        }
    }
    
}
