//
//  CachedImage.swift
//  APICalls
//
//  Created by DunkeyyFong on 25/12/2023.
//

import SwiftUI

struct CachedImage<Content: View>: View {
    
    @StateObject private var manager = CachedImageManager()
    
    let item: (name: String, url: String)
    
    @ViewBuilder let content: (AsyncImagePhase) -> Content
    
    var body: some View {
        ZStack {
            switch manager.currentState {
            case .loading:
                content(.empty)
            case .success(let data):
                if let image = UIImage(data: data) {
                    content(.success(Image(uiImage: image)))
                } else {
                    content(.failure(CachedImageError.invalidData))
                }
            case .failed(let error):
                content(.failure(error))
            default:
                content(.empty)
            }
        }
        .task {
            await manager.load(item)
        }
    }
}

struct CachedImage_Previews: PreviewProvider {
    static var previews: some View {
        CachedImage(item: (name: "", url: "https://dunkeyyfong.github.io/200.png")) { _ in
            EmptyView()
        }
    }
}

extension CachedImage {
    enum CachedImageError: Error {
        case invalidData
    }
}
