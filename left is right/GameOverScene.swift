//
//  GameOverScene.swift
//  left is right
//
//  Created by Aleksandar Savic on 20.02.19.
//  Copyright © 2019 Aleksandar Savic. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene{
    
    let restartLabel = SKLabelNode(fontNamed: "TheBoldFont")
    
    override func didMove(to view: SKView) {
        
        for i in 0...1{
            let background = SKSpriteNode(imageNamed: "back")

            background.setScale(0.8)

            background.position = CGPoint(x: self.size.width/2, y: self.size.height*CGFloat(i))

            background.zPosition = 0
            
            background.name = "Background"
            self.addChild(background)

        }
        
        let gameOverLabel = SKLabelNode(fontNamed: "TheBoldFont")
        gameOverLabel.text = "Game Over"
        gameOverLabel.fontSize = 200
        gameOverLabel.fontColor = SKColor.white
        gameOverLabel.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.7)
        gameOverLabel.zPosition = 1
        self.addChild(gameOverLabel)
        
        let scoreLabel = SKLabelNode(fontNamed: "TheBoldFont")
        scoreLabel.text = "Score \(gameScore)"
        scoreLabel.fontSize = 125
        scoreLabel.fontColor = SKColor.white
        scoreLabel.position = CGPoint(x: self.size.width/2,y:self.size.height*0.55)
        scoreLabel.zPosition = 1
        self.addChild(scoreLabel)
        
        let defaults = UserDefaults()
        var highScoreNumber = defaults.integer(forKey: "highScoreSaved")
        
        if gameScore > highScoreNumber{
            highScoreNumber = gameScore
            defaults.set(highScoreNumber, forKey: "highScoreSaved")
        }
        
        let highScoreLabel = SKLabelNode(fontNamed: "TheBoldFont")
        highScoreLabel.text = "High Score: \(highScoreNumber)"
        highScoreLabel.fontSize = 125
        highScoreLabel.fontColor = SKColor.white
        highScoreLabel.zPosition = 1
        highScoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.45)
        self.addChild(highScoreLabel)
        
        
        restartLabel.text = "Restart"
        restartLabel.fontSize = 100
        restartLabel.fontColor = SKColor.white
        restartLabel.zPosition = 1
        restartLabel.position = CGPoint(x: self.size.width/2, y:self.size.height*0.3)
        self.addChild(restartLabel)
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event : UIEvent?) {
       
        for touch in touches{
            
            let pointOfTouch = touch.location(in: self)
            
            if restartLabel.contains(pointOfTouch){
                let sceneToMoveTo = GameScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0)
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
            }
        }
    }
}
