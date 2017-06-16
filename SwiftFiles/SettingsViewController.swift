//
//  SettingsViewController.swift
//  Circle Tap To Win
//
//  Created by Connor Larkin on 8/29/16.
//  Copyright © 2016 Connor Larkin. All rights reserved.
//

import Foundation
import UIKit


class SettingsViewController: UIViewController{
    @IBOutlet weak var colorSwitch: UISwitch!
  //  @IBOutlet weak var emojiSwitch: UISwitch!
 //   @IBOutlet weak var flagSwitch: UISwitch!
 //   @IBOutlet weak var ballSwitch: UISwitch!
    
    @IBAction func colorSwitchActivated(sender: AnyObject) {
        if(colorSwitch.isOn){
            selectedSkins.append("emoji")
        }
        else{
            removeFromSkins(skin: "emoji")
        }
    }
    /*
    @IBAction func emojiSwitchActivated(sender: AnyObject) {
        if(emojiSwitch.on){
            selectedSkins.append("emoji")
        }
        else{
            removeFromSkins("emoji")
        }
    }

    @IBAction func flagSwitchActivated(sender: AnyObject) {
        if(flagSwitch.on){
            selectedSkins.append("flag")
        }
        else{
            removeFromSkins("flag")
        }
    }
    
    @IBAction func ballSwitchActivated(sender: AnyObject) {
        if(ballSwitch.on){
            selectedSkins.append("ball")
        }
        else{
            removeFromSkins("ball")
        }
    }
 */

    func removeFromSkins(skin: String) {
        if selectedSkins.count == 0 {
            return
        }
        for index in 0...(selectedSkins.count-1) {
            print(selectedSkins)
            if(selectedSkins[index] == skin){
                selectedSkins.remove(at: index)
            }
            print(selectedSkins)
        }
    }
    
    
}
