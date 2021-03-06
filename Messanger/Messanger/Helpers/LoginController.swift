//
//  LoginController.swift
//  Messanger
//
//  Created by arina.panchenko on 13.01.2022.
//

import Foundation
import UIKit

struct Credentials{
    let email:String
    let password:String
}

class LoginController{
    public static let shared:LoginController = LoginController()
    var loginStatusMessage:String = ""
    private var credentials:Credentials?
    
    func loginUser(with email:String, password:String, onCompleted:@escaping (Bool) -> ()){
        self.credentials = Credentials(email: email, password: password)
        
        FirebaseManager.shared.auth.signIn(withEmail: email, password: password){
            result, error in
            if let error = error {
                print("Faild to login \(error)")
                self.loginStatusMessage = "Faild to login \(error)"
                onCompleted(false)
            }
            self.loginStatusMessage = "Successfully login user \(result?.user.uid)"
            print("Successfully login user \(result?.user.uid)")
            onCompleted(true)
        }
    }
    
    func registerUser(with email:String, password:String, image:UIImage? = nil, onCompleted: @escaping (Bool) -> ()){
        FirebaseManager.shared.auth.createUser(withEmail: email, password: password, completion: {
            result, error in
            if let error = error {
                print("Faild to register \(error)")
                self.loginStatusMessage = "Faild to register \(error)"
                onCompleted(false)
                return
            }
            print("Successfully registered user \(result?.user.uid)")
            self.loginStatusMessage = "Successfully registered user \(result?.user.uid)"
            if let image = image {
                self.persistImageToStorage(image)
                onCompleted(true)
            } else {
                self.loginStatusMessage = "You must add image to your account."
                onCompleted(false)
            }
        })
    }
    
    private func persistImageToStorage(_ image:UIImage){
       // let filename = UUID().uuidString
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        let ref = FirebaseManager.shared.storage.reference(withPath: uid)
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
        ref.putData(imageData, metadata: nil){ metadata, err in
            if let error = err{
                self.loginStatusMessage = "Failed to push image to Storage: \(error)"
                return
            }
            
            ref.downloadURL(completion: { url, error in
                if let error = err {
                    self.loginStatusMessage = "Failed to retrieve downloadURL: \(error)"
                    return
                }
                self.loginStatusMessage = "Successfully stored image with  url :\(url?.absoluteString ?? "")"
                
                if let url = url {
                    self.storeUserInformation(url)
                }
            })
        }
    }
    
    private func storeUserInformation(_ imageProfileUrl:URL){
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {return }
        let userData = ["email" : self.credentials?.email, "uid":uid, "profileImageUrl" : imageProfileUrl.absoluteString]
        
        FirebaseManager.shared.firestore.collection("users")
            .document(uid)
            .setData(userData as [String : Any]) {
                err in
                if let err = err {
                    print(err)
                    self.loginStatusMessage = "\(err)"
                    return
                }
                print("Success")
            }
    }
}
