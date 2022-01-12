//
//  ARUIView.swift
//  ARApplication
//
//  Created by arina.panchenko on 10.01.2022.
//

import SwiftUI

struct ARUIView: View {
    @EnvironmentObject var data:DataModel
    @State var listIsHidden:Bool = false
    var body: some View {
        let detectDirectionalDrags = DragGesture(minimumDistance: 20, coordinateSpace: .local).onEnded{
            value in
            if value.translation.width > 0 {
                listIsHidden = false
            }
            if value.translation.width < 0 {
                listIsHidden = true
            }
        }
        
        List{
            Toggle(isOn: $data.enableAR){
                Text("AR")
            }
            Stepper("X: \(Int(data.xTranslation))", value: $data.xTranslation, in: -100...100)
            Stepper("Y: \(Int(data.yTranslation))", value: $data.yTranslation, in: -100...100)
            Stepper("Z: \(Int(data.zTranslation))", value: $data.zTranslation, in: -100...100)
        }
        .frame(width: listIsHidden ? CGFloat(50) : CGFloat(200))
        .gesture(detectDirectionalDrags)
    }
}

struct ARUIView_Previews: PreviewProvider {
    static var previews: some View {
        ARUIView()
    }
}
