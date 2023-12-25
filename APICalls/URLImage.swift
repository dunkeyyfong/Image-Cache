//
//  URLImage.swift
//  APICalls
//
//  Created by DunkeyyFong on 25/12/2023.
//

import SwiftUI

struct URLImage: View {
    
    let urlString: String
    
    @State var data: Data?
    
    var body: some View {
        if let data = data, let uiimage = UIImage(data: data) {
            Image(uiImage: uiimage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 80, height: 80)
                .background(Color.gray)
                .cornerRadius(20)
        }
        else {
            Image("")
                .frame(width: 80, height: 80)
                .background(Color.gray)
                .cornerRadius(20)
                .onAppear {
                    fetchData()
                }
        }
    }
    
    private func fetchData() {
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            self.data = data
        }
        
        task.resume()
    }
}
