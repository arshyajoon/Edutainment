//
//  ContentView.swift
//  Eduatainment
//
//  Created by Arshya GHAVAMI on 1/12/21.
//

import SwiftUI

struct ContentView: View {
    @State private var isActive = false
    let numberOfQuestions = ["5","10","20", "All"]
    @State private var currentQuestion = 0
    @State private var tables = 1
    @State private var questions = [Question]()
    var body: some View {
        Group {
            if isActive {
            Text("Hello, world!")
                .padding()
            } else {
                Stepper("Choose your table: \(tables)", value: $tables, in: 1...12)
                    .padding()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Question {
    var first: Int
    var second: Int
    var text: String {
     return  "What is \(first) * \(second)"
    }
    var answer: Int {
        return first * second
    }
}
