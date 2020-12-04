//
//  GameScene.swift
//  SpaceWar
//
//  Created by Egor on 29.03.2020.
//  Copyright © 2020 Egor. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

//битовые маски
enum CollisionType: UInt32 {
    case spaceShip = 1
    case asteroids = 2
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    

    
    //Создаем экземпляр node
    
    var scoreLabel: SKLabelNode!
    var score = 0
    var spaceBackground: SKSpriteNode!
    var spaceShip: SKSpriteNode!
    var asteroidLayer: SKNode!
    var musicPlayer: AVAudioPlayer!
    
    var musicOn = true
    var soundOn = true
    
    func musicSelector () {
        if musicOn {
            musicPlayer.play()
        } else {
            musicPlayer.stop()
        }
    }
 
    
    
    var gameIsPaused: Bool = false
    
    func pause () {
        gameIsPaused = true
        self.asteroidLayer.isPaused = true
        physicsWorld.speed = 0
//        musicSelector()
    }
    
    
    
    func goGame () {
        gameIsPaused = false
        self.asteroidLayer.isPaused = false
        physicsWorld.speed = 1
        musicSelector()
       
    }
    func resetGame()  {
        score = 0
        scoreLabel.text = "Score \(score)"
        gameIsPaused = false
        self.asteroidLayer.isPaused = false
        physicsWorld.speed = 1
    }
   
    
    override func didMove(to view: SKView) {
        
        playMusic()
        // эффект движения звезд
        if let particles = SKEmitterNode(fileNamed: "stars") {
        particles.position = CGPoint(x: 0, y: 600)
        particles.advanceSimulationTime(60)
        particles.zPosition = 0
        addChild(particles)
        }
        
//        // эффект огня двигателя
//
//         let fireEmitter = SKEmitterNode(fileNamed: "Fire")
//        fireEmitter?.zPosition = 0
//        fireEmitter?.position.y = -40
//        fireEmitter?.targetNode = self
//        spaceFire.addChild(fireEmitter!)
//
        
        
        // гравитация
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -0.5)
        
        scene?.size = UIScreen.main.bounds.size
        
        // фон
        spaceBackground = SKSpriteNode(imageNamed: "Stars")
        spaceBackground.size = self.frame.size
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height

        spaceBackground.size = CGSize(width: width , height: height )
        spaceBackground.zPosition = -1
        self.addChild(spaceBackground)
        
        
        // Инициализируем node
        spaceShip = SKSpriteNode(imageNamed: "ship (15)")
        spaceShip.name = "spaceShip"
//        spaceShip.position.x = frame.minX + 200// расположение элемента на view
        spaceShip.position.y = frame.minY + 200
        spaceShip.xScale = 0.5
        spaceShip.yScale = 0.5  // коэфициент размера корабля
        spaceShip.zPosition = 3
        self.addChild(spaceShip)
        
        
        // эффект огня двигателя
        
        let fireEmitter = SKEmitterNode(fileNamed: "Fire")!
        fireEmitter.zPosition = 4
        fireEmitter.position.y = -100
        fireEmitter.targetNode = self
        self.spaceShip.addChild(fireEmitter)
        
        
        spaceShip.physicsBody = SKPhysicsBody(texture: spaceShip.texture!, size: spaceShip.size) // Задаем физику тела корабля
        spaceShip.physicsBody?.categoryBitMask = CollisionType.spaceShip.rawValue
        spaceShip.physicsBody?.collisionBitMask = CollisionType.asteroids.rawValue
        spaceShip.physicsBody?.contactTestBitMask = CollisionType.asteroids.rawValue
        spaceShip.physicsBody?.isDynamic = false// Определяем отсутвие динамики тела ( не будет падать вниз
       
        // переливашка цвета объекта
//        let colorAction = SKAction.colorize(with: #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1), colorBlendFactor: 1, duration: 1)
//        let colorAction2 = SKAction.colorize(with: .systemBlue, colorBlendFactor:1,  duration: 1)
//        let colorSeqeuence = SKAction.sequence([colorAction, colorAction2])
//        let colorActionRepeat = SKAction.repeatForever(colorSeqeuence)
//        spaceShip.run(colorActionRepeat)

       
        
        
        
