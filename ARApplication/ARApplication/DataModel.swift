//
//  DataModel.swift
//  ARApplication
//
//  Created by arina.panchenko on 06.01.2022.
//

import RealityKit
import Combine

class DataModel:ObservableObject{
    public static var shared = DataModel()
    
    @Published var arView:ARView!
    @Published var enableAR:Bool = false
    @Published var xTranslation:Float = 0 {
        didSet{translateBox()}
    }
    @Published var yTranslation:Float = 0 {
        didSet{translateBox()}
    }
    @Published var zTranslation:Float = 0 {
        didSet{translateBox()}
    }
        
    init(){
            arView = ARView(frame: .zero)
        let anchor = AnchorEntity(plane: .horizontal)
            //Load the Box scene from the "Experience" Reality File
        
            if let model = try? Ball.loadСцена() {
            //Add the box anchor to the scene
              //  anchor.addChild(model)
                arView.scene.anchors.append(model)
            }
    }
    
    func translateBox(){
        if let steelBox = (arView.scene.anchors[0] as? Experience.Box)?.steelBox {
            ///Converting centimetres to metres
            let xTranslationM = xTranslation / 100
            let yTranslationM = yTranslation / 100
            let zTranslationM = zTranslation / 100
            
            ///Converting to a vector of 3 float values
            let translation = SIMD3<Float>(xTranslationM, yTranslationM, zTranslationM)
            
                ///Translate the box by this amount
            steelBox.transform.translation = translation
        }
    }
    
}
