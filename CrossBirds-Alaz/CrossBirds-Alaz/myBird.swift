//
//  myBird.swift
//  CrossBirds-Alaz
//
//  Created by alaz kalelioglu on 20.11.2021.
//

import SpriteKit

enum myBirdType: String{
    
    case red, blue, yellow, gray
}

class myBird: SKSpriteNode {
    
    let birdType: myBirdType
    
    init(type: myBirdType){
        birdType = type
        
        let color: UIColor!
        switch type{          //My bird colors
        case .red:
            color = UIColor.red
        case .blue:
            color = UIColor.blue
        case .yellow:
            color = UIColor.yellow
        case .gray:
            color = UIColor.gray
        }
        
        super.init(texture: nil, color: color, size: CGSize(width: 40.0, height:40.0))
        
    }
    
    required init?(coder aDecoder: NSCoder) {  //this is something XCode suggested to get rid of an error
        fatalError("init(coder:) has not been implemented")
    }
}
