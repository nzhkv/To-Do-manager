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
    private var storage = UserDefaults.standard
    var storageKey: String = "tasks"
    
    private enum TaskKey: String {
        case title
        case type
        case status
    }
    
    func loadTasks() -> [TaskProtocol] {
        // временная реализация
//        let testTasks: [TaskProtocol] = [
//            Task(title: "Buy milk", type: .normal, status: .planned),
//            Task(title: "Wash kat", type: .important, status: .planned),
//            Task(title: "Buy new vacuumcleaner", type: .important, status: .complited),
//            Task(title: "Learn SWIFT", type: .important, status: .complited),
//            Task(title: "Call parents", type: .important, status: .planned),
//            Task(title: "Invate David, Jack, Leonardo, Will and Brus to the party", type: .important, status: .planned)
//        ]
//        return testTasks
        
        var resultTasks: [TaskProtocol] = []
        let taskFromStorage = storage.array(forKey: storageKey) as? [[String:String]] ?? []
        
        for task in taskFromStorage {
            guard let title = task[TaskKey.title.rawValue],
                  let typeRaw = task[TaskKey.type.rawValue],
                  let statusRaw = task[TaskKey.status.rawValue] else { continue }
            let type: TaskPriority = typeRaw == "important" ? .important : .normal
            let status: TaskStatus = statusRaw == "planned" ? .planned : .complited
            
            resultTasks.append(Task(title: title, type: type, status: status))
        }
        return resultTasks
    }
    
    func saveTasks(_ tasks: [TaskProtocol]) {
        var arrayForStorage: [[String:String]] = []
        tasks.forEach { task in
            var newElementForStorage: Dictionary<String, String> = [:]
            newElementForStorage[TaskKey.title.rawValue] = task.title
            newElementForStorage[TaskKey.type.rawValue] = (task.type == .important) ? "important" : "normal"
            newElementForStorage[TaskKey.status.rawValue] = (task.status == .planned) ? "planned" : "completed"
            arrayForStorage.append(newElementForStorage)
        }
        storage.set(arrayForStorage, forKey: storageKey)
    }
}
