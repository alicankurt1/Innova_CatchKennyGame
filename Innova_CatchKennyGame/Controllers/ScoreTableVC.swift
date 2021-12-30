//
//  ScoreTableVC.swift
//  Innova_CatchKennyGame
//
//  Created by Alican Kurt on 29.12.2021.
//

import UIKit

class ScoreTableVC: UIViewController {
    
    
    
    private let scoreTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .black
        return tableView
    }()
    
    
    
    
    var scores : [ScoreTableModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scoreTableView.delegate = self
        scoreTableView.dataSource = self
        
        view.addSubview(scoreTableView)
        
        getScoresData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scoreTableView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height * 0.08, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.92)
    }
    
    private func getScoresData(){
        CoreDataManager.shared.getScoresData {[weak self] result  in
            switch result{
            case .failure(let error):
                print(error)
            case .success(let scoreTable):
                self?.scores = scoreTable
                self?.scores.sort { (lhs:ScoreTableModel, rhs:ScoreTableModel) in
                    return lhs.score > rhs.score
                }
                self?.scores.sort { (lhs:ScoreTableModel, rhs:ScoreTableModel) in
                    return lhs.levelInt > rhs.levelInt
                }
            }
        }
    }


}

extension ScoreTableVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.backgroundColor = .black
        cell.textLabel?.textColor = .orange
        cell.textLabel?.font = .boldSystemFont(ofSize: 18)
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.text = "N: \(scores[indexPath.row].allias)      S: \(scores[indexPath.row].score)      L: \(scores[indexPath.row].level)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "SCORE TABLE"
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.orange
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = .white
        header.textLabel?.textAlignment = .center
        header.textLabel?.font = .boldSystemFont(ofSize: 25)
    }
    
    
}
