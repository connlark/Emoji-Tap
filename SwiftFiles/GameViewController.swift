//
//  GameViewController.swift
//  Pop a Lock
//
//  Created by Connor Larkin on 6/22/16.
//  Copyright (c) 2016 Connor Larkin. All rights reserved.
//

import UIKit
import SpriteKit
import GoogleMobileAds
import CoreMotion


class GameViewController: UIViewController, GameDelegate {

    internal func gameEnded() -> (){
        print("Game End\n")
        
    }
    internal func gameStart() -> () {
        print("Start")
    }

    @IBOutlet weak var SettingsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Configure the view.
        let skView = self.view as! SKView/////////////
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.showsDrawCount = true

        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
            
        /* Set the scale mode to scale to fit the window */
       // scene.scaleMode = .aspectFill
       // scene.gameDelegate = self
       
        motionManager = CMMotionManager()
        motionManager.startAccelerometerUpdates()
            
       
        let sceneView = view as! SKView
        // sceneView.showsFPS = true
        // sceneView.showsNodeCount = true
        sceneView.ignoresSiblingOrder = true
        
        
        
        if let scene = MenuScene.unarchiveFromFile(file: "MenuScene", size: view.bounds.size) as? MenuScene {
            // Configure the view.
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .aspectFill
            print(view.bounds.size)
            scene.size = view.bounds.size
            
            skView.presentScene(scene)
        }
    }
    override var shouldAutorotate: Bool {
        return false
    }
    private var _orientations = UIInterfaceOrientationMask.portrait
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        get { return self._orientations }
        set { self._orientations = newValue }
    }
    private func createAndLoadInterstitial() {
    }
    
}
