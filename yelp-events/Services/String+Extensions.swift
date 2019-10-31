//
//  String+Extensions.swift
//  yelp-events
//
//  Created by Derik Flanary on 10/29/19.
//  Copyright © 2019 Derik Flanary. All rights reserved.
//

import Foundation

extension String {
    
    func asDate() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyy-MM-dd'T'HH:mm:ss-hh:mm"
        return formatter.date(from: self)
    }
    
    func dateConverted() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyy-MM-dd'T'HH:mm:ss-hh:mm"
        guard let date = formatter.date(from: self) else { return "Date not found"}
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: date)
    }
    
}


extension Date {

    func adding(months: Int) -> Date {
        let calendar = Calendar(identifier: .gregorian)

        var components = DateComponents()
        components.calendar = calendar
        components.month = months

        return calendar.date(byAdding: components, to: self) ?? self
    }

}
