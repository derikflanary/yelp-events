//
//  APIError.swift
//  network-combine
//
//  Created by Derik Flanary on 10/15/19.
//  Copyright © 2019 Derik Flanary. All rights reserved.
//

import Foundation

internal enum APIError: Error {
    case networkError(Error?)
    case unsuccessfulRequest(String?)
    case responseCorrupted
    case validationFailed(String?)
    case invalidURL(url: URLConvertible)
}
