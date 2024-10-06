//
//  DatabaseManager.swift
//  MonsterVault
//
//  Created by Junhao Qu on 2/4/24.
//

import Foundation
import UIKit
import FSCalendar
import SnapKit
import FirebaseDatabase
import FirebaseAuth


//store detail and user id
class UserManager{
    static var cuser:User?
    static var detailarr: [String.SubSequence]! = []
}
//store databse
class DatabaseManager {
    static let shared = DatabaseManager()
    let databaseRef = Database.database().reference()
    private init(){
        
    }
    
    //set the boolean to 0 (when the account be created) which reprsent whther the user is new. 1 means don't show instruction page, 0 means show instruction page
    public func setDefaultBool(uid: String) {
        let defaultBool: [String: Any] = [
            "uid": uid,
            "bool": 0
        ]
        let instructionRef = databaseRef.child("instruction").child(uid)
        instructionRef.setValue(defaultBool)
    }
    //get the boolean which reprsent whther the user is new. 1 means don't show instruction page, 0 means show instruction page
    public func getInstructionData(uid: String, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        databaseRef.child("instruction").child(uid).observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value as? [String: Any] else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            completion(.success(value))
        }
    }
    //updata boolean which reprsent whther the user is new. 1 means don't show instruction page, 0 means show instruction page
    public func updateBool(uid: String) {
        getInstructionData(uid: uid) { result in
            switch result {
            case .success(let instructionData):
                guard let currentBool = instructionData["bool"] as? Double else {
                    print("ERROR!")
                    return
                }
                let updatedBool = currentBool + 1
                let instructionRef = self.databaseRef.child("instruction").child(uid)
                instructionRef.updateChildValues(["bool": updatedBool]) { error, _ in
                    if let error = error {
                        print("Error to update!!!!")
                    } else {
                        print("Success to update bool!!!!")
                    }
                }
            case .failure(let error):
                print("Fail to get instruction data")
            }
        }
        
    }
    //add income data to the database
    public func addIncome(uid: String, amount: Double, source: String, date: String, detail: String) {
        let incomeRef = databaseRef.child("income").childByAutoId()
        let incomeData: [String: Any] = [
            "uid": uid,
            "amount": amount,
            "source": source,
            "date": date,
            "detail": detail
        ]
        incomeRef.setValue(incomeData)
    }
    //add expense data to the database
    public func addExpense(uid: String, amount: Double, category: String, date: String, detail:String) {
        let expenseRef = databaseRef.child("expense").childByAutoId()
        let expenseData: [String: Any] = [
            "uid": uid,
            "amount": amount,
            "category": category,
            "date": date,
            "detail": detail
        ]
        expenseRef.setValue(expenseData)
    }
    //add pet data to the database
    public func addPet(uid: String, experience: Double, level: Double) {
        let petRef = databaseRef.child("pet").childByAutoId()
        let petData: [String: Any] = [
            "uid": uid,
            "experience": experience,
            "level": level,
        ]
        petRef.setValue(petData)
    }
    //add point data to the database
    public func addPoint(uid: String, point: Double, bags: Double) {
        let pointRef = databaseRef.child("point").childByAutoId()
        let pointData: [String: Any] = [
            "uid": uid,
            "point": point,
            "bags": bags
        ]
        pointRef.setValue(pointData)
    }
    //get income data from database
    public func getAllIncome(with uid: String, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        databaseRef.child("income").queryOrdered(byChild: "uid").queryEqual(toValue: uid).observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value as? [String: Any] else {
                print("Error!")
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            print("Success!")
            completion(.success(value))
        })
    }
    //get expense data for other methods except stats from database
    public func getAllExpense(with uid:String, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        databaseRef.child("expense").queryOrdered(byChild: "uid").queryEqual(toValue: uid).observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value as? [String: Any] else {
                print("Error epxense!")
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            print("Success!")
            completion(.success(value))
        })
    }
    //get expense data for stats
    public func getAllExpense2(with uid:String, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        databaseRef.child("expense").queryOrdered(byChild: "uid").queryEqual(toValue: uid).observeSingleEvent(of: .value, with: { snapshot in
            if snapshot.exists() {
                guard let value = snapshot.value as? [String: Any] else {
                    completion(.failure(DatabaseError.failedToFetch))
                    return
                }
                print("Success!")
                completion(.success(value))
            } else {
                // No expense data found for the specific UID
                print("No expense data found for the specific UID")
                completion(.success([:])) // Return an empty dictionary as a success result
            }
        })
    }

    
    // update points when buying a bag of pet food
    public func buyPetFood(uid: String, currentBags: Double, currentPoints: Double, completion: @escaping (Result<(), Error>) -> Void) {
        guard currentPoints >= 10 else {
            completion(.failure(DatabaseError.insufficientPoints))
            return
        }
        //calculate points and bags
        let updatedPoints = currentPoints - 10
        let updatedBags = currentBags + 1
        // update the point table
        let pointRef = self.databaseRef.child("point").child(uid)
        let pointData: [String: Any] = [
            "point": updatedPoints,
            "bags": updatedBags
        ]
        pointRef.updateChildValues(pointData) { error, _ in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    //feed the pet with pet food
    public func feedPet(uid: String, currentBags: Double, currentExperience: Double, currentLevel: Double, completion: @escaping (Result<(), Error>) -> Void) {
        // check if there are enough bags of pet food
        guard currentBags > 0 else {
            // Not enough bags
            completion(.failure(DatabaseError.insufficientPetFood))
            return
        }
        var updatedBags = currentBags - 1
        var updatedExperience = currentExperience + 20 // Assuming feeding adds 20 experience per bag
        var updatedLevel = currentLevel

        // check if the pet has reached a specific amount of experience to level up
        if updatedExperience >= 100 { // here I set the limit is 100 value
            updatedExperience = 0
            updatedLevel += 1
        }
        // update the pet table
        let petRef = databaseRef.child("pet").child(uid)
        let petData: [String: Any] = [
            "experience": updatedExperience,
            "level": updatedLevel,
        ]
        petRef.updateChildValues(petData) { error, _ in
            if let error = error {
                completion(.failure(error))
            } else {
                // update the number of bags of pet food
                let pointRef = self.databaseRef.child("point").child(uid)
                pointRef.updateChildValues(["bags": updatedBags]) { error, _ in
                    if let error = error {
                        
                        completion(.failure(error))
                    } else {
                    
                        completion(.success(()))
                    }
                }
            }
        }
    }
    
    //get the user's pet's expreience and level
    public func getPetData(uid: String, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        databaseRef.child("pet").child(uid).observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value as? [String: Any] else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            completion(.success(value))
        }
    }
    // get point data from the database
    public func getPointData(uid: String, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        databaseRef.child("point").child(uid).observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value as? [String: Any] else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            completion(.success(value))
        }
    }
    //update points for recording expense
    public func updatePoints(uid: String) {
        getPointData(uid: uid) { result in
            switch result {
            case .success(let pointData):
                guard let currentPoint = pointData["point"] as? Double else {
                    print("ERROR!")
                    return
                }
                let updatedPoint = currentPoint + 3
                let pointRef = self.databaseRef.child("point").child(uid)
                pointRef.updateChildValues(["point": updatedPoint]) { error, _ in
                    if let error = error {
                        print("Error to update!!!!")
                    } else {
                        print("Success to update points!!!!")
                    }
                }
            case .failure(let error):
                print("Fail to get point data")
            }
        }
        
    }
    // set default points for a new user
    public func setDefaultPoints(uid: String) {
        let defaultPoints: [String: Any] = [
            "uid": uid,
            "point": 20,  // set default points to 10
            "bags": 0
        ]
        
        let pointRef = databaseRef.child("point").child(uid)
        pointRef.setValue(defaultPoints)
    }
    
    // set default pet for a new user
    public func setDefaultPet(uid: String) {
        let defaultPet: [String: Any] = [
            "uid": uid,
            "experience": 0,
            "level": 0,
        ]
        let petRef = databaseRef.child("pet").child(uid)
        petRef.setValue(defaultPet)
    }



}


