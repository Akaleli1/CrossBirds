//
//  Configuration.swift
//  CrossBirds-Alaz
//
//  Created by alaz kalelioglu on 20.11.2021.
//

import CoreGraphics

extension CGPoint{
    
    static public func * (left: CGPoint, right: CGFloat) -> CGPoint{
        return CGPoint(x: left.x * right, y: left.y * right)
    }
}
