//
//  Person.swift
//  NamesToFaces
//
//  Created by Татьяна Овсянникова on 25.03.2021.
//

import UIKit

class Person: NSObject, Codable //, NSCoding - for storing user data using UserDafaults
{
    //save data using UserDefaults
//    required init(coder aDecoder: NSCoder) {
//        name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
//        image = aDecoder.decodeObject(forKey: "image") as? String ?? ""
//    }
//
//    func encode(with aCoder: NSCoder) {
//        aCoder.encode(name, forKey: "name")
//        aCoder.encode(image, forKey: "image")
//    }
    
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
