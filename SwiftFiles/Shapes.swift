//
//  Shapes.swift
//  Circle Tap To Win
//
//  Created by Connor Larkin on 7/1/16.
//  Copyright © 2016 Connor Larkin. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit

var lockLayer = CAShapeLayer()

var previousBoxHeight = CGFloat.init()

var selectedSkins = [String]()
var runningPath = SKShapeNode()
var needle = SKShapeNode()
var dot = SKShapeNode()

class Shapes {
   
    func initRunningPath(path: UIBezierPath?, texture: SKTexture?) {
       // let path = getCirclePath(0.0, node: lock)
        //let shapePath = (path != nil) ? path!.CGPath : getCirclePath(20.0, node: runningPath).CGPath
        let shapePath = (path != nil) ? path!.cgPath : getCirclePath(startAngle: 20.0, node: runningPath).cgPath
        
        runningPath = SKShapeNode(path: shapePath, centered: true)
        
        //   lock.strokeColor = SKColor.grayColor()
        runningPath.lineWidth = 40.0
        runningPath.zPosition = -1.0
        runningPath.position = CGPoint(x: UIScreen.main.bounds.size.width / 2,y: UIScreen.main.bounds.size.height / 2)
        let name = "pathTexture\(Int.init(CGFloat.random(min: 1, max: 6))).png"
        let randoRunningTexture = SKTexture(imageNamed: name)

        runningPath.strokeTexture = (texture != nil) ? texture! : randoRunningTexture
        print(name)
       
    }
    func initNeedle(shape: SKShapeNode?, position: CGPoint?, color: UIColor?, texure: SKTexture?, zRotation: CGFloat?){
        needle = (shape != nil) ? shape! : SKShapeNode(rectOf: CGSize(width: 33.0,
                                                                         height: 3.5),
                                                                         cornerRadius: 3.5)
        
        needle.position = (position != nil) ? position! : CGPoint(x:  frameRect.width/2,
                                                                  y:  frameRect.height/2 + 120)
        
        needle.zRotation = (zRotation != nil) ? zRotation! : CGFloat(M_PI / 2.0)
        needle.zPosition = 10.0
    
        needle.fillColor = (color != nil) ? color! : UIColor.white
        needle.fillTexture = (texure != nil) ? texure! : needle.strokeTexture
    }


    func initDot(skin: String?, path: UIBezierPath?, position: CGPoint?, shape: SKShapeNode?){
        
        dot = (shape != nil) ? shape! : SKShapeNode(circleOfRadius: 15.0)

        dot.fillColor = SKColor.clear
        dot.strokeColor = SKColor.clear
        
        //default circular path if not initialized differently
        let radian = getRadian(node: needle)
        let startAngle = (!clockwise) ? CGFloat.random(min: radian + 1.0, max: radian + 2.5) : CGFloat.random(min: radian - 1.0, max: radian - 2.5)
        let path = (path != nil) ? path : getCirclePath(startAngle: startAngle, node: dot)
        
        dot.position = (position != nil) ? position! : path!.currentPoint
        
        if skin != nil {
            setUpSkin(skin: skin!)
        }
        else {
            setUpSkin(skin: "color")
        }
        
        dot.zPosition = 9.0
       
    }
   
 func setUpSkin(skin: String) {

        switch skin {
        case "emoji":
            let label = SKLabelNode()
            
            label.text = allEmojis.charAt(i: randomInt(min: 0,
                                                    max: allEmojis.characters.count))
            label.horizontalAlignmentMode = .center;
            label.verticalAlignmentMode = .center
            
            dot.addChild(label)
        case "color":
            dot.fillColor = randomColor()
        case "flag":
            let number = "flag\(Int.init(CGFloat.random(min: 1, max: 254))).png"
            
            dot.fillColor = SKColor.white
            dot.fillTexture = SKTexture(imageNamed: number)
        case "ball":
            dot.fillColor = SKColor.white

            let sports = "Sports\(Int.init(CGFloat.random(min: 1, max: 16))).png"
            
            dot.fillTexture = SKTexture(imageNamed: sports)
        default:
            dot.fillColor = randomColor()
        }
    }
    func returnDot(position: CGPoint) -> SKShapeNode {
        
        let dott = SKShapeNode(circleOfRadius: 15.0)
        
        dott.fillColor = SKColor.clear
        dott.strokeColor = SKColor.clear
        
        dott.position = position
        
        let skin = (selectedSkins.count > 0) ? selectedSkins[Int.init(CGFloat.random(min: 0, max: CGFloat.init(selectedSkins.count)))] : "color"
        
        switch skin {
        case "emoji":
            let label = SKLabelNode()
            
            label.text = allEmojis.charAt(i: randomInt(min: 0,
                                                       max: allEmojis.characters.count))
            label.horizontalAlignmentMode = .center;
            label.verticalAlignmentMode = .center
            
            dott.addChild(label)
        case "color":
            dott.fillColor = randomColor()
        case "flag":
            let number = "flag\(Int.init(CGFloat.random(min: 1, max: 254))).png"
            
            dott.fillColor = SKColor.white
            dott.fillTexture = SKTexture(imageNamed: number)
        case "ball":
            dott.fillColor = SKColor.white
            
            let sports = "Sports\(Int.init(CGFloat.random(min: 1, max: 16))).png"
            
            dott.fillTexture = SKTexture(imageNamed: sports)
        default:
            dott.fillColor = randomColor()
        }
        
        return dott
    }
}





