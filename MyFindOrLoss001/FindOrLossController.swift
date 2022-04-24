//
//  FindOrLossController.swift
//  MyFindOrLoss001
//
//  Created by Mustafa Taşdemir on 22.01.2022.
//

import Foundation
import SwiftUI
import Combine

class FindOrLossController: ObservableObject {
    
    private var publisher: ImagePublisher?
    @Published var error: Error?
    @Published var images: Array<CustomImage> = []
    
    init() {
        if let publisher = try? ImagePublisher() {
            self.publisher = publisher
        } else {
            self.error = GeneralError.setupError
        }
    }
    
    private func setImages(_ firstImage: ImageMetadata, _ secondImage: ImageMetadata) {
        self.images = [CustomImage(image: firstImage, imageNo: 1), CustomImage(image: secondImage, imageNo: 2), CustomImage(image: secondImage, imageNo: 2), CustomImage(image: secondImage, imageNo: 2)]
        self.images.shuffle()
    }
    
    // MARK: - intents
    
    private var cancellable: Set<AnyCancellable> = []
    func downloadImage() {
        publisher!.publisher()
            .zip(publisher!.publisher())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    self.error = error.error()
                }
            }, receiveValue: { (firstImage, secondImage) in
                self.setImages(firstImage, secondImage)
            })
            .store(in: &cancellable)
    }
    
    func checkSelection(selected imageNo: Int) {
        if imageNo == 1 {
            downloadImage()
        }
    }
}

struct CustomImage: Identifiable {
    var id: UUID = UUID()
    var image: ImageMetadata
    var imageNo: Int
    
    init(image: ImageMetadata, imageNo: Int) {
        self.image = image
        self.imageNo = imageNo
        self.image.image = Image(uiImage: self.image.uiImage!)
    }
}

extension DateFormatter {
    static var short: DateFormatter = {
       let df = DateFormatter()
        df.timeStyle = .none
        df.dateStyle = .short
        df.locale = Locale(identifier: "tr_TR")
        return df
    }()
}
