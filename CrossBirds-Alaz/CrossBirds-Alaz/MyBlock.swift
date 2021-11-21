//
//  MyBlock.swift
//  CrossBirds-Alaz
//
//  Created by alaz kalelioglu on 21.11.2021.
//

import SpriteKit

enum myBlockType: String{
    case wood, stone, glass
}

class MyBlock: SKSpriteNode {

    
    let type: myBlockType
    var health: Int //to see a block should be removed or not
    let damageThreshold: Int
    
    init(type: myBlockType){
        
        self.type = type
        switch type {
        case .wood:
            health = 200
        case .stone:
            health = 500
        case .glass:
            health = 50
        }
        
        damageThreshold = health / 2
        super.init(texture: nil, color:UIColor.clear , size: CGSize.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createPhysicsBody(){
        
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody?.isDynamic = true //blocks can be impacted by the bird and affected by gravity
        physicsBody?.categoryBitMask = PhysicsCategory.block
        physicsBody?.contactTestBitMask = PhysicsCategory.all //to check contants with all physic bodies
        physicsBody?.collisionBitMask = PhysicsCategory.all
        
    }
}
