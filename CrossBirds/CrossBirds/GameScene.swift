//
//  GameScene.swift
//  CrossBirds
//
//  Created by alaz kalelioglu on 7.11.2021.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    let myCamera = SKCameraNode()

    override func didMove(to view: SKView) {
        
        addmyCamera()
        
        
    }
    
    func addmyCamera(){
        
        addChild(myCamera) //to initilaze myCamera, added as a childnode.
    }
    
}
        
        
