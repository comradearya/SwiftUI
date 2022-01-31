//
//  MainMessagesView.swift
//  Messanger
//
//  Created by arina.panchenko on 13.01.2022.
//

import SwiftUI
import SDWebImageSwiftUI
import Firebase


struct MainMessagesView: View {
    @State var shouldPerformLogoutOptions:Bool = false
    @ObservedObject private var vm = MainMessagesViewModel()
    @State var shouldShowNewMessageScreen:Bool = false
    @State var shouldNavigatieToChatLogView:Bool = false
    @State var chatUser:ChatUser?
    var body: some View {
        NavigationView{
            VStack {
                Text("CURRENT USER ID: \(vm.chatUser?.uid ?? "")")
                self.customNavBar
                self.messagesView
                NavigationLink("", isActive: $shouldNavigatieToChatLogView) {
                    ChatLogView(chatUser: self.chatUser)
                }
            }
            .overlay(newMessageButton, alignment: .bottom)
            .navigationBarHidden(true)
        }
    }
    
    private var customNavBar: some View {
        HStack (spacing:16){
            
            if let url = vm.chatUser?.profileImageUrl {
                WebImage(url: URL(string: url))
                    .resizable()
                    .frame(width: 44, height: 44)
                    .clipped()
                    .cornerRadius(50)
                    .overlay(RoundedRectangle(cornerRadius: 44)
                                .stroke(Color(.label), lineWidth: 1)
                    )
                    .shadow(radius: 5)
            } else {
                Image(systemName: "person.fill")
                    .font(.system(size: 34, weight: .heavy))
                    .overlay(RoundedRectangle(cornerRadius: 44)
                                .stroke(Color(.label), lineWidth: 1)
                    )
                    .shadow(radius: 5)
            }
            
            
            VStack(alignment: .leading, spacing: 4){
                let email = vm.chatUser?.email.replacingOccurrences(of: "@gmail.com", with: "") ?? ""
                Text(email)
                    .font(.system(size: 24, weight: .bold))
                
                HStack{
                    Circle()
                        .foregroundColor(.green)
                        .frame(width: 14, height: 14)
                    Text("online")
                        .font(.system(size: 14))
                        .foregroundColor(Color(.lightGray))
                }
            }
            Spacer()
            
            Button{
                self.shouldPerformLogoutOptions.toggle()
            } label:{
                Image(systemName: "gear")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color(.label))
            }
            
        }
        .padding()
        .actionSheet(isPresented: $shouldPerformLogoutOptions){
            .init(title: Text("Settings"), message: Text("What do you want to do?"), buttons: [
                .destructive(Text("Sign Out"), action: {
                    print("sign out")
                    vm.signOut()
                }),
                .cancel()
            ])
        }
        .fullScreenCover(isPresented: $vm.isUserCurrentlyLoggedOut, onDismiss: nil){
            LoginView(didCompleteLoginProcess: {
                self.vm.isUserCurrentlyLoggedOut = false
                self.vm.fetchCurrentUser()
            })
        }
    }
    
    private var newMessageButton: some View {
        Button {
            shouldShowNewMessageScreen.toggle()
        } label: {
            HStack{
                Spacer()
                Text("+ New Message")
                    .font(.system(size: 16, weight: .bold))
                Spacer()
            }
            .foregroundColor(.white)
            .padding(.vertical)
            .background(Color.blue)
            .cornerRadius(32)
            .padding(.horizontal)
            .shadow(radius: 15)
            
        }
        .fullScreenCover(isPresented: $shouldShowNewMessageScreen, onDismiss: nil){
            CreateNewMessageView(didSelectNewUser: {
                user in
                self.chatUser = user
                self.shouldNavigatieToChatLogView.toggle()
                print(user.email)
            })
        }
    }
    
    var messagesView: some View {
        ScrollView{
            ForEach(vm.recentMessages){
                recentMessage in
                VStack {
                    NavigationLink{
                        Text("Destination")
                    } label: {
                        HStack(spacing:16){
                            WebImage(url: URL(string: recentMessage.profileImageUrl))
                                .resizable()
                                .scaledToFill()
                                .frame(width:64, height:64)
                                .clipped()
                                .cornerRadius(64)
                                .overlay(RoundedRectangle(cornerRadius: 64)
                                            .stroke(Color.black, lineWidth: 1))
                                .shadow(radius: 5)
//                            Image(systemName: "person.fill")
//                                    .font(.system(size: 32))
//                                    .padding(8)
//                                    .overlay(RoundedRectangle(cornerRadius: 44)
//                                                .stroke(Color(.label), lineWidth: 1))
                            
                            VStack(alignment:.leading){
                                Text(recentMessage.email)
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(Color(.label))
                                
                                Text(recentMessage.text)
                                    .font(.system(size: 14))
                                    .foregroundColor(Color(.lightGray))
                                    .multilineTextAlignment(.leading)
                            }
                            Spacer()
                            
                            Text(recentMessage.timestamp.description)
                                .font(.system(size:14, weight:.semibold))
                            
                        }
                    }
                    
                    Divider()
                        .padding(.vertical, 8)
                }.padding(.horizontal)
            }.padding(.bottom, 50)
        }
    }
}

struct MainMessagesView_Previews: PreviewProvider {
    static var previews: some View {
        MainMessagesView()
    }
}
