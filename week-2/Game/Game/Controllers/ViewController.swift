//
//  ViewController.swift
//  Game
//
//  Created by Macbook on 2.07.2021.
//

import UIKit

class ViewController: UIViewController{
    
    // MARK: IBOutlets
    @IBOutlet private weak var nickNameLabel: UILabel!
    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private weak var bottlePositionLabel: UILabel!
    @IBOutlet private weak var bottlePositionSlider: UISlider!
    @IBOutlet private weak var angleLabel: UILabel!
    @IBOutlet private weak var angleSlider: UISlider!
    @IBOutlet private weak var speedLabel: UILabel!
    @IBOutlet private weak var speedSlider: UISlider!
    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet weak var rangeLabel: UILabel!
    
    // MARK: Properties
    var game: Game?
    
    // MARK: LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialization
        let player = Player(nickname: "Player Name", score: 0)
        let cannon = Cannon(teta: 45, speed: 50)
        let bottle = Bottle(location: 750, delta: 1)
        
        game = Game(player: player, cannon: cannon, bottle: bottle)
        
        setInitialLayout()
     
    }
    
    @IBAction func throwButtonClicked(_ sender: Any) {
        
        let R = game?.throwTheBall()
        if let R = R {
            rangeLabel.text = "Range: \(String(format: "%.2f", R))m"
        }
        updateBottleState()
        if let state = game?.bottle.state, state == .fellDown{
            game?.player.score += 1
            scoreLabel.text = "\(game?.player.score ?? 0)"
        }
    }
    
    @IBAction func createNewGameBtnTapped(_ sender: Any) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let startVC = storyBoard.instantiateViewController(withIdentifier: "startVC") as? StartViewController else {
            return
        }
        startVC.delegate = self
        present(startVC, animated: true, completion: nil)
        
    }
    @IBAction func bottlePositonChanged(_ sender: Any) {
        let position = String(format: "%.2f", bottlePositionSlider.value)
        bottlePositionLabel.text = "Bottle Position: \(position)m"
        game?.setBottleLocation(location: Double(bottlePositionSlider.value))
    }
    
    @IBAction func angleChanged(_ sender: Any) {
        let angle = String(format: "%.0f", angleSlider.value)
        angleLabel.text = "Angle: \(angle)°"
        game?.setCannon(angle: Double(angleSlider.value), speed: Double(game?.cannon.speed ?? 0))
    }
    
    @IBAction func speedChanged(_ sender: Any) {
        let speed = String(format: "%.0f", speedSlider.value)
        speedLabel.text = "Speed: \(speed)m/s"
        game?.setCannon(angle: game?.cannon.teta ?? 0, speed: Double(speedSlider.value))
    }
    
    private func setInitialLayout(){
        
        guard let game = game else {
            return
        }
        
        nickNameLabel.text = game.player.nickname
        scoreLabel.text = "\(game.player.score)"
        
        let position = String(format: "%.2f", game.bottle.location)
        bottlePositionLabel.text = "Bottle Position: \(position)m"
        bottlePositionSlider.value = Float(game.bottle.location)
        
        let angle = String(format: "%.0f", game.cannon.teta)
        angleLabel.text = "Angle: \(angle)°"
        angleSlider.value = Float(game.cannon.teta)
        
        let speed = String(format: "%.0f", game.cannon.speed)
        speedLabel.text = "Speed: \(speed)m/s"
        speedSlider.value = Float(game.cannon.speed)
        
        updateBottleState()
        
        rangeLabel.text = "Range: "
    }
    
    private func updateBottleState(){
        if let state = game?.bottle.state, state == .fellDown {
            statusLabel.text = "Status: Fell Down"
        }else{
            statusLabel.text = "Status: Standing"
        }
    }
}

extension ViewController: ConfigureNewGameDelegate {
    
    func configureNewGame(playername: String) {
        
        guard let currentGame = game else{
            return
        }
        
        currentGame.setPlayerNickname(name: playername)
        
        // Restart the game with a new player name
        
        let player = currentGame.player
        let cannon = Cannon(teta: 45, speed: 50)
        let bottle = Bottle(location: 750, delta: 1)
        
        game = Game(player: player, cannon: cannon, bottle: bottle)
        
        setInitialLayout()
    }
    
}
