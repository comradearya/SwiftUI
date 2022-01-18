//
//  ChatView.swift
//  Messanger
//
//  Created by arina.panchenko on 16.01.2022.
//

import SwiftUI

struct ChatLogView: View {
    let chatUser:ChatUser?
//    @State var chatText = ""
    @ObservedObject var vm:ChatLogViewModel
    
    init(chatUser: ChatUser?){
        self.chatUser = chatUser
        self.vm = ChatLogViewModel(chatUser: self.chatUser)
    }
    
    var body: some View {
        ZStack{
           messagesView
            VStack{
                Spacer()
                chatBottomBar
                    .background(.white)
            }
            Text(vm.errorMessage)
        }
        .navigationTitle(self.chatUser?.email ?? "")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var messagesView: some View {
        ScrollView{
            ForEach(0..<20){ num in
                HStack{
                    Spacer()
                    HStack{
                        Text("FAKE MESSAGE FOR NOW")
                            .foregroundColor(.white)
                    }.padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .padding(.horizontal)
                .padding(.top, 8)
            }
            HStack{ Spacer() }
        }
        .background(Color(.init(white: 0.95, alpha:1)))
        .padding(.top, 8)
    }
    
    
    private var chatBottomBar: some View {
        HStack{
            Image(systemName: "photo.on.rectangle")
                .font(.system(size: 24))
                .foregroundColor(Color(.darkGray))
            ZStack{
               // DescriptionPlaceholder()
                TextField("Description", text: $vm.chatText)
                    .opacity(vm.chatText.isEmpty ? 0.5 : 1)
            }
            Button{
                vm.handleSend()
            } label: {
                Text("Send")
                    .foregroundColor(.white)
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(.blue)
            .cornerRadius(9)
            
        }
        .padding(.horizontal)
        .padding(.vertical, 8)

    }
}

struct ChatLogView_Previews: PreviewProvider {
    static var previews: some View {
//        ChatLogView(chatUser: ChatUser(data:(["uid":"6787g8fghctrdcrt6", "email":"arp1@gmail.com", "profileImageUrl": ""])))
        MainMessagesView()
        
    }
}
