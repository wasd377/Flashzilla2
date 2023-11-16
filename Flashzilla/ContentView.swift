//
//  ContentView.swift
//  Flashzilla
//
//  Created by Natalia D on 05.11.2023.
//

import SwiftUI
import CoreHaptics

struct ContentView: View {
    
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    @Environment(\.accessibilityVoiceOverEnabled) var voiceOverEnabled
    @Environment(\.scenePhase) var scenePhase
    @EnvironmentObject var vm : ViewModel
    
    @State private var timeRemaining = 100
    @State private var isActive = true
    @State private var showingEditScreen = false
    @State private var isCorrect = false
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    func newRemoval(card: Card) {
        
        let againCard = card
        
        vm.cards.removeAll(where: {$0.id == card.id })
        
        if isCorrect == false {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                vm.cards.insert(againCard, at: 0)
                vm.incorrectCards.append(againCard)
            }
        }
        if vm.cards.isEmpty {
            isActive = false
        }
    }


    var body: some View {
        
        ZStack {
            Image(decorative: "background")
                .resizable()
                .ignoresSafeArea()
            VStack{
                Text("Time: \(timeRemaining) Cards: \(vm.cards.count) Incorrect: \(vm.incorrectCards.count)")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding(.horizontal,20)
                    .padding(.vertical, 5)
                    .background(.black.opacity(0.75))
                    .clipShape(Capsule())
                ZStack{
                    ForEach(vm.cards) { card in
                        VStack{
                            CardView(card: card, isCorrect: $isCorrect) {
                                withAnimation {
                                    newRemoval(card: card)
                                }
                            }
                        }
                            .stacked(at: vm.cards.firstIndex(of: card)!, in: vm.cards.count)
                            .allowsHitTesting(vm.cards.firstIndex(of: card)!  < vm.cards.count)
                            .accessibilityHidden(vm.cards.firstIndex(of: card)! < vm.cards.count)
                    }
                }
                .allowsHitTesting(timeRemaining > 0)
                
                if vm.cards.isEmpty {
                    Button("Start Again", action: resetCards)
                        .padding()
                        .background(.white)
                        .foregroundColor(.black)
                        .clipShape(Capsule())
                }
            }
            
            VStack {
                HStack {
                  Spacer()
                    
                    Button{
                        showingEditScreen = true
                    } label: {
                        Image(systemName: "plus.circle")
                            .padding()
                            .background(.black.opacity(0.7))
                            .clipShape(Circle())
                    }
                }
                
                Spacer()
                
            }
            .foregroundColor(.white)
            .font(.largeTitle)
            .padding()
            
            if differentiateWithoutColor || voiceOverEnabled {
                VStack {
                    Spacer()

                    HStack {
                        Button {
                            withAnimation {
                                //removeCard(at: vm.cards.count - 1)
                            }
                        } label: {
                            Image(systemName: "xmark.circle")
                                .padding()
                                .background(.black.opacity(0.7))
                                .clipShape(Circle())
                        }
                        .accessibilityLabel("Wrong")
                        .accessibilityHint("Mark your answer as incorrect.")
                        
                        Spacer()
                        
                        Button {
                            withAnimation {
                                //removeCard(at: vm.cards.count - 1)
                            }
                        } label: {
                            Image(systemName: "checkmark.circle")
                                .padding()
                                .background(.black.opacity(0.7))
                                .clipShape(Circle())
                        }
                        .accessibilityLabel("Correct")
                        .accessibilityHint("Mark your answer as correct.")
                    }
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .padding()
                }
            }
        }
        .onReceive(timer) { time in
            guard isActive else { return }
            
            if timeRemaining > 0 {
                timeRemaining -= 1
            }
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                if vm.cards.isEmpty == false {
                    isActive = true
                }
            } else {
                isActive = false
            }
            
        }
        .sheet(isPresented: $showingEditScreen, onDismiss: resetCards, content: EditView.init) 
        .onAppear(perform: resetCards)
    }
    
    func resetCards() {

    timeRemaining = 100
        isActive = true
        vm.loadData()
    }
}
        
        extension View {
            func stacked(at position: Int, in total: Int) -> some View {
                let offset = Double(total - position)
                return self.offset(x: 0, y: offset * 5)
            }
        }

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ViewModel())
            .previewInterfaceOrientation(.landscapeLeft)
    }
}


