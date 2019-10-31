//
//  EventRouter.swift
//  yelp-events
//
//  Created by Derik Flanary on 10/28/19.
//  Copyright © 2019 Derik Flanary. All rights reserved.
//

import Foundation

extension Router {
    
    enum Event: URLRequestConvertible {
        
        /// Fetches events
        case getEvents(Coordinate?, String?)
        
        
        var method: HTTPMethod {
            switch self {
            case .getEvents:
                return .get
            }
        }
        
        var path: String {
            switch self {
            case .getEvents:
                return "events"
            }
        }
        
        
        func asURLRequest() throws -> URLRequest {
            let url = try path.asURL()
            switch self {
            case let .getEvents(coordinate, locationText):
                var params = JSONObject()
                params["start_date"] = Int(Date().adding(months: -3).timeIntervalSince1970)
                params["limit"] = 50
                if let locationText = locationText {
                    params["location"] = locationText
                } else if let coordinate = coordinate {
                    params["latitude"] = coordinate.latitude
                    params["longitude"] = coordinate.longitude
                }
                var request = URLRequest(url: url.parameterEncoded(params) ?? url)
                request.httpMethod = method.rawValue
                return request
            }
        }
        
    }

}
