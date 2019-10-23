//
//  TaskVC.swift
//  TaskList
//
//  Created by Moiz Khan on 2019-10-11.
//  Copyright © 2019 MK. All rights reserved.
//  Sheridan ID 9914774771 || UserName : khmoiz

import UIKit

class TaskVC: UITableViewController {
    
    private var taskList = [Task]()
    let taskController = TaskController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Todo Task List:"
        self.fetchAllTask()
        self.setupLongPressGesture()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_task", for: indexPath) as! TaskCell
        
        if indexPath.row < taskList.count
        {
            let task = taskList[indexPath.row]
            cell.lblTitle?.text = task.title
            cell.lblSubtitle?.text = task.subtitle
            
            let accessory: UITableViewCell.AccessoryType = task.done ? .checkmark : .none
            cell.accessoryType = accessory
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row < taskList.count
        {
            let taskTemp = taskList[indexPath.row]
            taskTemp.done = !taskTemp.done
            
            //Update the task.done (boolean) value by passing the object
            taskController.updateTaskDone(task: taskTemp)
            
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        if indexPath.row < taskList.count
        {
            self.deleteTask(indexPath: indexPath)
        }
    }
    
    @IBAction func onAddClick(_ sender: UIBarButtonItem) {
        // Create an alert
        let alert = UIAlertController(
            title: "New task",
            message: "Enter the new task details",
            preferredStyle: .alert)
        
        // Add a text field to the alert for the new item's title
        alert.addTextField{(textField : UITextField) in
            textField.placeholder = "What is the main goal?"
        }
        alert.addTextField { (textField: UITextField) in
            textField.keyboardAppearance = .dark
            textField.keyboardType = .default
            textField.autocorrectionType = .default
            textField.placeholder = "A bit more detail..?"
        }
        
        // Add a "cancel" button to the alert. This one doesn't need a handler
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        // Add a "OK" button to the alert. The handler calls addNewToDoItem()
        alert.addAction(UIAlertAction(title: "Add Task", style: .default, handler: { _ in
            if let title = alert.textFields?[0].text, let subtitle = alert.textFields?[1].text
            {
                self.addTask(title: title, subtitle: subtitle, rDone: false , insert: true)
                
            }
        }))
        
        // Present the alert to the user
        self.present(alert, animated: true, completion: nil)
    }
    
    func setupLongPressGesture() {
        let longPressGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress))
        longPressGesture.minimumPressDuration = 1.0 // 1 second press
        self.tableView.addGestureRecognizer(longPressGesture)
    }
    
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer){
        if gestureRecognizer.state == .ended {
            let touchPoint = gestureRecognizer.location(in: self.tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                self.displayEditAlert(indexPath: indexPath)
            }
        }
    }
    
    private func displayEditAlert(indexPath: IndexPath){
        
        // Create an alert
        let alert = UIAlertController(
            title: "Edit task",
            message: "Enter the updated task details",
            preferredStyle: .alert)
        
        // Add a text field to the alert for the new item's title
        alert.addTextField{(textField : UITextField) in
            textField.text = self.taskList[indexPath.row].title
        }
        alert.addTextField { (textField: UITextField) in
            textField.text = self.taskList[indexPath.row].subtitle
        }
        
        // Add a "cancel" button to the alert. This one doesn't need a handler
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        // Add a "OK" button to the alert. The handler calls addNewToDoItem()
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            if let title = alert.textFields?[0].text, let subtitle = alert.textFields?[1].text
            {
                self.editTask(indexPath: indexPath, title: title, subtitle: subtitle)
            }
        }))
        
        // Present the alert to the user
        self.present(alert, animated: true, completion: nil)
    }
    
    private func addTask(title: String, subtitle: String, rDone: Bool, insert: Bool)
    {
        // The index of the new item will be the current item count
        let newIndex = taskList.count
        
        // Create new item and add it to the task list
        var newT = Task(title: title, subtitle: subtitle)
        if (insert){
            //To make sure we dont add the same task twice to the database
            taskController.insertTask(newTask : newT)
        }else{
            newT.done = rDone
        }
        taskList.append(newT)
        
        // Tell the table view a new row has been created
        tableView.insertRows(at: [IndexPath(row: newIndex, section: 0)], with: .top)
        tableView.reloadData()
    }
    
    private func deleteTask(indexPath: IndexPath){
        
        //get task to remove from list to make sure we can remove from the database later
        var temp = taskList[indexPath.row]
        
        //remove item from task list
        taskList.remove(at: indexPath.row)
        
        taskController.deleteTask(task: temp)
        //delete the row from table view
        tableView.deleteRows(at: [indexPath], with: .top)
        
        tableView.reloadData()
    }
    
    private func editTask(indexPath: IndexPath, title: String, subtitle: String){
        
        var newTemp = Task(title: title, subtitle: subtitle)
        var temp = Task(title: taskList[indexPath.row].title, subtitle: taskList[indexPath.row].subtitle )
        taskList[indexPath.row].title = title
        taskList[indexPath.row].subtitle = subtitle
        taskController.updateTask(task: temp, newTask: newTemp)
        tableView.reloadData()
    }
    
    func fetchAllTask(){
        var allTask = self.taskController.getAllTasks()
        var doneTemp: Bool = false
        if (allTask != nil){
            for task in allTask!{
                doneTemp = task.value(forKey: "done")  as! Bool
                self.addTask(title: task.value(forKey: "title") as! String , subtitle: task.value(forKey: "subtitle") as! String , rDone: doneTemp, insert: false)
            }
        }
    }
}

