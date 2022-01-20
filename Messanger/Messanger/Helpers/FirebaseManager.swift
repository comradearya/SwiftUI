//
//  FirebaseMAnager.swift
//  Messanger
//
//  Created by arina.panchenko on 13.01.2022.
//

import Foundation
import Firebase

struct FirebaseConstraints{
    static let fromId = "fromId"
    static let toId = "toId"
    static let text = "text"
    static let profileImageUrl = "profileImageUrl"
    static let timestamp = "timestamp"
    static let email = "email"
}

class FirebaseManager:NSObject{
    let auth:Auth
    let storage:Storage
    let firestore:Firestore
    
    static let shared = FirebaseManager()
    
    override init(){
        FirebaseApp.configure()
        
        self.auth = Auth.auth()
        self.storage = Storage.storage()
        self.firestore = Firestore.firestore()
        
        super.init()
    }
}
