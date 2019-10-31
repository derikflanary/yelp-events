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
                    .foregroundColor(event.time_start.asDate()! < Date() ? Color(UIColor.tertiaryLabel) : Color(UIColor.label) )
            }
            .padding(4)
        }
    }
}
