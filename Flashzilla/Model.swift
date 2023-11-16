//
//  Card.swift
//  Flashzilla
//
//  Created by Natalia D on 10.11.2023.
//

import Foundation

struct Card: Codable, Identifiable, Hashable {
    let id: UUID
    let prompt: String
    let answer: String
    
    static let example = Card(id: UUID(), prompt: "Who played the 13th Doctor in Doctor Who?", answer: "Jodie Whittaker")
}

class ViewModel: ObservableObject {
    @Published var cards : [Card] = []
    @Published var incorrectCards: [Card] = []
    
    var urlFile: URL { //<-- Here
        getDocumentsDirectory().appendingPathComponent("cards.json")
    }
    
    init() { loadData() }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func loadData() {
           do {
               let data = try Data(contentsOf: urlFile)
               let decoder = JSONDecoder()
               cards = try decoder.decode([Card].self, from: data)
           } catch {
               debugPrint(error.localizedDescription)
           }
           
       }
       
       func saveData() {
           let encoder = JSONEncoder()
           do {
               let data = try encoder.encode(cards)
               try data.write(to: urlFile)
           } catch {
               debugPrint(error.localizedDescription)
           }
       }
    

          }

        

