//
//  Game.swift
//  Game
//
//  Created by Macbook on 2.07.2021.
//

import Foundation

class Game {
    var player: Player
    var cannon: Cannon
    var bottle: Bottle
    
    init(player: Player, cannon: Cannon, bottle: Bottle) {
        self.player = player
        self.cannon = cannon
        self.bottle = bottle
    }
    
    func setPlayerNickname(name: String) {
        player.nickname = name
    }
    
    func setBottleLocation(location: Double) {
        bottle.location = location
    }
    
    func setCannon(angle: Double, speed: Double) {
        cannon.teta = angle
        cannon.speed = speed
    }
    
    func throwTheBall() -> Double {
        let G = 10.0
        let R = cannon.speed * cannon.speed * __sinpi(2 * cannon.teta/180) / G
        
        if((bottle.location - bottle.delta) <= R && (bottle.location + bottle.delta) >= R ) {
            bottle.state = .fellDown
        }else {
            bottle.state = .standing
        }
        return R
    }
}
