//
//  GameScene.swift
//  VoidVanguard
//
//  Created by Tomi Neuendorf on 13.09.24.
//
import SpriteKit
import GameKit
import SwiftUI

class GameScene: SKScene, SKPhysicsContactDelegate {
    // Use an external game state
    var gameState: GameState? // Reference to GameState
    
    let background1 = SKSpriteNode(imageNamed: "background5")
    let background2 = SKSpriteNode(imageNamed: "background5")
    
    var player = SKSpriteNode()
    var fireTimer = Timer()
    var enemyTimer = Timer()
    var score = 0
    var scoreLabel = SKLabelNode()
    var playerLive = [SKSpriteNode]()
    var bossOne = SKSpriteNode()
    var bossOneFire = SKSpriteNode()
    var bossOneFireTimer = Timer()
    var bossOneLives = 25
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        
        scene?.size = CGSize(width: 750, height: 1335)
        
        setupBackground()
        makePlayer(playerShip: 1)
        
        fireTimer = .scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(playerFireFunction), userInfo: nil, repeats: true)
        enemyTimer = .scheduledTimer(timeInterval: 0.7, target: self, selector: #selector(makeEnemy), userInfo: nil, repeats: true)
        
        scoreLabel.text = "Score: \(score)"
        scoreLabel.fontName = "Chalkduster"
        scoreLabel.fontSize = 30
        scoreLabel.fontColor = .white
        scoreLabel.zPosition = 10
        scoreLabel.position = CGPoint(x: size.width / 2, y: size.height / 1.2)
        addChild(scoreLabel)
        
        addLives(lives: 3)
    }
    
    func setupBackground() {
        background1.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background1.setScale(1.3)
        background1.zPosition = 0
        addChild(background1)
        
        background2.position = CGPoint(x: size.width / 2, y: background1.position.y + background1.size.height)
        background2.setScale(1.3)
        background2.zPosition = 0
        addChild(background2)
    }
    
    override func update(_ currentTime: TimeInterval) {
        moveBackground()
    }
    
    func moveBackground() {
        let backgroundSpeed: CGFloat = 3.0
        background1.position.y -= backgroundSpeed
        background2.position.y -= backgroundSpeed
        
        if background1.position.y < -background1.size.height / 2 {
            background1.position.y = background2.position.y + background2.size.height
        }
        if background2.position.y < -background2.size.height / 2 {
            background2.position.y = background1.position.y + background1.size.height
        }
    }
    
    func makePlayer(playerShip: Int) {
        let shipname = "ship_\(playerShip)"
        player = SKSpriteNode(imageNamed: shipname)
        player.position = CGPoint(x: size.width / 2, y: 120)
        player.zPosition = 10
        player.setScale(2)
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.isDynamic = true
        player.physicsBody?.categoryBitMask = CBitmask.playerShip
        player.physicsBody?.contactTestBitMask = CBitmask.enemyShip | CBitmask.bossOneFire
        player.physicsBody?.collisionBitMask = CBitmask.enemyShip | CBitmask.bossOneFire
        addChild(player)
    }
    
    func makeBossOne() {
        bossOne = .init(imageNamed: "BossOne")
        bossOne.position = CGPoint(x: size.width / 2, y: size.height + bossOne.size.height)
        bossOne.zPosition = 10
        bossOne.setScale(0.4)
        bossOne.physicsBody = SKPhysicsBody(rectangleOf: bossOne.size)
        bossOne.physicsBody?.affectedByGravity = false
        bossOne.physicsBody?.categoryBitMask = CBitmask.bossOne
        bossOne.physicsBody?.contactTestBitMask = CBitmask.playerShip | CBitmask.playerFire
        bossOne.physicsBody?.collisionBitMask = CBitmask.playerFire
        
        let move1 = SKAction.moveTo(y: size.height / 1.3, duration: 2)
        let move2 = SKAction.moveTo(x: size.width - bossOne.size.width, duration: 2)
        let move3 = SKAction.moveTo(x: 0 + bossOne.size.width, duration: 2)
        let move4 = SKAction.moveTo(x: size.width / 2, duration: 1.5)
        let move7 = SKAction.moveTo(y: 0 + bossOne.size.height, duration: 2)
        let move8 = SKAction.moveTo(y: size.height / 1.3, duration: 2)
        
        let repeatforever = SKAction.repeatForever(SKAction.sequence([move2,move3,move4,move7,move8]))
        let sequence = SKAction.sequence([move1,repeatforever])
        
        bossOne.run(sequence)
        addChild(bossOne)
    }
    
    @objc func bossOneFireFunc() {
        bossOneFire = .init(imageNamed: "missile")
        bossOneFire.position = bossOne.position
        bossOneFire.zPosition = 5
        bossOneFire.setScale(1.5)
        bossOneFire.physicsBody = SKPhysicsBody(rectangleOf: bossOneFire.size)
        bossOneFire.physicsBody?.affectedByGravity = false
        bossOneFire.physicsBody?.categoryBitMask = CBitmask.bossOneFire
        bossOneFire.physicsBody?.contactTestBitMask = CBitmask.playerShip
        bossOneFire.physicsBody?.collisionBitMask = CBitmask.playerShip
        
        let move1 = SKAction.moveTo(y: 0 - bossOneFire.size.height, duration: 1.0)
        let removeAction = SKAction.removeFromParent()
        let sequence = SKAction.sequence([move1, removeAction])
        bossOneFire.run(sequence)
        
        addChild(bossOneFire)
    }
    
    @objc func playerFireFunction() {
        let playerFire = SKSpriteNode(imageNamed: "shot")
        playerFire.position = player.position
        playerFire.zPosition = 2
        playerFire.setScale(1.5)
        playerFire.physicsBody = SKPhysicsBody(rectangleOf: playerFire.size)
        playerFire.physicsBody?.affectedByGravity = false
        playerFire.physicsBody?.categoryBitMask = CBitmask.playerFire
        playerFire.physicsBody?.contactTestBitMask = CBitmask.enemyShip | CBitmask.bossOne
        playerFire.physicsBody?.collisionBitMask = CBitmask.enemyShip | CBitmask.bossOne
        addChild(playerFire)
        
        let moveAction = SKAction.moveTo(y: 1400, duration: 1)
        let delateAction = SKAction.removeFromParent()
        let combine = SKAction.sequence([moveAction, delateAction])
        
        playerFire.run(combine)
    }
    
    @objc func makeEnemy() {
        let randomNumber = GKRandomDistribution(lowestValue: 50, highestValue: 700)
        
        let enemy = SKSpriteNode(imageNamed: "enemyShip_1")
        enemy.position = CGPoint(x: randomNumber.nextInt(), y: 1400)
        enemy.zPosition = 5
        enemy.setScale(0.2)
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        enemy.physicsBody?.affectedByGravity = false
        enemy.physicsBody?.categoryBitMask = CBitmask.enemyShip
        enemy.physicsBody?.contactTestBitMask = CBitmask.playerShip | CBitmask.playerFire
        enemy.physicsBody?.collisionBitMask = CBitmask.playerFire
        addChild(enemy)
        
        let moveAction = SKAction.moveTo(y: -100, duration: 1.3)
        let delateAction = SKAction.removeFromParent()
        let combine = SKAction.sequence([moveAction, delateAction])
        
        enemy.run(combine)
    }
    
    struct CBitmask {
        static let playerShip: UInt32 = 0b1
        static let playerFire: UInt32 = 0b10
        static let enemyShip: UInt32 = 0b100
        static let bossOne: UInt32 = 0b1000
        static let bossOneFire: UInt32 = 0b10000
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let contactA: SKPhysicsBody
        let contactB: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            contactA = contact.bodyA
            contactB = contact.bodyB
        } else {
            contactA = contact.bodyB
            contactB = contact.bodyA
        }
        
        // Player ship hits enemy ship
        if contactA.categoryBitMask == CBitmask.playerShip && contactB.categoryBitMask == CBitmask.enemyShip {
            player.run(SKAction.repeat(SKAction.sequence([SKAction.fadeOut(withDuration: 0.1), SKAction.fadeIn(withDuration: 0.1)]), count: 8))
            contactB.node?.removeFromParent()
            
            reducePlayerLife()
        }
        
        // Player fire hits enemy ship
        if contactA.categoryBitMask == CBitmask.playerFire && contactB.categoryBitMask == CBitmask.enemyShip {
            playerFireHitEnemy(fires: contactA.node as! SKSpriteNode, enemys: contactB.node as! SKSpriteNode)
            updateScore()
            if score == 200 {
                makeBossOne()
                enemyTimer.invalidate()
                bossOneFireTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(bossOneFireFunc), userInfo: nil, repeats: true)
            }
        }
        
        // Player fire hits the boss
        if contactA.categoryBitMask == CBitmask.playerFire && contactB.categoryBitMask == CBitmask.bossOne {
            let explosion = SKEmitterNode(fileNamed: "Explosion")
            explosion?.position = contactB.node!.position
            explosion?.zPosition = 5
            explosion?.setScale(2)
            addChild(explosion!)
            
            contactA.node?.removeFromParent()
            bossOneLives -= 1
            
            if bossOneLives == 0 {
                contactB.node?.removeFromParent()
                bossOneFireTimer.invalidate()
                enemyTimer = .scheduledTimer(timeInterval: 0.7, target: self, selector: #selector(makeEnemy), userInfo: nil, repeats: true)
            }
        }
       
        if contactA.categoryBitMask == CBitmask.playerShip && contactB.categoryBitMask == CBitmask.bossOneFire {
            let explosion = SKEmitterNode(fileNamed: "Explosion")
            explosion?.position = contactB.node!.position
            explosion?.zPosition = 5
            explosion?.setScale(2)
            addChild(explosion!)
            // Player gets hit by boss fire
            contactB.node?.removeFromParent() // Remove the boss fire
            reducePlayerLife()
        }
    }
    
    func reducePlayerLife() {
        if let live1 = childNode(withName: "live1") {
            live1.removeFromParent()
        } else if let live2 = childNode(withName: "live2") {
            live2.removeFromParent()
        } else if let live3 = childNode(withName: "live3") {
            live3.removeFromParent()
            player.removeFromParent()
            fireTimer.invalidate()
            enemyTimer.invalidate()
            gameOverFunc()
        }
    }
    
    func playerFireHitEnemy(fires: SKSpriteNode, enemys: SKSpriteNode) {
        fires.removeFromParent()
        enemys.removeFromParent()
        
        let explosion = SKEmitterNode(fileNamed: "Explosion")
        explosion?.position = enemys.position
        explosion?.zPosition = 5
        addChild(explosion!)
    }
    
    func addLives(lives: Int) {
        for i in 1...lives {
            let live = SKSpriteNode(imageNamed: "heart")
            live.setScale(2)
            live.position = CGPoint(x: CGFloat(i) * live.size.width + 25, y: size.height - live.size.height - 10)
            live.zPosition = 10
            live.name = "live\(i)"
            playerLive.append(live)
            addChild(live)
        }
    }
    
    func updateScore() {
        score += 10
        scoreLabel.text = "Score: \(score)"
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            player.position.x = location.x
        }
    }
    
    func gameOverFunc() {
        removeAllChildren()
        gameState?.gameOver = true // Notify SwiftUI that the game is over
    }
}
