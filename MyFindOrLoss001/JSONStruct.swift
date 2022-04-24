//
//  JSONStruct.swift
//  MyFindOrLoss001
//
//  Created by Mustafa Taşdemir on 22.01.2022.
//

import Foundation
import SwiftUI

struct ImageMetadata: Decodable {
    var id: String
    var createdAt: Date
    var url: URL
    var uiImage: UIImage?
    var image: Image?
    
    enum Keys: String, CodingKey {
        case id, createdAt, url = "urls"
    }
    enum Urls: String, CodingKey {
        case small
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
        let urlContainer = try container.nestedContainer(keyedBy: Urls.self, forKey: .url)
        let url = try urlContainer.decode(String.self, forKey: .small)
        if let url = URL(string: url) {
            self.url = url
        } else {
            throw GeneralError.invalidURL
        }
    }
    
}
