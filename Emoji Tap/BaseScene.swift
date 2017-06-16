//
//  BaseScene.swift
//  Emoji Tap
//
//  Created by Connor Larkin on 12/11/16.
//  Copyright © 2016 Connor Larkin. All rights reserved.
//

import Foundation
import SpriteKit

enum SceneType: Int {
    
    case WelcomeScene   = 0
    case MenuScene      //1
    case GameScene      //2
}

struct GlobalData
{
    static var previousScene:SceneType?
    static var clutterNodes = [SKShapeNode()]
    //Other global data...
}

class BaseScene:SKScene,SKPhysicsContactDelegate{
    
    let button = SKSpriteNode(color: SKColor.black, size: CGSize(width: 50, height: 50))
    
    override func didMove(to view: SKView) {
        backgroundColor = UIColor.black
        print("HERE")

    }
    
    private func setupButton(){
        
        if (button.parent  == nil){
            
            //Just setup button properties like position, zPosition and name
            
            button.name = "goToGameScene"
            button.zPosition = 1
            button.position = CGPoint(x: frame.midX, y: 100)
            addChild(button)
        }
    }
    
    func goToScene(newScene: SceneType, withDuration: Double){
        print("workin")
        var sceneToLoad:SKScene?
        
        switch newScene {
            
        case SceneType.GameScene:
            
            sceneToLoad = GameScene()
            
        case SceneType.MenuScene:
            
            sceneToLoad = MenuScene.unarchiveFromFile(file: "MenuScene", size: (view?.bounds.size)!) as? MenuScene
            
        case SceneType.WelcomeScene:
            
            sceneToLoad = WelcomeScene()
            
        }
        if let scene = sceneToLoad {
            scene.size = self.size
           // scene.scaleMode = .fill
            let transition = SKTransition.fade(withDuration: TimeInterval(withDuration))
            self.view?.presentScene(scene, transition: transition)
        }
    }
    func dropShape(obj :SKShapeNode){
        obj.removeAllActions()
        obj.removeFromParent()
        
        let dropped = obj
    
        
        dropped.name = "droppedBall"
        dropped.zPosition = 0.0
        
        dropped.physicsBody = SKPhysicsBody(polygonFrom: obj.path!)
        dropped.physicsBody!.friction = 0.3
        dropped.physicsBody!.restitution = 0.1
        dropped.physicsBody!.mass = 0.6

        self.addChild(dropped)
        
        dropped.physicsBody!.velocity = CGVector.init(dx: CGFloat.random(min: -1000, max: 1000),
                                                      dy: CGFloat.random(min: -1000, max: 1000))
        dropped.physicsBody!.allowsRotation = true
        GlobalData.clutterNodes.append(dropped.copy() as! SKShapeNode)
    }
}
