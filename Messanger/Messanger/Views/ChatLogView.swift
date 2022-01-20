//
//  ChatView.swift
//  Messanger
//
//  Created by arina.panchenko on 16.01.2022.
//

import SwiftUI

struct ChatLogView: View {
    let chatUser:ChatUser?
    @ObservedObject var vm:ChatLogViewModel
    
    init(chatUser: ChatUser?){
        self.chatUser = chatUser
        self.vm = ChatLogViewModel(chatUser: self.chatUser)
    }
    
    var body: some View {
        ZStack{
            VStack{
                self.messagesView
                Spacer()
                self.chatBottomBar
                    .background(.white)
            }
            Text(vm.errorMessage)
        }
        .navigationTitle(self.chatUser?.email ?? "")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    static let emptyScrollToString = "Empty"
    private var messagesView: some View {
        ScrollView {
            ScrollViewReader{ scrollViewProxy in
                VStack{
                    ForEach(vm.chatMessages){ message in
                        MessageView(message: message)
                    }
                    HStack{ Spacer() }
                    .id(Self.emptyScrollToString)
                }
                .onReceive(vm.$count){
                    _ in
                    withAnimation(.easeOut(duration: 0.5)){
                    scrollViewProxy.scrollTo(Self.emptyScrollToString, anchor: .bottom)
                    }
                }
            }
            
        }
        .padding(.top, 8)
        .background(Color(.init(white:0.97, alpha:1)))
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
