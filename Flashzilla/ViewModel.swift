//
//  Card.swift
//  Flashzilla
//
//  Created by Natalia D on 10.11.2023.
//

import Foundation


class ViewModel: ObservableObject {
    @Published var cards : [Card] = []
    @Published var incorrectCards: [Card] = []
    @Published var isCorrect = false
    @Published var isActive = false
    
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
    
    func newRemoval(card: Card) {
        
        let againCard = card
        
        cards.removeAll(where: {$0.id == card.id })
        
        if isCorrect == false {
            //DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
               
            self.incorrectCards.append(againCard)
            self.cards.insert(againCard, at: 0)
          // }
        }
        if cards.isEmpty {
            isActive = false
        }
    }
    

}

        

