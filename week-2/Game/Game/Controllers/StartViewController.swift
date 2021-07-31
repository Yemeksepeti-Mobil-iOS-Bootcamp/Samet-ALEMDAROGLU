//
//  StartViewController.swift
//  Game
//
//  Created by ALEMDAR on 13.07.2021.
//

import UIKit


protocol ConfigureNewGameDelegate {
    func configureNewGame(playername: String)
}

class StartViewController: UIViewController {

    @IBOutlet weak var nickNameTextField: UITextField!
    
    var delegate: ConfigureNewGameDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func startButtonTapped(_ sender: Any) {
        if nickNameTextField.hasText{
            delegate?.configureNewGame(playername: nickNameTextField.text ?? "")
            dismiss(animated: true, completion: nil)
        }
    }
    
}
