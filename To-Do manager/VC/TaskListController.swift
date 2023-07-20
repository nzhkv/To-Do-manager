//
//  TaskListController.swift
//  To-Do manager
//
//  Created by Nikolay Zhukov on 16.07.2023.
//

import UIKit

class TaskListController: UITableViewController {
    
    var taskStorage: TaskStorageProtocol = TaskStorage()
    var tasks: [TaskPriority: [TaskProtocol]] = [:] {
        didSet {
            for (taskGroupPriority, taskGroup) in tasks {
                tasks[taskGroupPriority] = taskGroup.sorted { task1, task2 in
                    let task1position = taskStatusPosition.firstIndex(of: task1.status) ?? 0
                    let task2position = taskStatusPosition.firstIndex(of: task2.status) ?? 0
                    return task1position < task2position
                }
            }
        }
    }
    var sectionTypesPosition: [TaskPriority] = [.important, .normal]
    var taskStatusPosition: [TaskStatus] = [.planned, .complited]

    override func viewDidLoad() {
        super.viewDidLoad()
        loadTasks()
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    private func loadTasks() {
        sectionTypesPosition.forEach { taskType in
            tasks[taskType] = []
        }
        taskStorage.loadTasks().forEach { task in
            tasks[task.type]?.append(task)
        }
    }
    
    // удаление ячеек
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let taskType = sectionTypesPosition[indexPath.section]
        tasks[taskType]?.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    // перетаскивание ячеек
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let taskTypeFrom = sectionTypesPosition[sourceIndexPath.section]
        let taskTypeTo = sectionTypesPosition[destinationIndexPath.section]
        
        guard let movedTask = tasks[taskTypeFrom]?[sourceIndexPath.row] else { return }
        
        tasks[taskTypeFrom]!.remove(at: sourceIndexPath.row)
        tasks[taskTypeTo]!.insert(movedTask, at: destinationIndexPath.row)
        
        if taskTypeFrom != taskTypeTo {
            tasks[taskTypeTo]![destinationIndexPath.row].type = taskTypeTo
        }
        
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return tasks.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title: String?
        let taskType = sectionTypesPosition[section]
        if taskType == .important {
            title = "Important"
        } else if taskType == .normal {
            title = "Normal"
        }
        return title
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let taskType = sectionTypesPosition[section]
        guard let currentTasksType = tasks[taskType] else { return 0 }
        return currentTasksType.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        return getConfiguredTaskCell_constrains(for: indexPath)
        return getConfiguredTaskCell_stack(for: indexPath)
    }

//    private func getConfiguredTaskCell_constrains(for indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCellConstraints", for: indexPath)
//        let taskType = sectionTypesPosition[indexPath.section]
//        guard let currentTask = tasks[taskType]?[indexPath.row] else { return cell }
//        let symbolLabel = cell.viewWithTag(1) as? UILabel
//        let textLabel = cell.viewWithTag(2) as? UILabel
//
//        symbolLabel?.text = getSymbolForTasks(with: currentTask.status)
//        textLabel?.text = currentTask.title
//
//        if currentTask.status == .planned {
//            textLabel?.textColor = .black
//            symbolLabel?.textColor = .black
//        } else {
//            textLabel?.textColor = .lightGray
//            symbolLabel?.textColor = .lightGray
//        }
//        return cell
//    }
    
    private func getConfiguredTaskCell_stack(for indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCellStack", for: indexPath) as! TaskCell
        let taskType = sectionTypesPosition[indexPath.section]
        guard let currentTask = tasks[taskType]?[indexPath.row] else { return cell }
        cell.title.text = currentTask.title
        cell.symbol.text = getSymbolForTasks(with: currentTask.status)
        
        if currentTask.status == .planned {
            cell.title.textColor = .black
            cell.symbol.textColor = .black
        } else {
            cell.title.textColor = .lightGray
            cell.symbol.textColor = .lightGray
        }
        return cell
    }
    
    private func getSymbolForTasks(with status: TaskStatus) -> String {
        var resultSymbol: String
        if status == .planned {
            resultSymbol = "\u{25CB}"
        } else if status == .complited {
            resultSymbol = "\u{25C9}"
        } else {
            resultSymbol = ""
        }
        return resultSymbol
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let taskType = sectionTypesPosition[indexPath.section]
        guard let _ = tasks[taskType]?[indexPath.row] else { return }
        // Убеждаемся, что задача не является выполненной
        guard tasks[taskType]?[indexPath.row].status == .planned else {
            tableView.deselectRow(at: indexPath, animated: true)
            return
        }
        tasks[taskType]?[indexPath.row].status = .complited
        tableView.reloadSections(IndexSet(arrayLiteral: indexPath.section), with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let taskType = sectionTypesPosition[indexPath.section]
        guard let _ = tasks[taskType]?[indexPath.row] else { return nil }
//        guard tasks[taskType]?[indexPath.row].status == .complited else { return nil }
        
        let actionSwipeInstance = UIContextualAction(style: .normal, title: "not completed") { _, _, _ in
            self.tasks[taskType]![indexPath.row].status = .planned
            self.tableView.reloadSections(IndexSet(arrayLiteral: indexPath.section), with: .automatic)
        }
        
        let actionEditInstance = UIContextualAction(style: .normal, title: "Change") { _, _, _ in
            let editScreen = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "TaskEditController") as! TaskEditController
            
            editScreen.taskText = self.tasks[taskType]![indexPath.row].title
            editScreen.taskType = self.tasks[taskType]![indexPath.row].type
            editScreen.taskStatus = self.tasks[taskType]![indexPath.row].status
            
            editScreen.doAfterEdit = { [unowned self] title, type, status in
                let editedTask = Task(title: title, type: type, status: status)
                tasks[taskType]![indexPath.row] = editedTask
                tableView.reloadData()
            }
            
            self.navigationController?.pushViewController(editScreen, animated: true)
        }
        actionEditInstance.backgroundColor = .darkGray
        
        let actionsConfigurates: UISwipeActionsConfiguration
        if tasks[taskType]![indexPath.row].status == .complited {
            actionsConfigurates = UISwipeActionsConfiguration(actions: [actionSwipeInstance, actionEditInstance])
        } else {
            actionsConfigurates = UISwipeActionsConfiguration(actions: [actionEditInstance])
        }
        
        return actionsConfigurates
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCreateScreen" {
            let destination = segue.destination as! TaskEditController
            destination.doAfterEdit = { [unowned self] title, type, status in
                let newTask = Task(title: title, type: type, status: status)
                tasks[type]?.append(newTask)
                tableView.reloadData()
            }
        }
    }

}
