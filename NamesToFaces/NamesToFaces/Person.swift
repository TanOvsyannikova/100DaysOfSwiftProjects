//
//  Person.swift
//  NamesToFaces
//
//  Created by Татьяна Овсянникова on 25.03.2021.
//

import UIKit

class Person: NSObject {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
