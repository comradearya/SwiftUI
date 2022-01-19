//
//  NewMessageScreen.swift
//  Messanger
//
//  Created by arina.panchenko on 15.01.2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct CreateNewMessageView: View {
    @ObservedObject var vm = CreateNewMessageViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    let didSelectNewUser:(ChatUser) ->()
    
    var body: some View {
        NavigationView{
            ScrollView {
                Text(vm.errorMessage)
                usersList
            }.navigationTitle("New Message")
                .toolbar{
                    ToolbarItemGroup(placement: .navigationBarLeading){
                        Button{
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Text("Cancel")
                        }
                    }
                }
        }
    }
    
    private var usersList: some View {
        ForEach(vm.users){ user in
            Button {
                self.presentationMode.wrappedValue.dismiss()
                self.didSelectNewUser(user)
            } label: {
                HStack(spacing:14){
                    WebImage(url: URL(string: user.profileImageUrl))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .clipped()
                        .cornerRadius(50)
                        .overlay(RoundedRectangle(cornerRadius: 50)
                                    .stroke(Color(.label),
                                            lineWidth: 2))
                    Text(user.email)
                    Spacer()
                }.padding(.horizontal)
                Divider()
                    .padding(.vertical)
            }
        }
    }
}

struct NewMessageScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainMessagesView()
    }
}
