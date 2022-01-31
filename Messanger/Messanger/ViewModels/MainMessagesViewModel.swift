//
//  MainMessagesViewModel.swift
//  Messanger
//
//  Created by arina.panchenko on 14.01.2022.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class MainMessagesViewModel:ObservableObject{
    @Published var errorMessage:String = ""
    @Published var chatUser:ChatUser?
    
    @Published var isUserCurrentlyLoggedOut:Bool = false
    @Published var recentMessages = [RecentMessage]()
    init(){
        DispatchQueue.main.async {
            self.isUserCurrentlyLoggedOut = FirebaseManager.shared.auth.currentUser?.uid == nil
        }
        fetchRecentMessage()
        fetchCurrentUser()
        
    }
    
    private func fetchRecentMessage(){
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {return }
        FirebaseManager.shared.firestore
            .collection("recent_message")
            .document(uid)
            .collection("messages")
            .order(by: "timestamp")
            .addSnapshotListener{ querySnapshot, error in
                if let error = error {
                    self.errorMessage = "Failed to listen for recent messages: \(error)"
                    print(self.errorMessage)
                    return
                }
                querySnapshot?.documentChanges.forEach{ change in
                    let documentId = change.document.documentID
                    //   let data = change.document.data()
                    if let index = self.recentMessages.firstIndex(where: { rm in
                        return rm.id == documentId
                    }){
                        self.recentMessages.remove(at: index)
                    }
                    
                    do {
                        if let rm = try change.document.data(as: RecentMessage.self){
                            self.recentMessages.insert(rm, at: 0)
                        }
                    } catch {
                        print(error)
                    }
                    
                }
            }
    }
    
    func fetchCurrentUser(){
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            self.errorMessage = "Error fetching user uid"
            return }
        self.errorMessage = "\(uid)"
        FirebaseManager.shared.firestore.collection("users")
            .document(uid)
            .getDocument { snapshot, error in
                if let error = error {
                    self.errorMessage = "Failed to fetch current user: \(error)"
                    print("Failed to fetch current user: \(error)")
                    return
                }
                
                guard let data = snapshot?.data() else {
                    self.errorMessage = "No data found"
                    return
                }
                //self.errorMessage = "Data: \(data.description)"
                
                self.chatUser = ChatUser(data: data)
                
            }
    }
    
    func signOut(){
        try? FirebaseManager.shared.auth.signOut()
        self.isUserCurrentlyLoggedOut = true
        self.chatUser = nil
    }
}
