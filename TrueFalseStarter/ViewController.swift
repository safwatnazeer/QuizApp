//
//  ViewController.swift
//  TrueFalseStarter
//
//  Created by Pasan Premaratne on 3/9/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import UIKit
import GameKit
import AudioToolbox

class ViewController: UIViewController {
    
    let questionsPerRound = 4
    var questionsAsked = 0
    var correctQuestions = 0
    var indexOfSelectedQuestion: Int = 0
    
    var gameSound: SystemSoundID = 0
    
    let trivia: [[String : String]] = [
        ["Question": "Only female koalas can whistle", "Answer": "False"],
        ["Question": "Blue whales are technically whales", "Answer": "True"],
        ["Question": "Camels are cannibalistic", "Answer": "False"],
        ["Question": "All ducks are birds", "Answer": "True"]
    ]
    
    @IBOutlet weak var questionField: UILabel!
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var seccondButton: UIButton!
    @IBOutlet weak var playAgainButton: UIButton!
    @IBOutlet weak var thirdButton: UIButton!
    @IBOutlet weak var fourthButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        loadGameStartSound()
        // Start game
        playGameStartSound()
        displayQuestion()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayQuestion() {
        indexOfSelectedQuestion = GKRandomSource.sharedRandom().nextIntWithUpperBound(trivia.count)
        let questionDictionary = trivia[indexOfSelectedQuestion]
        questionField.text = questionDictionary["Question"]
        playAgainButton.hidden = true
    }
    
    func displayScore() {
        // Hide the answer buttons
        firstButton.hidden = true
        seccondButton.hidden = true
        
        // Display play again button
        playAgainButton.hidden = false
        
        questionField.text = "Way to go!\nYou got \(correctQuestions) out of \(questionsPerRound) correct!"
        
    }
    
    @IBAction func checkAnswer(sender: UIButton) {
        // Increment the questions asked counter
        questionsAsked += 1
        
        let selectedQuestionDict = trivia[indexOfSelectedQuestion]
        let correctAnswer = selectedQuestionDict["Answer"]
        
        if (sender === firstButton &&  correctAnswer == "True") || (sender === seccondButton && correctAnswer == "False") {
            correctQuestions += 1
            questionField.text = "Correct!"
        } else {
            questionField.text = "Sorry, wrong answer!"
        }
        
        loadNextRoundWithDelay(seconds: 2)
    }
    
    func nextRound() {
        if questionsAsked == questionsPerRound {
            // Game is over
            displayScore()
        } else {
            // Continue game
            displayQuestion()
        }
    }
    
    @IBAction func playAgain() {
        // Show the answer buttons
        firstButton.hidden = false
        seccondButton.hidden = false
        
        questionsAsked = 0
        correctQuestions = 0
        nextRound()
    }
    // MARK : Test layout guides
    
    func setLayout() {
        
        // set round button corners
        firstButton.layer.cornerRadius = 10
        seccondButton.layer.cornerRadius = 10
        thirdButton.layer.cornerRadius = 10
        fourthButton.layer.cornerRadius = 10
        
        /// setup Layout guides to give equal space between buttons based on device size
        let topLayoutGuide = UILayoutGuide()
        let centerLayoutGuide = UILayoutGuide()
        let bottomLayoutGuide = UILayoutGuide()
        
        view.addLayoutGuide(topLayoutGuide)
        view.addLayoutGuide(centerLayoutGuide)
        view.addLayoutGuide(bottomLayoutGuide)
        
        NSLayoutConstraint.activateConstraints([
        topLayoutGuide.topAnchor.constraintEqualToAnchor(firstButton.bottomAnchor),
        topLayoutGuide.bottomAnchor.constraintEqualToAnchor(seccondButton.topAnchor),
        centerLayoutGuide.topAnchor.constraintEqualToAnchor(seccondButton.bottomAnchor),
        centerLayoutGuide.bottomAnchor.constraintEqualToAnchor(thirdButton.topAnchor),
        bottomLayoutGuide.topAnchor.constraintEqualToAnchor(thirdButton.bottomAnchor),
        bottomLayoutGuide.bottomAnchor.constraintEqualToAnchor(fourthButton.topAnchor),
        topLayoutGuide.heightAnchor.constraintEqualToAnchor(centerLayoutGuide.heightAnchor),
        centerLayoutGuide.heightAnchor.constraintEqualToAnchor(bottomLayoutGuide.heightAnchor)
        ])
    }

    
    // MARK: Helper Methods
    
    func loadNextRoundWithDelay(seconds seconds: Int) {
        // Converts a delay in seconds to nanoseconds as signed 64 bit integer
        let delay = Int64(NSEC_PER_SEC * UInt64(seconds))
        // Calculates a time value to execute the method given current time and delay
        let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, delay)
        
        // Executes the nextRound method at the dispatch time on the main queue
        dispatch_after(dispatchTime, dispatch_get_main_queue()) {
            self.nextRound()
        }
    }
    
    func loadGameStartSound() {
        let pathToSoundFile = NSBundle.mainBundle().pathForResource("GameSound", ofType: "wav")
        let soundURL = NSURL(fileURLWithPath: pathToSoundFile!)
        AudioServicesCreateSystemSoundID(soundURL, &gameSound)
    }
    
    func playGameStartSound() {
        AudioServicesPlaySystemSound(gameSound)
    }
}

