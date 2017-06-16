//
//  GameScene.swift
//  Pop a Lock
//
//  Created by Connor Larkin on 6/22/16.
//  Copyright (c) 2016 Connor Larkin. All rights reserved.
//

import SpriteKit
import AudioToolbox
//import ParticlesLoadingView


var highScore = 0
var frameRect = CGRect()
var clockwise = true
var totalTaps = 0
var background = SKColor(red: 26.0/255.0, green: 188.0/255.0, blue: 156.0/255.0, alpha: 1.0)
let isIphone6s = (UIDevice.current.modelName.contains("iPhone 6s"))
var lowMEM = false
var tapLocation: CGPoint = CGPoint()
var ballTypes = "ball"
var pathType = "square"
var fillHerUP = false
//var circleTouch = [UITouch?]()
var circleTouch: UITouch?
var isFingerOnNode = false
var touchedNode: SKShapeNode?

var throwVelocity: CGVector?


/* to implement later
var loadingView: ParticlesLoadingView = {
    let view = ParticlesLoadingView(frame: CGRect(x: 0,y: 0,
                                                  width: UIScreen.mainScreen().bounds.size.width,
                                                  height: UIScreen.mainScreen().bounds.size.height))
    view.particleEffect = .Fire
    view.duration = 6.0
    view.particlesSize = 5.0
    view.clockwiseRotation = clockwise
    view.layer.cornerRadius = 20.0
    return view
}()
*/
 
class GameScene: BaseScene{
    var started = false
    var attemptAtScore = false
    var haveTouched = false
    var invalidateRun = false
    var isFallDownActive = false
    
    var lastTimeTouched = 0.0
    var numberOfBoxPairs = 0

    
    var gameDelegate: GameDelegate?
    
    var run = SKAction()
    
    var droppedLabels = [SKShapeNode()]
    var path = UIBezierPath()
    
    var level = 1
    var totalDots = 0
    var needleSpeed: CGFloat = 200
    var lastTap = 0.0
    var selectedNode = SKSpriteNode()
    
    var isHighScoreRun = false

    var emoji = SKShapeNode()
    let emitter = SKEmitterNode(fileNamed: "particle.sks")
    let spartEmit = SKEmitterNode(fileNamed: "fire.sks")
    let shapes = Shapes()
    
    override func didMove(to view: SKView){
        /* Setup your scene here */
        super.didMove(to: view)
        
        frameRect = self.frame
        selectedSkins.append("emoji")
        highScore = UserDefaults.standard.integer(forKey: "HighestScore")
        totalTaps = UserDefaults.standard.integer(forKey: "totalTaps")
        view.ignoresSiblingOrder = true
        layoutGame()
        let physicsBody = SKPhysicsBody (edgeLoopFrom: self.frame)
        self.physicsBody = physicsBody
        print( UIDevice.current.modelName)
        
     //   let timer = NSTimer(timeInterval: 0.0001, target: self, selector: #selector(updateGravity(_:)), userInfo: nil, repeats: true)
       // NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        //always fill the view
        blurEffectView.frame = (self.view?.bounds)!
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.view?.addSubview(blurEffectView)
    
    }
    deinit {print ("GameScene deinited")}

