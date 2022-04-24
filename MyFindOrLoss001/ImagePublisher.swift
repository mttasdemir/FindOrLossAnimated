//
//  ImagePublisher.swift
//  MyFindOrLoss001
//
//  Created by Mustafa Taşdemir on 22.01.2022.
//

import Foundation
import Combine
import SwiftUI

class ImagePublisher {
    static private let ticket: String = "nKBWwmafVF_v4Vcw_3sPFyyAGa0DsNOE7fJ9dYkBaj8" //"nKBWwmafVF_v4Vcw_3sPFyyAGa0DsNOE7fJ9dYkBaj8"
    static private let url: String = "https://api.unsplash.com//photos/random/?client_id=\(ticket)"
    
    private var session: URLSession
    private var urlRequest: URLRequest
    private var sessionConfig: URLSessionConfiguration
    private var jsonDecoder: JSONDecoder
    
    init(_ sessionConfig: URLSessionConfiguration, _ url: URL) {
        self.sessionConfig = sessionConfig
        self.session = URLSession(configuration: sessionConfig)
        self.urlRequest = URLRequest(url: url)
        self.jsonDecoder = JSONDecoder()
    }
    
    convenience init() throws {
        guard let url = URL(string: ImagePublisher.url) else { throw GeneralError.invalidURL }
        let sessinCongif = URLSessionConfiguration.default
        sessinCongif.urlCache = nil
        sessinCongif.requestCachePolicy = .reloadIgnoringLocalCacheData
        self.init(sessinCongif, url)
        self.jsonDecoder.dateDecodingStrategy = .iso8601
        self.jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    func imageUrlPublisher() -> AnyPublisher<ImageMetadata, GeneralError> {
        URLSession(configuration: sessionConfig).dataTaskPublisher(for: urlRequest)
            .tryMap { output in
                guard (output.response as? HTTPURLResponse)?.statusCode == 200 else {
                    throw GeneralError.statusCodeError
                }
                return output.data
            }
            .decode(type: ImageMetadata.self, decoder: self.jsonDecoder)
            .mapError({ GeneralError.map($0) })
            .eraseToAnyPublisher()
    }
    
    func imagePublisher(from imageMetadata: ImageMetadata) -> AnyPublisher<ImageMetadata, GeneralError> {
        var imageMetadata = imageMetadata
        return URLSession(configuration: sessionConfig).dataTaskPublisher(for: imageMetadata.url)
            .tryMap { output -> Data in
                guard (output.response as? HTTPURLResponse)?.statusCode == 200 else {
                    throw GeneralError.statusCodeError
                }
                return output.data
            }
            .tryMap { data -> ImageMetadata in
                guard let image = UIImage(data: data) else {
                    throw GeneralError.unsupportedFormat
                }
                imageMetadata.uiImage = image
                return imageMetadata
            }
            .mapError { GeneralError.map($0) }
            .eraseToAnyPublisher()
    }
    
    func publisher() -> AnyPublisher<ImageMetadata, GeneralError> {
        imageUrlPublisher()
            .flatMap { [unowned self] imageMetadata in
                self.imagePublisher(from: imageMetadata)
            }
            .eraseToAnyPublisher()
    }
    
}
