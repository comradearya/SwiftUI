//
//  ChatLogViewModel.swift
//  Messanger
//
//  Created by arina.panchenko on 17.01.2022.
//

import SwiftUI
import Firebase

class ChatLogViewModel:ObservableObject{
    @Published var chatText = ""
    @Published var errorMessage = ""
    let chatUser:ChatUser?
    init(chatUser: ChatUser?){
        self.chatUser = chatUser
    }
    
    func handleSend(){
        print(chatText)
        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid else { return }
        guard let toId = chatUser?.uid else {return }
        
        let document = FirebaseManager.shared.firestore.collection("messages")
            .document(fromId)
            .collection(toId)
            .document()
        
        let messagesData = ["fromId":fromId, "toId":toId, "text":self.chatText, "timestamp":Timestamp()] as [String:Any]
        document.setData(messagesData){error in
            if let error = error {
                self.errorMessage = "Failed to save message into Firestore: \(error)"
                return
            }
            print("Successfully saved current user sending message")
            self.chatText = ""
        }
        
        let recepientMessageDocument = FirebaseManager.shared.firestore.collection("messages")
            .document(toId)
            .collection(fromId)
            .document()
        
        recepientMessageDocument.setData(messagesData){ error in
            if let error = error {
                self.errorMessage = "Failed to save message into Firestore: \(error)"
                return
            }
            print("Recepient saved message as well")
        }
    }
}
