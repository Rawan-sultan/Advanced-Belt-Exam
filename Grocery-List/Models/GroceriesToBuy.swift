//
//  GroceriesToBuy.swift
//  Grocery-List
//
//  Created by 라완 💕 on 16/06/1444 AH.
//

import Foundation
import Firebase

struct GroceriesToBuy {
  
  let ref: DatabaseReference?
  let key: String
  var name: String
  var addedByUser: String
  var completed: Bool
  
  init(name: String, addedByUser: String, completed: Bool, key: String = "")
  {
    self.ref = nil
    self.key = key
    self.name = name
    self.addedByUser = addedByUser
    self.completed = completed
  }
  
  init?(snapshot: DataSnapshot)
  {
    guard
      let value = snapshot.value as? [String: AnyObject],
      let name = value["name"] as? String,
      let addedByUser = value["addedByUser"] as? String,
      let completed = value["completed"] as? Bool else
  {
      return nil
  }
    
    self.ref = snapshot.ref
    self.key = snapshot.key
    self.name = name
    self.addedByUser = addedByUser
    self.completed = completed
  }
  
  func toAnyObject() -> Any {
    return [
      "name": name,
      "addedByUser": addedByUser,
      "completed": completed
    ]
  }
}


