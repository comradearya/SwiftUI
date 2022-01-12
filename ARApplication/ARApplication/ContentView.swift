//
//  ContentView.swift
//  ARApplication
//
//  Created by arina.panchenko on 06.01.2022.
//

import SwiftUI
import RealityKit

struct ContentView : View {
    @EnvironmentObject var data:DataModel
    var body: some View {
        TabView {

        HStack{
            ARUIView()
            if data.enableAR{ARDisplayView()}
            else { Spacer()}
        }
        .tabItem {
            Text("FirstTab")
        }
        }
    }
}


#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
