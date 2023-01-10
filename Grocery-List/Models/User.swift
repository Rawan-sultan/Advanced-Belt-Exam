//
//  User.swift
//  Grocery-List
//
//  Created by 라완 💕 on 16/06/1444 AH.
//

import Foundation
import Firebase

struct User {
  
  let uid: String
  let email: String
  
  init(authData: Firebase.User)
  {
    uid = authData.uid
    email = authData.email!
  }
  
  init(uid: String, email: String)
  {
    self.uid = uid
    self.email = email
  }
}
