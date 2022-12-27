//
//  SnakeBodyBlock.swift
//  Retro Snake
//
//  Created by Alok Sagar on 27/12/22.
//

import Foundation
import SwiftUI


struct SnakeBodyBlock:Hashable{
    func hash(into hasher: inout Hasher) {
        hasher.combine(position.x/position.y)
        hasher.combine(color)
    }
    var color:Color
    var index:Int
    var position:CGPoint

    static func getInitialArray(headPoint:CGPoint) -> [SnakeBodyBlock] {
        var ball  =  SnakeBodyBlock.init(color: .red, index: 0, position: headPoint)
        return[ball]
        
    }
    
}
