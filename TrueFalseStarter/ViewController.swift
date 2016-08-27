

import UIKit
import GameKit
import AudioToolbox

class ViewController: UIViewController {

    let trivia = Trivia() // create an instance of the class that hold all game data
    
    // define sound effects variables
    var correctAnswerSound: SystemSoundID = 0   // correct answer sound
    var wrongAnswerSound: SystemSoundID = 1     // wrong answer sound
    var gameStartSound: SystemSoundID = 2       // new game start sound
    var gameEndSound: SystemSoundID = 3         // game end sound
    var timeOutSound: SystemSoundID = 4         // time out sound
    
    var timer = NSTimer()       // create timer object to be used to time every question, actual setup is done in helper methods section
    let questionWithFourOptions  = 4   // constant to represent a question with 4 answers options
    let questionWithThreeOptions = 3   // constant to represent a question with 3 answers options
    
    // outlets to stroyboard elements
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
        // Prepare for game
        loadGameStartSound()
        prepareButtons()
        // Start game
        playSound(gameStartSound)
        displayQuestion()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Game play core
    
    //  Function to display a question and set buttons to answer options
    func displayQuestion() {
        
        let currentQuestion = trivia.getQuestion() // ask trivia class to get a new random question
        
        // show questions and answer options
        questionField.text = currentQuestion.question
        firstButton.setTitle(currentQuestion.options[0], forState: .Normal)
        seccondButton.setTitle(currentQuestion.options[1], forState: .Normal)
        thirdButton.setTitle(currentQuestion.options[2], forState: .Normal)
        
        // check if the question has 3 or 4 answer options and adjust button layouts accordingly
        if currentQuestion.options.count == questionWithFourOptions {
            fourthButton.setTitle(currentQuestion.options[3], forState: .Normal)
            setLayout(questionWithFourOptions) // setup layout for 4 options
            fourthButton.hidden = false
        } else {
            fourthButton.hidden = true
            setLayout(questionWithThreeOptions) // setup layout for 3 options only
            
        }
        
        // hide other buttons until player picks an answer
        playAgainButton.hidden = true
        resultLabel.hidden = true
        nextQuestionButton.hidden = true
    
        enableAllButtons()
        startTimer() // start measuring time to answer
 
 }
    // Function to dsiplay total score achieved and give player the option to play again
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
    
    // Function to check the answer by asking trivia if answer is correct or not.
    //
    @IBAction func checkAnswer(sender: UIButton) {
        
        stopTimer() // stop the timer as player has already picked an answer
        
        let answerIsCorrect = trivia.checkAnswer(sender.titleLabel!.text!) // Ask Trivia if answer is correct or not
        
        if answerIsCorrect {
            // show correct answer and play correct answer sound
            playSound(correctAnswerSound)
            resultLabel.text = "Correct!"
            resultLabel.textColor = UIColor.greenColor()
        }
        else {
            // show wrong answer and play wrong answer sound
            playSound(wrongAnswerSound)
            resultLabel.text = "Sorry that's not it."
            resultLabel.textColor = UIColor.orangeColor()
        }
        
        // show result and give player option to go for next question
        resultLabel.hidden = false
        nextQuestionButton.hidden = false
        // display correct answer anyway by highlighting button with correct answer
        displayCorrectAnswer()
    }
    
    // Function to move to next question in case game is not finished
    func nextRound() {
        if trivia.isGameOver() {
            // Game is over
            displayScore()
            playSound(gameEndSound)
        } else {
            // Continue game
            displayQuestion()
        }
    }
    
   // Function to respond to play again button
    @IBAction func playAgain() {
        
        // Show the answer buttons
        firstButton.hidden = false
        seccondButton.hidden = false
        thirdButton.hidden = false
        fourthButton.hidden = false
        
        // ask Trivia to prepare for a new game
        trivia.prepareToPlayAgain()
        playSound(gameStartSound)
        nextRound()
    }
    
    // Function to respond to next question button
    @IBAction func nextQuestion() {
        nextRound()
    }
    
    // Implementation of optional requirement #4: display a mix of 3-option questions as well as 4-option questions
    // Helper function to setup the layout of buttons at equal spacing based on number of answer options passed
    // This function uses 4 layout guides to automatically adjust spacing between buttons according to available space (works on all types of iPhones portrait mode)
    
