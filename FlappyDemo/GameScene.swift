//
// Designed using tutorial
//
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var gameStarted = Bool(false)
    var isDead = Bool(false)
    let coinSound = SKAction.playSoundFileNamed("Splash.mp3", waitForCompletion: false)
    
    var score = Int(0)
    var scoreTag = SKLabelNode()
    var highscoreTag = SKLabelNode()
    var taptoplayLbl = SKLabelNode()
    var restartButton = SKSpriteNode()
    var pauseButton = SKSpriteNode()
    var titleName = SKSpriteNode()
    var waterPair = SKNode()
    var moveAndRemove = SKAction()
    
    let joshAtlas = SKSpriteNode(imageNamed: "Josh")
    var josh = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        createScene()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameStarted == false{
            gameStarted =  true
            josh.physicsBody?.affectedByGravity = true
            createpauseButton()
            titleName.run(SKAction.scale(to: 0.5, duration: 0.3), completion: {
                self.titleName.removeFromParent()
            })
            taptoplayLbl.removeFromParent()
            
            let spawn = SKAction.run({
                () in
                self.waterPair = self.createWater()
                self.addChild(self.waterPair)
            })
            
            let delay = SKAction.wait(forDuration: 1.5)
            let SpawnDelay = SKAction.sequence([spawn, delay])
            let spawnDelayForever = SKAction.repeatForever(SpawnDelay)
            self.run(spawnDelayForever)
            
            let distance = CGFloat(self.frame.width + waterPair.frame.width)
            let movePipes = SKAction.moveBy(x: -distance - 50, y: 0, duration: TimeInterval(0.008 * distance))
            let removePipes = SKAction.removeFromParent()
            moveAndRemove = SKAction.sequence([movePipes, removePipes])
            
            josh.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            josh.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 40))
        } else {
            if isDead == false {
                josh.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                josh.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 40))
            }
        }
        
        for touch in touches{
            let location = touch.location(in: self)
            if isDead == true{
                if restartButton.contains(location){
                    if UserDefaults.standard.object(forKey: "highScore") != nil {
                        let hscore = UserDefaults.standard.integer(forKey: "highScore")
                        if hscore < Int(scoreTag.text!)!{
                            UserDefaults.standard.set(scoreTag.text, forKey: "highScore")
                        }
                    } else {
                        UserDefaults.standard.set(0, forKey: "highScore")
                    }
                    restartScene()
                }
            } else {
                if pauseButton.contains(location){
                    if self.isPaused == false{
                        self.isPaused = true
                        pauseButton.texture = SKTexture(imageNamed: "playButton")
                    } else {
                        self.isPaused = false
                        pauseButton.texture = SKTexture(imageNamed: "pauseButton")
                    }
                }
            }
        }
    }
    
    func createScene(){
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody?.categoryBitMask = CollisionBitMask.groundCategory
        self.physicsBody?.collisionBitMask = CollisionBitMask.joshCategory
        self.physicsBody?.contactTestBitMask = CollisionBitMask.joshCategory
        self.physicsBody?.isDynamic = false
        self.physicsBody?.affectedByGravity = false
        
        self.physicsWorld.contactDelegate = self
        
        for i in 0..<2 {
            let background = SKSpriteNode(imageNamed: "backg2")
            background.anchorPoint = CGPoint.init(x: 0, y: 0)
            background.position = CGPoint(x:CGFloat(i) * self.frame.width, y:0)
            background.name = "background"
            background.size = (self.view?.bounds.size)!
            self.addChild(background)
        }
        
        self.josh = createjosh()
        self.addChild(josh)
        
        scoreTag = createScoreTag()
        self.addChild(scoreTag)
        
        highscoreTag = createHighscoreTag()
        self.addChild(highscoreTag)
        
        createTitle()
        
        taptoplayLbl = createTapToPlayTag()
        self.addChild(taptoplayLbl)
    }
    
    func restartScene(){
        self.removeAllChildren()
        self.removeAllActions()
        isDead = false
        gameStarted = false
        score = 0
        createScene()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
        
        if firstBody.categoryBitMask == CollisionBitMask.joshCategory && secondBody.categoryBitMask == CollisionBitMask.waterCategory || firstBody.categoryBitMask == CollisionBitMask.waterCategory && secondBody.categoryBitMask == CollisionBitMask.joshCategory || firstBody.categoryBitMask == CollisionBitMask.joshCategory && secondBody.categoryBitMask == CollisionBitMask.groundCategory || firstBody.categoryBitMask == CollisionBitMask.groundCategory && secondBody.categoryBitMask == CollisionBitMask.joshCategory{
            enumerateChildNodes(withName: "waterPair", using: ({
                (node, error) in
                node.speed = 0
                self.removeAllActions()
            }))
            if isDead == false{
                isDead = true
                createrestartButton()
                pauseButton.removeFromParent()
                self.josh.removeAllActions()
            }
        } else if firstBody.categoryBitMask == CollisionBitMask.joshCategory && secondBody.categoryBitMask == CollisionBitMask.fishCategory {
            run(coinSound)
            score += 1
            scoreTag.text = "\(score)"
            secondBody.node?.removeFromParent()
        } else if firstBody.categoryBitMask == CollisionBitMask.fishCategory && secondBody.categoryBitMask == CollisionBitMask.joshCategory {
            run(coinSound)
            score += 1
            scoreTag.text = "\(score)"
            firstBody.node?.removeFromParent()
        }
    }
    
    override func update(_ currentTime: TimeInterval) {

        if gameStarted == true{
            if isDead == false{
                enumerateChildNodes(withName: "background", using: ({
                    (node, error) in
                    let bg = node as! SKSpriteNode
                    bg.position = CGPoint(x: bg.position.x - 2, y: bg.position.y)
                    if bg.position.x <= -bg.size.width {
                        bg.position = CGPoint(x:bg.position.x + bg.size.width * 2, y:bg.position.y)
                    }
                }))
            }
        }
    }
}



