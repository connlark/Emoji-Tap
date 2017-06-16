//
//  WelcomeScene.swift
//  Emoji Tap
//
//  Created by Connor Larkin on 12/11/16.
//  Copyright © 2016 Connor Larkin. All rights reserved.
//

import Foundation
import SpriteKit


class WelcomeScene:BaseScene {
    
    
    override func didMove(to view: SKView) {
        
        super.didMove(to: view)
        print("welcome scn")
        self.backgroundColor = randomColor()
    }
    
    deinit {print ("WelcomeScene deinited")}
    
override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        
        if let location = touch?.location(in: self){
            
            //Give a priority to a button - if button is tapped go to GameScene
            let node = atPoint(location)
            if node.name == "goToGameScene"{
                GlobalData.previousScene = SceneType.MenuScene
              //  goToScene(newScene: SceneType.GameScene)
            }else{
                //Otherwise, do a transition to the previous scene
                
                //Get the previous scene
                if let previousScene = GlobalData.previousScene {
                    
                    GlobalData.previousScene = SceneType.WelcomeScene
                   // goToScene(newScene: previousScene)
                    
                }else{
                    
                    // There is no previousScene set yet? Go to MenuScene then...
                    GlobalData.previousScene = SceneType.WelcomeScene
                   // goToScene(newScene: SceneType.MenuScene)
                    
                }
            }       
        }      
    }
}
