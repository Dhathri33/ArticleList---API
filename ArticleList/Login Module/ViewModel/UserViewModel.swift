//
//  UserViewModel.swift
//  ArticleList
//
//  Created by Dhathri Bathini on 10/1/25.
//
import UIKit

protocol UserViewModelProtocol {
    var users: [User] { get set }
    func checkLoginCredentials(username: String, password: String) -> Bool
    func validateValueifPresent(_ field: String) -> Bool
    func validateLength(_ password: String) -> Bool
    func validateUser(_ username: String, _ password: String) -> Bool
}

class UserViewModel: UserViewModelProtocol {
    
    var users: [User] = []
    
    init() {
        users = User.sampleData()
    }
    
    func checkLoginCredentials(username: String, password: String) -> Bool {
        users.contains { $0.username == username && $0.password == password }
    }
    
    func validateValueifPresent(_ field: String) -> Bool{
        if field.isEmpty {
            return false
        }
        return true
    }
    
    //MARK: Validate the length
    
    func validateLength(_ password: String) -> Bool {
        if password.count < 4 {
            return false
        }
        return true
    }
    
    //MARK: Validate User
    
    func validateUser(_ username: String, _ password: String) -> Bool {
        if ((!validateValueifPresent(username)) && (!validateValueifPresent(password))) {
            print("Enter one of the missing fields")
            return false
        }
        else if !validateLength(password) {
            print("Password must be at least 5 characters long")
            return false
        }
        else {
            return true
        }
    }
}

