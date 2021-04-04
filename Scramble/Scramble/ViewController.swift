//
//  ViewController.swift
//  Scramble
//
//  Created by Татьяна Овсянникова on 09.03.2021.
//

import UIKit

class ViewController: UITableViewController {
    var allWords = [String]()
    
    var gameState = GameState(currentWord: "", usedWords: [String]())
    let gameStateKey = "GameState"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promtForAnswer))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(startGame))
        
        if let startWordURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordURL) {
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        
        if allWords.isEmpty
        {
            allWords = ["silkworm"]
        }
        
        performSelector(inBackground: #selector(loadGameState), with: nil)
    }
    
    @objc func loadGameState() {
        let userDefaults = UserDefaults.standard
        if let loadedState = userDefaults.object(forKey: gameStateKey) as? Data {
            let decoder = JSONDecoder()
            if let decodedState = try? decoder.decode(GameState.self, from: loadedState) {
                gameState = decodedState
            }
        }
        
        //start a new game
        if gameState.currentWord.isEmpty {
            performSelector(onMainThread: #selector(startGame), with: nil, waitUntilDone: false)
        }
        //load data
        else {
            performSelector(onMainThread: #selector(loadGameStateView), with: nil, waitUntilDone: false)
        }
    }
    
    @objc func saveGameState() {
        let encoder = JSONEncoder()
        if let encodedState = try? encoder.encode(gameState) {
            let userDefaults = UserDefaults.standard
            userDefaults.set(encodedState, forKey: gameStateKey)
        }
    }
    
    @objc func loadGameStateView() {
        title = gameState.currentWord
        tableView.reloadData()
    }
    
    @objc func startGame() {
        gameState.currentWord = allWords.randomElement() ?? "silkworm"
        gameState.usedWords.removeAll(keepingCapacity: true)
        
        DispatchQueue.global().async { [weak self] in
            self?.saveGameState()
            
            DispatchQueue.main.async {
                self?.loadGameStateView()
            }
        }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameState.usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = gameState.usedWords[indexPath.row]
        return cell
    }
    
    @objc func promtForAnswer() {
        let ac = UIAlertController(title: "Answer", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) {
            [weak self, weak ac] _ in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.submit(answer)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func submit(_ answer: String) {
        let lowerAnswer = answer.lowercased()
        
        if lowerAnswer != "" && lowerAnswer != title {
            if isPossible(word: lowerAnswer) {
                if isOriginal(word: lowerAnswer) {
                    if isReal(word: lowerAnswer) {
                        if isLong(word: lowerAnswer) {
                            gameState.usedWords.insert(lowerAnswer, at: 0)
                            
                            DispatchQueue.global().async { [weak self] in
                                self?.saveGameState()
                                
                                DispatchQueue.main.async {
                                    let indexPath = IndexPath(row: 0, section: 0)
                                    self?.tableView.insertRows(at: [indexPath], with: .automatic)
                                }
                            }
                            return
                        }
                        else { showErrorMessage(errorTitle: "Word too short", errorMessage: "Make it longer than 2 letters!") }
                        
                    } else { showErrorMessage(errorTitle: "Word not recognized", errorMessage: "You can't make them up :)") }
                    
                } else { showErrorMessage(errorTitle: "Word already used", errorMessage: "Be more original.") }
                
            } else {
                guard let title = title else { return }
                showErrorMessage(errorTitle: "Word not possible", errorMessage: "You can't spell that word from \(title.lowercased()).") }
        } else { showErrorMessage(errorTitle: "Enter a word", errorMessage: "You should provide some input.") }
    }
    
    func isPossible(word: String) -> Bool {
        guard var tempWord = title?.lowercased() else { return false }
        
        for letter in word {
            if let position = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: position)
            } else {
                return false
            }
        }
        
        return true
    }
    
    func isOriginal(word: String) -> Bool {
        return !gameState.usedWords.contains(word)
    }
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound
    }
    
    func isLong(word: String) -> Bool {
        return (word.count > 2)
    }
    
    func showErrorMessage(errorTitle: String, errorMessage: String) {
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "ok", style: .default))
        present(ac, animated: true)
    }
}

