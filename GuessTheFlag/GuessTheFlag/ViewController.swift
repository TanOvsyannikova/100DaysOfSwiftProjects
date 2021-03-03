//
//  ViewController.swift
//  GuessTheFlag
//
//  Created by Татьяна Овсянникова on 03.03.2021.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var firstFlagButton: UIButton!
    @IBOutlet var secondFlagButton: UIButton!
    @IBOutlet var thirdFlagButton: UIButton!
    
    var countries = [String]()
    var score = 0
    var counter = 1
    var correctAnswer = 0
    let amountOfQuestionsInOneGame = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        
        firstFlagButton.layer.borderWidth = 1
        secondFlagButton.layer.borderWidth = 1
        thirdFlagButton.layer.borderWidth = 1
        
        firstFlagButton.layer.borderColor = UIColor.lightGray.cgColor
        secondFlagButton.layer.borderColor = UIColor.lightGray.cgColor
        thirdFlagButton.layer.borderColor = UIColor.lightGray.cgColor
        
        askQuestion()
    }
    
    func askQuestion(action: UIAlertAction! = nil) {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        firstFlagButton.setImage(UIImage( named: countries[0]) , for: .normal)
        secondFlagButton.setImage(UIImage( named: countries[1]) , for: .normal)
        thirdFlagButton.setImage(UIImage( named: countries[2]) , for: .normal)
        
        title = countries[correctAnswer].uppercased() + "   (Flag: \(counter)/10)"
        
        
    }
    
    @IBAction func ButtonTapped(_ sender: UIButton) {
        //let title: String
        
        func countryToCapitalLetters(country: String) -> String
        {
            var countryWithPrettyName: String
            if (country == "us" || country == "uk") {
                countryWithPrettyName = country.uppercased()
            } else {
                countryWithPrettyName = country.capitalized
            }
            return countryWithPrettyName
        }
        
        
        if sender.tag == correctAnswer {
            score += 1
        } else {
            let ac = UIAlertController(title: "Mistake!", message: "That was \(countryToCapitalLetters(country: countries[correctAnswer]))", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Continue", style: .default))
            
            present(ac, animated: true)
        }
        
        
        
        if counter == amountOfQuestionsInOneGame {
            let ac = UIAlertController(title: "Result", message: "Your final score is \(score)/10", preferredStyle: .alert)
            
            ac.addAction(UIAlertAction(title: "Play again", style: .default, handler: askQuestion))
            
            present(ac, animated: true)
            
            counter = 1
            score = 0
        } else {
            counter += 1
            askQuestion()
        }
    }
    
}

