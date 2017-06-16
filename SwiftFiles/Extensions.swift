//
//  Extensions.swift
//  Pop a Lock
//
//  Created by Connor Larkin on 6/22/16.
//  Copyright © 2016 Connor Larkin. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit 

protocol GameDelegate {
    func gameEnded()
    func gameStart()
}

let GOLDEN_RATIO_CONJUGATE:Float = 0.618033988749895

func getRadian(node: SKShapeNode) -> CGFloat {
    let dx = node.position.x -  frameRect.width/2
    let dy = node.position.y -  frameRect.height/2
    
    return atan2(dy, dx)
}

extension CGFloat {
    static func random(min: CGFloat, max: CGFloat) -> CGFloat {
        
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
            * (max - min) + min
    }
}

public func createColor(golden:Bool = true, baseColor:UIColor?) -> UIColor {
    var h: CGFloat = 0, s: CGFloat=0, b: CGFloat=0, a: CGFloat=0
    if let color = baseColor {
        color.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return createColor(golden:false, hue: Float(h), saturation: Float(s), brightness: Float(b), alpha: Float(a))
    } else {
        return createColor(golden: golden)
    }
}

public func createColor(golden:Bool = true, hue:Float? = nil, saturation:Float = 0.5, brightness:Float = 0.8, alpha:Float = 1.0) -> UIColor {
    let seed_hue = hue != nil ? hue! : randomFloat()
    let h:Float = golden ? fmodf(seed_hue + GOLDEN_RATIO_CONJUGATE, 1.0) : seed_hue
    return UIColor(hue: CGFloat(h), saturation: CGFloat(saturation), brightness: CGFloat(brightness), alpha: CGFloat(alpha))
}

public func createColorScheme(golden:Bool = true, count:Int) -> [UIColor] {
    var colors = [UIColor]()
    var color: UIColor?
    repeat {
        color = createColor(golden: golden, baseColor:color)
        colors.append(color!)
    } while colors.count < count
    return colors
}

func randomFloat() -> Float {
    return Float(arc4random_uniform(100)) / 100.0;
}

func getColorScheme(count: Int) -> [UIColor] {
    return createColorScheme(golden: true, count: count)
}
func randomColor() -> UIColor {
    return createColor()
}

extension UIColor {
    func inverse () -> UIColor {
        var r:CGFloat = 0.0; var g:CGFloat = 0.0; var b:CGFloat = 0.0; var a:CGFloat = 0.0;
        if self.getRed(&r, green: &g, blue: &b, alpha: &a) {
            return UIColor(red: 1.0-r, green: 1.0 - g, blue: 1.0 - b, alpha: a)
        }
        return self
    }
}

extension SKSpriteNode
{
    func copyWithPhysicsBody()->SKSpriteNode
    {
        let node = self.copy() as! SKSpriteNode;
        node.physicsBody = self.physicsBody;
        return node;
    }
}
extension String {
    func charAt(i: Int) -> String {
        guard i >= 0 && i < characters.count else { return "" }
        return String(self[index(startIndex, offsetBy: i)])
    }
}
public extension UIDevice {
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,3", "iPad6,4", "iPad6,7", "iPad6,8":return "iPad Pro"
        case "AppleTV5,3":                              return "Apple TV"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
    
}

extension SKShapeNode {
    func runCircular(speed: CGFloat, clockwise: Bool) {
        let radian = getRadian(node: self)
        let path = getCirclePath(startAngle: radian, node: self)

        let run = SKAction.follow(path.cgPath, asOffset: false, orientToPath: true, speed: speed)
    
        if clockwise {
            self.run(SKAction.repeatForever(run.reversed()))
        }
        else {
            self.run(SKAction.repeatForever(run))
        }
    }
}
func randomInt(min: Int, max:Int) -> Int {
    return min + Int(arc4random_uniform(UInt32(max - min + 1)))
}

func getCirclePath(startAngle: CGFloat, node: SKShapeNode) -> UIBezierPath {
    return UIBezierPath(arcCenter: CGPoint(x: frameRect.width/2, y: frameRect.height/2),
                        radius: 120,
                        startAngle: startAngle,
                        endAngle: startAngle + CGFloat(M_PI*2),
                        clockwise: true)
}

extension SKNode {
    
