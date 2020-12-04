//
//  GameViewController.swift
//  SpaceWar
//
//  Created by Egor on 29.03.2020.
//  Copyright © 2020 Egor. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    var gameScene: GameScene!
    var pauseVC: PauseViewController!
        
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        pauseVC = storyboard?.instantiateViewController(withIdentifier: "PauseViewController") as? PauseViewController // инициализация VC
        
        pauseVC.delegate = self // подписываемся на делегат
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                gameScene = scene as? GameScene
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
           
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    func showPauseScreen(_ viewController: UIViewController) {
        addChild(viewController)
        view.addSubview(viewController.view)
        viewController.view.frame = view.bounds
        
        // плавность появления меню паузы
        viewController.view.alpha = 0
        
        UIView.animate(withDuration: 0.7) {
            viewController.view.alpha = 1
        }
    }
    
    // скрытие меню паузы
    func hidePassScreen ( _ viewController: PauseViewController) {
        viewController.willMove(toParent: nil)
        viewController.removeFromParent()
        
        
        // плавность выхода с меню паузы
        viewController.view.alpha = 1
        
        UIView.animate(withDuration: 0.5, animations: {
            viewController.view.alpha = 0
            
        }) { (completed) in
            viewController.view.removeFromSuperview()
            
        }
    }
    @IBAction func pauseButton(_ sender: UIButton) {
        showPauseScreen(pauseVC)
        gameScene.pause()
     
    }
    
        
    
}
extension GameViewController: PauseVCdelegate {
    
    // метод переключателя звука удара
    func pauseVCSoundButton(_ viewController: PauseViewController) {
        gameScene.soundOn = !gameScene.soundOn
        
        
        if gameScene.soundOn == true {
            viewController.soundButton.setTitle("On", for: .normal)
        } else if gameScene.soundOn == false{
            viewController.soundButton.setTitle("Off", for: .normal)
        }
        
        
    }
    //метод переключателя музыки в игре
    func pauseVCMusicButton(_ viewController: PauseViewController) {
        gameScene.musicOn = !gameScene.musicOn
        gameScene.musicSelector()
        
        let text = gameScene.musicOn ? "ON" : "OFF"
        viewController.musicButton.setTitle(text, for: .normal)
    }
    
    func pauseVCPlayBut(_ viewController: PauseViewController) {
        hidePassScreen(pauseVC)
        gameScene.goGame()
    }
    
    
}
