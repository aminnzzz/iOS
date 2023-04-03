//
//  QuestionModel.swift
//  QuizLad
//
//  Created by Sepehr on 3/14/22.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

struct Question: Hashable {
    var prompt: String
    var options: [String]
    var sender: String
    var reciever: String
    
    init(pr: String, opt: [String], snd:String, rec: String) {
        prompt = pr
        options = opt
        sender = snd
        reciever = rec
    }
    
    init(pr: String, op1: String,op2: String,op3: String,op4: String, snd:String, rec: String) {
        prompt = pr
        options = [op1,op2,op3,op4]
        sender = snd
        reciever = rec
    }
}

class QuestionList: ObservableObject {
    @Published private var _questions: [Question]
    @Published private var _selection: Int = -1
    
    init() {
        _questions = []
    }

    func loadQuestions(){
        let db = Firestore.firestore()
        let userID = UserDefaults.standard.string(forKey: "user_id") ?? "testing12333"
        let docRef = db.collection("users").document(userID)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let questions = document.data()!["questions"] as! [[String:String]]
                self._questions.removeAll()
                for i in questions{
                    
                    self._questions.append(Question(pr: i["prompt"]?.decode_hash() ?? "Loading"
                                                    , op1: i["o1"]?.decode_hash() ?? "Loading",op2: i["o2"]?.decode_hash() ?? "Loading",op3: i["o3"]?.decode_hash() ?? "Loading",op4: i["o4"]?.decode_hash() ?? "Loading",snd: i["sender"] ?? "Loading", rec: userID))
                }
            }
        }
    }
    
    
    func addQuestion(question: Question) {
        _questions.append(question)
    }
    
    func delQuestion(_ idx: Int) {
        if (_questions.startIndex..<_questions.count).contains(idx) {
            _questions.remove(at: idx)
        }
    }

    func questions() -> [Question] {
        return _questions
    }

}

