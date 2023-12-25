//
//  ImageCache.swift
//  APICalls
//
//  Created by DunkeyyFong on 25/12/2023.
//

// Determine the capacity of the Cache


import Foundation

class ImageCache {
    
    typealias CacheType = NSCache<NSString, NSData>
    
    static let shared = ImageCache()
    
    private init() {}
    
    private lazy var cache: CacheType = {
        let cache = CacheType()
        cache.countLimit = 100
        cache.totalCostLimit = 50 * 1024 * 1024 // 50mb = 50 bytes * 1024 bytes * 1024 bytes. If you want to adjust the storage capacity to                                         be larger, set 50 to the capacity you want
        return cache
    }()
    
    func object(forkey key: NSString) -> Data? {
        return cache.object(forKey: key) as? Data
    }
    
    func set(object: NSData, forkey key: NSString) {
        cache.setObject(object, forKey: key)
    }
}
