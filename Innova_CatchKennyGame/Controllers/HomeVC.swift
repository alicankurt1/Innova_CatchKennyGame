//
//  HomeVC.swift
//  Innova_CatchKennyGame
//
//  Created by Alican Kurt on 29.12.2021.
//

import UIKit

class HomeVC: UIViewController {
    
    // Create Components
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "background")
        return imageView
    }()
    
    private let gameNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Catch The Kenny"
        label.textColor = .orange
        label.font = .boldSystemFont(ofSize: 40)
        label.backgroundColor = .black
        label.textAlignment = .center
        label.layer.masksToBounds = true
        label.layer.cornerRadius = CGFloat(40.0)
        return label
    }()
    
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "kenny")
        imageView.layer.borderWidth = 10.0
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = CGFloat(50.0)
        return imageView
    }()
    
    private let ifYouCanLabel: UILabel = {
        let label = UILabel()
        label.text = "If you can.."
        label.textColor = .orange
        label.font = .boldSystemFont(ofSize: 30)
        label.backgroundColor = .black
        label.textAlignment = .center
        label.layer.masksToBounds = true
        label.layer.cornerRadius = CGFloat(30.0)
        return label
    }()
        
    
    private let startButton: UIButton = {
        let button = UIButton()
        button.setTitle("Start Game", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 35)
        button.backgroundColor = .orange
        button.layer.masksToBounds = true
        button.layer.cornerRadius = CGFloat(20.0)
        return button
    }()
    
    private let scoreTableButton: UIButton = {
        let button = UIButton()
        button.setTitle("Score Table", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 25)
        button.backgroundColor = .orange
        button.layer.masksToBounds = true
        button.layer.cornerRadius = CGFloat(20.0)
        return button
    }()
    
    
    
    private var screenHeight = UIScreen.main.bounds.height
    private var screenWidth = UIScreen.main.bounds.width
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        startButton.addTarget(self, action: #selector(touchDownButton(button:)), for: .touchDown)
        startButton.addTarget(self, action: #selector(didTapStartButton), for: .touchUpInside)
        
        scoreTableButton.addTarget(self, action: #selector(touchDownButton(button:)), for: .touchDown)
        scoreTableButton.addTarget(self, action: #selector(didTapScoreTableButton), for: .touchUpInside)
        
        view.addSubview(backgroundImageView)
        view.addSubview(gameNameLabel)
        view.addSubview(logoImageView)
        view.addSubview(ifYouCanLabel)
        view.addSubview(startButton)
        view.addSubview(scoreTableButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Assign Frames
        backgroundImageView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        gameNameLabel.frame = CGRect(x: 0, y: screenHeight * 0.1, width: screenWidth, height: 50)
        logoImageView.frame = CGRect(x: (screenWidth * 0.5) - (screenWidth * 0.8 / 2), y: screenHeight * 0.2, width: screenWidth * 0.8, height: screenHeight * 0.3)
        ifYouCanLabel.frame = CGRect(x: screenWidth * 0.5 - screenWidth * 0.7 / 2, y: screenHeight * 0.2 + screenHeight * 0.3 + 30, width: screenWidth * 0.7, height: 40)
        startButton.frame = CGRect(x: (screenWidth * 0.5) - (screenWidth * 0.7 / 2), y: screenHeight * 0.72, width: screenWidth * 0.7, height: 50)
        scoreTableButton.frame = CGRect(x: (screenWidth * 0.5) - (screenWidth * 0.5 / 2), y: screenHeight * 0.82, width: screenWidth * 0.5, height: 40)
        
    }
    
    @objc private func touchDownButton(button: UIButton){
        button.backgroundColor = .cyan
        button.setTitleColor(.black, for: .normal)
    }
    
    
    @objc private func didTapStartButton(){
        startButton.backgroundColor = .orange
        startButton.setTitleColor(.white, for: .normal)
        print("Start Button Clicked")
        
        let playingGameVC = PlayingGameVC()
        playingGameVC.modalPresentationStyle = .fullScreen
        present(playingGameVC, animated: false, completion: nil)
    }
    
    @objc private func didTapScoreTableButton(){
        scoreTableButton.backgroundColor = .orange
        scoreTableButton.setTitleColor(.white, for: .normal)
        print("Score Table Button Clicked")
        
        let scoreTableVC = ScoreTableVC()
        scoreTableVC.modalPresentationStyle = .popover
        present(scoreTableVC, animated: true, completion: nil)
    }
    

 

}
