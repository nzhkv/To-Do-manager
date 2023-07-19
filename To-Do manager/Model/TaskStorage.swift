//
//  TaskStorage.swift
//  To-Do manager
//
//  Created by Nikolay Zhukov on 16.07.2023.
//

import Foundation

protocol TaskStorageProtocol {
    func loadTasks() -> [TaskProtocol]
    func saveTasks(_ tasks: [TaskProtocol])
}

class TaskStorage: TaskStorageProtocol {
    func loadTasks() -> [TaskProtocol] {
        // временная реализация
        let testTasks: [TaskProtocol] = [
            Task(title: "Buy milk", type: .normal, status: .planned),
            Task(title: "Wash kat", type: .important, status: .planned),
            Task(title: "Buy new vacuumcleaner", type: .important, status: .complited),
            Task(title: "Learn SWIFT", type: .important, status: .complited),
            Task(title: "Call parents", type: .important, status: .planned),
            Task(title: "Invate David, Jack, Leonardo, Will and Brus to the party", type: .important, status: .planned)
        ]
        return testTasks
    }
    
    func saveTasks(_ tasks: [TaskProtocol]) {
    }
    
    
}
