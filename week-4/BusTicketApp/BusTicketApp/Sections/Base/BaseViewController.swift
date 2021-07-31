//
//  BaseViewController.swift
//  BusTicketApp
//
//  Created by ALEMDAR on 31.07.2021.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        configureNavigationBar()
    }
    
    private func configureNavigationBar(){
        let navigationBar = navigationController?.navigationBar
        navigationBar?.isTranslucent = false
        navigationBar?.tintColor = .white
        navigationBar?.barTintColor = UIColor.rgba(red: 6, green: 17, blue: 82, alpha: 1)
        navigationBar?.barStyle = .black
        navigationBar?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    func setNavigationBarTitle(title: String) {
        navigationItem.title = title
    }
    
    func setViewBackgroundColor(color: UIColor){
        view.backgroundColor = color
    }
    
    func hideNavigationBar() {
        navigationController?.navigationBar.isHidden = true
    }
    
    func showNavigationBar() {
        navigationController?.navigationBar.isHidden = false
    }
    
    func hideBackButton(){
        navigationItem.setHidesBackButton(true, animated: true)
    }

}
