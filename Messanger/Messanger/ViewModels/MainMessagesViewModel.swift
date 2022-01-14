//
//  MainMessagesViewModel.swift
//  Messanger
//
//  Created by arina.panchenko on 14.01.2022.
//

import Foundation

class MainMessagesViewModel:ObservableObject{
    @Published var errorMessage = ""
    @Published var chatUser:ChatUser?
    
    init(){
        fetchCurrentUser()
    }
    
    private func fetchCurrentUser(){
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
                let uid = data["uid"] as? String ?? ""
                let email = data["email"] as? String ?? ""
                let profileImageUrl = data["profileImageUrl"] as? String ?? ""
                self.chatUser = ChatUser(uid: uid, email: email, profileImageUrl: profileImageUrl)
            }
    }
}
