//
//  PauseViewController.swift
//  SpaceWar
//
//  Created by Egor on 01.04.2020.
//  Copyright © 2020 Egor. All rights reserved.
//

import UIKit

protocol PauseVCdelegate {
    
    func pauseVCPlayBut (_ viewController: PauseViewController)
    func pauseVCSoundButton (_ viewController: PauseViewController)
    func pauseVCMusicButton (_ viewController: PauseViewController)
    
}
class PauseViewController: UIViewController {
    
    @IBOutlet weak var musicButton: UIButton!
    @IBOutlet weak var soundButton: UIButton!
    var delegate: PauseVCdelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        

       
    }
    
    @IBAction func soundAction(_ sender: UIButton) {
        delegate.pauseVCSoundButton(self)
    }
    
    @IBAction func musicAction(_ sender: Any) {
        delegate.pauseVCMusicButton(self)
        
    }
    
    @IBAction func playButton(_ sender: UIButton) {
        delegate.pauseVCPlayBut(self)
    }
    
}
