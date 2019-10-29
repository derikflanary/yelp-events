//
//  EventCell.swift
//  yelp-events
//
//  Created by Derik Flanary on 10/29/19.
//  Copyright © 2019 Derik Flanary. All rights reserved.
//

import Foundation
import SwiftUI

struct EventCell: View {
    
    var event: YelpEvent
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(event.name)
                    .font(.headline)
                    .layoutPriority(1.0)
                Text(event.time_start.dateConverted())
                    .font(.subheadline)
            }
            .padding(4)
            if event.is_official {
                Spacer(minLength: 0)
                Image(systemName: "star")
                    .foregroundColor(.yellow)
                    .padding()
            }
        }
    }
}
