//
//  ContentView.swift
//  APICalls
//
//  Created by DunkeyyFong on 25/12/2023.
//

import SwiftUI

struct Test: Hashable, Codable {
    let title: String
    let image: String
    let desc: String
}

struct ContentView: View {
    
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.tests, id: \.self) { test in
                    HStack {
                        //URLImage(urlString: test.image)
                        CachedImage(item: (name: test.title, url: test.image)) { phase in
                            switch phase {
                            case .empty:
                                Image("")
                                    .frame(width: 80, height: 80)
                                    .background(.gray)
                                    .cornerRadius(20)
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 80, height: 80)
                                    .cornerRadius(20)
                            case .failure(let error):
                                Image("")
                                    .frame(width: 80, height: 80)
                                    .background(.gray)
                                    .cornerRadius(20)
                            @unknown default:
                                EmptyView()
                            }
                        }
                        VStack {
                            Text(test.title)
                                .font(.title2)
                                .bold()
                            Text(test.desc)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .padding()

                    }
                    .padding(2)
                }
            }
            .navigationTitle("Test")
            .onAppear(
                perform: { viewModel.fetch() }
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