        let asteroidCreate = SKAction.run {
            let asteroids = SKSpriteNode(imageNamed: "asteroidR1")
              let randomScale = CGFloat(GKRandomSource.sharedRandom().nextInt(upperBound: 6)) / 10
              asteroids.xScale = randomScale
              asteroids.yScale = randomScale
              
              asteroids.position.x = CGFloat(GKRandomSource.sharedRandom().nextInt(upperBound: 16))
            asteroids.position.y = asteroids.frame.size.height + 400
              
            asteroids.physicsBody = SKPhysicsBody(texture: asteroids.texture!, size: asteroids.size)
              asteroids.name = "asteroids"
              
              asteroids.physicsBody?.categoryBitMask = CollisionType.asteroids.rawValue
              asteroids.physicsBody?.collisionBitMask = CollisionType.spaceShip.rawValue | CollisionType.asteroids.rawValue
              asteroids.physicsBody?.contactTestBitMask = CollisionType.spaceShip.rawValue
            
             
              
              let asteroidSpeedX: CGFloat = 100.0
              asteroids.physicsBody?.angularVelocity = CGFloat(drand48() * 2 - 1) * 3 // УГловая скорость
              asteroids.physicsBody?.velocity.dx = CGFloat(drand48() * 2 - 1) * asteroidSpeedX
              asteroids.zPosition = 3
            
            self.asteroidLayer.addChild(asteroids)
            
        }
        let asteroidsPerSecond: Double = 2
        let asteroidCreationDelay = SKAction.wait(forDuration: 1.0 / asteroidsPerSecond, withRange: 1)
        let asteroidSequenceAction = SKAction.sequence([asteroidCreate, asteroidCreationDelay])
        let asteroidRunAction = SKAction.repeatForever(asteroidSequenceAction)
        
        //создаем asteroid
        asteroidLayer = SKNode()
        asteroidLayer.zPosition = 2
        addChild(asteroidLayer)
        
        self.asteroidLayer.run(asteroidRunAction)
        
        // создание счетчика
        
        scoreLabel = SKLabelNode(text: "Score: \(score)")
        scoreLabel.position = CGPoint(x: frame.size.width / scoreLabel.frame.size.width, y: 300)
        
        addChild(scoreLabel)
        
        scoreLabel.zPosition = 1
    }
    
    
    // создаем музыкальный плеер
    func playMusic () {
        if let musicPath = Bundle.main.url(forResource: "Sound_06680", withExtension: "mp3") {
            musicPlayer = try! AVAudioPlayer(contentsOf: musicPath, fileTypeHint: nil)
            musicPlayer.play()
            musicPlayer.numberOfLoops = -1 //бесконечное воспроизведение
            musicPlayer.volume = 0.2
            
        }
    
    }
     
    // формула фиксированной скорости перемещения C = sqrt((x2 - x1)2 + (y2 - y1)2)
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !gameIsPaused {
            if let touch = touches.first {
            
            // Определяем точку прикосновения
                let toucheLocation = touch.location(in: self)
            let distance = distanceCalc(a: spaceShip.position, b: toucheLocation)
            let speed: CGFloat = 350
            let time = timeToTravelDistance(distance: distance, speed: speed)
            
            // Создаем действие
            let movAction = SKAction.move(to: toucheLocation, duration: time)
            movAction.timingMode = SKActionTimingMode.easeInEaseOut // плавность хода/замедление при старте
            spaceShip.run(movAction)
            
            // Паралакс эффект для бэкграудна
            let bgAction = SKAction.move(to: CGPoint(x: -toucheLocation.x / 150, y: -toucheLocation.y / 150), duration: time)
            
            spaceBackground.run(bgAction)
        }
        }
    }
        func distanceCalc(a: CGPoint, b: CGPoint) -> CGFloat {
            return sqrt((b.x - a.x)*(b.x-a.x) + (b.y - a.x)*(b.y - a.y))
    }
    
    func timeToTravelDistance(distance: CGFloat, speed: CGFloat) ->TimeInterval {
        let time = distance / speed
        return TimeInterval(time)
    }
    
    // звук ударов об корабль
    func soundStatement(soundOn some: Bool) {
            if some  {
                let explosionSound = SKAction.playSoundFileNamed("sound", waitForCompletion: true)
        
        run(explosionSound)
            } 
    }
    

    // Удаление астериода после падения вниз
    override func didApplyConstraints() {
        
        // удаление падающих нодов за слой asteroidLayer
        asteroidLayer.enumerateChildNodes(withName: "asteroids") { (asteroids, stop) in
            let heightScreen = UIScreen.main.bounds.height
            if asteroids.position.y < -heightScreen {
                asteroids.removeFromParent()
                
                self.score = self.score + 1
                self.scoreLabel.text = "Score: \(self.score)"
        }
            
        }
    }
    
    // Математика счета
    func didBegin(_ contact: SKPhysicsContact) {
        soundStatement(soundOn: soundOn)
        
        if contact.bodyA.categoryBitMask == CollisionType.spaceShip.rawValue && contact.bodyB.categoryBitMask == CollisionType.asteroids.rawValue || contact.bodyB.categoryBitMask == CollisionType.spaceShip.rawValue && contact.bodyA.categoryBitMask == CollisionType.asteroids.rawValue {
            self.score = 0
            self.scoreLabel.text = "Score: \(self.score)"
        }
      
        
        
}
    
}
