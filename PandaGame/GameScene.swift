//
//  GameScene.swift
//  PandaGame
//
//  Created by Das Tarlochan Preet Singh on 2020-06-16.
//  Copyright © 2020 Tarlochan5268. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
  
  let panda = SKSpriteNode(imageNamed: "panda")
  var lastUpdateTime: TimeInterval = 0
  var dt: TimeInterval = 0
    let livesLabel = SKLabelNode(fontNamed: "Chalkduster")
    let scoresLabel = SKLabelNode(fontNamed: "Chalkduster")
    let levelLabel = SKLabelNode(fontNamed: "Chalkduster")
  let pandaMovePointsPerSec: CGFloat = 480.0
  var velocity = CGPoint.zero
  let playableRect: CGRect
 var coinCollected = 0
  var lastTouchLocation: CGPoint?
  let pandaRotateRadiansPerSec:CGFloat = 4.0 * π
  let pandaAnimation: SKAction
    let pandaMove: SKAction
    let pandaMoveback: SKAction
  let catCollisionSound: SKAction = SKAction.playSoundFileNamed(
    "Mario-coin-sound.mp3", waitForCompletion: false)
  let enemyCollisionSound: SKAction = SKAction.playSoundFileNamed(
    "hitCatLady.wav", waitForCompletion: false)
  var invincible = false
  let catMovePointsPerSec:CGFloat = 480.0
  var lives = 3
  var gameOver = false
  let cameraNode = SKCameraNode()
  let cameraMovePointsPerSec: CGFloat = 200.0
    var exitFlag = false;

  
  
 
  
  
  func spawnPanda() {
    panda.position = CGPoint(x: 100, y: playableRect.minY + 30)
    panda.zPosition = 100
    addChild(panda)
    panda.run(SKAction.repeatForever(pandaAnimation))
    panda.run(SKAction.repeatForever(pandaMove))
  }
    
  override func update(_ currentTime: TimeInterval) {
  
    if lastUpdateTime > 0 {
      dt = currentTime - lastUpdateTime
    } else {
      dt = 0
    }
    lastUpdateTime = currentTime
  move(sprite: panda, velocity: velocity)
  
    boundsCheckpanda()
    // checkCollisions()
    moveTrain()

livesLabel.text = "Lives: \(lives)"
    scoresLabel.text = "Coins: \(coinCollected)"
    levelLabel.text = "Level: 1"
    //moveCamera()
    if(coinCollected >= 2)
    {
        spawnExit()
    }
    if lives <= 0 && !gameOver {
      gameOver = true
      print("You lose!")
      backgroundMusicPlayer.stop()
      
      // 1
        let gameOverScene = GameOverScene(size: size, won: false , score: coinCollected)
      gameOverScene.scaleMode = scaleMode
      // 2
      let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
      // 3
      view?.presentScene(gameOverScene, transition: reveal)
    }
    
  }
  
  
    
  
  func moveTrain() {
  
    var trainCount = 0
    var targetPosition = panda.position
    
    enumerateChildNodes(withName: "train") { node, stop in
      trainCount += 1
      if !node.hasActions() {
        let actionDuration = 0.3
        let offset = targetPosition - node.position
        let direction = offset.normalized()
        let amountToMovePerSec = direction * self.catMovePointsPerSec
        let amountToMove = amountToMovePerSec * CGFloat(actionDuration)
        let moveAction = SKAction.moveBy(x: amountToMove.x, y: amountToMove.y, duration: actionDuration)
        node.run(moveAction)
      }
      targetPosition = node.position
    }
    
    if trainCount >= 2 && !gameOver && exitFlag {
        let gameScene2 = GameScene2(size:CGSize(width: 2048, height: 1536))
      gameScene2.scaleMode = scaleMode
      // 2
      let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
      // 3
      view?.presentScene(gameScene2, transition: reveal)
    }
    
  }
  
  func loseCats() {
    // 1
    var loseCount = 0
    enumerateChildNodes(withName: "train") { node, stop in
      // 2
      var randomSpot = node.position
      randomSpot.x += CGFloat.random(min: -100, max: 100)
      randomSpot.y += CGFloat.random(min: -100, max: 100)
      // 3
      node.name = ""
      node.run(
        SKAction.sequence([
          SKAction.group([
            SKAction.rotate(byAngle: π*4, duration: 1.0),
            SKAction.move(to: randomSpot, duration: 1.0),
            SKAction.scale(to: 0, duration: 1.0)
            ]),
          SKAction.removeFromParent()
        ]))
      // 4
      loseCount += 1
      if loseCount >= 2 {
        stop[0] = true
      }
    }
  }
  
  
    //no Change
    
    func spawnEnemy() {
      let enemy = SKSpriteNode(imageNamed: "spikes")
      enemy.position = CGPoint(
        x: playableRect.maxX + enemy.size.width/2,
        y: playableRect.minY + 30)
      enemy.zPosition = 50
      enemy.name = "enemy"
      addChild(enemy)
      
      let actionMove =
        SKAction.moveBy(x: -(size.width + enemy.size.width), y: 0, duration: 4.0)
      let actionRemove = SKAction.removeFromParent()
      enemy.run(SKAction.sequence([actionMove, actionRemove]))
    }
    
    func spawnCat() {
      // 1
      let cat = SKSpriteNode(imageNamed: "coin2")
      cat.name = "cat"
      cat.position = CGPoint(
        x: playableRect.minX + 700,
        y: playableRect.minY + 100)
      cat.zPosition = 50
      cat.setScale(0)
      addChild(cat)
      // 2
      let appear = SKAction.scale(to: 1.0, duration: 0.5)

      let actions = [appear]
      cat.run(SKAction.sequence(actions))
    }
    func spawnExit() {
      // 1
      let exit = SKSpriteNode(imageNamed: "exit")
      exit.name = "exit"
      exit.position = CGPoint(
        x: playableRect.maxX-100,
        y: playableRect.minY + 100)
      exit.zPosition = 50
      exit.setScale(0)
      addChild(exit)
      // 2
      let appear = SKAction.scale(to: 1.0, duration: 0.5)

      let actions = [appear]
      exit.run(SKAction.sequence(actions))
    }
    
    func spawnCat2() {
      // 1
      let cat = SKSpriteNode(imageNamed: "coin2")
      cat.name = "cat"
      cat.position = CGPoint(
        x: playableRect.minX + 1300,
        y: playableRect.minY + 100)
      cat.zPosition = 50
      cat.setScale(0)
      addChild(cat)
      // 2
      let appear = SKAction.scale(to: 1.0, duration: 0.5)

      let actions = [appear]
      cat.run(SKAction.sequence(actions))
    }
    
    func move(sprite: SKSpriteNode, velocity: CGPoint) {
      let amountToMove = CGPoint(x: velocity.x * CGFloat(dt),
                                 y: velocity.y * CGFloat(dt))
      sprite.position += amountToMove
    }
    
    func movepandaToward(location: CGPoint) {
      startpandaAnimation()
      let offset = location - panda.position
      let direction = offset.normalized()
      velocity = direction * pandaMovePointsPerSec
    }
    
    func sceneTouched(touchLocation:CGPoint) {
      lastTouchLocation = touchLocation
      movepandaToward(location: touchLocation)
    }

    override func touchesBegan(_ touches: Set<UITouch>,
        with event: UIEvent?) {
      //guard let touch = touches.first else {
      //  return
      //}
      ///let touchLocation = touch.location(in: self)
      //sceneTouched(touchLocation: touchLocation)
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }

    override func touchesMoved(_ touches: Set<UITouch>,
        with event: UIEvent?) {
      guard let touch = touches.first else {
        return
      }
      let touchLocation = touch.location(in: self)
      sceneTouched(touchLocation: touchLocation)
    }
    
    func boundsCheckpanda() {
      let bottomLeft = CGPoint(x: playableRect.minX, y: playableRect.minY)
      let topRight = CGPoint(x: playableRect.maxX, y: playableRect.maxY)
      let midLeft = CGPoint(x: playableRect.minX+50, y: playableRect.minY + 30)
      let midRight = CGPoint(x: playableRect.maxX-50, y: playableRect.minY + 30)
        if panda.position.x <= midLeft.x {
            panda.position.x = midLeft.x
        velocity.x = abs(velocity.x)
      }
        if panda.position.x >= midRight.x {
            panda.position.x = midRight.x
        velocity.x = -velocity.x
      }
      if panda.position.x <= bottomLeft.x {
        panda.position.x = bottomLeft.x
        velocity.x = abs(velocity.x)
      }
      if panda.position.x >= topRight.x {
        panda.position.x = topRight.x
        velocity.x = -velocity.x
      }
      if panda.position.y <= bottomLeft.y {
        panda.position.y = bottomLeft.y
        velocity.y = -velocity.y
      }
      if panda.position.y >= topRight.y {
        panda.position.y = topRight.y
        velocity.y = -velocity.y
      }
    }
    
    
    override func didMove(to view: SKView) {

      playBackgroundMusic(filename: "BgSound.wav")
    
        let background = SKSpriteNode(imageNamed: "bakground")
        background.anchorPoint = CGPoint.zero
        background.position = CGPoint.zero
        background.name = "bakground"
        background.zPosition = -1
        addChild(background)
      
        spawnPanda()
      // panda.run(SKAction.repeatForever(pandaAnimation))
      
      run(SKAction.repeatForever(SKAction.sequence([SKAction.run() { [weak self] in
                        self?.spawnEnemy()
                      },SKAction.wait(forDuration: 3.0)])))

      spawnCat()
        spawnCat2()
        if(coinCollected >= 2)
        {
            spawnExit()
        }
      
      // debugDrawPlayableArea()
      
      addChild(cameraNode)
      camera = cameraNode
      cameraNode.position = CGPoint(x: size.width/2, y: size.height/2)
      
            livesLabel.text = "Lives: X"
            livesLabel.fontColor = SKColor.red
            livesLabel.fontSize = 70
            livesLabel.zPosition = 150
            livesLabel.horizontalAlignmentMode = .left
            livesLabel.verticalAlignmentMode = .bottom
            livesLabel.position = CGPoint(
                x: -playableRect.size.width/2 + CGFloat(20),
                y: -playableRect.size.height/2 + CGFloat(1100))
            cameraNode.addChild(livesLabel)
        
        scoresLabel.text = "Coins : \(coinCollected)"
        scoresLabel.fontColor = SKColor.red
        scoresLabel.fontSize = 70
        scoresLabel.zPosition = 150
        scoresLabel.horizontalAlignmentMode = .left
        scoresLabel.verticalAlignmentMode = .bottom
        scoresLabel.position = CGPoint(
            x: playableRect.size.width/2 - CGFloat(500),
            y: -playableRect.size.height/2 + CGFloat(1100))
        cameraNode.addChild(scoresLabel)
        
        levelLabel.text = "Level : 1"
        levelLabel.fontColor = SKColor.red
        levelLabel.fontSize = 70
        levelLabel.zPosition = 150
        levelLabel.horizontalAlignmentMode = .left
        levelLabel.verticalAlignmentMode = .bottom
        levelLabel.position = CGPoint(
            x: playableRect.size.width/2 - CGFloat(1200),
            y: -playableRect.size.height/2 + CGFloat(1100))
        cameraNode.addChild(levelLabel)
    }
    
   
    
    override init(size: CGSize) {
      let maxAspectRatio:CGFloat = 16.0/9.0
      let playableHeight = size.width / maxAspectRatio
      let playableMargin = (size.height-playableHeight)/2.0
      playableRect = CGRect(x: 0, y: playableMargin,
                            width: size.width,
                            height: playableHeight)
      
      // 1
      var textures:[SKTexture] = []
      // 2
        textures.append(SKTexture(imageNamed: "panda"))
      /*
        for i in 1...12 {
        textures.append(SKTexture(imageNamed: "panda\(i)"))
      }
      // 3
      textures.append(textures[2])
      textures.append(textures[1])
        */
      // 4
      pandaAnimation = SKAction.animate(with: textures,
        timePerFrame: 0.1)
        
        pandaMove = SKAction.moveBy(x: 200 + panda.size.width, y: 0, duration: 1.5)
        pandaMoveback = SKAction.moveBy(x: 200 + panda.size.width, y: 0, duration: 1.5)
      super.init(size: size)
    }

    required init(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    func pandaHit(cat: SKSpriteNode) {
      cat.name = "train"
      cat.removeAllActions()
      cat.setScale(1.0)
      cat.zRotation = 0
      
      let turnGreen = SKAction.colorize(with: SKColor.green, colorBlendFactor: 1.0, duration: 0.2)
      cat.run(turnGreen)
        cat.isHidden = true
      coinCollected+=1
      run(catCollisionSound)
    }
    
    func pandaHit(exit: SKSpriteNode) {
      exit.name = "exit"
      exit.removeAllActions()
      exit.setScale(1.0)
      exit.zRotation = 0
      
      let turnGreen = SKAction.colorize(with: SKColor.green, colorBlendFactor: 1.0, duration: 0.2)
      exit.run(turnGreen)
        exit.isHidden = true
      exitFlag = true
      run(catCollisionSound)
    }
    
    func pandaHit(enemy: SKSpriteNode) {
      panda.removeFromParent()
        spawnPanda()
        invincible = true
      let blinkTimes = 10.0
      let duration = 3.0
      let blinkAction = SKAction.customAction(withDuration: duration) { node, elapsedTime in
        let slice = duration / blinkTimes
        let remainder = Double(elapsedTime).truncatingRemainder(
          dividingBy: slice)
        node.isHidden = remainder > slice / 2
      }
      let setHidden = SKAction.run() { [weak self] in
        self?.panda.isHidden = false
        self?.invincible = false
      }
        
        
      panda.run(SKAction.sequence([blinkAction, setHidden]))
      
      run(enemyCollisionSound)
      
      loseCats()
      lives -= 1
    }
    
    //debug duplicate function
    func pandaHit2(enemy: SKSpriteNode) {
      invincible = true
      let blinkTimes = 10.0
      let duration = 3.0
      let blinkAction = SKAction.customAction(withDuration: duration) { node, elapsedTime in
        let slice = duration / blinkTimes
        let remainder = Double(elapsedTime).truncatingRemainder(
          dividingBy: slice)
        node.isHidden = remainder > slice / 2
      }
      let setHidden = SKAction.run() { [weak self] in
        self?.panda.isHidden = false
        self?.invincible = false
      }
        //panda.removeFromParent()
        
      panda.run(SKAction.sequence([blinkAction, setHidden]))
      
      run(enemyCollisionSound)
      
      loseCats()
      lives -= 1
    }
    
    
    func checkCollisions() {
      var hitCats: [SKSpriteNode] = []
      enumerateChildNodes(withName: "cat") { node, _ in
        let cat = node as! SKSpriteNode
        if cat.frame.intersects(self.panda.frame) {
          hitCats.append(cat)
        }
      }
      
      for cat in hitCats {
        pandaHit(cat: cat)
      }
      
      if invincible {
        return
      }
     
      var hitEnemies: [SKSpriteNode] = []
      enumerateChildNodes(withName: "enemy") { node, _ in
        let enemy = node as! SKSpriteNode
        if node.frame.insetBy(dx: 10, dy: 10).intersects(
          self.panda.frame) {
          hitEnemies.append(enemy)
        }
      }
      for enemy in hitEnemies {
        pandaHit(enemy: enemy)
      }
        
        
        var hitExit: [SKSpriteNode] = []
        enumerateChildNodes(withName: "exit") { node, _ in
          let exit = node as! SKSpriteNode
          if node.frame.insetBy(dx: 10, dy: 10).intersects(
            self.panda.frame) {
            hitExit.append(exit)
          }
        }
        for exit in hitExit {
          pandaHit(exit: exit)
        }
    }
    
    override func didEvaluateActions() {
      checkCollisions()
    }
    
    func startpandaAnimation() {
      if panda.action(forKey: "animation") == nil {
        panda.run(
          SKAction.repeatForever(pandaAnimation),
          withKey: "animation")
      }
    }

    func stoppandaAnimation() {
      panda.removeAction(forKey: "animation")
    }
    
    
    
    func debugDrawPlayableArea() {
          let shape = SKShapeNode()
          let path = CGMutablePath()
          path.addRect(playableRect)
          shape.path = path
          shape.strokeColor = SKColor.red
          shape.lineWidth = 5.0
          addChild(shape)
        }
    
    func touchDown(atPoint pos: CGPoint) {
          print("jump")
          jump()
      }
    func jump() {
            playBackgroundMusic(filename: "jumpSound.wav")
            let jumpUpAction = SKAction.moveBy(x: 0, y: 330, duration: 0.33)
            let jumpDownAction = SKAction.moveBy(x: 0, y: -330, duration: 0.63)
            let jumpSequence = SKAction.sequence([jumpUpAction, jumpDownAction])

            panda.run(jumpSequence)
        }
}
