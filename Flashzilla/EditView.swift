//
//  EditView.swift
//  Flashzilla
//
//  Created by Natalia D on 11.11.2023.
//

import SwiftUI

struct EditView: View {
    @EnvironmentObject var vm : ViewModel
    @Environment(\.dismiss) var dismiss
    @State private var cards = [Card]()
    @State private var newPrompt = ""
    @State private var newAnswer = ""

    var body: some View {
        NavigationView {
            List {
                Section("Add new card") {
                    TextField("Prompt", text: $newPrompt)
                    TextField("Answer", text: $newAnswer)
                    Button("Add card", action: addCard)
                }

                Section {
                    ForEach(vm.cards) { card  in
                        VStack(alignment: .leading) {
                            Text(card.prompt)
                                .font(.headline)
                            Text(card.answer)
                                .foregroundColor(.secondary)
                        }
                    }
                    .onDelete(perform: removeCards)
                }
            }
            .navigationTitle("Edit Cards")
            .toolbar {
                Button("Done", action: done)
            }
            .listStyle(.grouped)
            .onAppear(perform: vm.loadData)
        }
    }

    func done() {
        dismiss()
    }


//    func saveData() {
//        if let data = try? JSONEncoder().encode(cards) {
//            UserDefaults.standard.set(data, forKey: "Cards")
//        }
//    }

    func addCard() {
        let trimmedPrompt = newPrompt.trimmingCharacters(in: .whitespaces)
        let trimmedAnswer = newAnswer.trimmingCharacters(in: .whitespaces)
        guard trimmedPrompt.isEmpty == false && trimmedAnswer.isEmpty == false else { return }

        let card = Card(id: UUID(), prompt: trimmedPrompt, answer: trimmedAnswer)
        vm.cards.insert(card, at: 0)
        vm.saveData()
        
        newPrompt = ""
        newAnswer = ""
    }

    func removeCards(at offsets: IndexSet) {
        vm.cards.remove(atOffsets: offsets)
        vm.saveData()
    }
}

struct EditView_Previews: PreviewProvider {
    
    static var previews: some View {
        EditView()
            .environmentObject(ViewModel())
    }
}
