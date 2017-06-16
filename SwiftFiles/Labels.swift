//
//  Labels.swift
//  Circle Tap To Win
//
//  Created by Connor Larkin on 7/1/16.
//  Copyright © 2016 Connor Larkin. All rights reserved.
//

import Foundation
import SpriteKit

var levelLabel = SKLabelNode()
var currentScoreLabel = SKLabelNode()
var highScoreLabel = SKLabelNode()
var smallHSLabel = SKLabelNode()

func createLevelLabel() {
    levelLabel = SKLabelNode(fontNamed: "Chalkduster")
    levelLabel.position = CGPoint(x: frameRect.width/2, y: frameRect.height/5)
    levelLabel.fontColor = SKColor(red: 236.0/255.0, green: 240.0/255.0, blue: 241.0/255.0, alpha: 1.0)
    levelLabel.text = ""
    levelLabel.isHidden = true
    levelLabel.zPosition = 1
    
}

func createCurrentScoreLevel() {
    currentScoreLabel = SKLabelNode(fontNamed: "Chalkduster")
    
    currentScoreLabel.position = CGPoint(x: frameRect.width/2, y:  frameRect.height/2 - 10)
    currentScoreLabel.fontColor = SKColor(red: 236.0/255.0, green: 240.0/255.0, blue: 241.0/255.0, alpha: 1.0)
    currentScoreLabel.fontSize = 52
    currentScoreLabel.text = "Tap!"
    currentScoreLabel.zPosition = 1
    
}

func createHighscoreLabel() {
    if let hs: Int = UserDefaults.standard.object(forKey: "HighestScore") as? Int{
         highScore = hs
    }
    
    highScoreLabel = SKLabelNode(fontNamed: "Chalkduster")
    highScoreLabel.position = CGPoint(x:  frameRect.width/2, y:  frameRect.height/5)
    highScoreLabel.fontColor = SKColor(red: 236.0/255.0, green: 240.0/255.0, blue: 241.0/255.0, alpha: 1.0)
    highScoreLabel.text = "High Score: \( highScore)"
    highScoreLabel.zPosition = 1
    
    let hsFrame = highScoreLabel.frame
    let border = SKShapeNode(rect:CGRect(origin: CGPoint(x:  frameRect.width/2, y:  frameRect.height/5), size: hsFrame.size))
    border.physicsBody = SKPhysicsBody(polygonFrom: border.path!)
    border.physicsBody!.friction = 0.3
    border.physicsBody!.restitution = 0.1
    border.physicsBody!.mass = 0.6

    highScoreLabel.addChild(border)
}
func createSmallHSLabel() {
    smallHSLabel = SKLabelNode(fontNamed: "Chalkduster")
    smallHSLabel.position = CGPoint(x:  frameRect.width/2, y:  frameRect.height/5 - 30)
    smallHSLabel.fontColor = SKColor(red: 236.0/255.0, green: 240.0/255.0, blue: 241.0/255.0, alpha: 1.0)
    smallHSLabel.text = "HS: \(highScore)"
    smallHSLabel.zPosition = 1

}


extension SKLabelNode {
    func updateLabel(text: String){
        self.text = text
    }
}
    
    
    
    
