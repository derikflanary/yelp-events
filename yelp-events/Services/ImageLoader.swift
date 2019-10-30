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
    
    private var cancelable: AnyCancellable?
    
    @Published var image: Image = Image("")
    
    func load(_ url: URL) {
        let session = URLSession(configuration: URLSessionConfiguration.default)
        cancelable = session.dataTaskPublisher(for: url)
            .map{ (data, response) -> Image? in
                guard let uiimage = UIImage(data: data) else { return nil }
                return Image(uiImage: uiimage)
            }
            .replaceError(with: nil)
            .replaceNil(with: Image(systemName: ""))
            .receive(on: RunLoop.main)
            .assign(to: \.image, on: self)
    }
    
}

struct URLImage: View {
    
    let url: URL
    
    @ObservedObject var imageLoader = ImageLoader()
    
    init(url: URL) {
        self.url = url
    }
    
    var body: some View {
        imageLoader.image
            .resizable()
            .onAppear {
                self.imageLoader.load(self.url)
            }
    }
    
}
