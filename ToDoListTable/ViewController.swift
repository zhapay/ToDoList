//
//  ViewController.swift
//  ToDoListTable
//
//  Created by Dastan Zhapay on 24.05.2021.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private let cellId = "cellId"
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let tableView: UITableView = {
       let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "To Do List"
        
        view.addSubview(tableView)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
        fetchName()
        setupConstraints()
    }
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc func didTapAdd(){
        print("Hello world")
        let alert = UIAlertController(title: "TASK", message: "What is your task for today?", preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        let addButton = UIAlertAction(title: "Add", style: .cancel, handler: {_ in
            guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else{return}
            self.createItem(item: text)
        })
        alert.addAction(addButton)
        present(alert, animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return person.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let selectedIndex = person[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.textLabel?.text = selectedIndex.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let personName = person[indexPath.row]
        let deleteButton = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            self.deleteItem(item: personName)
        }
        return UISwipeActionsConfiguration(actions: [deleteButton])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedIndex = person[indexPath.row]
        let alert = UIAlertController(title: "EDIT", message: "Edit your task", preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.textFields?.first?.text = selectedIndex.name
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: {_ in
            guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else{return}
            self.updateItem(item: selectedIndex, newPerson: text)
            
        }))
        present(alert, animated: true, completion: nil)
    }
    
    var person = [Person]()
    
    func fetchName(){
        do{
            self.person = try context.fetch(Person.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }catch{
        }
    }
    
    func createItem(item: String){
        let name = Person(context: context)
        name.name = item
        do{
            try context.save()
            fetchName()
        }catch{

        }
    }
    
    func deleteItem(item: Person){
        context.delete(item)
        do{
            try context.save()
            fetchName()
        }catch{
            
        }
    }
    
    func updateItem(item: Person, newPerson: String){
        item.name = newPerson
        do{
            try context.save()
            fetchName()
        }catch{
            
        }
    }


}


