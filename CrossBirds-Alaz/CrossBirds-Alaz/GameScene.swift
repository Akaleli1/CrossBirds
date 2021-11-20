//
//  GameScene.swift
//  CrossBirds-Alaz
//
//  Created by alaz kalelioglu on 18.11.2021.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var mapNode = SKTileMapNode()
    
    let myCamera = MyCamera()
    var panRecognizer = UIPanGestureRecognizer()
    var pinchRecognizer = UIPinchGestureRecognizer()
    var maxScale: CGFloat = 0
    
    override func didMove(to view: SKView) {
        
        setupLevel()
        setupGestureRecognizer()
        
    }
        
    func setupGestureRecognizer(){
        guard let view = view else {return} //checking if the view property contains a value
        panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(pan)) //specified target and action for panRecognizer
        view.addGestureRecognizer(panRecognizer)
        
        pinchRecognizer = UIPinchGestureRecognizer(target:self, action:#selector(pinch)) //set the parameters
        view.addGestureRecognizer(pinchRecognizer) //adding it to our view
    }
    
    func setupLevel(){  //for my levels
        if let mapNode = childNode(withName: "Tile Map Node") as? SKTileMapNode {
            self.mapNode = mapNode
            
            maxScale = mapNode.mapSize.height / frame.size.height
        }
        
        addCamera()
    }
    
    func addCamera(){  //custom method to add my camera
        
        guard let view = view else {return} //checking if the view property contains a value
    
        
        addChild(myCamera)   //we added our camera as a child node
        myCamera.position = CGPoint(x: view.bounds.width/2, y:view.bounds.size.height/2)  //setting the camera position in the middle of x-axis and y-axis.
        camera = myCamera  //settin myCamera as the camera of my game
        myCamera.setConstraints(with: self, and: mapNode.frame, to: nil)//defining the scene
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
    
    @objc func pinch(sender: UIPinchGestureRecognizer){
        
        guard let view = view else{return}
        
        if sender.numberOfTouches == 2 {  //for users to able to zoom through pinch they need 2 touches
            let locationInView = sender.location(in: view)
            let myLocation = convertPoint(fromView: locationInView)
            if sender.state == .changed{
                let changedScale = 1/sender.scale
                let myScale = myCamera.yScale * changedScale
                    
                if myScale < maxScale && myScale > 0.5{
                    myCamera.setScale(myScale)
                }
                
                
                
                let locationAfterScale = convertPoint(fromView: locationInView)
                let locationDelta = CGPoint(x: myLocation.x - locationAfterScale.x, y:myLocation.y - locationAfterScale.y)
                let myNewPosition = CGPoint(x: myCamera.position.x + locationDelta.x, y:myCamera.position.y + locationDelta.y)
                myCamera.position = myNewPosition
                sender.scale = 1.0 //this is where is set the scale size
                
                // To not have problems when scales are changed, I add:
                myCamera.setConstraints(with: self, and: mapNode.frame, to: nil)
            }
        }
        
    }
    
}
