//
//  ImageRetriever.swift
//  APICalls
//
//  Created by DunkeyyFong on 25/12/2023.
//

import Foundation

struct ImageRetriever {
    func fetch(_ image: String) async throws -> Data {
        guard let url = URL(string: image) else {
            throw RetrieverError.invalidUrl
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        return data
    }
}

private extension ImageRetriever {
    enum RetrieverError: Error {
        case invalidUrl
    }
}
