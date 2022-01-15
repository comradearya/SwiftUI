//
//  CreateNewMessageViewModel.swift
//  Messanger
//
//  Created by arina.panchenko on 15.01.2022.
//

import Foundation

class CreateNewMessageViewModel:ObservableObject {
    @Published var users = [ChatUser]()
    @Published var errorMessage = ""
    
    init(){
        fetchAllUsers()
    }
    
    private func fetchAllUsers(){
        FirebaseManager.shared.firestore.collection("users")
            .getDocuments{ docsSnapshot, error in
                if let error = error {
                    print("Failed to fetch users: \(error)")
                    self.errorMessage = "Failed to fetch users: \(error)"
                    return
                }
                
                docsSnapshot?.documents.forEach({
                    snapshot in
                    let user = ChatUser(data: snapshot.data())
                    if user.uid != FirebaseManager.shared.auth.currentUser?.uid {
                        self.users.append(user)
                    }
                })
            }
        self.errorMessage = "Fetched users successfully"
    }
}
