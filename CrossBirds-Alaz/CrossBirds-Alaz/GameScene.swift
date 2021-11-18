//
//  GameScene.swift
//  CrossBirds-Alaz
//
//  Created by alaz kalelioglu on 18.11.2021.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    let myCamera = SKCameraNode() //created my camera here
    var panRecognizer = UIPanGestureRecognizer()
    
    override func didMove(to view: SKView) {
        
        addCamera()  //I am calling my method
        setupGestureRecognizer()
        
    }
        
    func setupGestureRecognizer(){
        guard let view = view else {return} //checking if the view property contains a value
        panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(pan)) //specified target and action for panRecognizer
        view.addGestureRecognizer(panRecognizer)
    }
    
    
    
    func addCamera(){  //custom method to add my camera
        
        guard let view = view else {return} //checking if the view property contains a value
    
        
        addChild(myCamera)   //we added our camera as a child node
        myCamera.position = CGPoint(x: view.bounds.width/2, y:view.bounds.size.height/2)  //setting the camera position in the middle of x-axis and y-axis.
        camera = myCamera
    }
}


extension GameScene{
    
    @objc func pan(sender: UIPanGestureRecognizer){  //all the functionality
        guard let view = view else {return} //checking if the view property contains a value
        
        let translation = sender.translation (in: view)
        myCamera.position = CGPoint(x: myCamera.position.x - translation.x, y: myCamera.position.y + translation.y)
        //this is how scrolling or dragging is simulated
        sender.setTranslation(CGPoint.zero, in: view)
    
    }
    
}
