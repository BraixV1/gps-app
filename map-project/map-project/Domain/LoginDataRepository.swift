//
//  LoginDataRepository.swift
//  map-project
//
//  Created by Brajan Kukk on 25.12.2024.
//


import Foundation
import SwiftData


@MainActor
class LoginDataRepository: ObservableObject {
    let container: ModelContainer
    
    init(container: ModelContainer) {
        self.container = container
    }
    
    // MARK: - Get All Saved Games
    func getAll() -> [LoginSave] {
        let context = container.mainContext
        do {
            let LoginSaves = try context.fetch(FetchDescriptor<LoginSave>())
            return LoginSaves
        } catch {
            print("Failed to fetch logins: \(error)")
            return []
        }
    }
    
    // MARK: - Load a Specific login
    func get(byId id: UUID) -> LoginSave? {
        let context = container.mainContext
        let descriptor = FetchDescriptor<LoginSave>(
            predicate: #Predicate { $0.Id == id }
        )
        do {
            return try context.fetch(descriptor).first
        } catch {
            print("Failed to fetch login with ID \(id): \(error)")
            return nil
        }
    }
    
    // MARK: - Save a New Game
    func save(login: LoginSave) {
        let context = container.mainContext
        context.insert(login)
        do {
            try context.save()
        } catch {
            print("Failed to save the new game: \(error)")
        }
    }
    
    // MARK: - Update an Existing Game
    func update(login: LoginSave, newLogin: LoginSave) {
        let context = container.mainContext
        do {
            if let existingSave = get(byId: login.Id) {
                existingSave.firstName = newLogin.firstName
                existingSave.lastName = newLogin.lastName
                existingSave.status = newLogin.status
                existingSave.token = newLogin.token
                try context.save()
            } else {
                print("No login found with ID \(login.Id) to update.")
            }
        } catch {
            print("Failed to update the login: \(error)")
        }
    }
    
    // MARK: - Delete an Existing Login
    func delete(login: LoginSave) -> Bool {
        let context = container.mainContext
        
        do {
            if let existingSave = get(byId: login.Id) {
                context.delete(existingSave)
                try context.save()
                return true
            } else {
                print("No login found with ID \(login.Id) to delete.")
                return false
            }
        } catch {
            print("Failed to delete the login: \(error)")
            return false
        }
    }

}
