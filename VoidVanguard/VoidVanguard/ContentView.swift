//
//  ContentView.swift
//  VoidVanguard
//
//  Created by Tomi Neuendorf on 09.09.24.
//

import SwiftUI
import SpriteKit
import GameKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let background = SKSpriteNode(imageNamed:"Background-1")
    var player = SKSpriteNode()
    var playerFire = SKSpriteNode()
    var fireTimer = Timer()
    var enemyTimer = Timer()
    var enemy = SKSpriteNode()
    var score = 0
    var scoreLabel = SKLabelNode()
    var playerLive = [SKSpriteNode]()
    
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        scene?.size = CGSize(width: 750, height: 1335)
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.setScale(1.3)
        background.zPosition = 1
        addChild(background)
        
        makePlayer(playerShip: 1)
        
        fireTimer = .scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(playerFireFunction), userInfo: nil, repeats: true)
        
        enemyTimer = .scheduledTimer(timeInterval: 1, target: self, selector: #selector(makeEnemys), userInfo: nil, repeats: true)
        
        //Score Text and Font
        
        scoreLabel.text = "Score: \(score)"
        scoreLabel.fontName = "Chalkduster"
        scoreLabel.fontSize = 30
        scoreLabel.fontColor = .white
        scoreLabel.zPosition = 10
        scoreLabel.position = CGPoint(x: size.width / 2, y: size.height / 1.2)
        addChild(scoreLabel)
        
        addLives(lives: 3)
        
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
        
        if contactA.categoryBitMask == CBitmask.playerFire && contactB.categoryBitMask == CBitmask.enemyShip {
            playerFireHitEnemy(fires: contactA.node as! SKSpriteNode, enemys: contactB.node as! SKSpriteNode)
            
            updateScore()
        }
        
        if contactA.categoryBitMask == CBitmask.playerShip && contactB.categoryBitMask == CBitmask.enemyShip {
            player.run(SKAction.repeat(SKAction.sequence([SKAction.fadeOut(withDuration: 0.1),SKAction.fadeIn(withDuration: 0.1)]),count: 8))
            
            contactB.node?.removeFromParent()
            
            if let live1 = childNode(withName: "live1") {
                live1.removeFromParent()
            } else if let live2 = childNode(withName: "live2") {
                live2.removeFromParent()
            } else if let live3 = childNode(withName: "live3") {
                live3.removeFromParent()
                player.removeFromParent()
                fireTimer.invalidate()
                enemyTimer.invalidate()
            }
        }
    }
    
    func playerHitEnemy(players: SKSpriteNode, enemys: SKSpriteNode) {
        players.removeFromParent()
        enemys.removeFromParent()
        
        fireTimer.invalidate()
        enemyTimer.invalidate()
        
        let explosion = SKEmitterNode(fileNamed: "Explosion")
        explosion?.position = players.position
        explosion?.zPosition = 5
        addChild(explosion!)
    }
    
    func playerFireHitEnemy(fires: SKSpriteNode, enemys: SKSpriteNode) {
        fires.removeFromParent()
        enemys.removeFromParent()
        
        let explosion = SKEmitterNode(fileNamed: "Explosion")
        explosion?.position = enemys.position
        explosion?.zPosition = 5
        addChild(explosion!)
    }
    
    func addLives(lives:Int) {
        for i in 1...lives {
            let live = SKSpriteNode(imageNamed: "heart")
            live.setScale(2)
            live.position = CGPoint(x: CGFloat(i) * live.size.width + 10, y: size.height - live.size.height - 10)
            live.zPosition = 10
            live.name = "live\(i)"
            playerLive.append(live)
            addChild(live)
        }
    }
    
    struct CBitmask {
        static let playerShip: UInt32 = 0b1
        static let playerFire: UInt32 = 0b10
        static let enemyShip: UInt32 = 0b100
        static let bossOne: UInt32 = 0b1000
    }
    
    func makePlayer(playerShip: Int) {
        var shipname = ""
        
        switch playerShip {
        case 1:
            shipname = "ship_1"
        case 2:
            shipname = "ship_3"
        case 3:
            shipname = "ship_4"
        case 4:
            shipname = "ship_5"
        case 5:
            shipname = "ship_6"
        default:
            shipname = "ship_default"
        }
        
        player = SKSpriteNode(imageNamed: shipname)  // Initialize player first
        player.position = CGPoint(x: size.width / 2, y: 120)
        player.zPosition = 10
        player.setScale(2)
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.isDynamic = true
        player.physicsBody?.categoryBitMask = CBitmask.playerShip
        player.physicsBody?.contactTestBitMask = CBitmask.enemyShip
        player.physicsBody?.collisionBitMask = CBitmask.enemyShip
        addChild(player)
    }
    
    @objc func playerFireFunction() {
        playerFire = SKSpriteNode(imageNamed: "shot")
        playerFire.position = player.position
        playerFire.zPosition = 2
        playerFire.physicsBody = SKPhysicsBody(rectangleOf: playerFire.size)
        playerFire.physicsBody?.affectedByGravity = false
        playerFire.physicsBody?.categoryBitMask = CBitmask.playerFire
        playerFire.physicsBody?.contactTestBitMask = CBitmask.enemyShip
        playerFire.physicsBody?.collisionBitMask = CBitmask.enemyShip
        addChild(playerFire)
        
        let moveAction = SKAction.moveTo(y: 1400, duration: 1)
        let delateAction = SKAction.removeFromParent()
        let combine = SKAction.sequence([moveAction, delateAction])
        
        playerFire.run(combine)
    }
    
    @objc func makeEnemys() {
        let randomNumber = GKRandomDistribution(lowestValue: 50, highestValue: 700)
        
        enemy = SKSpriteNode(imageNamed: "enemyShip_1")
        enemy.position = CGPoint(x: randomNumber.nextInt(), y: 1400)
        enemy.zPosition = 5
        enemy.setScale(0.2)
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        enemy.physicsBody?.affectedByGravity = false
        enemy.physicsBody?.categoryBitMask = CBitmask.enemyShip
        enemy.physicsBody?.contactTestBitMask = CBitmask.playerShip | CBitmask.playerFire
        enemy.physicsBody?.collisionBitMask = CBitmask.playerFire
        addChild(enemy)
        
        let moveAction = SKAction.moveTo(y: -100, duration: 3.5)
        let delateAction = SKAction.removeFromParent()
        let combine = SKAction.sequence([moveAction, delateAction])
        
        enemy.run(combine)
    }
    
    func updateScore () {
        score += 10
        
        scoreLabel.text = "Score: \(score)"
        
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            player.position.x = location.x
        }
    }
}

struct ContentView: View {
    let scene = GameScene()
    
    var body: some View {
        SpriteView(scene: scene)
            .ignoresSafeArea()
            .statusBar(hidden: true )
    }
}

#Preview {
    ContentView()
}


