//
//  ImageRetriver.swift
//  UsefulMap
//
//  Created by Dmitry Zasenko on 21.12.22.
//

import SwiftUI

class ImageLoader {
    
    //MARK: - Properties
    
    static let shared = ImageLoader()

    //MARK: - Initialization
    
    private init() {}
    
    //MARK: - Private Properties
    
    private let cache: ImageCache = .shared
}

extension ImageLoader {
    
    private enum RetriverError: Error {
        case invalidUrl
        case invalidData
        case invalidCacheData
    }
    
    //MARK: - Functions
    
    func loadImage(url: String) async throws -> Image {
        if let imageData = cache.object(forKey: url as NSString) {
            return try await makeImageFromData(data: imageData)
        }
        let data = try await fetch(stringUrl: url)
        cache.set(object: data as NSData, forKey: url as NSString)
        return try await makeImageFromData(data: data)
        
    }
    
    //MARK: - Private functions
    
    private func makeImageFromData(data: Data) async throws -> Image {
        guard let uiImage = UIImage(data: data) else {
            throw RetriverError.invalidData
        }
        return Image(uiImage: uiImage)
    }

    private func fetch(stringUrl: String) async throws -> Data {
        guard let url = URL(string: stringUrl) else {
            throw RetriverError.invalidUrl
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    }
    
    private func loadDataFromCache(cache: ImageCache, for key: String) async throws -> Data {
        guard let imageData = cache.object(forKey: key as NSString) else {
            throw RetriverError.invalidCacheData
        }
        return imageData
    }
}
