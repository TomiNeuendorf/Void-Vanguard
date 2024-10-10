//
//  GameScene.swift
//  VoidVanguard
//
//  Created by Tomi Neuendorf on 13.09.24.
//
import SpriteKit
import GameKit
import SwiftUI
import AVFoundation

class GameScene: SKScene, SKPhysicsContactDelegate {
    var gameState: GameState?
    
    var playerShootSound: AVAudioPlayer?
    var explosionSound: AVAudioPlayer?
    var bossShootSound: AVAudioPlayer?
    
    let background1 = SKSpriteNode(imageNamed: "background5")
    let background2 = SKSpriteNode(imageNamed: "background5")
    
    var player = SKSpriteNode()
    var bossOne = SKSpriteNode()
    var enemy = SKSpriteNode()
    
    var fireTimer = Timer()
    var enemyTimer = Timer()
    var bossOneFireTimer = Timer()
    
    var score = 0
    var scoreLabel = SKLabelNode()
    var playerLive = [SKSpriteNode]()
    
    var bossOneFire = SKSpriteNode()
    var bossOneLives = 25
    
    var upgrade: SKSpriteNode?
    var originalFireRate: TimeInterval = 0.5
    var boostedFireRate: TimeInterval = 0.2
    
    struct CBitmask {
        static let playerShip: UInt32 = 0b1
        static let playerFire: UInt32 = 0b10
        static let enemyShip: UInt32 = 0b100
        static let bossOne: UInt32 = 0b1000
        static let bossOneFire: UInt32 = 0b10000
        static let upgrade: UInt32 = 0b100000
    }
    
    // MARK: - Scene Setup
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        
        scene?.size = CGSize(width: 750, height: 1335)
        
        setupBackground()
        
        makePlayer(playerShip: 1)
        
        fireTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(playerFireFunction), userInfo: nil, repeats: true)
        enemyTimer = Timer.scheduledTimer(timeInterval: 0.7, target: self, selector: #selector(makeEnemy), userInfo: nil, repeats: true)
        
        setupScoreLabel()
        
        addLives(lives: 3)
    }
    
    // MARK: - Background Setup
    
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
    
    // MARK: - Score Label Setup
    
    func setupScoreLabel() {
        scoreLabel.text = "Score: \(score)"
        scoreLabel.fontName = "Chalkduster"
        scoreLabel.fontSize = 30
        scoreLabel.fontColor = .white
        scoreLabel.zPosition = 10
        scoreLabel.position = CGPoint(x: size.width / 2, y: size.height / 1.2)
        addChild(scoreLabel)
    }
    
    // MARK: - Player Setup
    
    func makePlayer(playerShip: Int) {
        let shipName = "ship_\(playerShip)"
        player = SKSpriteNode(imageNamed: shipName)
        player.position = CGPoint(x: size.width / 2, y: 120)
        player.zPosition = 10
        player.setScale(2)
        
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.isDynamic = true
        player.physicsBody?.categoryBitMask = CBitmask.playerShip
        player.physicsBody?.contactTestBitMask = CBitmask.enemyShip | CBitmask.bossOneFire | CBitmask.upgrade
        player.physicsBody?.collisionBitMask = CBitmask.enemyShip | CBitmask.bossOneFire
        
        addChild(player)
        
    }
    
    // MARK: - Enemy Setup
    
    @objc func makeEnemy() {
        let randomNumber = GKRandomDistribution(lowestValue: 50, highestValue: Int(size.width) - 50)
        let enemyX = CGFloat(randomNumber.nextInt())
        let enemy = SKSpriteNode(imageNamed: "enemyShip_1")
        enemy.position = CGPoint(x: enemyX, y: size.height + enemy.size.height)
        enemy.zPosition = 5
        enemy.setScale(0.2)
        
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        enemy.physicsBody?.affectedByGravity = false
        enemy.physicsBody?.categoryBitMask = CBitmask.enemyShip
        enemy.physicsBody?.contactTestBitMask = CBitmask.playerShip | CBitmask.playerFire
        enemy.physicsBody?.collisionBitMask = CBitmask.playerFire
        
        addChild(enemy)
        
        let moveAction = SKAction.moveTo(y: -enemy.size.height, duration: 1.3)
        let removeAction = SKAction.removeFromParent()
        let sequence = SKAction.sequence([moveAction, removeAction])
        
        enemy.run(sequence)
    }
    
    // MARK: - Boss Setup
    
    func makeBossOne() {
        bossOne = SKSpriteNode(imageNamed: "BossOne")
        bossOne.position = CGPoint(x: size.width / 2, y: size.height + bossOne.size.height)
        bossOne.zPosition = 10
        bossOne.setScale(0.4)
        
        bossOne.physicsBody = SKPhysicsBody(rectangleOf: bossOne.size)
        bossOne.physicsBody?.affectedByGravity = false
        bossOne.physicsBody?.categoryBitMask = CBitmask.bossOne
        bossOne.physicsBody?.contactTestBitMask = CBitmask.playerShip | CBitmask.playerFire
        bossOne.physicsBody?.collisionBitMask = CBitmask.playerFire
        
        addChild(bossOne)
        
        
        let moveUp = SKAction.moveTo(y: size.height / 1.3, duration: 2)
        let moveRight = SKAction.moveTo(x: size.width - bossOne.size.width, duration: 2)
        let moveLeft = SKAction.moveTo(x: bossOne.size.width, duration: 2)
        let moveCenter = SKAction.moveTo(x: size.width / 2, duration: 1.5)
        let moveDown = SKAction.moveTo(y: bossOne.size.height, duration: 2)
        let moveUpAgain = SKAction.moveTo(y: size.height / 1.3, duration: 2)
        
        let repeatForever = SKAction.repeatForever(SKAction.sequence([moveRight, moveLeft, moveCenter, moveDown, moveUpAgain]))
        let sequence = SKAction.sequence([moveUp, repeatForever])
        
        bossOne.run(sequence)
    }
    
    // MARK: - Boss Fire Function
    
    @objc func bossOneFireFunc() {
        let bossFire = SKSpriteNode(imageNamed: "missile")
        playBossShootSound()
        bossFire.position = CGPoint(x: bossOne.position.x, y: bossOne.position.y - bossOne.size.height / 2)
        bossFire.zPosition = 5
        bossFire.setScale(1.5)
        
        
        bossFire.physicsBody = SKPhysicsBody(rectangleOf: bossFire.size)
        bossFire.physicsBody?.affectedByGravity = false
        bossFire.physicsBody?.categoryBitMask = CBitmask.bossOneFire
        bossFire.physicsBody?.contactTestBitMask = CBitmask.playerShip
        bossFire.physicsBody?.collisionBitMask = CBitmask.playerShip
        
        addChild(bossFire)
        
        let moveAction = SKAction.moveTo(y: -bossFire.size.height, duration: 1.0)
        let removeAction = SKAction.removeFromParent()
        let sequence = SKAction.sequence([moveAction, removeAction])
        
        bossFire.run(sequence)
    }
    
    // MARK: - Player Fire Function
    
    @objc func playerFireFunction() {
        let playerFire = SKSpriteNode(imageNamed: "shoot")
        playPlayerShootSound()
        playerFire.position = CGPoint(x: player.position.x, y: player.position.y + player.size.height / 2)
        playerFire.zPosition = 2
        playerFire.setScale(1.5)
        
        
        
        playerFire.physicsBody = SKPhysicsBody(rectangleOf: playerFire.size)
        playerFire.physicsBody?.affectedByGravity = false
        playerFire.physicsBody?.categoryBitMask = CBitmask.playerFire
        playerFire.physicsBody?.contactTestBitMask = CBitmask.enemyShip | CBitmask.bossOne
        playerFire.physicsBody?.collisionBitMask = CBitmask.enemyShip | CBitmask.bossOne
        
        addChild(playerFire)
        
        let moveAction = SKAction.moveTo(y: size.height + playerFire.size.height, duration: 1)
        let removeAction = SKAction.removeFromParent()
        let sequence = SKAction.sequence([moveAction, removeAction])
        
        playerFire.run(sequence)
    }
    
    // MARK: - Sound Funktion for Player Boss and Explosion
    func playPlayerShootSound() {
        guard let url = Bundle.main.url(forResource: "shoot", withExtension: "wav") else { return }
        
        do {
            playerShootSound = try AVAudioPlayer(contentsOf: url)
            playerShootSound?.play()
            playerShootSound?.volume = 0.070
        } catch {
            print("Error Loading shoot sound")
        }
    }
    
    func playBossShootSound(){
        guard let url = Bundle.main.url(forResource: "missile", withExtension: "wav") else { return }
        
        do {
            bossShootSound = try AVAudioPlayer(contentsOf: url)
            bossShootSound?.play()
            bossShootSound?.volume = 0.070
        } catch {
            print("Error Loading shoot sound")
        }
    }
    
    func playExplosionSound() {
        guard let url = Bundle.main.url(forResource: "explosion", withExtension: "wav") else { return }
        
        do {
            explosionSound = try AVAudioPlayer(contentsOf: url)
            explosionSound?.play()
            explosionSound?.volume = 0.070
        } catch {
            print("Error loading explosion sound")
        }
    }
    
    // MARK: - Lives Setup
    
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
    
    // MARK: - Score Management
    
    func updateScore() {
        score += 10
        scoreLabel.text = "Score: \(score)"
    }
    
    // MARK: - Touch Handling
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            player.position.x = location.x
        }
    }
    
    // MARK: - Physics Contact Delegate
    
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
        
        if contactA.categoryBitMask == CBitmask.playerShip && contactB.categoryBitMask == CBitmask.upgrade {
            if let upgradeNode = contactB.node as? SKSpriteNode {
                applyUpgrade(upgrade: upgradeNode, to: player)
                upgradeNode.removeFromParent()
            }
        }
        
        
        
        
        // MARK: - Contact Scenarios
        
        if contactA.categoryBitMask == CBitmask.playerShip && contactB.categoryBitMask == CBitmask.enemyShip {
            player.run(SKAction.repeat(SKAction.sequence([
                SKAction.fadeOut(withDuration: 0.1),
                SKAction.fadeIn(withDuration: 0.1)
            ]), count: 8))
            contactB.node?.removeFromParent()
            
            reducePlayerLife()
        }
        
        if contactA.categoryBitMask == CBitmask.playerFire && contactB.categoryBitMask == CBitmask.enemyShip {
            if let fireNode = contactA.node as? SKSpriteNode, let enemyNode = contactB.node as? SKSpriteNode {
                playerFireHitEnemy(fires: fireNode, enemys: enemyNode)
                playExplosionSound()
                updateScore()
                
                // Trigger boss appearance at score 200
                if score == 200 {
                    makeBossOne()
                    enemyTimer.invalidate()
                    bossOneFireTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(bossOneFireFunc), userInfo: nil, repeats: true)
                }
            }
        }
        
        if contactA.categoryBitMask == CBitmask.playerFire && contactB.categoryBitMask == CBitmask.bossOne {
            if let fireNode = contactA.node as? SKSpriteNode, let bossNode = contactB.node as? SKSpriteNode {
                let explosion = SKEmitterNode(fileNamed: "Explosion")
                explosion?.position = bossNode.position
                explosion?.zPosition = 5
                explosion?.setScale(2)
                if let explosion = explosion {
                    addChild(explosion)
                }
                
                fireNode.removeFromParent()
                bossOneLives -= 1
                
                if bossOneLives == 0 {
                    bossNode.removeFromParent()
                    playExplosionSound()
                    bossOneFireTimer.invalidate()
                    enemyTimer = Timer.scheduledTimer(timeInterval: 0.7, target: self, selector: #selector(makeEnemy), userInfo: nil, repeats: true)
                }
            }
        }
        
        // MARK:- 4. Player ship hits boss fire
        if contactA.categoryBitMask == CBitmask.playerShip && contactB.categoryBitMask == CBitmask.bossOneFire {
            if let bossFireNode = contactB.node as? SKSpriteNode {
                let explosion = SKEmitterNode(fileNamed: "Explosion")
                explosion?.position = bossFireNode.position
                explosion?.zPosition = 5
                explosion?.setScale(2)
                if let explosion = explosion {
                    addChild(explosion)
                }
                
                bossFireNode.removeFromParent()
                reducePlayerLife()
            }
        }
        // MARK: - 5. Player collects upgrade
        if contactA.categoryBitMask == CBitmask.playerShip && contactB.categoryBitMask == CBitmask.upgrade {
            if let upgradeNode = contactB.node as? SKSpriteNode {
                applyUpgrade(upgrade: upgradeNode , to: player)
                upgradeNode.removeFromParent()
            }
        }
    }
    
    // MARK: - Collision Handlers
    
    func playerFireHitEnemy(fires: SKSpriteNode, enemys: SKSpriteNode) {
        fires.removeFromParent()
        enemys.removeFromParent()
        
        let explosion = SKEmitterNode(fileNamed: "Explosion")
        explosion?.position = enemys.position
        explosion?.zPosition = 5
        explosion?.setScale(2)
        if let explosion = explosion {
            addChild(explosion)
        }
        
        // Random chance to spawn an upgrade (e.g., 5% chance)
        let chance = Int.random(in: 1...100)
        if chance <= 5 {
            spawnUpgrade(at: enemys.position)
        }
    }
    
    // MARK: - Upgrade Spawning
    func spawnUpgrade(at position: CGPoint) {
        let upgradeType = Int.random(in: 0...1) // Randomly choose an upgrade type (0 for speed, 1 for fire rate)
        let upgrade: SKSpriteNode
        
        if upgradeType == 0 {
            upgrade = SKSpriteNode(imageNamed: "speedBoost")
            upgrade.name = "speedUpgrade"
        } else {
            upgrade = SKSpriteNode(imageNamed: "fireRateBoost")
            upgrade.name = "fireRateUpgrade"
        }
        
        upgrade.position = position
        upgrade.zPosition = 5
        upgrade.setScale(1.5)
        
        upgrade.physicsBody = SKPhysicsBody(rectangleOf: upgrade.size)
        upgrade.physicsBody?.affectedByGravity = false
        upgrade.physicsBody?.categoryBitMask = CBitmask.upgrade
        upgrade.physicsBody?.contactTestBitMask = CBitmask.playerShip
        upgrade.physicsBody?.collisionBitMask = 0
        
        addChild(upgrade)
        
        let accompanyingImage = SKSpriteNode(imageNamed: "speedBoost")
        accompanyingImage.position = position
        accompanyingImage.zPosition = 5
        accompanyingImage.setScale(1.5)
        accompanyingImage.alpha = 0.8
        
        let fadeOutAction = SKAction.fadeOut(withDuration: 3.0)
        let removeAccompanyingImageAction = SKAction.removeFromParent()
        let imageSequence = SKAction.sequence([fadeOutAction, removeAccompanyingImageAction])
        accompanyingImage.run(imageSequence)
        
        addChild(accompanyingImage)
        
        let moveAction = SKAction.moveTo(y: -upgrade.size.height, duration: 3.0)
        let removeAction = SKAction.removeFromParent()
        let sequence = SKAction.sequence([moveAction, removeAction])
        upgrade.run(sequence)
    }
    
    // MARK: Apply Upgrade
    
    func applyUpgrade(upgrade: SKSpriteNode, to player: SKSpriteNode) {
        if upgrade.name == "speedUpgrade" {
            // Apply speed boost to player (e.g., increasing movement speed or handling)
            print("Speed upgrade applied!")
            // Implement the speed boost logic here
        } else if upgrade.name == "fireRateUpgrade" {
            // Apply fire rate boost to player
            print("Fire rate upgrade applied!")
            fireTimer.invalidate() // Stop the existing timer
            fireTimer = Timer.scheduledTimer(timeInterval: boostedFireRate, target: self, selector: #selector(playerFireFunction), userInfo: nil, repeats: true)
            
            Timer.scheduledTimer(withTimeInterval: 10.0, repeats: false) { [weak self] timer in
                self?.fireTimer.invalidate()
                self?.fireTimer = Timer.scheduledTimer(timeInterval: self?.originalFireRate ?? 0.5, target: self!, selector: #selector(self?.playerFireFunction), userInfo: nil, repeats: true)
            }
        }
    }
    
    // MARK: - Reduce Player Life Function
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
            bossOneFireTimer.invalidate()
            gameOverFunc()
        }
    }
    
    // MARK: - Game Over
    
    func gameOverFunc() {
        removeAllChildren()
        gameState?.gameOver = true // Notify SwiftUI that the game is over
        gameState?.score = score
    }
}
