//
//  ViewController.swift
//  SimplePicturesViewer
//
//  Created by Татьяна Овсянникова on 02.03.2021.
//

import UIKit

class ViewController: UITableViewController {
    
    var pictures = [String]()
    var picturesTapCount = [String: Int]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        title = "Lovely Cats Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        performSelector(inBackground: #selector(loadImages), with: nil)
        
        let userDefaults = UserDefaults.standard
        picturesTapCount = userDefaults.object(forKey: "TapCount") as? [String: Int] ?? [String: Int]()
    }
    
    @objc func loadImages() {
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasSuffix(".jpg") {
                pictures.append(item)
            }
        }
        
        tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "picture", for: indexPath)
        cell.textLabel?.text = "A Lovely Cat \(indexPath.row + 1)"
        cell.detailTextLabel?.text = "Views: \(picturesTapCount[pictures[indexPath.row], default: 0])"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.selectedImage = pictures[indexPath.row]
            
            picturesTapCount[pictures[indexPath.row], default: 0] += 1
            
            DispatchQueue.global().async { [weak self] in
                self?.saveTapCount()
                
                DispatchQueue.main.async {
                    self?.navigationController?.pushViewController(vc, animated: true)
                    self?.tableView.reloadRows(at: [indexPath], with: .none)
                }
            }
        }
    }
    
    func saveTapCount() {
        let userDefaults = UserDefaults.standard
        userDefaults.set(picturesTapCount, forKey: "TapCount")
    }
}

