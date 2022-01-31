//
//  RecentMessage.swift
//  Messanger
//
//  Created by arina.panchenko on 20.01.2022.
//

import Firebase
import FirebaseFirestoreSwift

struct RecentMessage:Identifiable, Codable{
   @DocumentID var id:String?
    let text,fromId, toId, email, profileImageUrl:String
    let timestamp:Date
    
//    init(documentId:String, data:[String:Any]){
//    //    self.documentId = documentId
//        self.text = data[FirebaseConstraints.text] as? String ?? ""
//     //   self.timestamp = data[FirebaseConstraints.timestamp] as? Timestamp ?? Timestamp(date: Date())
//        self.fromId = data[FirebaseConstraints.fromId] as? String ?? ""
//        self.toId = data[FirebaseConstraints.toId] as? String ?? ""
//        self.email = data[FirebaseConstraints.email] as? String ?? ""
//        self.profileImageUrl = data[FirebaseConstraints.profileImageUrl] as? String ?? ""
//    }
}
