//
//  ViewController.swift
//  HitList
//
//  Created by Mark Shen on 10/17/21.
//

import UIKit
import CoreData

class ViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!
  var people: [NSManagedObject] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "The List"
    tableView.register(LivingEntityCell.self, forCellReuseIdentifier: "LivingEntityCell")

    
    // Do any additional setup after loading the view.
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }
    let managedContext = appDelegate.persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "LivingEntity")
    do {
      people = try managedContext.fetch(fetchRequest)
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }
  }

  @IBAction func addName(_ sender: Any) {
    let alert = UIAlertController(title: "New Name", message:"Add a new name", preferredStyle: .alert)
    let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned self] action in
      guard let textField = alert.textFields?.first,
            let nameToSave = textField.text else {
        return
      }
      guard let textField = alert.textFields?[1],
            let typeToSave = textField.text else {
        return
      }
      self.save(name:nameToSave, type:typeToSave)
      self.tableView.reloadData()
    }
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
    alert.addTextField()
    alert.addTextField()
    alert.addAction(saveAction)
    present(alert, animated: true)
    
  }
  func save(name: String, type: String) {
    guard let appDelegate =
      UIApplication.shared.delegate as? AppDelegate else {
      return
    }
    let managedContext = appDelegate.persistentContainer.viewContext
    let entity = NSEntityDescription.entity(forEntityName: "LivingEntity", in: managedContext)
    let livingEntity = NSManagedObject(entity: entity!, insertInto: managedContext)
    livingEntity.setValue(name, forKeyPath:"name")
    livingEntity.setValue(type, forKeyPath:"type")
//    person.
    do {
      try managedContext.save()
      people.append(livingEntity)
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo) ")
      
    }
  }
}

extension ViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return people.count
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let person = people[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: "LivingEntityCell", for: indexPath)
    if let livingEntityCell = cell as? LivingEntityCell {
      livingEntityCell.loadWithModel(name:person.value(forKeyPath:"name") as! String, type:person.value(forKeyPath:"type") as! String)
      return livingEntityCell
    }
//    cell.textLabel?.text = person.value(forKeyPath:"name") as? String
    return cell
  }
}

