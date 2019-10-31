//
//  ImageLoader.swift
//  yelp-events
//
//  Created by Derik Flanary on 10/30/19.
//  Copyright © 2019 Derik Flanary. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

class ImageLoader: ObservableObject  {
    
    static var placeholder: Image = Image("yelp")
    private var cancelable: AnyCancellable?
    
    @Published var image: Image = ImageLoader.placeholder
    
    func load(_ url: URL) {
        let session = URLSession(configuration: URLSessionConfiguration.default)
        cancelable = session.dataTaskPublisher(for: url)
            .retry(3)
            .map{ (data, response) -> Image? in
                guard let uiimage = UIImage(data: data) else { return nil }
                return Image(uiImage: uiimage)
            }
            .replaceError(with: nil)
            .replaceNil(with: ImageLoader.placeholder)
            .receive(on: RunLoop.main)
            .assign(to: \.image, on: self)
    }
    
}
