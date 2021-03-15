//
//  Petition.swift
//  Parser
//
//  Created by Татьяна Овсянникова on 15.03.2021.
//

import Foundation

struct Petition: Codable {
    var title: String
    var body: String
    var signatureCount: Int
}
