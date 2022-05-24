//
//  GameOverViewController.swift
//  MovieQuiz
//
//  Created by Herrison Feres on 24/05/22.
//

import UIKit

class GameOverViewController: UIViewController {

    @IBOutlet weak var lbScore: UILabel!
    
    var score: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lbScore.text = "\(score)"
    }
    
    
    @IBAction func playAgain(_ sender: Any) {
        dismiss(animated: true)
    }
    
}
