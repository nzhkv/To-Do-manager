//
//  Task.swift
//  To-Do manager
//
//  Created by Nikolay Zhukov on 16.07.2023.
//

import Foundation

enum TaskPriority {
    case normal
    case important
}

enum TaskStatus: Int {
    case complited
    case planned
}

protocol TaskProtocol {
    var title: String { get set }
    var type: TaskPriority { get set }
    var status: TaskStatus { get set }
}

struct Task: TaskProtocol {
    var title: String
    var type: TaskPriority
    var status: TaskStatus
}
