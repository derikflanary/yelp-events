//
//  URLImage.swift
//  yelp-events
//
//  Created by Derik Flanary on 10/30/19.
//  Copyright © 2019 Derik Flanary. All rights reserved.
//

import Foundation
import SwiftUI

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
            .aspectRatio(contentMode: .fit)
    }
    
}
