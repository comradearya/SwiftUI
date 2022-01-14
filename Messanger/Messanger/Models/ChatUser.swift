//
//  ChatUser.swift
//  Messanger
//
//  Created by arina.panchenko on 14.01.2022.
//

import Foundation

struct ChatUser {
    let uid:String
    let email:String
    let profileImageUrl:String
    
    init(data:[String: Any]){
        self.uid = data["uid"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.profileImageUrl = data["profileImageUrl"] as? String ?? ""
    }
}
