//
//  Model.swift
//  TrueFalseStarter
//
//  Created by Safwat Shenouda on 25/08/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import Foundation
import GameKit


let trivia: [[String : String]] = [
    ["Question": "Only female koalas can whistle", "Answer": "False"],
    ["Question": "Blue whales are technically whales", "Answer": "True"],
    ["Question": "Camels are cannibalistic", "Answer": "False"],
    ["Question": "All ducks are birds", "Answer": "True"]
]


struct Question {
    
    let question: String
    let options: [String]
    let correctAnswer: Int
}

class Trivia {
    var questions = [Question]()   // array of questions
    var currentQuestion: Int = 0  // hold the current question index to be used later to comcpare with supplied answer
    var questionsAsked = 0  // hold number of questions asked since game start
    var correctQuestions = 0 // hold number of correct answers
    var questionsPerRound = 4
    
    init() {
        
        questions.append(
            Question(question: "This was the only US President to serve more than two consecutive terms.",
            options: ["George Washington","Franklin D. Roosevelt","Woodrow Wilson","Andrew Jackson"],
            correctAnswer: 2)
        )
        questions.append(
            Question(question: "Which of the following countries has the most residents?",
                options: ["Nigeria","Russia","Iran","Vietnam"],
                correctAnswer: 1)
        )
        questions.append(
            Question(question: "In what year was the United Nations founded?",
                options: ["1918","1919","1945","1954"],
                correctAnswer: 3)
        )
        questions.append(
            Question(question: "The Titanic departed from the United Kingdom, where was it supposed to arrive?",
                options: ["Paris"," Washington D.C.","New York City","Boston"],
                correctAnswer: 3)
        )
        questions.append(
            Question(question: "Which nation produces the most oil?",
                options: ["Iran","Iraq","Brazil","Canada"],
                correctAnswer: 4)
        )
        questions.append(
            Question(question: "Which country has most recently won consecutive World Cups in Soccer?",
                options: ["Italy","Brazil","Argetina","Spain"],
                correctAnswer: 2)
        )
        questions.append(
            Question(question: "Which of the following rivers is longest?",
                options: ["Yangtze","Mississippi","Congo","Mekong"],
                correctAnswer: 2)
        )
        questions.append(
            Question(question: "Which city is the oldest?",
                options: ["Mexico City","Cape Town","San Juan","Sydney"],
                correctAnswer: 1)
        )
        questions.append(
            Question(question: "Which country was the first to allow women to vote in national elections?",
                options: ["Poland","United States","Sweden","Senegal"],
                correctAnswer: 1)
        )
        questions.append(
            Question(question: "Which of these countries won the most medals in the 2012 Summer Games?",
                options: ["France","Germany","Japan","Great Britian"],
                correctAnswer: 4)
        )

    }
    
    
    func getQuestion() -> Question {
       let indexOfSelectedQuestion = GKRandomSource.sharedRandom().nextIntWithUpperBound(questions.count)
        self.currentQuestion = indexOfSelectedQuestion
        return questions[indexOfSelectedQuestion]
    }
    
    func checkAnswer(answer:String) -> String {

       
        questionsAsked += 1 // increment counter
    
        let correctAnswerIndex = questions[currentQuestion].correctAnswer - 1
        if answer == questions[currentQuestion].options[correctAnswerIndex] {
           
            correctQuestions += 1
            return "Correct!"
        } else {
           
            return "Sorry, wrong answer!"
        }
    }
    
    func getScore() -> String {
        
        return  "Way to go!\nYou got \(correctQuestions) out of \(questionsPerRound) correct!"
    }
    
}