    func layoutGame() {
        smallHSLabel.removeFromParent()
        backgroundColor = SKColor(red: 26.0/255.0, green: 188.0/255.0, blue: 156.0/255.0, alpha: 1.0)
        
    
        invalidateRun = false
        numberOfBoxPairs = 0
    
        self.view?.isUserInteractionEnabled = false

        started = false
        clockwise = true
        level = 1
        totalDots = 0
        needleSpeed = 200
        
        shapes.initRunningPath(path: nil, texture: nil)
        self.addChild(runningPath)
        
        
        shapes.initNeedle(shape: nil, position: nil, color: nil, texure: nil, zRotation: nil)
        self.addChild(needle)

        createLevelLabel()
        self.addChild(levelLabel)
        
        createHighscoreLabel()
        self.addChild(highScoreLabel)
        
        createCurrentScoreLevel()
        self.addChild(currentScoreLabel)
        
        
        shapes.initDot(skin: nil, path: nil, position: nil, shape: nil)
        self.addChild(dot)
        
        self.view?.isUserInteractionEnabled =  true
        //fillScreen()
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        let touching = needle.intersects(dot)
    
        if fillHerUP {
            fillScreen()
        }
        
        if started && touching {
            haveTouched = true
        }
        
        if (haveTouched && !touching && started) {
            haveTouched = false
            gameOver()
        }

        updateGravity()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
         totalTaps += 1
        
       /* Called when a touch begins */
        //let currentTime = CACurrentMediaTime()
        if  lowMEM {
            removeStuff()
            lowMEM = false
        }
        
        let touch = touches.first
        let touchLocation = touch!.location(in: self)
        
        let maxForce = touch?.maximumPossibleForce
        let force = touch?.force

        
        if let body = physicsWorld.body(at: touchLocation) {
            if body.node!.name == "droppedBall" {
                touchedNode = body.node as? SKShapeNode
                isFingerOnNode = true
                if isIphone6s && force! / maxForce! > 0.75{
                    addTwentyBalls(atPoint: (body.node?.position)!)
                }
            }
        }
        
        self.view?.isUserInteractionEnabled =  false

        if !started && !isFingerOnNode{
            
            if isHighScoreRun {
                isHighScoreRun = false
                emitter?.removeFromParent()
                spartEmit?.removeFromParent()
               // loadingView.stopAnimating()
            }
            clockwise = true
            needle.runCircular(speed: needleSpeed,clockwise: clockwise)

            currentScoreLabel.updateLabel(text: "")
            highScoreLabel.isHidden = true
            levelLabel.isHidden = false
            levelLabel.updateLabel(text: "Level: \(self.level)")
            createSmallHSLabel()
            self.addChild(smallHSLabel)
            

            gameDelegate?.gameStart()
            started = true
        }
        else if (haveTouched && !invalidateRun) {
            haveTouched = false
            
            if  clockwise {
                clockwise = false
                needle.runCircular(speed: needleSpeed, clockwise: clockwise)
                             }
            else {
                clockwise = true
                needle.runCircular(speed: needleSpeed, clockwise: clockwise)
            }
            
            pointGain()
        }
        else {
            invalidateRun = true
        }
       
        if isHighScoreRun {
            highScoreLabel.fontColor = dot.strokeColor
            highScore = totalDots
            highScoreLabel.updateLabel(text: "High Score: \( highScore)")
        }
        
        self.view?.isUserInteractionEnabled = true
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isFingerOnNode {

            touchedNode!.physicsBody!.affectedByGravity = false
            let touch = touches.first
            let touchLocation = touch!.location(in: self)
            let previousLocation = touch!.previousLocation(in: self)
            

            var nodeX = touchedNode!.position.x + (touchLocation.x - previousLocation.x)
            var nodeY = touchedNode!.position.y + (touchLocation.y - previousLocation.y)
            
            throwVelocity = CGVector(dx: (touchLocation.x - previousLocation.x) * 50 , dy: (touchLocation.y - previousLocation.y)*50)

            nodeX = max(nodeX, touchedNode!.frame.width/2)
            nodeX = min(nodeX, size.width - touchedNode!.frame.width/2)
            
            nodeY = max(nodeY, touchedNode!.frame.height/2)
            nodeY = min(nodeY, size.height - touchedNode!.frame.height/2)

            touchedNode!.position = CGPoint(x: nodeX, y: nodeY)
        }
    }
    
    // Clean up the touch event when the finger anchoring the circle is raised from the screen.
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if touchedNode != nil && throwVelocity != nil{
            touchedNode!.physicsBody!.affectedByGravity = true
            touchedNode!.physicsBody!.velocity = throwVelocity!
            
            touchedNode = nil
        }
        
