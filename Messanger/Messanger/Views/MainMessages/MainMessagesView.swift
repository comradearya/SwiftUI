//
//  MainMessagesView.swift
//  Messanger
//
//  Created by arina.panchenko on 13.01.2022.
//

import SwiftUI

struct MainMessagesView: View {
    @State var shouldPerformLogoutOptions:Bool = false
    
    private var customNavBar: some View {
        HStack (spacing:16){
            
            Image(systemName: "person.fill")
                .font(.system(size: 34, weight: .heavy))
            
            VStack(alignment: .leading, spacing: 4){
                Text("Username")
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
                }),
                .cancel()
            ])
        }
    }
    
    private var newMessageButton: some View {
        Button {
            
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
    }
    
    var messagesView: some View {
        ScrollView{
            ForEach(0..<10, id:\.self){
                num in
                VStack {
                    HStack(spacing:16){
                        
                        Image(systemName: "person.fill")
                            .font(.system(size: 32))
                            .padding(8)
                            .overlay(RoundedRectangle(cornerRadius: 44)
                                        .stroke(Color(.label), lineWidth: 1))
                        
                        VStack(alignment:.leading){
                            Text("Username")
                                .font(.system(size: 16, weight: .bold))
                            
                            Text("Message sent to user")
                                .font(.system(size: 14))
                                .foregroundColor(Color(.lightGray))
                        }
                        Spacer()
                        
                        Text("22d")
                            .font(.system(size:14, weight:.semibold))
                        
                    }
                    Divider()
                        .padding(.vertical, 8)
                }.padding(.horizontal)
            }.padding(.bottom, 50)
        }
    }
    
    var body: some View {
        NavigationView{
            VStack {
                self.customNavBar
                self.messagesView
            }
            .overlay(newMessageButton, alignment: .bottom)
            .navigationBarHidden(true)
        }
    }
}

struct MainMessagesView_Previews: PreviewProvider {
    static var previews: some View {
        MainMessagesView()
    }
}
