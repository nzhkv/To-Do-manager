//
//  TaskListController.swift
//  To-Do manager
//
//  Created by Nikolay Zhukov on 16.07.2023.
//

import UIKit

class TaskListController: UITableViewController {
    
    var taskStorage: TaskStorageProtocol = TaskStorage()
    var tasks: [TaskPriority: [TaskProtocol]] = [:]
    var sectionTypesPosition: [TaskPriority] = [.important, .normal]

    override func viewDidLoad() {
        super.viewDidLoad()
        loadTasks()
    }
    
    private func loadTasks() {
        sectionTypesPosition.forEach { taskType in
            print(taskType)
            tasks[taskType] = []
        }
        taskStorage.loadTasks().forEach { task in
            tasks[task.type]?.append(task)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return tasks.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let taskType = sectionTypesPosition[section]
        guard let currentTasksType = tasks[taskType] else { return 0 }
        return currentTasksType.count
    }

//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
//
//        return cell
//    }
//
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
    
//    private func getSymbolForTasks(with status: TaskStatus) -> String {
//        var resultSymbol: String
//        if status == .planned {
//            resultSymbol = "\u{25CB}"
//        } else if status == .complited {
//            resultSymbol = "\u{25C9}"
//        } else {
//            resultSymbol = ""
//        }
//        return resultSymbol
//    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
