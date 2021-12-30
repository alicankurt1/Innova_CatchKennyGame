//
//  CoreDataManager.swift
//  Innova_CatchKennyGame
//
//  Created by Alican Kurt on 29.12.2021.
//

import Foundation
import UIKit
import CoreData


class CoreDataManager{
    
    public static let shared = CoreDataManager()
    
        
    public func getScoresData(completion: @escaping (Result<[ScoreTableModel],Error>) -> Void){
        var scores: [ScoreTableModel] = []
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Scores")
        fetchRequest.returnsObjectsAsFaults = false
        
        do{
            let results = try context.fetch(fetchRequest)
            for result in results as! [NSManagedObject] {
                guard let allias = result.value(forKey: "allias") as? String,
                      let score = result.value(forKey: "score") as? Int,
                      let level = result.value(forKey: "level") as? String,
                      let levelInt = result.value(forKey: "level_int") as? Int else{
                          print("Get Data Guard Let Error")
                          completion(.failure(GetDataError.FailedToGetData))
                          return
                }
                scores.append(ScoreTableModel(allias: allias, score: score, level: level, levelInt: levelInt))
            }
            completion(.success(scores))
        }catch{
            print("Get Data Error")
            completion(.failure(GetDataError.FailedToGetData))
        }
    }
    
    
}

public enum GetDataError: Error{
    case FailedToGetData
}
