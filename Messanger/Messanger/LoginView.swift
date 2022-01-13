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
        
    private let loginController = LoginController.shared
    
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
                    Text(loginController.loginStatusMessage).foregroundColor(.red)
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
        self.loginController.registerUser(with:self.email, password: self.password, image: self.image)
    }
    
    private func loginUser(){
        self.loginController.loginUser(with: email, password: password)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