    func setLayout(numberOfOptions: Int) {
        
        // remove old layoutguides (automatically removes constraints as well)
        for layoutGuid in view.layoutGuides {
            view.removeLayoutGuide(layoutGuid)
        }
        
        
        /// setup Layout guides to give equal space between buttons based on device size
        let firstLayoutGuide = UILayoutGuide()
        let secondLayoutGuide = UILayoutGuide()
        let thirdLayoutGuide = UILayoutGuide()
        let fourthLayoutGuide = UILayoutGuide()
        
        
        view.addLayoutGuide(firstLayoutGuide)
        view.addLayoutGuide(secondLayoutGuide)
        view.addLayoutGuide(thirdLayoutGuide)
        view.addLayoutGuide(fourthLayoutGuide)
    
        // select layout which layout to setup
        if numberOfOptions == questionWithFourOptions
        {
            // setup layoutguide for 4 buttons
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
        else {
            // setup layoutguides for 3 buttons
            NSLayoutConstraint.activateConstraints([
            firstLayoutGuide.topAnchor.constraintEqualToAnchor(firstButton.bottomAnchor),
            firstLayoutGuide.bottomAnchor.constraintEqualToAnchor(seccondButton.topAnchor),
            secondLayoutGuide.topAnchor.constraintEqualToAnchor(seccondButton.bottomAnchor),
            secondLayoutGuide.bottomAnchor.constraintEqualToAnchor(thirdButton.topAnchor),
            thirdLayoutGuide.topAnchor.constraintEqualToAnchor(thirdButton.bottomAnchor),
            thirdLayoutGuide.bottomAnchor.constraintEqualToAnchor(nextQuestionButton.topAnchor),
            
            firstLayoutGuide.heightAnchor.constraintEqualToAnchor(secondLayoutGuide.heightAnchor),
            secondLayoutGuide.heightAnchor.constraintEqualToAnchor(thirdLayoutGuide.heightAnchor)
            
            ])

        }
        
    }
    
    // Implementation of optional requirement #3: Implement a way to appropriately display the correct answer
    // Function to display correct answer by highlighting the button with correct answer and disable the others
    // User interaction is disabled anyway so user can't select any answer after correct answer is shown
    func displayCorrectAnswer() {
        
        disableAllButtons()
    
        // get the correct answer and compare to all buttons and highlight the correct one
        let correctAnswer = trivia.getCorrectAnswer()
        
        // highlight button with correct answer
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
        
        // show next question button
        nextQuestionButton.hidden = false
        
    }
    
    
    
    // MARK: Helper Methods
  
    // Implmentation of optional requirment #1: sound effects
    // Load 5 game snouds for game start,end,correct answer , wrong answer and time out
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
    
    func playSound(sound:SystemSoundID) {
        //AudioServicesPlaySystemSound(gameStartSound)
        AudioServicesPlaySystemSound(sound)

    }
    
    // Implmentation of optional requirment #2: Lightning mode
    // Setup timer to fire after 15 seconds in case of player didnt give any answer
    func startTimer(){
        timer.invalidate()
        timer = NSTimer.scheduledTimerWithTimeInterval(15, target: self, selector:#selector(timerAction), userInfo: nil, repeats: false)
    
    }
    
    func stopTimer() {
        timer.invalidate()
    }
    // function executed by timer after 15 sec to show correct answer
    func timerAction() {
        stopTimer()
        resultLabel.text = "Time out!!"
        resultLabel.textColor = UIColor.redColor()
        resultLabel.hidden = false
        playSound(timeOutSound)
        trivia.timeOutOccured()// inform trivia that timeout occured to adjust calculations
        displayCorrectAnswer()
    }
    
   
    // Helper function to disable all buttons as part of showing correct answer
    func disableAllButtons() {
        // disable all button
        firstButton.enabled = false
        seccondButton.enabled = false
        thirdButton.enabled = false
        fourthButton.enabled = false
        
        
    }
    
    // Helper function to enable buttons to show as part of next round
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
    
    // Helper function to shape buttons round corners
    func prepareButtons() {
        // set round button corners
        firstButton.layer.cornerRadius = 10
        seccondButton.layer.cornerRadius = 10
        thirdButton.layer.cornerRadius = 10
        fourthButton.layer.cornerRadius = 10
        nextQuestionButton.layer.cornerRadius = 10
        playAgainButton.layer.cornerRadius = 10
    }
    
}

