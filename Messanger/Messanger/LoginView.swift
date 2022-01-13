//
//  ContentView.swift
//  Messanger
//
//  Created by arina.panchenko on 12.01.2022.
//

import SwiftUI
import Firebase

struct LoginView: View {
    @State var isLogingMode = false
    @State var shouldShowImagePicker = false
    @State var email:String = ""
    @State var password:String = ""
    @State var image:UIImage?
    
    @State var loginStatusMessage:String = ""
    
    var body: some View {
        NavigationView{
            ScrollView{
                VStack(spacing: 20){
                    //MARK:-  Segmented Control
                    Picker(selection: $isLogingMode, label: Text("")){
                        Text("Login")
                            .tag(true)
                        Text("Create Account")
                            .tag(false)
                    }.pickerStyle(SegmentedPickerStyle())
                    //MARK:- Profile Image
                    if !isLogingMode {
                        Button{
                            self.shouldShowImagePicker.toggle()
                        } label: {
                            VStack{
                                if let image = self.image {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 128, height: 128)
                                        .cornerRadius(64)
                                } else {
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 64))
                                        .padding()
                                }
                            }
                            .overlay(RoundedRectangle(cornerRadius: 64)
                                        .stroke(Color.black, lineWidth: 4))
                        }
                    }
                    
                    //MARK:- Login & Password
                    Group {
                        TextField("Email", text:$email)
                            .keyboardType(.emailAddress)
                        
                        SecureField("Password", text:$password)
                    }
                    .autocapitalization(.none)
                    .padding(12)
                    .background(Color.white)
                    
                    //MARK:- Create Account Button
                    
                    Button{
                        self.handleAction()
                    } label:{
                        HStack{
                            Spacer()
                            Text(isLogingMode ? "Login" : "Create Account")
                                .foregroundColor(.white)
                                .padding(.vertical, 10)
                                .font(.system(size:14, weight: .semibold))
                            Spacer()
                        }.background(Color.blue)
                    }
                    Text(self.loginStatusMessage).foregroundColor(.red)
                }
                .padding()
                
            }
            .navigationBarTitle(isLogingMode ? "Log In" : "Create Account")
            .background(Color(.init(white:0, alpha: 0.06))
                            .ignoresSafeArea())
        }
        //     .navigationViewStyle(StackNavigationViewStyle())
        .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil){
            ImagePicker(image: $image)
        }
    }
    
    private func handleAction(){
        if isLogingMode{
            print("login")
        } else {
            self.createNewAccount()
        }
    }
    
    private func createNewAccount(){
        FirebaseManager.shared.auth.createUser(withEmail: email, password: password, completion: {
            result, error in
            if let error = error {
                print("Faild to register \(error)")
                self.loginStatusMessage = "Faild to register \(error)"
                return
            }
            print("Successfully registered user \(result?.user.uid)")
            self.loginStatusMessage = "Successfully registered user \(result?.user.uid)"
            
            self.persistImageToStorage()
        })
    }
    
    private func loginUser(){
        FirebaseManager.shared.auth.signIn(withEmail: email, password: password){
            result, error in
            if let error = error {
                print("Faild to login \(error)")
                self.loginStatusMessage = "Faild to login \(error)"
                return
            }
            print("Successfully logged in as a user \(result?.user.uid)")
            self.loginStatusMessage = "Successfully login user \(result?.user.uid)"
        }
    }
    
    private func persistImageToStorage(){
        let filename = UUID().uuidString
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        let ref = FirebaseManager.shared.storage.reference(withPath: uid)
        guard let imageData = self.image?.jpegData(compressionQuality: 0.5) else { return }
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
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
