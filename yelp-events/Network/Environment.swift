//
//  Environment.swift
//  yelp-events
//
//  Created by Derik Flanary on 10/28/19.
//  Copyright © 2019 Derik Flanary. All rights reserved.
//

import Foundation

struct Environment: ProtectedAPIEnvironment {
    
    var baseURL: URL? = URL(string: "https://api.yelp.com/v3/")
    var bearerToken: String? = "O3qO17p_uXR9iib5yeGOy4AqbCpooPFAF8kTgIItOuDX_gRJ3RgLW2K-f2vayIy3jB4GI_Zy2XjPFaqUKra6XT1oSktAC0d0A7UPs6xJKK6Eleqrkr0FOyntmhe3XXYx"
    var isExpired: Bool {
        return bearerToken == nil
    }
    
}
