//
//  MenuScene.swift
//  Emoji Tap
//
//  Created by Connor Larkin on 12/8/16.
//  Copyright © 2016 Connor Larkin. All rights reserved.
//

import Foundation
import UIKit
import SceneKit
import SpriteKit

class MenuScene: BaseScene{
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        //backgroundColor = randomColor()
        self.backgroundColor = UIColor.red
        let physicsBody = SKPhysicsBody (edgeLoopFrom: self.frame)
        self.physicsBody = physicsBody
        addStuff()
    }
    deinit {
        print ("MenuScene deinited") //If this method isn't called, you might have problems with strong reference cycles.
    }
    override func update(_ currentTime: TimeInterval) {
        if let data = motionManager.accelerometerData?.acceleration {
            physicsWorld.gravity = CGVector(dx: data.x * 10,
                                            dy: data.y * 10)
        }
    }
    
    private func addStuff() {        
        for node in GlobalData.clutterNodes {
            let obj = node
            if obj.name == "droppedBall"{
                obj.name = "droppedBall"
                obj.zPosition = 0.0
                
                obj.position = CGPoint(x: 0, y: 0)
                    
                obj.physicsBody = SKPhysicsBody(polygonFrom: obj.path!)
                obj.physicsBody!.friction = 0.3
                obj.physicsBody!.restitution = 0.1
                obj.physicsBody!.mass = 0.6
                    
                self.addChild(obj)
                print(obj)

                obj.physicsBody!.velocity = CGVector.init(dx: CGFloat.random(min: -1000, max: 1000),
                                                          dy: CGFloat.random(min: -1000, max: 1000))
                obj.physicsBody!.allowsRotation = true
            }
        }
        
    }
    
    private func startGame() {
        let skView = self.view! 
        let transition = SKTransition.push(with: .up, duration: 0.5)
        
        let nextScene = GameScene(size: (view?.bounds.size)!)
        nextScene.scaleMode = .aspectFill
        
        skView.presentScene(nextScene, transition: transition)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        startGame()
        if let location = touch?.location(in: self){
            
            //Give a priority to a button - if button is tapped go to GameScene
            let node = atPoint(location)
            if node.name == "goToGameScene"{
                GlobalData.previousScene = SceneType.MenuScene
            //    goToScene(newScene: SceneType.GameScene)
            }else{
                //Otherwise, do a transition to the previous scene
                
                //Get the previous scene
                if let previousScene = GlobalData.previousScene {
                    
                    GlobalData.previousScene = SceneType.MenuScene
              //      goToScene(newScene: previousScene)
                    
                } 
            }
        } 
    }
}
    
    
    
    

