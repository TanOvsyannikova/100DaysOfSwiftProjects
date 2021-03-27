//
//  ViewController.swift
//  NamesToFaces
//
//  Created by Татьяна Овсянникова on 24.03.2021.
//

import UIKit

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var people = [Person]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell else {
            fatalError("Unable to dequeue PersonCell")
        }
        
        let person = people[indexPath.item]
        
        cell.name.text = person.name
        
        let path = getDocumentsDirectory().appendingPathComponent(person.image)
        cell.imageView.image = UIImage(contentsOfFile: path.path)
        
        cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
        
        return cell
    }
    
    @objc func addNewPerson() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        
        //challenge 2
//        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
//            {
//                picker.sourceType = UIImagePickerController.SourceType.camera
//                picker.allowsEditing = true
//                self.present(picker, animated: true, completion: nil)
//            }
//            else
//            {
//                let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//                self.present(alert, animated: true, completion: nil)
//            }
//
       present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        let person = Person(name: "Unknown", image: imageName)
        people.append(person)
        collectionView.reloadData()
        
        dismiss(animated: true)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let person = people[indexPath.item]
        
        let ac2 = UIAlertController(title: "Rename", message: nil, preferredStyle: .alert)
        ac2.addTextField()
        ac2.addAction(UIAlertAction(title: "OK", style: .default) {
            [weak self, weak ac2] _ in
            guard let newName = ac2?.textFields?[0].text else {
                return
            }
            person.name = newName
            self?.collectionView.reloadData()
        })
        
        //challenge 1
        let ac = UIAlertController(title: "Choose action", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Rename", style: .default, handler: {_ in self.present(ac2, animated: true)}))
        ac.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
                        self?.people.remove(at: indexPath.item)
                        self?.collectionView.deleteItems(at: [indexPath])
                    })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        present(ac, animated: true)
      
    }
    
   
}

