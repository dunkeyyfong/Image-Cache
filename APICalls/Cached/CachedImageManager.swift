//
//  CachedImageManager.swift
//  APICalls
//
//  Created by DunkeyyFong on 25/12/2023.
//

import Foundation

final class CachedImageManager: ObservableObject {
    @Published private(set) var currentState: CurrentState?
    
    private let imageRetriver = ImageRetriever()
    
    @MainActor
    func load(_ item: (name: String, url: String), cache: ImageCache = .shared) async {
        
        if let imageData = cache.object(forkey: item.name as NSString) {
            self.currentState = .success(data: imageData)
            
            #if DEBUG
            print("Fetching image from the cache: \(item.name)")
            #endif
            
            return
        }
        
        if let diskCacheItem = FileStorageManager.shared.retrive(with: item.name),
           Date.now < diskCacheItem.evictionDate {
            
            #if DEBUG
            print("Storing image in memory from disk: \(diskCacheItem.name)")
            #endif
            
            cache.set(object: diskCacheItem.data as NSData, forkey: diskCacheItem.name as NSString)
            
            self.currentState = .success(data: diskCacheItem.data)
            
            return
            
        }
        
        FileStorageManager.shared.remove(with: item.name)
        
        self.currentState = .loading
    
        do {
            let data = try await imageRetriver.fetch(item.url)
            self.currentState = .success(data: data)
            cache.set(object: data as NSData, forkey: item.name as NSString)
            
            if let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: .now) {
                FileStorageManager.shared.save(.init(name: item.name, data: data, evictionDate: tomorrow))
            }
            
            #if DEBUG
            print("Caching image: \(item.url)")
            #endif
            
        } catch {
            self.currentState = .failed(error: error)
        }
    }
}

extension CachedImageManager {
    enum CurrentState {
        case loading
        case failed(error: Error)
        case success(data: Data)
    }
}
