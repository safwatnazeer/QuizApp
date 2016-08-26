//
//  Model.swift
//  TrueFalseStarter
//
//  Created by Safwat Shenouda on 25/08/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import Foundation
import GameKit



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
    var questionsAskedDuringGame = [Int]() // array to hold the indices of questions that were already asked before
    
    init() {
        
 /*       questions.append(
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
   */
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

        questions.append(
            Question(question: "On which country coast you can see two oceans meet?",
                options: ["France","South Africa","India"],
                correctAnswer: 2)
        )
        questions.append(
            Question(question: "Which african country won cup of nations in football 3 times in a row?",
                options: ["Egypt","Ghana","South Africa"],
                correctAnswer: 1)
        )

        
    }
    
    
    func getQuestion() -> Question {
        var indexOfSelectedQuestion: Int
        var looping = 0
        repeat
        {   looping += 1
            indexOfSelectedQuestion = GKRandomSource.sharedRandom().nextIntWithUpperBound(questions.count)
            print("looping .. \(looping) .. question index = \(indexOfSelectedQuestion)")
        } while isQuestionAskedBefore(indexOfSelectedQuestion)
        
        self.currentQuestion = indexOfSelectedQuestion
        questionsAskedDuringGame.append(indexOfSelectedQuestion) // add question to list of asked questions
        return questions[indexOfSelectedQuestion]
    }
    
    func checkAnswer(answer:String) -> Bool {

       
        questionsAsked += 1 // increment counter
    
        let correctAnswerIndex = questions[currentQuestion].correctAnswer - 1
        if answer == questions[currentQuestion].options[correctAnswerIndex] {
            correctQuestions += 1
            return true
        } else {
            return false
        }
    }
    
    func getCorrectAnswer() -> String {
        
        let correctAnswerIndex = questions[currentQuestion].correctAnswer - 1
        return questions[currentQuestion].options[correctAnswerIndex]
    }
    
    
    func getScore() -> String {
        return  "Way to go!\nYou got \(correctQuestions) out of \(questionsPerRound) correct!"
    }
    
    
    
    func prepareToPlayAgain() {
        questionsAsked = 0
        correctQuestions = 0
        questionsAskedDuringGame.removeAll()
        
    }
    
    func isGameOver() -> Bool {
        
        if questionsAsked >= questionsPerRound {
            return true
        } else {
            return false
        }
        
    }
    func timeOutOccured()  {
        questionsAsked += 1 // increment counter by the question that wasnt answered
    }
    

// Helper function to check if question was asked before
    func isQuestionAskedBefore(questionIndex:Int) -> Bool {
        
        for i in questionsAskedDuringGame {
            if questionIndex == i {
                return true
            }
        }
     return false
    }
    
}