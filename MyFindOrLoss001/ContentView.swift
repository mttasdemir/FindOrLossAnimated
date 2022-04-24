//
//  ContentView.swift
//  MyFindOrLoss001
//
//  Created by Mustafa Taşdemir on 22.01.2022.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var findLossController: FindOrLossController
    
    var body: some View {
        if let error = findLossController.error {
            Text(error.localizedDescription)
        }

        LazyVGrid(columns: [GridItem(.adaptive(minimum: 175, maximum: 175), spacing: 2.0)], spacing: 2.0) {
            ForEach(findLossController.images) { image in
                VStack {
                    Image(uiImage: image.image.uiImage!)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 175, height: 175, alignment: .center)
                        .clipped()
                        .border(.blue)
                        .onTapGesture {
                            findLossController.checkSelection(selected: image.imageNo)
                        }
                    Text(DateFormatter.short.string(from: image.image.createdAt))
                }
                .transition(.asymmetric(insertion: .scale.animation(.linear(duration: 3)), removal: .opacity.animation(.easeIn(duration: 2))))
            }
        }
        .padding(.top, 100)

        Spacer()
        Button("New Images") {
            withAnimation {
                findLossController.downloadImage()
            }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(findLossController: FindOrLossController())
    }
}
