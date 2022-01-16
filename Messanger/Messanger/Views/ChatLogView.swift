//
//  ChatView.swift
//  Messanger
//
//  Created by arina.panchenko on 16.01.2022.
//

import SwiftUI

struct ChatLogView: View {
    let chatUser:ChatUser?
    
    
    var body: some View {
        ScrollView{
            ForEach(0..<10){ num in
                Text("FAKE MESSAGE FOR NOW")
            }
        }.navigationTitle(self.chatUser?.email ?? "")
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct ChatLogView_Previews: PreviewProvider {
    static var previews: some View {
            MainMessagesView()
        
    }
}
