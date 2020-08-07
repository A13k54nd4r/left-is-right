//
//  GameViewController.swift
//  left is right
//
//  Created by Aleksandar Savic on 15.02.19.
//  Copyright © 2019 Aleksandar Savic. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import AVFoundation
class GameViewController: UIViewController {
    
    var backgroundMusic = AVAudioPlayer()
    var backgroundMusic2 = AVAudioPlayer()
    var backgroundMusic3 = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundMusicPath = Bundle.main.path(forResource: "backgroundMusic_3", ofType: "mp3")
        let backgroundMusicNSURL = NSURL(fileURLWithPath: backgroundMusicPath!)
        do{ backgroundMusic = try AVAudioPlayer(contentsOf: backgroundMusicNSURL as URL) }
        catch { return print("Cannot Find Audio") }
        backgroundMusic.numberOfLoops = -1
        backgroundMusic.volume = 0
        backgroundMusic.play()
        
        let backgroundMusic2Path = Bundle.main.path(forResource: "backgroundMusic_3", ofType: "mp3")
        let backgroundMusic2NSURL = NSURL(fileURLWithPath: backgroundMusic2Path!)
        do{ backgroundMusic2 = try AVAudioPlayer(contentsOf: backgroundMusic2NSURL as URL) }
        catch { return print("Cannot Find Audio") }
        backgroundMusic2.numberOfLoops = -1
        backgroundMusic2.volume = 1
        backgroundMusic2.play()
        
        
        let backgroundMusic3Path = Bundle.main.path(forResource: "bike_sound", ofType: "mp3")
        let backgroundMusic3NSURL = NSURL(fileURLWithPath: backgroundMusic3Path!)
        do{ backgroundMusic3 = try AVAudioPlayer(contentsOf: backgroundMusic3NSURL as URL) }
        catch { return print("Cannot Find Audio") }
        backgroundMusic3.numberOfLoops = -1
        backgroundMusic3.volume = 100
        backgroundMusic3.play()
        
        let scene = MainMenuScene(size: CGSize(width: 1536, height: 2048))
        let skView = self.view as! SKView
        skView.showsFPS = false
        skView.showsNodeCount = false
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .aspectFill
        skView.presentScene(scene)
        
        
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