    class func unarchiveFromFile(file : String, size: CGSize) -> SKNode? {
        if let path = Bundle.main.path(forResource: file, ofType: "sks") {
            let sceneData = try! NSData(contentsOfFile: path, options: .mappedIfSafe)
            let archiver = NSKeyedUnarchiver(forReadingWith: sceneData as Data)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObject(forKey: NSKeyedArchiveRootObjectKey) as! MenuScene
            archiver.finishDecoding()
            scene.size = size
            return scene
        } else {
            return nil
        }
    }
    
}
let allEmojis = "😀😬😁😂😃😄😅😆😇😉😊🙂🙃☺️😋😌😍😘😗😙😚😜😝😛🤑🤓😎🤗😏😶😐😑😒🙄🤔😳😞😟😠😡😔😕🙁☹️😣😖😫😩😤😮😱😨😰😯😦😧😢😥😪😓😭😵😲🤐😷🤒🤕😴💤💩💩💩💩💩💩💩😈👿👹👺💀👻👽🤖😺😸😹😻😼😽🙀😿😾🙌👏👋👍👎👊✊✌☝👆👇👈👉🖕🖐🤘🖖✍💅👄👅👂👃👁👀👤👥🗣👶👦👧👨👩👱👴👵👲👳👮🎅👼👸👰🚶🏃💃👯👫👬👭🙇💁🙅🙆🙋🙎🙍💇💆💑👚👕👖👔👗👙👘💄💋👣👠👡👢👞👟👒🎩🎓👑⛑🎒👝👛👜💼👓💍🌂🐶🐱🐭🐹🐰🐻🐼🐨🐯🦁🐮🐷🐽🐸🐙🐵🙈🙉🙊🐒🐔🐧🐦🐤🐣🐥🐺🐗🐴🦄🐝🐛🐌🐞🦂🦀🐍🐢🐠🐟🐡🐬🐳🐋🐊🐆🐅🐋🐊🐆🐅🐂🐪🐫🐘🐐🐏🐑🐎🐖🐀🐁🐓🕊🐀🐕🐩🐈🐇🐿🐾🐉🐲🌵🎄🌲🌳🌴🌱🌿☘🍀🎍🎋🍃🍂🍁🌾🌺🌻🌹🌷🌼🌸💐🍄🌰🎃🐚🌎🌍🌏🌚🌗🌝🌛🌜🌞🌙⭐️🌟💫✨☄☀️🌤⛅️🌥🌦☁️🌧⛈🌩⚡️🔥🔥🔥🔥💥💥💥❄️🌨⛄️☃🌬💨☂☔️💧💦🌊🍏🍎🍐🍊🍋🍌🍉🍇🍓🍈🍒🍑🍍🍅🍆🌶🌽🍠🍯🍞🧀🍗🍖🍤🍳🍔🍟🌭🍕🍝🍣🍱🍛🍙🍚🍘🍢🍡🍧🍨🍦🍰🍮🎂🍬🍭🍫🍿🍩🍪🍪🍺🍻🍷🍸🍹🍾🍶🍵☕️🍼🍴🍽⚽️🏀🏈⚾️🎾🏌⛳️🏐🏉🏓🏸🏒🏑🏏🎿⛷🏂⛸🏹🎣🚣🏊🏄🛀⛹🏋🚴🚵🏇🏆🎽🏅🎖🎗🏵🎫🎟🎭🎨🎪🎷🎺🎸🎻🎬👾🎯🎲🎰🚗🚕🚙🚌🚎🏎🚓🚑🚒🚐🚚🚛🚜🏍🚲🚨🚔🚍🚘🚖🚡🚠🚟🚃🚋🚝🚄🚅🚈🚞🚂🚆🚇🚊🚉🚁🛩✈️🛫🛬⛵️🛥🚤⛴🛳🚀🛰💺⚓️⚓️🚧⛽️🚏🚦🚥🏁🚢🎡🎢🎠🏗🎑⛲️🏭🗼⛰🏔🗻🌋🗾🏕⛺️🏞🛣🛤🌅🌄🏜🏖🏝🌇🌆🏙🌃🌉🌈🎆🎇🌠🌌🏠🏡🏚🏢🏬🗽🏨🏦🏥🏤🏣🏪🏫🏩💒🏛⛩🕍🕌⛪️📱📲⌨🖨🖱🖲🕹🗜💽💾💿📀📹📸📷🎞☎️📟🎚🎙📻📺📠⏱⏲⏰🕰🔋📡⌛️⏳💡🔦🕯🗑🛢💷💶💴💸💵💰💳💎⚖🔧🔩⛏🛠🔨⚒⚙⛓🔪☠🚬🛡⚔🗡⚰⚱🏺🔮📿🔬🔭⚗💈💊💉🌡🏷🔖🏷🌡💉💊🚽🚿🛁🔑🛎🚪🛏🛌🖼🗺⛱🗿🗿🛍🎁🎀🎏🎈🎊🏮🎌🎐🎎🎉✉️📩📨📧💌📭📬📯📦📮📜📉📈📊📑📃📄📅📆🗓📇🗒📋🗄🗳🗃📁📂🗂🗞📰📙📘📕📗📓📔📒📚📖🔗✂️🖇📎📌📍🚩🏳🖊🖍🔏✏️📝🔎📝✒️✒️🔍🖋🖌❤️💛💚💙💜💓💞💝💘💕❣💖💗💔☢🆘🆑🚫❌‼️⁉️📵♨️🔆🔅〽️🚸⚠️⚜🔱🔰♻️🌐🌀🌀💠🆒🎵🔴🔵🔷🔶🔊🔔🔉♥️♦️💭🗯💬💬📢"



