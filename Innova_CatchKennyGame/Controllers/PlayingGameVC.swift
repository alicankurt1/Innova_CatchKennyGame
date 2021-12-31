//
//  ViewController.swift
//  Innova_CatchKennyGame
//
//  Created by Alican Kurt on 28.12.2021.
//

import UIKit
import CoreData

class PlayingGameVC: UIViewController {

    // Create Components
    private let kennyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "kenny")
        imageView.isHidden = true
        imageView.isUserInteractionEnabled = true
        imageView.layer.borderWidth = 2.0
        imageView.layer.borderColor = UIColor.white.cgColor
        return imageView
    }()
    
    private let cartmanImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "cartman")
        imageView.isHidden = true
        imageView.isUserInteractionEnabled = true
        imageView.layer.borderWidth = 2.0
        imageView.layer.borderColor = UIColor.white.cgColor
        return imageView
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "Time: 15"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 32.0)
        return label
    }()
    
    private let scoreLabel: UILabel = {
        let label = UILabel()
        label.text = "Your Score: 0"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 23.0)
        label.layer.masksToBounds = true
        label.layer.cornerRadius = CGFloat(20.0)
        return label
    }()
    
    private let bestScoreLabel: UILabel = {
        let label = UILabel()
        label.text = "Best Score: 0"
        label.textColor = .cyan
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18.0)
        return label
    }()
    
    private let stopButton: UIButton = {
        let button = UIButton()
        button.setTitle("Stop", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.backgroundColor = .red
        button.isHidden = true
        button.layer.masksToBounds = true
        button.layer.cornerRadius = CGFloat(10.0)
        return button
    }()
    
    
    private let tryAgainButton: UIButton = {
        let button = UIButton()
        button.setTitle("Try Again", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 35)
        button.backgroundColor = .orange
        button.isHidden = true
        button.layer.masksToBounds = true
        button.layer.cornerRadius = CGFloat(10.0)
        return button
    }()
    

    
    
    private let screenHeight = UIScreen.main.bounds.height
    private let screenWidth = UIScreen.main.bounds.width
    
    private var timeTimer = Timer()
    private var kennyTimer = Timer()
    private var gameCount = 0
    private let kennyCoordinate = UIScreen.main.bounds.width/4 - 10
    
    private var score = 0
    private var choosenLevel = ""
    private var choosenLevelInt = 0
    private var bestScore : ScoreTableModel?
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        stopButton.addTarget(self, action: #selector(didTouchDownButton(button:)), for: .touchDown)
        stopButton.addTarget(self , action: #selector(didTapStopButton(button:)), for: .touchUpInside)
        
        tryAgainButton.addTarget(self, action: #selector(didTouchDownButton(button:)), for: .touchDown)
        tryAgainButton.addTarget(self, action: #selector(didTapTryAgainButton), for: .touchUpInside)
        
        
        view.addSubview(kennyImageView)
        view.addSubview(cartmanImageView)
        view.addSubview(timeLabel)
        view.addSubview(scoreLabel)
        view.addSubview(bestScoreLabel)
        view.addSubview(stopButton)
        view.addSubview(tryAgainButton)
        
        let kennyRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapKenny))
        let cartmanRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapCartman))
        kennyImageView.addGestureRecognizer(kennyRecognizer)
        cartmanImageView.addGestureRecognizer(cartmanRecognizer)
        
        
                
        
        DispatchQueue.main.async {
            self.startAlert(title: "Catch The Kenny", message: "You will show Kenny and Cartman. You should tap to Kenny picture.\n\nNote: Be careful not to tap on Cartman's picture.\n\nShall we begin?")
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Asign frames
        timeLabel.frame = CGRect(x: 0, y: screenHeight * 0.07, width: screenWidth, height: 50)
        bestScoreLabel.frame = CGRect(x: 0, y: screenHeight * 0.08 + 30, width: screenWidth, height: 50)
        scoreLabel.frame = CGRect(x: screenWidth * 0.5 - screenWidth * 0.3, y: screenHeight * 0.08 + 75, width: screenWidth * 0.6, height: 35)
        stopButton.frame = CGRect(x: screenWidth * 0.79,y: screenHeight * 0.08, width: screenWidth * 0.2, height: 30)
        tryAgainButton.frame = CGRect(x: screenWidth * 0.5 - screenWidth * 0.25, y: screenHeight * 0.5 - 25, width: screenWidth * 0.5, height: 50)
    }
    
    private func getBestScore(){
        CoreDataManager.shared.getScoresData {[weak self] result  in
            switch result{
            case .failure(let error):
                print(error)
            case .success(let scoreTable):
                if var scoreArray = scoreTable as? [ScoreTableModel], !scoreTable.isEmpty{
                    scoreArray.sort { (lhs:ScoreTableModel, rhs:ScoreTableModel) in
                        return lhs.score > rhs.score
                    }
                    scoreArray.sort { (lhs:ScoreTableModel, rhs:ScoreTableModel) in
                        return lhs.levelInt > rhs.levelInt
                    }
                    guard let bestScore = scoreArray.first! as? ScoreTableModel else{
                        return
                    }
                    self?.bestScore = bestScore
                }
            }
        }
        
    }
    
    // Start Game
    private func startGame(level: Float){
        getBestScore()
        if let safeBestScore = bestScore{
            bestScoreLabel.text = "Best Score: \(safeBestScore.allias) \(safeBestScore.score) \(safeBestScore.level)"
        }else{
            bestScoreLabel.text = "Best Score: 0"
        }
        
        score = 0
        gameCount = 15
        timeLabel.text = "Time: \(gameCount)"
        scoreLabel.text = "Your Score: 0"
        timeTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
        kennyTimer = Timer.scheduledTimer(timeInterval: TimeInterval(level), target: self, selector: #selector(showKennyAndCartman), userInfo: nil, repeats: true)
        stopButton.isHidden = false
        tryAgainButton.isHidden = true
    }
    
    // Game Time Count
    @objc private func countDown(){
        gameCount -= 1
        timeLabel.text = "Time: \(gameCount)"
        if gameCount <= 0{
            timeTimer.invalidate()
            kennyTimer.invalidate()
            kennyImageView.isHidden = true
            cartmanImageView.isHidden = true
            stopButton.isHidden = true
                       
            guard let score = scoreLabel.text else{
                return
            }
            gameOverAlert(title: "Game Over", message: "Your \(score)")
        }
        
    }
    
    
    // Show Kenny and Cartman
    @objc private func showKennyAndCartman(){
        scoreLabel.backgroundColor = .black
        
        kennyImageView.isHidden = false
        cartmanImageView.isHidden = false
        // Asign frames
        
        let randomKenny_X = Int.random(in: 0..<4)
        let randomKenny_Y = Int.random(in: 2..<7)
        
        var randomCartman_X = Int.random(in: 0..<4)
        var randomCartman_Y = Int.random(in: 2..<7)
        
        while(randomKenny_X == randomCartman_X && randomKenny_Y == randomCartman_Y){
            randomCartman_X = Int.random(in: 0..<4)
            randomCartman_Y = Int.random(in: 2..<7)
        }
        
        kennyImageView.frame = CGRect(x: (kennyCoordinate + 10) * CGFloat(randomKenny_X), y: (kennyCoordinate + 12) * CGFloat(randomKenny_Y), width: kennyCoordinate, height: kennyCoordinate)
        cartmanImageView.frame = CGRect(x: (kennyCoordinate + 10) * CGFloat(randomCartman_X), y: (kennyCoordinate + 12) * CGFloat(randomCartman_Y), width: kennyCoordinate, height: kennyCoordinate)
    }
    
    
    // Did Tap Kenny -> Score + 1
    @objc private func didTapKenny(){
        score += 1
        scoreLabel.text = "Your Score: \(score)"
        scoreLabel.backgroundColor = .green
    }
    
    // Did Tap Cartman -> Score - 1
    @objc private func didTapCartman(){
        if score > 0{
            score -= 1
        }
        scoreLabel.text = "Your Score: \(score)"
        scoreLabel.backgroundColor = .red
    }
    
    
    // Stop Button
    @objc private func didTouchDownButton(button: UIButton){
        button.backgroundColor = .cyan
        button.setTitleColor(.black, for: .normal)
    }
    
    @objc private func didTapStopButton(button: UIButton){
        button.backgroundColor = .red
        button.setTitleColor(.white, for: .normal)
        
        button.isHidden = true
        
        timeTimer.invalidate()
        kennyTimer.invalidate()
        kennyImageView.isHidden = true
        cartmanImageView.isHidden = true
        
        DispatchQueue.main.async {
            self.startAlert(title: "Catch The Kenny", message: "You will show Kenny and Cartman. You should tap to Kenny picture.\n\nNote: Be careful not to tap on Cartman's picture.\n\nShall we begin?")
        }
    }
    
    // Try Again Button
    @objc private func didTapTryAgainButton(){
        startAlert(title: "Catch The Kenny", message: "You will show Kenny and Cartman. You should tap to Kenny picture.\n\nNote: Be careful not to tap on Cartman's picture.\n\nShall we begin?")
    }
    
    
    // Start Game Alert
    private func startAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
               
        let startButton = UIAlertAction(title: "Start", style: .default) { [weak self] _ in
            self?.chooseLevelAlert(title: "Difficulty Level", message: "Choose your difficulty level")
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) {[weak self] _ in
            let homeVC = HomeVC()
            homeVC.modalPresentationStyle = .fullScreen
            self?.present(homeVC, animated: false, completion: nil)
        }

        alert.addAction(startButton)
        alert.addAction(cancelButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    // Choose Level Alert
    private func chooseLevelAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
               
        let beginnerButton = UIAlertAction(title: "Beginner", style: .default) { [weak self] _ in
            self?.startGame(level: 0.9)
            self?.choosenLevel = "Beginner"
            self?.choosenLevelInt = 1
        }
        let normalButton = UIAlertAction(title: "Normal", style: .default) { [weak self] _ in
            self?.startGame(level: 0.4)
            self?.choosenLevel = "Normal"
            self?.choosenLevelInt = 2
        }
        let challengingButton = UIAlertAction(title: "Challenging", style: .default) { [weak self] _ in
            self?.startGame(level: 0.25)
            self?.choosenLevel = "Challenging"
            self?.choosenLevelInt = 3
        }


        alert.addAction(beginnerButton)
        alert.addAction(normalButton)
        alert.addAction(challengingButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    // Game Over Alert
    private func gameOverAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addTextField { alliasField in
            alliasField.placeholder = "Enter your allias"
        }
        
        let startButton = UIAlertAction(title: "Try Again", style: .default) { [weak self] _ in
            self?.chooseLevelAlert(title: "Difficulty Level", message: "Choose your difficulty level")
        }
        let saveButton = UIAlertAction(title: "Save", style: .default) {[weak self] _ in
            print("Save Clicked")
            guard let allias = alert.textFields![0].text, !allias.isEmpty else{
                return
            }
            
            // Save Core Data
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let newScore = NSEntityDescription.insertNewObject(forEntityName: "Scores", into: context)
            
            newScore.setValue(allias, forKey: "allias")
            newScore.setValue(self?.score, forKey: "score")
            newScore.setValue(self?.choosenLevel, forKey: "level")
            newScore.setValue(self?.choosenLevelInt, forKey: "level_int")
            newScore.setValue(UUID(), forKey: "id")
            
            do{
                try context.save()
                self?.tryAgainButton.isHidden = false
                let scoreTableVC = ScoreTableVC()
                scoreTableVC.modalPresentationStyle = .popover
                self?.present(scoreTableVC, animated: true, completion: nil)
            }catch{
                print("Saving Error")
            }
            
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) {[weak self] _ in
            let homeVC = HomeVC()
            homeVC.modalPresentationStyle = .fullScreen
            self?.present(homeVC, animated: false, completion: nil)
        }
        
        alert.addAction(saveButton)
        alert.addAction(startButton)
        alert.addAction(cancelButton)
        self.present(alert, animated: true, completion: nil)
    }


}




