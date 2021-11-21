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
    
    var bird = myBird(type: .red)  //red bird initialized as default
    let anchor = SKNode()                               //it will be an anchor point for my birds (launch)
    
    
    override func didMove(to view: SKView) {
        
        setupLevel()
        setupGestureRecognizer()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first {
            let location = touch.location(in: self)
            
            if bird.contains(location){
                
                panRecognizer.isEnabled = false
                bird.grabbed = true
                bird.position = location
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first {
            if bird.grabbed{
                let location = touch.location(in: self)
                bird.position = location
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if bird.grabbed{
            myCamera.setConstraints(with: self, and: mapNode.frame, to: bird)
            
            bird.grabbed = false
            bird.birdisFlying = true
            constraintToAnchor(active: false)
            
            let dx = anchor.position.x - bird.position.x
            let dy = anchor.position.y - bird.position.y
            
            let impulse = CGVector(dx: dx, dy: dy)
            bird.physicsBody?.applyImpulse(impulse)
            bird.isUserInteractionEnabled = false
            
        }
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
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: mapNode.frame)    //making my camera move with my bird!
        physicsBody?.categoryBitMask = PhysicsCategory.edge
        physicsBody?.contactTestBitMask = PhysicsCategory.bird | PhysicsCategory.block
        physicsBody?.collisionBitMask = PhysicsCategory.all
        
        
        anchor.position = CGPoint(x: mapNode.frame.midX/2, y: mapNode.frame.midY/2)
        addChild(anchor)                                             //to add the anchor node to my scene
        addmyBird()
        
    }
    
    func addCamera(){  //custom method to add my camera
        
        guard let view = view else {return} //checking if the view property contains a value
    
        
        addChild(myCamera)   //we added our camera as a child node
        myCamera.position = CGPoint(x: view.bounds.width/2, y:view.bounds.size.height/2)  //setting the camera position in the middle of x-axis and y-axis.
        camera = myCamera  //settin myCamera as the camera of my game
        myCamera.setConstraints(with: self, and: mapNode.frame, to: nil)//defining the scene
    }
    
    func addmyBird(){
        
        bird.physicsBody = SKPhysicsBody(rectangleOf: bird.size)
        bird.physicsBody?.categoryBitMask = PhysicsCategory.bird
        bird.physicsBody?.contactTestBitMask = PhysicsCategory.all
        bird.physicsBody?.collisionBitMask = PhysicsCategory.block | PhysicsCategory.edge
        bird.physicsBody?.isDynamic = false
        
        
        bird.position = anchor.position //since I will be launching my birds from anchor point,
        addChild(bird)
        
        constraintToAnchor(active: true) //activating
        
    }
    
    func constraintToAnchor(active: Bool){
        
        if active{
            let slingRange = SKRange(lowerLimit: 0.0, upperLimit: bird.size.width*3)
            let positionConstraint = SKConstraint.distance(slingRange, to: anchor)
            bird.constraints = [positionConstraint]
        } else{
            bird.constraints?.removeAll()
        }
    }
}


extension GameScene{
    
    @objc func pan(sender: UIPanGestureRecognizer){  //all the functionality
        guard let view = view else {return} //checking if the view property contains a value
        
        let translation = sender.translation(in: view) * myCamera.yScale
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
                let locationDelta = myLocation - locationAfterScale
                let myNewPosition = locationDelta + myCamera.position
                myCamera.position = myNewPosition
                sender.scale = 1.0 //this is where is set the scale size
                
                // To not have problems when scales are changed, I add:
                myCamera.setConstraints(with: self, and: mapNode.frame, to: nil)
            }
        }
        
    }
    
}