        isFingerOnNode = false
    }
    
    func pointGain(){
       self.view?.isUserInteractionEnabled = false
         _ = vibrate(option: "Peek")
     
        totalDots += 1
        currentScoreLabel.updateLabel(text: "\(totalDots)")
    
        if  highScore < totalDots && !isHighScoreRun{
            isHighScoreRun = true
            startHighscore()
        }
        
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
       
        dropShape(obj: dot)
        
        shapes.initDot(skin: nil, path: nil, position: nil, shape: nil)
        if level > 2 {
            if CGFloat.random(min: 0, max: 1) > 0.5 {
                if  clockwise {
                    dot.runCircular(speed: needleSpeed/2 - 40, clockwise: true)
                }
                else {
                    dot.runCircular(speed: CGFloat.random(min: 10, max: CGFloat(10 + level)), clockwise: true)
                }
            }
            else {
                if  clockwise {
                    dot.runCircular(speed: CGFloat.random(min: 10, max: CGFloat(10 + level)), clockwise: false)
                }
                else {
                    dot.runCircular(speed: needleSpeed/2 - 40, clockwise: false)
                }
            }
        }
        
        self.addChild(dot)
        
        if (totalDots % 6) == 5 {
            levelUp()
        }
       
        self.view?.isUserInteractionEnabled =  true
    }
    
    func gameOver(){
        invalidateRun = false

        self.view?.isUserInteractionEnabled =  false
        _ = vibrate(option: "Nope")
        started = false
       
        UserDefaults.standard.set( totalTaps, forKey:"totalTaps")
        UserDefaults.standard.set( highScore, forKey:"HighestScore")
        //NSUserDefaults.standardUserDefaults().setInteger(0, forKey:"HighestScore")
        print( totalTaps)

        if isHighScoreRun {
            if emitter != nil {
                emitter!.position = CGPoint(x: self.frame.width/2, y: 0)
                emitter!.zPosition = 0
                
                emitter!.particleColorSequence = nil
                emitter!.particleColorBlendFactor = 1.0
                emitter!.emissionAngle = CGFloat(M_PI)
                emitter!.particleBirthRate = 100
                emitter!.constraints = highScoreLabel.constraints
                
                emitter?.name = "excempt"
                self.addChild(emitter!)
                
                let action = SKAction.run({
                    let color = randomColor()
                    self.emitter!.particleColor = color})
               
                let wait = SKAction.wait(forDuration: 0.5)
                self.run((SKAction.repeatForever( SKAction.sequence([action,wait]))))
            }
        }
        UserDefaults.standard.synchronize()
        
        let actionRed = SKAction.colorize(with: UIColor.red, colorBlendFactor: 1.0, duration:0.4)
        let actionBack = SKAction.colorize(with: SKColor(red: 26.0/255.0, green: 188.0/255.0, blue: 156.0/255.0, alpha: 1.0), colorBlendFactor: 1.0, duration: 0.3)
        
        dropShape(obj: needle)
        dropShape(obj: dot)
        
        spartEmit?.removeFromParent()
        levelLabel.removeFromParent()
        currentScoreLabel.removeFromParent()
        highScoreLabel.removeFromParent()
        smallHSLabel.removeFromParent()
        runningPath.removeFromParent()
        
        if droppedLabels.count > 2 {
            let lvl = droppedLabels.last!.copy() as! SKShapeNode
            droppedLabels.last!.removeFromParent()
            self.addChild(lvl)
        }
        for obj in droppedLabels {
            obj.removeFromParent()
        }
        
        droppedLabels.removeAll()
    
        self.scene?.run(SKAction.sequence([actionRed,actionBack]), completion: {
           // self.dot.removeFromParent()

            print("layout")
           // self.layoutGame()
        })
        
        self.view?.isUserInteractionEnabled = true
        self.gameDelegate?.gameEnded()
       // if droppedStuff.count > 7 {startFallDown()}
        removeIfNessecary()
    
        goToScene(newScene: SceneType.MenuScene,withDuration: 0.2)
    }

    func levelUp(){
        self.view?.isUserInteractionEnabled = false
        _ = vibrate(option: "Pop")
        _ = vibrate(option: "Pop")
         background = randomColor()
        
        let actionGreen = SKAction.colorize(with: UIColor.green, colorBlendFactor: 1.0, duration: 0.28)
        let actionBack = SKAction.colorize( with: background, colorBlendFactor: 1.0, duration: 0.28)
        
        self.level += 1
        if level != 1 {
            droppedLabels.last?.removeFromParent()
        }
        dropLabel(label: levelLabel)
        levelLabel.updateLabel(text: "Level: \(self.level)")
        self.scene?.run(SKAction.sequence([actionGreen,actionBack]), completion: {
            self.needleSpeed += 20
            print("Level \(self.level) = Speed: \(self.needleSpeed)")
            
        })
        
        levelLabel.fontColor =  background.inverse()
        changeFireColor()
        self.view?.isUserInteractionEnabled = false
    }
    func startHighscore(){
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        /*let timer = Timer(timeInterval: 0.6,
                          target: self,
                          selector: Selector(("highScoreVibrate")),
                          userInfo: nil,
                          repeats: true);
        RunLoop.main.add(timer, forMode: RunLoopMode.commonModes)
        */
        if let fire = spartEmit {
            fire.zPosition = -10
            currentScoreLabel.fontColor = UIColor.red
            fire.constraints = currentScoreLabel.constraints
            currentScoreLabel.addChild(fire)
        }
    }
    func dropLabel(label: SKLabelNode){
        let node = SKShapeNode(rect: label.frame, cornerRadius: 200)
        node.zPosition = 0.0
        node.strokeColor = UIColor.clear
        
        node.physicsBody = SKPhysicsBody(polygonFrom: node.path!)
        node.physicsBody!.friction = 0.3
        node.physicsBody!.restitution = 0.1
        node.physicsBody!.mass = 0.6
        
        let l = label.copy() as! SKNode
        node.addChild(l)
        droppedLabels.append(node)
        self.addChild(droppedLabels.last!)
        node.physicsBody!.velocity = CGVector.init(dx: CGFloat.random(min: -1000, max: 1000),
                                                      dy: CGFloat.random(min: -1000, max: 0))
        node.name = "droppedLabel"

        node.physicsBody!.allowsRotation = true
    }
    
    func removeStuff(){
        for thing in self.children{
            if thing.name == "droppedBall" {
                thing.removeFromParent()
            }
        }
        print("removed")
        
    }
    func countDropped() -> Int{
        var count = 0
        for thing in self.children{
            if thing.name == "droppedBall" {
                count+=1
            }
        }
        print(count)
        return count
    }
    
    func removeIfNessecary(){
        var count = 0
        let removeNumber = ((UIDevice.current.modelName.contains("iPhone")) ? 50 : 100)
        if  countDropped() > removeNumber{
            for thing in self.children{
                if thing.name == "droppedBall" && count < removeNumber{
                    thing.removeFromParent()
                    count+=1
                }
            }
        }
    }
    
    func updateGravity() {
        if let data = motionManager.accelerometerData?.acceleration {
            physicsWorld.gravity = CGVector(dx: data.x * 10,
                                            dy: data.y * 10)
        }
    }
    
    func highScoreVibrate(timer: Timer){
        vibrate(option: "Peek")
        
        if !isIphone6s {
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
        if !started {
            timer.invalidate()
        }
    }
    
    func vibrate(option: String) -> Bool {
        if !isIphone6s {
            return false
        }
        switch option {
        case "Peek":
            AudioServicesPlaySystemSound(1519)
        case "Pop":
            AudioServicesPlaySystemSound(1520)
        case "Nope":
            AudioServicesPlaySystemSound(1521)
        default:
            return false
        }
        return true
    }
    
    func degToRad(degree: Double) -> CGFloat {
        return CGFloat(Double(degree) / 180.0 * M_PI)
    }

    func changeFireColor() {
        spartEmit!.emissionAngleRange = CGFloat.random(min: 0, max: 10)
        spartEmit!.particleRotation = 40.0
        if (level > 1){
            let action = SKAction.run({
                let color = randomColor()
                self.spartEmit!.particleColor = color})
            
            let wait = SKAction.wait(forDuration: 0.5)
            self.run((SKAction.repeatForever( SKAction.sequence([action,wait]))))
        }
        else{
            let color = self.backgroundColor
            spartEmit!.particleColor = color.inverse()
        }
    }
    func fillScreen() {
        let action = SKAction.run({
            let randX = CGFloat.random(min: 0, max: self.frame.width)
            let randY = CGFloat.random(min: 0, max: self.frame.height)
            let pos = CGPoint.init(x: randX, y: randY)
            self.dropShape(obj: self.shapes.returnDot(position: pos))
        })
        
        let numberOfBalls = Int.init((self.frame.height * self.frame.width) / 400)
        print((self.frame.height * self.frame.width) / 225)
        let wait = SKAction.wait(forDuration: 0.04)
        self.run(SKAction.repeat(SKAction.sequence([action,wait]), count: numberOfBalls))
        fillHerUP = false
    }
    
    func addTwentyBalls(atPoint: CGPoint){
        let action = SKAction.run({
            self.dropShape(obj: self.shapes.returnDot(position: atPoint))
        })
        let wait = SKAction.wait(forDuration: 0.0001)
        self.run(SKAction.repeat(SKAction.sequence([action,wait]), count: 20))
    }
}
