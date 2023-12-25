//
//  ViewModal.swift
//  APICalls
//
//  Created by DunkeyyFong on 25/12/2023.
//

import Foundation
import SwiftUI

class ViewModel: ObservableObject {
    
    @Published var tests: [Test] = []
    
    func fetch() {
        guard let url = URL(string: "https://dunkeyyfong.github.io/test.json") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let tests = try JSONDecoder().decode([Test].self, from: data)
                DispatchQueue.main.async {
                    self.tests = tests
                }
            } catch {
                print(error)
            }
            
        }
        
        task.resume()
    }
}
