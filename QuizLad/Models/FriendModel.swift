//
//  FriendModel.swift
//  QuizLad
//
//  Created by Sepehr on 3/14/22.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

struct Friend: Hashable {
    var name: String
    var streak: Int
    var points: Int
    var id: String
    
    init(id: String, name: String, points:Int, streak: Int) {
        self.name = name
        self.streak = streak
        self.points = points
        self.id = id
    }
    
    init(id: String, name:String) {
        self.name = name
        self.streak = 0
        self.points = 0
        self.id = id
    }
}

class FriendList: ObservableObject {
    @Published private var _friends: [Friend]
    
    init() {
        _friends = []
    }
    
    func addFriend(friend: Friend) {
        _friends.append(friend)
    }
    
    func loadFriends(){
        let db = Firestore.firestore()
        let userID = UserDefaults.standard.string(forKey: "user_id") ?? "testing12333"
        let docRef = db.collection("users").document(userID)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let friends = document.data()!["friends"] as! [Any]
                let points = document.data()!["points"] as! [[String:Any]]
                self._friends.removeAll()
                
                for j in 0..<friends.count{
                    let docRef2 = db.collection("users").document(friends[j] as! String)
                    docRef2.getDocument { (document2, error2) in
                        if let document2 = document2, document2.exists {
                            let f_n = document2.data()!["name"]!
                            self._friends.append(Friend(id: friends[j] as! String, name: f_n as! String, points:  points[j]["point"] as! Int, streak: points[j]["streak"] as! Int))
                        }
                    }
                }
                
            }
        }
    }
    
    func delQuestion(_ idx: Int) {
        if (_friends.startIndex..<_friends.count).contains(idx) {
            _friends.remove(at: idx)
        }
    }

    func friends() -> [Friend] {
        return _friends
    }

}
