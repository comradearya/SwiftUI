//
//  ChatMessage.swift
//  Messanger
//
//  Created by arina.panchenko on 18.01.2022.
//

import Foundation

struct ChatMessage:Identifiable {
    var id:String { documentId }
    let fromId, toId, text, documentId:String
    
    init(documentId: String, data: [String:Any]){
        self.documentId = documentId
        self.fromId = data[FirebaseConstraints.fromId] as? String ?? ""
        self.toId = data[FirebaseConstraints.toId] as? String ?? ""
        self.text = data[FirebaseConstraints.text] as? String ?? ""
    }
}
