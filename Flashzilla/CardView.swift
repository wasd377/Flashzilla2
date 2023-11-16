//
//  CardView.swift
//  Flashzilla
//
//  Created by Natalia D on 10.11.2023.
//

import SwiftUI

struct CardView: View {
    
    @Environment(\.accessibilityDifferentiateWithoutColor) var differintiateWithoutColor
    @Environment(\.accessibilityVoiceOverEnabled) var voiceOverEnabled
    
    let card: Card
    
    @State private var isShowingAnswer = false
    @State private var offset = CGSize.zero
    @State private var feedback = UINotificationFeedbackGenerator()
    @State private var isReturning = false
    @State private var fillColor = Color.white
    @Binding var isCorrect: Bool
    
    var removal: (() -> Void)? = nil

    
    var body: some View {
        
      //  fillColor = offset.width > 0 ? .green : .red
        
        ZStack {
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(
                    differintiateWithoutColor
                    ? .white
                    : .white
                        .opacity(1 - Double(abs(offset.width / 50)))
                    )
                .background(
                    differintiateWithoutColor
                    ? nil
                    : RoundedRectangle(cornerRadius: 25, style: .continuous)
                        //.fill(offset.width > 0 ? (isReturning ? .green : .green) : (isReturning ? .red : .red)))
                        .fill(offset == .zero ? .white : (offset.width > 0 ? .green : .red)))
                .shadow(radius: 10)
            
            VStack {
                if voiceOverEnabled {
                    Text(isShowingAnswer ? card.answer : card.prompt)
                        .font(.largeTitle)
                        .foregroundColor(.black)
                }
                Text(card.prompt)
                    .font(.largeTitle)
                    .foregroundColor(.black)
                
                if isShowingAnswer {
                    
                    Text(card.answer)
                        .font(.title)
                        .foregroundColor(.gray)
                }
            }
            .padding(20)
                       .multilineTextAlignment(.center)
        }
        .accessibilityAddTraits(.isButton)
        .frame(width: 450, height: 250)
        .rotationEffect(.degrees(Double(offset.width / 5)))
        .offset(x: offset.width * 5, y: 0)
        .opacity(2 - Double(abs(offset.width / 50)))
        .gesture(
        DragGesture()
            .onChanged { gesture in
                feedback.prepare()
                offset = gesture.translation
        }
            .onEnded { _ in
                if abs(offset.width) > 200 {
                    if offset.width > 0 {
                        feedback.notificationOccurred(.success)
                       isCorrect = true
                    } else {
                        feedback.notificationOccurred(.error)
                        isCorrect = false
                    }
                    removal?()
                } else {
                   
                    withAnimation {
                        isReturning = true
                        offset = .zero
                        isReturning = false
                    }
                    
                }
                
            }
        )
        
        .onTapGesture {
            isShowingAnswer.toggle()
        }
        .animation(.spring(), value: offset)
    }
}





struct CardView_Previews: PreviewProvider {
    
    @State static var isCorrect = false
    
    static var previews: some View {
        CardView(card: Card.example, isCorrect: $isCorrect)
            .previewInterfaceOrientation(.landscapeLeft)
    }
}


