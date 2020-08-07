//
//  MainMenuScene.swift
//  left is right
//
//  Created by Aleksandar Savic on 21.02.19.
//  Copyright © 2019 Aleksandar Savic. All rights reserved.
//

import Foundation
import SpriteKit

class MainMenuScene: SKScene{
    
    override func didMove(to view: SKView) {
        
        for i in 0...1{
            let background = SKSpriteNode(imageNamed: "back")
            
            background.setScale(0.8)
            
            background.position = CGPoint(x: self.size.width/2, y: self.size.height*CGFloat(i))
            
            background.zPosition = 0
            
            background.name = "Background"
            self.addChild(background)
            // so wird etwas erstellt
        }
        
        let gameName = SKLabelNode(fontNamed: "TheBoldFont")
        gameName.text = "☜ = ☞"
        gameName.fontSize = 230
        gameName.fontColor = SKColor.white
        gameName.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.7)
        gameName.zPosition = 1
        self.addChild(gameName)
        
        let startGame = SKLabelNode(fontNamed: "TheBoldFont")
        startGame.text = "Start"
        startGame.fontSize = 130
        startGame.fontColor = SKColor.white
        startGame.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.2)
        startGame.zPosition = 1
        startGame.name = "startButton"
        self.addChild(startGame)
        }
    
    var lastUpdateTime: TimeInterval = 0
    var deltaFrameTime: TimeInterval = 0
    var amountToMovePerSecond: CGFloat = 2000.0
    
    override func update(_ currentTime:TimeInterval){
        if lastUpdateTime == 0{
            lastUpdateTime = currentTime
        }
        else{
            deltaFrameTime = currentTime - lastUpdateTime
            lastUpdateTime = currentTime
        }
        let amountToMoveBackground = amountToMovePerSecond * CGFloat(deltaFrameTime)
        self.enumerateChildNodes(withName: "Background"){
            background, stop in
            background.position.y -= amountToMoveBackground
            if background.position.y < -self.size.height{
                background.position.y += self.size.height*2
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let pointOfTouch = touch.location(in: self)
            let nodeITapped = atPoint(pointOfTouch)
            if nodeITapped.name  == "startButton"{
                let sceneToMoveTo = GameScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0)
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
            }
        }
    }
}

