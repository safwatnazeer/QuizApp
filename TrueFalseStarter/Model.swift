//
//  Model.swift
//  TrueFalseStarter
//
//  Created by Safwat Shenouda on 25/08/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import Foundation
import GameKit


// struct to hold all question information
struct Question {
    let question: String    // question text
    let options: [String]   // array of answer options
    let correctAnswer: Int  // index of correct answer
}

// Trivia class is responsible for managing all game data
// the class encapsulates all data so design fully adpots MVC pattern
class Trivia {
    var questions = [Question]()    // array of questions
    var currentQuestion: Int = 0    // hold the current question index to be used later to comcpare with supplied answer
    var questionsAsked = 0          // hold number of questions asked since game start
    var correctQuestions = 0        // hold number of correct answers during a game
    var questionsPerRound = 4       // number of questions to be asked in a game
    var questionsAskedDuringGame = [Int]() // array to hold the indices of questions that were already asked before to avoid repeating them
    
    // Intitalize questions data 
    // I modified the original list by removing one answer in some questions to have a mix of 3-options and 4-options questions. I also added a couple of questions at the end.
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
                options: ["1918","1945","1954"],
                correctAnswer: 2)
        )
        questions.append(
            Question(question: "The Titanic departed from the United Kingdom, where was it supposed to arrive?",
                options: ["Paris"," Washington D.C.","New York City","Boston"],
                correctAnswer: 3)
        )
        questions.append(
            Question(question: "Which nation produces the most oil?",
                options: ["Iran","Iraq","Canada"],
                correctAnswer: 3)
        )
        questions.append(
            Question(question: "Which country has most recently won consecutive World Cups in Soccer?",
                options: ["Italy","Brazil","Argetina","Spain"],
                correctAnswer: 2)
        )
        questions.append(
            Question(question: "Which of the following rivers is longest?",
                options: ["Yangtze","Mississippi","Congo"],
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

        questions.append(
            Question(question: "On which country coast you can see two oceans meet?",
                options: ["France","South Africa","India"],
                correctAnswer: 2)
        )
        questions.append(
            Question(question: "Which african country won cup of nations in football for 3 times in a row?",
                options: ["Egypt","Ghana","South Africa"],
                correctAnswer: 1)
        )

        
    }
    

    // Function to return a random question that wasn't asked before
    // Assumption that total number of questions is always >  questions per round
    func getQuestion() -> Question {
        
            var indexOfSelectedQuestion: Int
        
            // a repeat while loop to search for a new random question. In case we run out of new question it will return any question. but this will happen only if number of total questions is not > questiosn per round
            repeat
            {
                indexOfSelectedQuestion = GKRandomSource.sharedRandom().nextIntWithUpperBound(questions.count)
            } while isQuestionAskedBefore(indexOfSelectedQuestion) && (questionsAskedDuringGame.count<questions.count)
        
            self.currentQuestion = indexOfSelectedQuestion
            questionsAskedDuringGame.append(indexOfSelectedQuestion) // add question to the list of asked questions
            return questions[indexOfSelectedQuestion]
        
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

    // Function to check if supplied answer is correct or not
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
    
    // Function to return correct answer when needed
    func getCorrectAnswer() -> String {
        
        let correctAnswerIndex = questions[currentQuestion].correctAnswer - 1
        return questions[currentQuestion].options[correctAnswerIndex]
    }
    
    // Function to return total score (number of correct answers)
    func getScore() -> String {
        return  "Way to go!\nYou got \(correctQuestions) out of \(questionsPerRound) correct!"
    }
    
    
    // Function to prepare for a new game by reseting all counters
    func prepareToPlayAgain() {
        questionsAsked = 0
        correctQuestions = 0
        questionsAskedDuringGame.removeAll() // clear the array that hold asked before questions
        
    }
    
    // Function to check if game is over by checking how many question were asked so far in compare to questionsPerRound
    func isGameOver() -> Bool {
        
        if questionsAsked >= questionsPerRound {
            return true
        } else {
            return false
        }
        
    }
    
    // Function to adjust calaculation when player has not responded
    func timeOutOccured()  {
        questionsAsked += 1 // increment counter by the question that wasnt answered
    }
    


}