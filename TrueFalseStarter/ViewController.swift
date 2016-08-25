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
    ///
    let trivia = Trivia() // create instance of the class that hold all data
    ///
    
    var gameSound: SystemSoundID = 0
       
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
    
    // a function to display a question and set all answer buttons to possible options
    func displayQuestion() {
        
        let currentQuestion = trivia.getQuestion() // ask trivia class to get a new random question
        
        questionField.text = currentQuestion.question 
        
        firstButton.setTitle(currentQuestion.options[0], forState: .Normal)
        seccondButton.setTitle(currentQuestion.options[1], forState: .Normal)
        thirdButton.setTitle(currentQuestion.options[2], forState: .Normal)
        fourthButton.setTitle(currentQuestion.options[3], forState: .Normal)
        
        playAgainButton.hidden = true
 
 
 }
    
    func displayScore() {
        // Hide the answer buttons
        firstButton.hidden = true
        seccondButton.hidden = true
        thirdButton.hidden = true
        fourthButton.hidden = true
        
        // Display play again button
        playAgainButton.hidden = false
        
        questionField.text = trivia.getScore()
        
    }
    
    @IBAction func checkAnswer(sender: UIButton) {
        
        questionField.text =  trivia.checkAnswer(sender.titleLabel!.text!) // set text of question feild to show result
        loadNextRoundWithDelay(seconds: 2)
    }
    
    func nextRound() {
        if trivia.questionsAsked == trivia.questionsPerRound {
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
        thirdButton.hidden = false
        fourthButton.hidden = false
        
        trivia.questionsAsked = 0
        trivia.correctQuestions = 0
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

