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
    @Published var chatMessages :[ChatMessage] = []
    @Published var count = 0 
    let chatUser:ChatUser?
    init(chatUser: ChatUser?){
        self.chatUser = chatUser
        self.fetchMessages()
    }
    
    private func fetchMessages(){
        guard let fromId = FirebaseManager.shared.auth
                .currentUser?.uid else {return }
        guard let toId = chatUser?.uid else {return }
        FirebaseManager.shared.firestore
            .collection("messages")
            .document(fromId)
            .collection(toId)
            .order(by: FirebaseConstraints.timestamp)
            .addSnapshotListener{ querySnapshot, err in
                if let error = err {
                    self.errorMessage = "Failed to listen for messages: \(error)"
                    print(error)
                    return
                }
                querySnapshot?.documentChanges.forEach({ change in
                    if change.type == .added {
                        let data = change.document.data()
                        let chatMessage = ChatMessage(documentId: change.document.documentID, data: data)
                        self.chatMessages.append(chatMessage)}
                })
            }
        DispatchQueue.main.async {
            self.count += 1
        }
    }
    
    func handleSend(){
        print(chatText)
        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid else { return }
        guard let toId = chatUser?.uid else {return }
        
        let document = FirebaseManager.shared.firestore.collection("messages")
            .document(fromId)
            .collection(toId)
            .document()
        
        let messagesData = [FirebaseConstraints.fromId:fromId, FirebaseConstraints.toId:toId, FirebaseConstraints.text: self.chatText, FirebaseConstraints.timestamp:Timestamp()] as [String:Any]
        document.setData(messagesData){error in
            if let error = error {
                self.errorMessage = "Failed to save message into Firestore: \(error)"
                return
            }
            print("Successfully saved current user sending message")
            
            self.persistRecentMessage()
            
            self.chatText = ""
            self.count += 1
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
    
    private func persistRecentMessage(){
        
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {return }
        guard let toId = self.chatUser?.uid else {return }
        let document = FirebaseManager.shared.firestore
            .collection("recent_message")
            .document(uid)
            .collection("messages")
            .document(toId)
        
        let data = [FirebaseConstraints.timestamp : Timestamp(),
                    FirebaseConstraints.text : self.chatText,
                    FirebaseConstraints.toId : toId,
                    FirebaseConstraints.fromId: uid,
                    FirebaseConstraints.profileImageUrl: chatUser?.profileImageUrl ??  "",
                    FirebaseConstraints.email : chatUser?.email] as [String:Any]
        
        //TODO: - Implement saving another similar dictionary for the recepient of this message...how?
        document.setData(data){ error in
            if let error = error {
                self.errorMessage = "Failed to save recent message: \(error)"
                print(self.errorMessage)
                return
            }
        }
        
    }
}
