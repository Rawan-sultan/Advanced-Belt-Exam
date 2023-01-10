//
//  OnlineFamilyUsersTableViewController.swift
//  Grocery-List
//
//  Created by 라완 💕 on 17/06/1444 AH.
//

import UIKit
import Firebase

class OnlineFamilyUsersTableViewController: UITableViewController {
    
    // MARK: Constants
    let OnlineUserCell = "OnlineUserCell"
    
    // Displaying a List of Online Users
    let usersRef = Database.database().reference(withPath: "online")
    
    // MARK: Properties
    var currentUsers: [String] = []
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        onlineUser()
        
    }
    
    // Updating the Online User Count
    func onlineUser() {
        usersRef.observe(.childAdded, with:
                            { snap in
            
            guard let email = snap.value as? String else { return }
            self.currentUsers.append(email)
            
            let indexPath = IndexPath(row: self.currentUsers.count - 1, section: 0)
            
            self.tableView.insertRows(at: [indexPath], with: .top)
        } )
        
        usersRef.observe(.childRemoved, with:
                            { snap in
            
            guard let emailToFind = snap.value as? String else { return }
            for (index, email) in self.currentUsers.enumerated()
            {
                if email == emailToFind
                {
                    let indexPath = IndexPath(row: index, section: 0)
                    self.currentUsers.remove(at: index)
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                }
            }
        } )
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentUsers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OnlineUserCell, for: indexPath)
        let onlineUserEmail = currentUsers[indexPath.row]
        cell.textLabel?.text = onlineUserEmail
        return cell
    }
    
    // Logging Users Out
    @IBAction func signoutClickIt(_ sender: AnyObject) {
        let user = Auth.auth().currentUser!
        let onlineRef = Database.database().reference(withPath: "online/\(user.uid)")
        
        onlineRef.removeValue
        { (error, _) in
            
            if let error = error
            {
                print("Removing online failed: \(error)")
                return
            }
            
            do
            { // this signs out the user from keychain (local)
                try Auth.auth().signOut()
                self.dismiss(animated: true, completion: nil)
            } catch (let error)
            {
                print("Auth sign out failed: \(error)")
            }
        }
    }
}
