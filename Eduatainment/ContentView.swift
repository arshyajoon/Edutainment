//
//  ContentView.swift
//  Eduatainment
//
//  Created by Arshya GHAVAMI on 1/12/21.
//

import SwiftUI

extension AnyTransition {
  static var customTransition: AnyTransition {
    let transition = AnyTransition.move(edge: .top)
      .combined(with: .scale(scale: 0.2, anchor: .top))
      .combined(with: .opacity)
    return transition
  }
}


struct RoundButton: View {
    
    var name = ""
    var primaryColor = Color.blue
    var secondaryColor = Color.white
    var body: some View {
        Text("\(name)")
        .padding(20)
        .font(.headline)
//            .fontWeight(.bold)
            .frame(minWidth: 100, idealWidth: 200, maxWidth: 300, minHeight: 50, idealHeight: 50, maxHeight: 50, alignment: .center)

            .foregroundColor(primaryColor)
            .background(secondaryColor)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(primaryColor, lineWidth: 4)
            )
    }
}

struct AnimalImage: View {
    var name: String = "panda"
    
    var animalNames = ["panda", "bear", "zebra", "shark", "gorilla", "bear", "buffalo", "chick", "chicken", "cow", "crocodile", "duck", "dog", "elephant", "frog", "giraffe", "goat", "hippo","horse","monkey", "moose", "narwhal", "owl", "parrot", "pig", "penguin", "rabbit", "rhino", "sloth", "snake", "walrus", "whale" ]
    
    var body: some View {
        Image(animalNames[Int.random(in: 0..<animalNames.count)])
            .resizable()
            .frame(width: 100, height: 100, alignment: .center)
        
    }
}

struct ContentView: View {
    @State private var isActive = false
    var questionAmounts = ["5","10","20", "All"]
    @State private var currentQuestion = 0
    @State private var tables = 1
    @State private var questions = [Question]()
    @State var question: [Question] = []
    @State private var totalQuestions = 0
    @State private var isCorrect = false
    @State var numQuestionsIndex = 0
    @State var numQuestions = 0
    @State var questionCounter = 0
    @State private var angle: Double = 0
    @State private var dragAmount = CGSize.zero
    @State var minimum = 5
    @State var maximum = 8
    @State var num1 = 2
    @State var num2 = 3
    @State var correctQuestions = 0
    @State var answer = ""
    @State var gameOver = false
    func createQuestions()
        {
            questionCounter = 0
            questions.removeAll()
            correctQuestions = 0 // reset correct ?'s
            totalQuestions = 0 // reset total ?'s
            for num1 in minimum...maximum
            {
                for num2 in minimum ... maximum
                {
                    let newQuest = Question(num1: num1, num2: num2)
                    questions.append(newQuest)
                }
            }
            questions.shuffle()
            
        numQuestions = Int(questionAmounts[numQuestionsIndex]) ?? questions.count
        }
        
        func loadQuestion()
        {
            if questionCounter < numQuestions
            {
                let currentQuestion = questions[questionCounter % questions.count] // make sure we lap back around if there are not enough questions
                num1 = currentQuestion.num1
                num2 = currentQuestion.num2
                questionCounter += 1
                
                print("loaded a new question: \(num1) * \(num2): questionCounter = \(questionCounter)")
            }
            else {
                isActive.toggle()
            }

        }
    func checkAnswer()
        {
            let theAnswer = Int(self.answer) ?? 0
            if self.num1 * self.num2 == theAnswer
            {
                correctQuestions += 1
                isCorrect = true
                
                angle += 720
            }
            else { isCorrect = false }
            totalQuestions += 1
        }
    var body: some View {
        NavigationView {
            VStack{
                if !isActive  {
                    Group {
                          Text("What times tables would you like to practice?")
                          Stepper("Min: \(minimum)", value: $minimum, in: 1...maximum)
                          Stepper("Max: \(maximum)", value: $maximum, in: minimum...12)
                          HStack {
                            VStack {
                                Text("How many questions?")
                                Text("\(questionAmounts[numQuestionsIndex])")
                            }
                            Picker(selection: $numQuestionsIndex, label: Text("How many questions?")) {
                                  ForEach(0..<self.questionAmounts.count) {
                                        index in
                                    Text("\(self.questionAmounts[index])")
                                  }
                              }
                              .pickerStyle(SegmentedPickerStyle())
                          }

                      }
//                    .frame(height: inGameMode ? 0: .none)
//                    .transition(.asymmetric(insertion: .scale, removal: .opacity))
                        .transition(.customTransition)
                }
                if isActive {
                    Group {
                        HStack {
                            RoundButton(name: "\(num1)", primaryColor: Color.blue, secondaryColor: Color.white)
                            Text(" x ")
                            RoundButton(name: "\(num2)", primaryColor: Color.blue, secondaryColor: Color.white)
                        }
                        TextField("Answer", text: $answer)
                        .padding(10)
                            .multilineTextAlignment(.center)
                        .font(Font.system(size: 15, weight: .medium, design: .serif))
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1))
                            .keyboardType(.decimalPad)
                            .padding()
                        Button(action: {
                            // check answer
                            self.checkAnswer()
                            
                            // load question
                            self.loadQuestion()
                            // clear out the answer
                            self.answer = ""
                            // check if game is over
                            
                        }){
                            RoundButton(name: "Check", primaryColor: Color.white, secondaryColor: Color.blue)
                        }
                        Spacer()
                        RoundButton(name: "Score: \(correctQuestions)/\(totalQuestions): Total Questions: \(numQuestions)", primaryColor: isCorrect ? Color.green: Color.red, secondaryColor: Color.white)
                        
                        Spacer()
                    
                        AnimalImage()
                        .rotationEffect(.degrees(angle))
                        .animation(.easeIn)
                        .offset(dragAmount)
                        .gesture(
                            DragGesture()
                                .onChanged { self.dragAmount = $0.translation }
                                .onEnded { _ in
                                    withAnimation(.spring()) {
                                        self.dragAmount = .zero
                                    }
                                }
                        )
                        .animation(.spring())
                        Spacer()
                    }
                    .transition(.customTransition)
//                        .transition(.asymmetric(insertion: .scale, removal: .opacity))
                }
                Spacer()
            }
            .navigationBarTitle("Times Tables")
            .padding(.leading)
            .padding(.trailing)
            .navigationBarItems(trailing:
                Button(isActive ? "Settings" : "Play") {
                    withAnimation{
                        self.isActive.toggle()
                    }

                    // create Questions
                    self.createQuestions()
                    self.loadQuestion()
                }
            )
            .alert(isPresented: $gameOver) {
                Alert(title: Text("Game Over"), message: Text("Your score is \(correctQuestions)/ \(totalQuestions)"), dismissButton: .default(Text("Continue")) {
                    withAnimation{
                        self.isActive.toggle()
                    }
                })
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
    var num1: Int
    var num2: Int
    var text: String {
        return  "What is \(num1) * \(num2)"
    }
    var answer: Int {
        return num1 * num2
    }
}
