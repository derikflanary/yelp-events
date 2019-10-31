//
//  API.swift
//  network-combine
//
//  Created by Derik Flanary on 10/15/19.
//  Copyright © 2019 Derik Flanary. All rights reserved.
//

import Foundation

protocol APIEnvironment {
    var baseURL: URL? { get }
}


protocol ProtectedAPIEnvironment: APIEnvironment {
    var bearerToken: String? { get }
    var isExpired: Bool { get }
}


protocol MockAPIEnvironment: APIEnvironment {
    var protocolClass: AnyClass? { get }
}

typealias JSONObject = [String: Any]
