//
//  MessageView.swift
//  Messanger
//
//  Created by arina.panchenko on 19.01.2022.
//

import SwiftUI

struct MessageView: View {
    let message:ChatMessage
    
    var body: some View {
        VStack{
            if message.fromId == FirebaseManager.shared.auth.currentUser?.uid {
                HStack{
                    Spacer()
                    HStack{
                        Text(message.text)
                            .foregroundColor(.white)
                    }.padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }
            } else {
                HStack{
                    HStack{
                        Text(message.text)
                            .foregroundColor(.black)
                    }.padding()
                        .background(Color.white)
                        .cornerRadius(8)
                    Spacer()
                }
            }
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }
}

//struct MessageView_Previews: PreviewProvider {
//    static var previews: some View {
//       //
//    }
//}
