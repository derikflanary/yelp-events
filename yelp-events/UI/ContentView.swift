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
    @EnvironmentObject var locationService: LocationService
    
    @State private var searchString: String = ""
    
    var body: some View {
        NavigationView {
            VStack{
                SearchTextField(eventsStore: eventsStore)
                List(eventsStore.events) { event in
                    NavigationLink(destination: EventDetailView(event: event, eventsStore: self.eventsStore)) {
                        EventCell(event: event)
                    }
                }
                .navigationBarTitle("Local Yelp Events")

                Spacer()
                Button(action: {
                    self.locationService.findCurrentLocation()
                }) {
                    Text("Use Current Location")
                        .padding()
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

struct CircularProgressIndicator: View {
    
    static private let _animation = Animation
        .linear(duration: 1)

    @State private var active: Bool = false

    var body: some View {
        Circle()
            .fill(Color.blue)
            .scaleEffect(CGFloat(0.25))
            .offset(x: 0, y: -14)
            .rotationEffect(.degrees(active ? 0 : -360))
            .animation(active ? CircularProgressIndicator._animation : nil)
            .frame(height:CGFloat(28))
            .onAppear { self.active.toggle() }
    }
}
