//
//  GroceriesToBuyTableViewController.swift
//  Grocery-List
//
//  Created by 라완 💕 on 16/06/1444 AH.
//

import UIKit
import Firebase

class GroceriesToBuyTableViewController: UITableViewController {
    
    // MARK: Constants
    let ItemsToUsers = "ItemsToUsers"
    
    // Creating a connection to firebase
    let ref = Database.database().reference(withPath: "grocery-items")
    
    // Monitoring Users Online Status
    let usersRef = Database.database().reference(withPath: "online")
    
    // Variable: Models
    var items: [GroceriesToBuy] = []
    var user: User!
    
    var userCountBarButtonItem: UIBarButtonItem!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsMultipleSelectionDuringEditing = false
        
        userCountBarButtonItem = UIBarButtonItem(title: "1",
                                                 style: .plain,
                                                 target: self,
                                                 action: #selector(userCountButton))

        userCountBarButtonItem.tintColor = UIColor.black
        navigationItem.leftBarButtonItem = userCountBarButtonItem
        
        syncData()
        currentUser()
      }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
      let groceryItem = items[indexPath.row]
      
      cell.textLabel?.text = groceryItem.name
      cell.detailTextLabel?.text = groceryItem.addedByUser
      
      return cell
    }
    
    // Removing items from the Table View
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
      {
          let groceryItem = items[indexPath.row]

          groceryItem.ref?.removeValue()
      }
    }
    
    // Update item in the list
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let groceryItem = items[indexPath.row]
        let name = groceryItem.name

        let alertController = UIAlertController(title: "EDIT", message:"Edit Item", preferredStyle:.alert)

        let updateAction = UIAlertAction(title: "Update", style:.default){(_) in
    
            guard let textField = alertController.textFields?.first,
                  let text = textField.text else { return }
            self.items[indexPath.row].name = text
            let item = ["name": text, "addedByUser": self.user.email, "completed": false]
            self.ref.child(name.lowercased()).updateChildValues(item)

        }
        let cancelAction = UIAlertAction(title: "Cancel", style:.default){(_) in
        }
        alertController.addTextField{(textField) in
            textField.text = name
        }
        alertController.addAction(updateAction)
        alertController.addAction(cancelAction)
        present(alertController, animated:true, completion: nil)
   
    }
    
    // Synchronizing Data to the Table View
    func syncData() {
        ref.queryOrdered(byChild:"completed").observe(.value, with:
            { snapshot in
            var newItems: [GroceriesToBuy] = []
                
            for child in snapshot.children
            {
                if let snapshot = child as? DataSnapshot, let groceryItem = GroceriesToBuy(snapshot: snapshot)
                {
                    newItems.append(groceryItem)
                }
            }
            
            self.items = newItems
            self.tableView.reloadData()
            } )
        
        
    }
    // Observing Authentication State
    func currentUser() {
        Auth.auth().addStateDidChangeListener
        { auth, user in
            guard let user = user else { return }
            self.user = User(authData: user)
            
            let currentUserRef = self.usersRef.child(self.user.uid)
            currentUserRef.setValue(self.user.email)
            currentUserRef.onDisconnectRemoveValue()
        }
        
        usersRef.observe(.value, with:
                            { snapshot in
            if snapshot.exists()
            {
                self.userCountBarButtonItem?.title = snapshot.childrenCount.description
            } else
            {
                self.userCountBarButtonItem?.title = "0"
            }
        } )
    }
    
    
    @objc func userCountButton() {
      performSegue(withIdentifier: ItemsToUsers, sender: nil)
    }
    
    //Adding new items to the list
    @IBAction func addButton(_ sender: AnyObject) {
        let alert = UIAlertController(title: "Grocery Item",
                                      message: "Add an Item",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default)
        { _ in
            
          guard let textField = alert.textFields?.first,
                let text = textField.text else { return }
        
          let groceryItem = GroceriesToBuy(name: text,
                                        addedByUser: self.user.email,
                                           completed: false)
            
          self.ref.child(text.lowercased()).setValue(groceryItem.toAnyObject())

          self.items.append(groceryItem)
          self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addTextField()
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
       }
}
