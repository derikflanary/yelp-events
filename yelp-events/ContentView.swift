//
//  ContentView.swift
//  yelp-events
//
//  Created by Derik Flanary on 10/28/19.
//  Copyright © 2019 Derik Flanary. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var eventsStore: EventsStore
    @State private var searchString: String = ""
    
    var body: some View {
        NavigationView {
            VStack{
                SearchTextField(eventStore: eventsStore)
                List(eventsStore.events) { event in
                    NavigationLink(destination: EventDetailView(event: event)) {
                        EventCell(event: event)
                    }
                }
                .navigationBarTitle("Local Yelp Events")
                .onAppear {
                    self.eventsStore.fetchEvents()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct EventCell: View {
    
    var event: YelpEvent
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(event.name)
                .font(.headline)
            Text(event.time_start.dateConverted())
                .font(.subheadline)
        }
        .padding(4)
    }
}

struct SearchTextField: View {
    
    @ObservedObject var eventStore: EventsStore
    
    var body: some View {
        HStack {
            TextField("Location", text: $eventStore.searchString)
                .foregroundColor(.primary)
                .padding()
            if !eventStore.searchString.isEmpty {
                Button(action: {
                    self.eventStore.fetchEvents(filteredBy: self.eventStore.searchString)
                }) {
                    Text("search")
                        .font(.caption)
                        .foregroundColor(.blue)
                }
                .padding()
            }
        }
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10.0)
        .padding()
    }
    
}

struct EventDetailView: View {
    
    var event: YelpEvent
    
    var body: some View {
        return Text(event.description)
    }
    
}
