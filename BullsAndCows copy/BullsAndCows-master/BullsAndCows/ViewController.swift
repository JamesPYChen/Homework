//
//  ViewController.swift
//  BullsAndCows
//
//  Created by Brian Hu on 5/19/16.
//  Copyright © 2016 Brian. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {
    @IBOutlet weak var guessTextField: UITextField!
    @IBOutlet weak var guessButton: UIButton!
    @IBOutlet weak var remainingTimeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var answearLabel: UILabel!
    var remainingTime: UInt8! {
        didSet {
            remainingTimeLabel.text = "remaining time: \(remainingTime)"
            if remainingTime == 0 {
                guessButton.enabled = false
            } else {
                guessButton.enabled = true
            }
        }
    }
    
    var hintArray = [(guess: String, hint: String)]() {
        didSet {
            self.tableView.reloadData()
        }
        
    }
    
    // TODO: 1. decide the data type you want to use to store the answear
    var answear: UInt16!
    var Answer: [Int] = []
    var stringArray: [String] = []
    var userAnswer: String = ""
    var hintNumberA: Int = 0
    var hintNumberB: Int = 0
    var guessStringArray: [String]=[]
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGame()
    }
    
    func setGame() {
        generateAnswear()
        remainingTime = 9
        hintArray.removeAll()
        answearLabel.text = nil
        guessTextField.text = nil
        
    }
    
    func generateAnswear() {
        // TODO: 2. generate your answear here
        // You need to generate 4 random and non-repeating digits.
        // Some hints: http://stackoverflow.com/q/24007129/938380
        let num = [0,1,2,3,4,5,6,7,8,9]
        var index: Int
        
        index = Int(arc4random_uniform(10))
        Answer.append(index)
     
        for _ in 1...3{
            while (Answer.contains(index)) {
                index = Int(arc4random_uniform(10))
                
            }
            Answer.append(index)
            
        }
        print(Answer)
        
        stringArray = Answer.map{
            String($0)
        }
        
        userAnswer = stringArray.joinWithSeparator("")
        
        
        
        print(stringArray)
        
    }
    
    @IBAction func guess(sender: AnyObject) {
        hintNumberA = 0
        hintNumberB = 0

        let guessString = guessTextField.text
        guard guessString?.characters.count == 4 else {
            let alert = UIAlertController(title: "you should input 4 digits to guess!", message: nil, preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        // TODO: 3. convert guessString to the data type you want to use and judge the guess
        let character1 = String(guessString![(guessString?.startIndex.advancedBy(0))!])
        let character2 = String(guessString![(guessString?.startIndex.advancedBy(1))!])
        let character3 = String(guessString![(guessString?.startIndex.advancedBy(2))!])
        let character4 = String(guessString![(guessString?.startIndex.advancedBy(3))!])
        
        guessStringArray.append(character1)
        guessStringArray.append(character2)
        guessStringArray.append(character3)
        guessStringArray.append(character4)
        
        
        if(stringArray[0] == character1){
            hintNumberA = hintNumberA+1
        } else if stringArray.contains(character1){
            hintNumberB = hintNumberB+1
        }
        
        if(stringArray[1] == character2){
            hintNumberA = hintNumberA+1
        } else if stringArray.contains(character2){
            hintNumberB = hintNumberB+1
        }
        
        if(stringArray[2] == character3){
            hintNumberA = hintNumberA+1
        } else if stringArray.contains(character3){
            hintNumberB = hintNumberB+1
        }
        
        if(stringArray[3] == character4){
            hintNumberA = hintNumberA+1
        } else if stringArray.contains(character4){
            hintNumberB = hintNumberB+1
        }
        
        
        
        
        
        
        // TODO: 4. update the hint
        let hint = "\(hintNumberA)A\(hintNumberB)B"
        
        hintArray.append((guessString!, hint))
        
        // TODO: 5. update the constant "correct" if the guess is correct
        var correct = false
        if hintNumberA == 4{
            correct = true
        }
        if correct {
            let alert = UIAlertController(title: "Wow! You are awesome!", message: nil, preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            guessButton.enabled = false
        } else {
            remainingTime! -= 1
        }
        
    }
    @IBAction func showAnswear(sender: AnyObject) {
        // TODO: 6. convert your answear to string(if it's necessary) and display it
        answearLabel.text = "\(userAnswer)"
    }
    
    @IBAction func playAgain(sender: AnyObject) {
        setGame()
        hintNumberA = 0
        hintNumberB = 0
    }
    
    // MARK: TableView
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hintArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Hint Cell", forIndexPath: indexPath)
        let (guess, hint) = hintArray[indexPath.row]
        cell.textLabel?.text = "\(guess) => \(hint)"
        return cell
    }
}

