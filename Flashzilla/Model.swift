//
//  Model.swift
//  Flashzilla
//
//  Created by Natalia D on 20.11.2023.
//

import Foundation


struct Card: Codable, Identifiable, Hashable {
    let id: UUID
    let prompt: String
    let answer: String
    
    static let example = Card(id: UUID(), prompt: "Who played the 13th Doctor in Doctor Who?", answer: "Jodie Whittaker")
}
