//
//  ViewController.swift
//  BuyMe
//
//  Created by Татьяна Овсянникова on 14.03.2021.
//

import UIKit

import UIKit

class ViewController: UITableViewController {
    
    var shoppingListOfItems = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promtForShoppingListItem))
                
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(createShoppingList))
        
        createShoppingList()
    }
    
    
    @objc func createShoppingList() {
            title = "Shopping List"
            shoppingListOfItems.removeAll(keepingCapacity: true)
            tableView.reloadData()
        }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return shoppingListOfItems.count
        }
        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath)
            cell.textLabel?.text = shoppingListOfItems[indexPath.row]
            return cell
        }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        if editingStyle == .delete {
            shoppingListOfItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
    }
    }
    
    
    @objc func promtForShoppingListItem() {
            let ac = UIAlertController(title: "Item", message: nil, preferredStyle: .alert)
            ac.addTextField()
            
            let submitAction = UIAlertAction(title: "Submit", style: .default) {
                [weak self, weak ac] _ in
                guard let item = ac?.textFields?[0].text else { return }
                self?.submit(item)
            }
            
            ac.addAction(submitAction)
            present(ac, animated: true)
        }
    
    func submit(_ item: String) {
        
        if isNotEmpty(string: item) {
            if isUnique(string: item) {
                shoppingListOfItems.insert(item, at: 0)
                let indexPath = IndexPath(row: 0, section: 0)
                tableView.insertRows(at: [indexPath], with: .automatic)
                return
            } else {
                showErrorMessage(errorTitle: "Word already in the list", errorMessage: "You have already added '\(item)' to the list.")
            }
        } else {
            showErrorMessage(errorTitle: "Try again", errorMessage: "Type a product name to add to your shopping list.")
        }
    }

        func isNotEmpty(string: String) -> Bool {
            return string.count > 0
        }
        
        func isUnique(string: String) -> Bool {
            return !shoppingListOfItems.contains(string)
        }
        
        
        
        
        func showErrorMessage(errorTitle: String, errorMessage: String) {
                let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "ok", style: .default))
                present(ac, animated: true)
            }
}

