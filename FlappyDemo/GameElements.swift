//
// Designed using tutorial
//
//
import SpriteKit

struct CollisionBitMask {
    static let joshCategory:UInt32 = 0x1 << 0
    static let waterCategory:UInt32 = 0x1 << 1
    static let fishCategory:UInt32 = 0x1 << 2
    static let groundCategory:UInt32 = 0x1 << 3
}

extension GameScene {
    func createjosh() -> SKSpriteNode {

        let josh = SKSpriteNode(imageNamed: "Josh")
        josh.size = CGSize(width: 50, height: 50)
        josh.position = CGPoint(x:self.frame.midX, y:self.frame.midY)

        josh.physicsBody = SKPhysicsBody(circleOfRadius: josh.size.width / 2)
        josh.physicsBody?.linearDamping = 1.1
        josh.physicsBody?.restitution = 0

        josh.physicsBody?.categoryBitMask = CollisionBitMask.joshCategory
        josh.physicsBody?.collisionBitMask = CollisionBitMask.waterCategory | CollisionBitMask.groundCategory
        josh.physicsBody?.contactTestBitMask = CollisionBitMask.waterCategory | CollisionBitMask.fishCategory | CollisionBitMask.groundCategory

        josh.physicsBody?.affectedByGravity = false
        josh.physicsBody?.isDynamic = true
        return josh
    }

    func createrestartButton() {
        restartButton = SKSpriteNode(imageNamed: "replay")
        restartButton.size = CGSize(width:100, height:100)
        restartButton.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        restartButton.zPosition = 6
        restartButton.setScale(0)
        self.addChild(restartButton)
        restartButton.run(SKAction.scale(to: 1.0, duration: 0.3))
    }

    func createpauseButton() {
        pauseButton = SKSpriteNode(imageNamed: "pauseButton")
        pauseButton.size = CGSize(width:40, height:40)
        pauseButton.position = CGPoint(x: self.frame.width - 30, y: 30)
        pauseButton.zPosition = 6
        self.addChild(pauseButton)
    }

    func createScoreTag() -> SKLabelNode {
        let scoreTag = SKLabelNode()
        scoreTag.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 + self.frame.height / 2.6)
        scoreTag.text = "\(score)"
        scoreTag.zPosition = 5
        scoreTag.fontSize = 50
        scoreTag.fontName = "Arial-BoldMT"
        scoreTag.fontColor = UIColor(red: 1/255, green: 1/255, blue: 1/255, alpha: 1.0)
        return scoreTag
    }

    func createHighscoreTag() -> SKLabelNode {
        let highscoreTag = SKLabelNode()
        highscoreTag.position = CGPoint(x: self.frame.width - 80, y: self.frame.height - 22)
        if let highScore = UserDefaults.standard.object(forKey: "highScore"){
            highscoreTag.text = "High Score: \(highScore)"
        } else {
            highscoreTag.text = "High Score: 0"
        }
        highscoreTag.zPosition = 5
        highscoreTag.fontSize = 15
        highscoreTag.fontName = "Arial-BoldMT"
        highscoreTag.fontColor = UIColor(red: 1/255, green: 1/255, blue: 1/255, alpha: 1.0)
        return highscoreTag
    }

    func createTitle() {
        titleName = SKSpriteNode(imageNamed: "title")
        titleName.size = CGSize(width: 272, height: 65)
        titleName.position = CGPoint(x:self.frame.midX, y:self.frame.midY + 100)
        titleName.setScale(0.5)
        self.addChild(titleName)
        titleName.run(SKAction.scale(to: 1.0, duration: 0.3))
    }

    func createTapToPlayTag() -> SKLabelNode {
        let taptoplayLbl = SKLabelNode()
        taptoplayLbl.position = CGPoint(x:self.frame.midX, y:self.frame.midY - 100)
        taptoplayLbl.text = "Tap to play"
        taptoplayLbl.fontColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        taptoplayLbl.zPosition = 5
        taptoplayLbl.fontSize = 20
        taptoplayLbl.fontName = "Arial-BoldMT"
        return taptoplayLbl
    }
    
    func createWater() -> SKNode  {

        let fishNode = SKSpriteNode(imageNamed: "fish1")
        fishNode.size = CGSize(width: 35, height: 35)
        fishNode.position = CGPoint(x: self.frame.width + 25, y: self.frame.height / 2)
        fishNode.physicsBody = SKPhysicsBody(rectangleOf: fishNode.size)
        fishNode.physicsBody?.affectedByGravity = false
        fishNode.physicsBody?.isDynamic = false
        fishNode.physicsBody?.categoryBitMask = CollisionBitMask.fishCategory
        fishNode.physicsBody?.collisionBitMask = 0
        fishNode.physicsBody?.contactTestBitMask = CollisionBitMask.joshCategory
        fishNode.color = SKColor.blue

        waterPair = SKNode()
        waterPair.name = "waterPair"
        
        let topWater = SKSpriteNode(imageNamed: "water")
        let btmWater = SKSpriteNode(imageNamed: "water")
        topWater.size = CGSize(width: 100, height: 1400)
        btmWater.size = CGSize(width: 100, height: 1400)
        
        topWater.position = CGPoint(x: self.frame.width + 25, y: self.frame.height / 2 + 420)
        btmWater.position = CGPoint(x: self.frame.width + 25, y: self.frame.height / 2 - 420)
        
        topWater.setScale(0.5)
        btmWater.setScale(0.5)
        
        topWater.physicsBody = SKPhysicsBody(rectangleOf: topWater.size)
        topWater.physicsBody?.categoryBitMask = CollisionBitMask.waterCategory
        topWater.physicsBody?.collisionBitMask = CollisionBitMask.joshCategory
        topWater.physicsBody?.contactTestBitMask = CollisionBitMask.joshCategory
        topWater.physicsBody?.isDynamic = false
        topWater.physicsBody?.affectedByGravity = false
        
        btmWater.physicsBody = SKPhysicsBody(rectangleOf: btmWater.size)
        btmWater.physicsBody?.categoryBitMask = CollisionBitMask.waterCategory
        btmWater.physicsBody?.collisionBitMask = CollisionBitMask.joshCategory
        btmWater.physicsBody?.contactTestBitMask = CollisionBitMask.joshCategory
        btmWater.physicsBody?.isDynamic = false
        btmWater.physicsBody?.affectedByGravity = false
        
        topWater.zRotation = CGFloat(Double.pi)
        
        waterPair.addChild(topWater)
        waterPair.addChild(btmWater)
        
        waterPair.zPosition = 1

        let randomPosition = random(min: -150, max: 150)
        waterPair.position.y = waterPair.position.y +  randomPosition
        waterPair.addChild(fishNode)
        
        waterPair.run(moveAndRemove)
        
        return waterPair
    }
    
    func random() -> CGFloat{
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min : CGFloat, max : CGFloat) -> CGFloat{
        return random() * (max - min) + min
    }
}
