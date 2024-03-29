//
//  SearchTextField.swift
//  yelp-events
//
//  Created by Derik Flanary on 10/29/19.
//  Copyright © 2019 Derik Flanary. All rights reserved.
//

import Foundation
import SwiftUI

struct SearchTextField: View {
    
    @ObservedObject var eventsStore: EventsService
    
    var body: some View {
        VStack {
            HStack {
                TextField("City", text: $eventsStore.searchString)
                    .foregroundColor(.primary)
                    .padding()
                if !eventsStore.searchString.isEmpty {
                    Button(action: {
                        self.eventsStore.fetchEvents(filteredBy: self.eventsStore.searchString)
                    }) {
                        Text("search")
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                    .transition(.opacity)
                    .padding()
                }
            }
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10.0)
            .padding()
            if eventsStore.isSearching {
                ActivityIndicator()
                    .transition(.opacity)
            }
        }
    }
    
}
