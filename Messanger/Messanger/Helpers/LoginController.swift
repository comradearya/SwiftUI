//
//  LoginController.swift
//  Messanger
//
//  Created by arina.panchenko on 13.01.2022.
//

import Foundation
import UIKit

class LoginController{
    public static let shared:LoginController = LoginController()
    var loginStatusMessage:String = ""
    
    func loginUser(with email:String, password:String){
        FirebaseManager.shared.auth.signIn(withEmail: email, password: password){
            result, error in
            if let error = error {
                print("Faild to login \(error)")
                self.loginStatusMessage = "Faild to login \(error)"
            }
            self.loginStatusMessage = "Successfully login user \(result?.user.uid)"
           print("Successfully login user \(result?.user.uid)")
        }
    }
    
    func registerUser(with email:String, password:String, image:UIImage? = nil){
        FirebaseManager.shared.auth.createUser(withEmail: email, password: password, completion: {
            result, error in
            if let error = error {
                print("Faild to register \(error)")
                self.loginStatusMessage = "Faild to register \(error)"
                return
            }
            print("Successfully registered user \(result?.user.uid)")
            self.loginStatusMessage = "Successfully registered user \(result?.user.uid)"
            
            if let image = image {
                self.persistImageToStorage(image)
            }
        })
    }
    
    private func persistImageToStorage(_ image:UIImage){
        let filename = UUID().uuidString
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        let ref = FirebaseManager.shared.storage.reference(withPath: uid)
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
        ref.putData(imageData, metadata: nil){ metadata, err in
            if let error = err{
                self.loginStatusMessage = "Failed to push image to Storage: \(error)"
            }
            
            ref.downloadURL(completion: { url, error in
                if let error = err {
                    self.loginStatusMessage = "Failed to retrieve downloadURL: \(error)"
                }
                self.loginStatusMessage = "Successfully stored image with  url :\(url?.absoluteString ?? "")"
            })
        }
    }
}
