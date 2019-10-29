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
    @ObservedObject var eventsStore: EventsStore
    
    var body: some View {
        
            VStack(alignment: .leading) {
                Text(event.name)
                    .font(.title)
                    .padding()
                    .lineLimit(4)
                Text(event.time_start.dateConverted())
                    .font(.subheadline)
                    .foregroundColor(Color(UIColor.secondaryLabel))
                    .padding()
                Text(event.description)
                    .padding()
                    .lineLimit(100)
                    .font(.body)
            
                Button(action: {
                    let path = "http://maps.apple.com/?address=" + self.event.location.addressString.replacingOccurrences(of: "\n", with: ",").replacingOccurrences(of: " ", with: "+")
                    guard let url = URL(string: path) else { return }
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
                HStack {
                    Spacer()
                    VStack(spacing: 20) {
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
                    Spacer()
                }
            }
            .padding()
        
    }
    
}

