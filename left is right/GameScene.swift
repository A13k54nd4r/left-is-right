//
//  GameScene.swift
//  left is right
//
//  Created by Aleksandar Savic on 15.02.19.
//  Copyright © 2019 Aleksandar Savic. All rights reserved.
//


import UIKit
import SpriteKit
import GameplayKit
var gameScore = 1

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var scoreLabel = SKLabelNode(fontNamed: "TheBoldFont")
    let tapToStartLabel = SKLabelNode(fontNamed: "TheBoldFont")
    
    enum gameState{
        case preGame
        case inGame
        case afterGame
    }
    
    var currentGameState = gameState.preGame
  
    struct PhysicsCategories{
        static let None : UInt32 = 0
        static let Player : UInt32 = 0b1 //1
        static let xyz : UInt32 = 0b10//2
        static let Enemy : UInt32 = 0b100 //4
    }
    
    let player = SKSpriteNode(imageNamed: "radler")
    let explosionSound = SKAction.playSoundFileNamed("explosion_sound.mp3", waitForCompletion: false)

    @objc func swipedRight(sender: UISwipeGestureRecognizer){
        if (currentGameState == gameState.inGame && (player.position.x >= 768.0 && player.position.x <= 1119.0)) {

            player.run(SKAction.moveBy(x: -350, y: 0, duration: 0.1))
        }
       // print("x: \(player.position.x)")
    }
    
    @objc func swipedLeft(sender: UISwipeGestureRecognizer){
         if (currentGameState == gameState.inGame && (player.position.x >= 418.0 && player.position.x <= 769.0)){

            player.run(SKAction.moveBy(x: +350, y: 0, duration: 0.1))
        }
        //print("x: \(player.position.x)")
    }
    
    let gameArea: CGRect
    
    override init(size: CGSize) {
        let maxAspectRation: CGFloat = 16.0/9.0
        let playableWidth = size.height / maxAspectRation
        let margin = (size.width - playableWidth) / 2

        gameArea = CGRect(x: margin, y: 0, width: playableWidth, height: size.height)
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")

    }
    
    override func didMove(to view: SKView) {
        
        gameScore = 0
        self.physicsWorld.contactDelegate = self
        
        let swipeRight:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipedRight(sender:)))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
        
        let swipeLeft:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipedLeft(sender:)))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
        
        for i in 0...1{
        let background = SKSpriteNode(imageNamed: "back")

        background.setScale(0.8)

        background.position = CGPoint(x: self.size.width/2, y: self.size.height*CGFloat(i))

        background.zPosition = 0

        background.name = "Background"
        self.addChild(background)

        }

        player.setScale(0.5)
        player.position = CGPoint(x: self.size.width/2, y: 0 - player.size.height)
        player.zPosition = 2
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody!.affectedByGravity = false
        player.physicsBody!.categoryBitMask = PhysicsCategories.Player
        player.physicsBody!.contactTestBitMask = PhysicsCategories.Enemy
        self.addChild(player)
        
        scoreLabel.text = "Score: 0"
        scoreLabel.fontSize = 70
        scoreLabel.fontColor = SKColor.white
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        scoreLabel.position = CGPoint(x: self.size.width*0.15, y: self.size.height + scoreLabel.frame.size.height)
        scoreLabel.zPosition = 100
        self.addChild(scoreLabel)
        
        /* lvl werden später implementiert
        levelLabel.text = "Level: 0"
        levelLabel.fontSize = 70
        levelLabel.fontColor = SKColor.white
        levelLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        levelLabel.position = CGPoint(x: self.size.width*0.65, y: self.size.height + levelLabel.frame.size.height)
        levelLabel.zPosition = 100
        self.addChild(levelLabel)
        */
        let moveToScreenAction = SKAction.moveTo(y: self.size.height*0.9, duration: 1)
        scoreLabel.run(moveToScreenAction)
        
        tapToStartLabel.text = "Tap To Start"
        tapToStartLabel.fontColor = SKColor.white
        tapToStartLabel.fontSize = 100
        tapToStartLabel.zPosition = 1
        tapToStartLabel.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        tapToStartLabel.alpha = 0
        self.addChild(tapToStartLabel)
        
        let fadeInAction = SKAction.fadeIn(withDuration: 2)
        tapToStartLabel.run(fadeInAction)
        
        
        //startNewLevel()
    }
    

    func addScore(){
        gameScore += 1
        scoreLabel.text = "Score: \(gameScore)"
        //levelLabel.text = "Level: \(levelNumber)"
        /* if gameScore == 20 || gameScore == 30 || gameScore == 40 || gameScore == 50 || gameScore == 60 || gameScore == 70{
         startNewLevel()
         }*/
        
    }
    
    func spawnEnemy_left(){
        
        let enemy:  SKSpriteNode
        let randomColour = Int.random(in: 1 ... 2)
        switch Int(randomColour) {
        case 1:
            enemy = SKSpriteNode(imageNamed: "enemy")
        case 2:
            enemy = SKSpriteNode(imageNamed: "enemy_2")
        default:
            enemy = SKSpriteNode(imageNamed: "enemy")
        }
        
        let startPoint = CGPoint(x: 418, y: self.size.height * 1.2)
        let endPoint = CGPoint(x: 418, y: -self.size.height * 0.2)
        
        enemy.name = "Enemey"
        enemy.setScale(0.6)
        enemy.position = startPoint
        enemy.zPosition = 2
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        enemy.physicsBody!.affectedByGravity = false
        enemy.physicsBody!.categoryBitMask = PhysicsCategories.Enemy
        enemy.physicsBody!.collisionBitMask = PhysicsCategories.None
        self.addChild(enemy)
        
        var enemySpeed: Double!
        
        switch gameScore{
        case 0 ..< 20:
            enemySpeed = 2.5
        case 20 ..< 30:
            enemySpeed = 2.4
        case 30 ..< 40:
            enemySpeed = 2.3
        case 40 ..< 50:
            enemySpeed = 2.2
        case 50 ..< 60:
            enemySpeed = 2.1
        case 60 ..< 70:
            enemySpeed = 2.0
        case 70 ..< 80:
            enemySpeed = 1.9
        case 80 ..< 90:
            enemySpeed = 1.8
        case 90 ..< 100:
            enemySpeed = 1.7
        case 100 ..< 110:
            enemySpeed = 1.6
        case 110 ..< 120:
            enemySpeed = 1.5
        case 120 ..< 130:
            enemySpeed = 1.4
        case 130 ..< 140:
            enemySpeed = 1.3
        case 140 ..< 150:
            enemySpeed = 1.2
        case 150 ..< 160:
            enemySpeed = 1.1
        case 150 ..< 999:
            enemySpeed = 1.0
        default:
            enemySpeed = 0.5
        }
        
        let moveEnemy = SKAction.move(to: endPoint, duration: enemySpeed)
        let deleteEnemy = SKAction.removeFromParent()
        
        let enemySequence = SKAction.sequence([moveEnemy, deleteEnemy])
        if currentGameState == gameState.inGame{
            enemy.run(enemySequence)
            addScore()
        }
    }
    
    func spawnEnemy_center(){
        
        let enemy:  SKSpriteNode
        let randomColour = Int.random(in: 1 ... 2)
        switch Int(randomColour) {
        case 1:
            enemy = SKSpriteNode(imageNamed: "enemy")
        case 2:
            enemy = SKSpriteNode(imageNamed: "enemy_2")
        default:
            enemy = SKSpriteNode(imageNamed: "enemy")
        }
        
        let startPoint = CGPoint(x: 768, y: self.size.height * 1.2)
        let endPoint = CGPoint(x: 768, y: -self.size.height * 0.2)
        
        enemy.name = "Enemey"
        enemy.setScale(0.6)
        enemy.position = startPoint
        enemy.zPosition = 2
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        enemy.physicsBody!.affectedByGravity = false
        enemy.physicsBody!.categoryBitMask = PhysicsCategories.Enemy
        enemy.physicsBody!.collisionBitMask = PhysicsCategories.None
        
        self.addChild(enemy)
        
        var enemySpeed: Double!
        
        switch gameScore{
        case 0 ..< 20:
            enemySpeed = 2.5
        case 20 ..< 30:
            enemySpeed = 2.4
        case 30 ..< 40:
            enemySpeed = 2.3
        case 40 ..< 50:
            enemySpeed = 2.2
        case 50 ..< 60:
            enemySpeed = 2.1
        case 60 ..< 70:
            enemySpeed = 2.0
        case 70 ..< 80:
            enemySpeed = 1.9
        case 80 ..< 90:
            enemySpeed = 1.8
        case 90 ..< 100:
            enemySpeed = 1.7
        case 100 ..< 110:
            enemySpeed = 1.6
        case 110 ..< 120:
            enemySpeed = 1.5
        case 120 ..< 130:
            enemySpeed = 1.4
        case 130 ..< 140:
            enemySpeed = 1.3
        case 140 ..< 150:
            enemySpeed = 1.2
        case 150 ..< 160:
            enemySpeed = 1.1
        case 150 ..< 999:
            enemySpeed = 1.0
        default:
            enemySpeed = 0.5
        }
        
        let moveEnemy = SKAction.move(to: endPoint, duration: enemySpeed)
        let deleteEnemy = SKAction.removeFromParent()
        
        let enemySequence = SKAction.sequence([moveEnemy, deleteEnemy])
        if currentGameState == gameState.inGame{
            enemy.run(enemySequence)
            addScore()
        }
    }
    
    func spawnEnemy_right(){
        
        let enemy:  SKSpriteNode
        let randomColour = Int.random(in: 1 ... 2)
        switch Int(randomColour) {
        case 1:
            enemy = SKSpriteNode(imageNamed: "enemy")
        case 2:
            enemy = SKSpriteNode(imageNamed: "enemy_2")
        default:
            enemy = SKSpriteNode(imageNamed: "enemy")
        }
        
        let startPoint = CGPoint(x: 1118, y: self.size.height * 1.2)
        let endPoint = CGPoint(x: 1118, y: -self.size.height * 0.2)
        
        enemy.name = "Enemey"
        enemy.setScale(0.6)
        enemy.position = startPoint
        enemy.zPosition = 2
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        enemy.physicsBody!.affectedByGravity = false
        enemy.physicsBody!.categoryBitMask = PhysicsCategories.Enemy
        enemy.physicsBody!.collisionBitMask = PhysicsCategories.None
        
        self.addChild(enemy)
        
        var enemySpeed: Double!
        
        switch gameScore{
        case 0 ..< 20:
            enemySpeed = 2.5
        case 20 ..< 30:
            enemySpeed = 2.4
        case 30 ..< 40:
            enemySpeed = 2.3
        case 40 ..< 50:
            enemySpeed = 2.2
        case 50 ..< 60:
            enemySpeed = 2.1
        case 60 ..< 70:
            enemySpeed = 2.0
        case 70 ..< 80:
            enemySpeed = 1.9
        case 80 ..< 90:
            enemySpeed = 1.8
        case 90 ..< 100:
            enemySpeed = 1.7
        case 100 ..< 110:
            enemySpeed = 1.6
        case 110 ..< 120:
            enemySpeed = 1.5
        case 120 ..< 130:
            enemySpeed = 1.4
        case 130 ..< 140:
            enemySpeed = 1.3
        case 140 ..< 150:
            enemySpeed = 1.2
        case 150 ..< 160:
            enemySpeed = 1.1
        case 150 ..< 999:
            enemySpeed = 1.0
        default:
            enemySpeed = 0.5
        }
        
        let moveEnemy = SKAction.move(to: endPoint, duration: enemySpeed)
        let deleteEnemy = SKAction.removeFromParent()
        
        let enemySequence = SKAction.sequence([moveEnemy, deleteEnemy])
        if currentGameState == gameState.inGame{
            enemy.run(enemySequence)
            addScore()
        }
    }
    
    func randomEnemyCombination(){
        let left = SKAction.run(spawnEnemy_left)
        let right = SKAction.run(spawnEnemy_right)
        let center = SKAction.run(spawnEnemy_center)
        var sequence: SKAction
        
        var time: Double
        let random = Int.random(in: 1 ... 2)
        switch Int(random) {
        case 1:
            time = 0.10
        case 2:
            time = 0.13
        case 3:
            time = 0.15
        default:
            time = 0.0
        }
        let spawnDelay = SKAction.wait(forDuration: time)
        
        
        let randomSequence = Int.random(in: 1 ... 9)
        switch Int(randomSequence) {
        case 1:
            sequence = SKAction.sequence([left])
            break
        case 2:
            sequence = SKAction.sequence([right])
            break
        case 3:
            sequence = SKAction.sequence([center])
            break
        case 4:
            sequence = SKAction.sequence([left, spawnDelay, center])
            break
        case 5:
            sequence = SKAction.sequence([left, spawnDelay, right])
            break
        case 6:
            sequence = SKAction.sequence([center, spawnDelay, right])
            break
        case 7:
            sequence = SKAction.sequence([center, spawnDelay, left])
            break
        case 8:
            sequence = SKAction.sequence([right, spawnDelay, left])
            break
        case 9:
            sequence = SKAction.sequence([right, spawnDelay, center])
            break
        default:
            sequence = SKAction.sequence([left, center, right])
        }
        self.run(sequence)
        
        
    }
    /* //all enemies with random distribution
    func spawnEnemy(){
        
        var randomPath: CGFloat = 0
        
        let randomNum = Int.random(in: 1 ... 3)
        switch Int(randomNum) {
        case 1:
            randomPath = 418
            break
        case 2:
            randomPath = 768
            break
        case 3:
            randomPath = 1118
        default:
            randomPath = 418
        }
        
        let startPoint = CGPoint(x: randomPath, y: self.size.height * 1.2)
        let endPoint = CGPoint(x: randomPath, y: -self.size.height * 0.2)
        
        
        let enemy = SKSpriteNode(imageNamed: "enemy")
        enemy.name = "Enemey"
        enemy.setScale(0.6)
        enemy.position = startPoint
        enemy.zPosition = 2
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        enemy.physicsBody!.affectedByGravity = false
        enemy.physicsBody!.categoryBitMask = PhysicsCategories.Enemy
        enemy.physicsBody!.collisionBitMask = PhysicsCategories.None
        
        self.addChild(enemy)
        
        var enemySpeed: Double!
        
        switch gameScore{
        case 0 ..< 10:
            enemySpeed = 2.5
        case 10 ..< 20:
            enemySpeed = 2.0
        case 20 ..< 30:
            enemySpeed = 1.5
        case 30 ..< 999:
            enemySpeed = 1.0
        default:
            enemySpeed = 3
        }
        
        let moveEnemy = SKAction.move(to: endPoint, duration: enemySpeed)
        let deleteEnemy = SKAction.removeFromParent()

        let enemySequence = SKAction.sequence([moveEnemy, deleteEnemy])
        if currentGameState == gameState.inGame{
            enemy.run(enemySequence)
            addScore()
        }
    }
    */
    func go(){
        
        var respawnTime: Double!
        
        switch gameScore{
        case 0 ..< 10:
            respawnTime = 1.0
        case 10 ..< 20:
            respawnTime = 3.0
        case 20 ..< 30:
            respawnTime = 1.0
        case 30 ..< 999:
            respawnTime = 0.5
        default:
            respawnTime = 3
        }
        
        let waitToSpawn = SKAction.wait(forDuration: respawnTime)
        let spawn = SKAction.run(randomEnemyCombination)
        
        let spawnSequence = SKAction.sequence([waitToSpawn, spawn])
        let repeatForever = SKAction.repeatForever(spawnSequence)
        self.run(repeatForever)
    }

    func spawnExplosion(spawnPosition: CGPoint){
        let explosion = SKSpriteNode(imageNamed: "explosion")
        explosion.position = spawnPosition
        explosion.zPosition = 3
        self.addChild(explosion)
        let scaleIn = SKAction.scale(to: 1, duration: 0.1)
        let fadeOut = SKAction.fadeOut(withDuration: 0.1)
        let delete = SKAction.removeFromParent()
        
        let explosionSequence = SKAction.sequence([explosionSound, scaleIn, fadeOut, delete])
        
        explosion.run(explosionSequence)
    }
    /*
    func startNewLevel(){
        levelNumber += 1
        
        if self.action(forKey: "spawningEnemies") != nil{
            self.removeAction(forKey: "spawningEnemies")
        }
        
        var levelDuration = TimeInterval()
        
        switch levelNumber{
        case 1: levelDuration = 0.5
        case 2: levelDuration = 0.4
        case 3: levelDuration = 0.3
        case 4: levelDuration = 0.3
        case 5: levelDuration = 0.3
        case 6: levelDuration = 0.3
        default:
            levelDuration = 0.5
            print("Cannot find level info")
        }
        
        let spawn = SKAction.run(spawnEnemy)
        let waitToSpawn = SKAction.wait(forDuration: levelDuration)
        let spawnSequence = SKAction.sequence([waitToSpawn, spawn])
        let spawnForever = SKAction.repeatForever(spawnSequence)
        self.run(spawnForever, withKey: "spawningEnemies")
    }
    */

    func startGame(){
        currentGameState = gameState.inGame
        
        let fadeOutAction = SKAction.fadeOut(withDuration: 0)
        let deleteAction = SKAction.removeFromParent()
        let deleteSequence = SKAction.sequence([fadeOutAction, deleteAction])
        tapToStartLabel.run(deleteSequence)
        
        let movePlayerToScreenAction = SKAction.moveTo(y: self.size.height*0.2, duration: 0.5)
        let startGameAction = SKAction.run(go)
        let startGameSequence = SKAction.sequence([movePlayerToScreenAction, startGameAction])
        player.run(startGameSequence)
    }
    
    func runGameOver(){
        currentGameState = gameState.afterGame
        
        self.removeAllActions()
        self.enumerateChildNodes(withName: "Enemy"){
            enemy, stop in
            enemy.removeAllActions()
        }
        
        let changeSceneAction = SKAction.run(changeScene)
        let waitToChangeScene = SKAction.wait(forDuration: 1)
        let changeSceneSequence = SKAction.sequence([waitToChangeScene, changeSceneAction])
        self.run(changeSceneSequence
        )
        
    }
    
    func changeScene(){
        let sceneToMoveTo = GameOverScene(size: self.size)
        sceneToMoveTo.scaleMode = self.scaleMode
        let myTransition = SKTransition.fade(withDuration: 0)
        self.view!.presentScene(sceneToMoveTo, transition: myTransition)
        
    }
    var lastUpdateTime: TimeInterval = 0
    var deltaFrameTime: TimeInterval = 0
    var amountToMovePerSecond: CGFloat = 3500.0
    
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
    
    func didBegin(_ contact: SKPhysicsContact) {
        var body1 = SKPhysicsBody()
        var body2 = SKPhysicsBody()
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask{
            body1 = contact.bodyA
            body2 = contact.bodyB
        }
        else{
            body1 = contact.bodyB
            body2 = contact.bodyA
        }
        
        if body1.categoryBitMask == PhysicsCategories.Player && body2.categoryBitMask == PhysicsCategories.Enemy{
            if body1.node != nil  {
                spawnExplosion(spawnPosition: body1.node!.position)
            }
            if body2.node != nil{
                spawnExplosion(spawnPosition: body2.node!.position)
            }
            
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
            
            runGameOver()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if currentGameState == gameState.preGame{
            startGame()
        }
    }
}

