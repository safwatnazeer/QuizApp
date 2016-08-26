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
    
    
    var correctAnswerSound: SystemSoundID = 0   // correct answer sound
    var wrongAnswerSound: SystemSoundID = 1     // wrong answer sound
    var gameStartSound: SystemSoundID = 2   // new game start sound
    var gameEndSound: SystemSoundID = 3     // game end sound
    var timeOutSound: SystemSoundID = 4 // time out sound
    
    var timer = NSTimer()
    
    @IBOutlet weak var questionField: UILabel!
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var seccondButton: UIButton!
    @IBOutlet weak var playAgainButton: UIButton!
    @IBOutlet weak var thirdButton: UIButton!
    @IBOutlet weak var fourthButton: UIButton!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var nextQuestionButton: UIButton!

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
        resultLabel.hidden = true
        nextQuestionButton.hidden = true
        
        enableAllButtons()
        startTimer()// start measuring time to answer
 
 }
    
    func displayScore() {
        // Hide the answer buttons
        firstButton.hidden = true
        seccondButton.hidden = true
        thirdButton.hidden = true
        fourthButton.hidden = true
        
        // hide result label
        resultLabel.hidden = true
        
        //hide next question button
        nextQuestionButton.hidden = true
        
        // Display play again button
        playAgainButton.hidden = false
        
        questionField.text = trivia.getScore()
        
    }
    
    @IBAction func checkAnswer(sender: UIButton) {
        stopTimer()
        
        let answerIsCorrect = trivia.checkAnswer(sender.titleLabel!.text!) // Bool to indicate if answer is correct or not
        
        if answerIsCorrect {
            AudioServicesPlaySystemSound(correctAnswerSound)
            resultLabel.text = "Correct!"
            resultLabel.textColor = UIColor.greenColor()
        }
        else {
            AudioServicesPlaySystemSound(wrongAnswerSound)
            resultLabel.text = "Sorry that's not it."
            resultLabel.textColor = UIColor.orangeColor()
        }
        resultLabel.hidden = false
        nextQuestionButton.hidden = false
        
        displayCorrectAnswer()
       // loadNextRoundWithDelay(seconds: 2)
    }
    
    func nextRound() {
        if trivia.isGameOver() {
            // Game is over
            displayScore()
            AudioServicesPlaySystemSound(gameEndSound)
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
        
        
        trivia.prepareToPlayAgain()
        AudioServicesPlaySystemSound(gameStartSound)
        nextRound()
    }
    
    @IBAction func nextQuestion() {
        nextRound()
    }
    
    func setLayout() {
        
        // set round button corners
        firstButton.layer.cornerRadius = 10
        seccondButton.layer.cornerRadius = 10
        thirdButton.layer.cornerRadius = 10
        fourthButton.layer.cornerRadius = 10
        nextQuestionButton.layer.cornerRadius = 10
        playAgainButton.layer.cornerRadius = 10
        
        /// setup Layout guides to give equal space between buttons based on device size
        let firstLayoutGuide = UILayoutGuide()
        let secondLayoutGuide = UILayoutGuide()
        let thirdLayoutGuide = UILayoutGuide()
        let fourthLayoutGuide = UILayoutGuide()
        
        
        view.addLayoutGuide(firstLayoutGuide)
        view.addLayoutGuide(secondLayoutGuide)
        view.addLayoutGuide(thirdLayoutGuide)
        view.addLayoutGuide(fourthLayoutGuide)
        
        NSLayoutConstraint.activateConstraints([
        firstLayoutGuide.topAnchor.constraintEqualToAnchor(firstButton.bottomAnchor),
        firstLayoutGuide.bottomAnchor.constraintEqualToAnchor(seccondButton.topAnchor),
        secondLayoutGuide.topAnchor.constraintEqualToAnchor(seccondButton.bottomAnchor),
        secondLayoutGuide.bottomAnchor.constraintEqualToAnchor(thirdButton.topAnchor),
        thirdLayoutGuide.topAnchor.constraintEqualToAnchor(thirdButton.bottomAnchor),
        thirdLayoutGuide.bottomAnchor.constraintEqualToAnchor(fourthButton.topAnchor),
        fourthLayoutGuide.topAnchor.constraintEqualToAnchor(fourthButton.bottomAnchor),
        fourthLayoutGuide.bottomAnchor.constraintEqualToAnchor(nextQuestionButton.topAnchor),
            
            
        firstLayoutGuide.heightAnchor.constraintEqualToAnchor(secondLayoutGuide.heightAnchor),
        secondLayoutGuide.heightAnchor.constraintEqualToAnchor(thirdLayoutGuide.heightAnchor),
        thirdLayoutGuide.heightAnchor.constraintEqualToAnchor(fourthLayoutGuide.heightAnchor)
        ])
        
    }

    func displayCorrectAnswer() {

        disableAllButtons()
    
        // get the correcg answer and compare to all buttons and highlight the correct one
        let correctAnswer = trivia.getCorrectAnswer()
        
        if firstButton.currentTitle == correctAnswer {
            firstButton.enabled = true
            firstButton.userInteractionEnabled = false
        }
        if seccondButton.currentTitle == correctAnswer {
            seccondButton.enabled = true
            seccondButton.userInteractionEnabled = false
        }
        if thirdButton.currentTitle == correctAnswer {
            thirdButton.enabled = true
            thirdButton.userInteractionEnabled = false
        }
        if fourthButton.currentTitle == correctAnswer {
            fourthButton.enabled = true
            fourthButton.userInteractionEnabled = false
        }
        
        nextQuestionButton.hidden = false
        
    }
    
    func disableAllButtons() {
        // disable all button
        firstButton.enabled = false
        seccondButton.enabled = false
        thirdButton.enabled = false
        fourthButton.enabled = false
        
        
    }
    func enableAllButtons() {
        // disable all button
        firstButton.enabled = true
        seccondButton.enabled = true
        thirdButton.enabled = true
        fourthButton.enabled = true
        
        firstButton.userInteractionEnabled = true
        seccondButton.userInteractionEnabled = true
        thirdButton.userInteractionEnabled = true
        fourthButton.userInteractionEnabled = true
    }
    
    
    // MARK: Helper Methods
    
/*    func loadNextRoundWithDelay(seconds seconds: Int) {
        // Converts a delay in seconds to nanoseconds as signed 64 bit integer
        let delay = Int64(NSEC_PER_SEC * UInt64(seconds))
        // Calculates a time value to execute the method given current time and delay
        let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, delay)
        
        // Executes the nextRound method at the dispatch time on the main queue
        dispatch_after(dispatchTime, dispatch_get_main_queue()) {
            self.nextRound()
        }
    }
  */
  
    func loadGameStartSound() {
        var pathToSoundFile = NSBundle.mainBundle().pathForResource("wrong", ofType: "wav")
        var soundURL = NSURL(fileURLWithPath: pathToSoundFile!)
        AudioServicesCreateSystemSoundID(soundURL, &wrongAnswerSound)
        
        pathToSoundFile = NSBundle.mainBundle().pathForResource("correct", ofType: "wav")
        soundURL = NSURL(fileURLWithPath: pathToSoundFile!)
        AudioServicesCreateSystemSoundID(soundURL, &correctAnswerSound)
        
        pathToSoundFile = NSBundle.mainBundle().pathForResource("gamestart", ofType: "wav")
        soundURL = NSURL(fileURLWithPath: pathToSoundFile!)
        AudioServicesCreateSystemSoundID(soundURL, &gameStartSound)
        
        pathToSoundFile = NSBundle.mainBundle().pathForResource("gameend", ofType: "wav")
        soundURL = NSURL(fileURLWithPath: pathToSoundFile!)
        AudioServicesCreateSystemSoundID(soundURL, &gameEndSound)
        
        pathToSoundFile = NSBundle.mainBundle().pathForResource("timeout", ofType: "wav")
        soundURL = NSURL(fileURLWithPath: pathToSoundFile!)
        AudioServicesCreateSystemSoundID(soundURL, &timeOutSound)

        
    }
    
    func playGameStartSound() {
        AudioServicesPlaySystemSound(gameStartSound)
    }
    
    func startTimer(){
        timer.invalidate()
        timer = NSTimer.scheduledTimerWithTimeInterval(15, target: self, selector:#selector(timerAction), userInfo: nil, repeats: false)
    
    }
    func stopTimer() {
        timer.invalidate()
    }
    
    func timerAction() {
        stopTimer()
        resultLabel.text = "Time out!!"
        resultLabel.textColor = UIColor.redColor()
        resultLabel.hidden = false
        AudioServicesPlaySystemSound(timeOutSound)
        displayCorrectAnswer()
    }
    
}

