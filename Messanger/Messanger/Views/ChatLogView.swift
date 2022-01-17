//
//  ChatView.swift
//  Messanger
//
//  Created by arina.panchenko on 16.01.2022.
//

import SwiftUI

struct ChatLogView: View {
    let chatUser:ChatUser?
    @State var chatText = ""
    
    var body: some View {
        VStack{
            ScrollView{
                ForEach(0..<10){ num in
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
            
            HStack{
                Image(systemName: "photo.on.rectangle")
                    .font(.system(size: 24))
                    .foregroundColor(Color(.darkGray))
                TextField("Description", text: $chatText)
                Button{
                    
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

            
        }
        .navigationTitle(self.chatUser?.email ?? "")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ChatLogView_Previews: PreviewProvider {
    static var previews: some View {
        ChatLogView(chatUser: ChatUser(data:(["uid":"6787g8fghctrdcrt6", "email":"arp1@gmail.com", "profileImageUrl": ""])))
        
    }
}
