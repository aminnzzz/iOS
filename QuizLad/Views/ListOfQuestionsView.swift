//
//  ListOfQuestionsView.swift
//  QuizLad
//
//  Created by Sepehr on 3/14/22.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct ListOfQuestionsPage: View {
    @EnvironmentObject private var questionList: QuestionList
    var body: some View {
        NavigationView {
            List(questionList.questions(), id: \.self) { question in
                NavigationLink {
                    QuestionDetail(question: question)
                } label: {
                    QuestionRow(question: question)
                }
            }
            .navigationTitle("Questions")
        }.onAppear{
            questionList.loadQuestions()
        }
    }
}


struct QuestionDetail: View {
    var question: Question
    @State private var showingAlert = false
    @State private var answerStat = "Correct"
    @Environment(\.presentationMode) var presentation
    var db = Firestore.firestore()

    var body: some View {
        Spacer()
        VStack{
            Text("Select the answer of the following question:")
            Spacer()
            HStack{
                
                Text(question.prompt).font(.title2).bold()
                
            }
            
            //Text("🤔").font(.largeTitle)
            Spacer()
            Spacer()
            Button(question.options[0]) {
                let userID = Auth.auth().currentUser!.uid
                let docRef = db.collection("users").document(userID)
                docRef.getDocument { (document, error) in
                    if let document = document, document.exists {
                        let questions = document.data()!["questions"] as! [[String:Any]]
                        let points = document.data()!["points"] as! [[String:Any]]
                        var newPoints = [[String:Any]]()
                        var newQuestions = [[String:Any]]()

                        for i in points{
                            if i["user"] as! String == question.sender{
                                let x = ["user":question.sender, "point":i["point"] as! Int + 1, "streak":i["streak"] as! Int + 1] as [String:Any]
                                newPoints.append(x)
                            }else{
                                newPoints.append(i)
                            }
                        }
                        
                        for i in questions{
                            if String(i["prompt"] as! String).decode_hash() != question.prompt
                                && i["o1"] as! String != question.options[0]{
                                newQuestions.append(i)
                            }
                        }
                                                
                        db.collection("users").document(userID).updateData(
                            [
                                "points": newPoints,
                                "questions":newQuestions
                            ]
                        )
                        
                    }
                }
                
                let docRef2 = db.collection("users").document(question.sender)
                docRef2.getDocument { (document, error) in
                    if let document = document, document.exists {
                        let points = document.data()!["points"] as! [[String:Any]]
                        var newPoints = [[String:Any]]()


                        for i in points{
                            if i["user"] as! String == userID{
                                let x = ["user":userID, "point":i["point"]!, "streak":i["streak"] as! Int + 1] as [String:Any]
                                newPoints.append(x)
                            }else{
                                newPoints.append(i)
                            }
                        }
                      
                                                
                        db.collection("users").document(question.sender).updateData(
                            [
                                "points": newPoints,
                            ]
                        )
                        
                        
                    }
                }
                
               showingAlert = true
               answerStat = "Correct"
                
            }.alert(answerStat, isPresented: $showingAlert) {
                Button("OK", role: .cancel) {
                    self.presentation.wrappedValue.dismiss()
                }
            }.frame(width: 320.0, height: 45, alignment: .center).background(ZStack {
                Color(.yellow)
                LinearGradient(gradient: Gradient(colors: [Color.white.opacity(0.3) , Color.clear]), startPoint: .top, endPoint: .bottom)
                })
            
                .foregroundColor(.black)
                .cornerRadius(21.0)
                
            Button(question.options[1]) {
                let userID = Auth.auth().currentUser!.uid
                let docRef = db.collection("users").document(userID)
                docRef.getDocument { (document, error) in
                    if let document = document, document.exists {
                        let questions = document.data()!["questions"] as! [[String:Any]]
                        let points = document.data()!["points"] as! [[String:Any]]
                        var newPoints = [[String:Any]]()
                        var newQuestions = [[String:Any]]()

                        for i in points{
                            if i["user"] as! String == question.sender{
                                let x = ["user":question.sender, "point":i["point"]!, "streak":i["streak"] as! Int + 1] as [String:Any]
                                newPoints.append(x)
                            }else{
                                newPoints.append(i)
                            }
                        }
                        
                        for i in questions{
                            if String(i["prompt"] as! String).decode_hash() != question.prompt
                                && i["o1"] as! String != question.options[0]{
                                newQuestions.append(i)
                            }
                        }
                                                
                        db.collection("users").document(userID).updateData(
                            [
                                "points": newPoints,
                                "questions":newQuestions
                            ]
                        )
                        
                    }
                }
                
                let docRef2 = db.collection("users").document(question.sender)
                docRef2.getDocument { (document, error) in
                    if let document = document, document.exists {
                        let points = document.data()!["points"] as! [[String:Any]]
                        var newPoints = [[String:Any]]()


                        for i in points{
                            if i["user"] as! String == userID{
                                let x = ["user":userID, "point":i["point"]!, "streak":i["streak"] as! Int + 1] as [String:Any]
                                newPoints.append(x)
                            }else{
                                newPoints.append(i)
                            }
                        }
                      
                                                
                        db.collection("users").document(question.sender).updateData(
                            [
                                "points": newPoints,
                            ]
                        )
                        
                        
                    }
                }
                
               showingAlert = true
                answerStat = "Incorrect"
            }.alert(answerStat, isPresented: $showingAlert) {
                Button("OK", role: .cancel) {
                    self.presentation.wrappedValue.dismiss()
                }
            }.frame(width: 320.0, height: 45, alignment: .center).background(ZStack {
                Color(.yellow)
                LinearGradient(gradient: Gradient(colors: [Color.white.opacity(0.3) , Color.clear]), startPoint: .top, endPoint: .bottom)
                })
            
                .foregroundColor(.black)
                .cornerRadius(21.0)
            
            Button(question.options[2]) {
                let userID = Auth.auth().currentUser!.uid
                let docRef = db.collection("users").document(userID)
                docRef.getDocument { (document, error) in
                    if let document = document, document.exists {
                        let questions = document.data()!["questions"] as! [[String:Any]]
                        let points = document.data()!["points"] as! [[String:Any]]
                        var newPoints = [[String:Any]]()
                        var newQuestions = [[String:Any]]()

                        for i in points{
                            if i["user"] as! String == question.sender{
                                let x = ["user":question.sender, "point":i["point"]!, "streak":i["streak"] as! Int + 1] as [String:Any]
                                newPoints.append(x)
                            }else{
                                newPoints.append(i)
                            }
                        }
                        
                        for i in questions{
                            if String(i["prompt"] as! String).decode_hash() != question.prompt
                                && i["o1"] as! String != question.options[0]{
                                newQuestions.append(i)
                            }
                        }
                                                
                        db.collection("users").document(userID).updateData(
                            [
                                "points": newPoints,
                                "questions":newQuestions
                            ]
                        )
                        
                    }
                }
                
                let docRef2 = db.collection("users").document(question.sender)
                docRef2.getDocument { (document, error) in
                    if let document = document, document.exists {
                        let points = document.data()!["points"] as! [[String:Any]]
                        var newPoints = [[String:Any]]()


                        for i in points{
                            if i["user"] as! String == userID{
                                let x = ["user":userID, "point":i["point"]!, "streak":i["streak"] as! Int + 1] as [String:Any]
                                newPoints.append(x)
                            }else{
                                newPoints.append(i)
                            }
                        }
                      
                                                
                        db.collection("users").document(question.sender).updateData(
                            [
                                "points": newPoints,
                            ]
                        )
                        
                        
                    }
                }
                
                
               showingAlert = true
                answerStat = "Incorrect"
            }.alert(answerStat, isPresented: $showingAlert) {
                Button("OK", role: .cancel) {
                    self.presentation.wrappedValue.dismiss()
                }
            }.frame(width: 320.0, height: 45, alignment: .center).background(ZStack {
                Color(.yellow)
                LinearGradient(gradient: Gradient(colors: [Color.white.opacity(0.3) , Color.clear]), startPoint: .top, endPoint: .bottom)
                })
            
                .foregroundColor(.black)
                .cornerRadius(21.0)
            
            Button(question.options[3]) {
                let userID = Auth.auth().currentUser!.uid
                let docRef = db.collection("users").document(userID)
                docRef.getDocument { (document, error) in
                    if let document = document, document.exists {
                        let questions = document.data()!["questions"] as! [[String:Any]]
                        let points = document.data()!["points"] as! [[String:Any]]
                        var newPoints = [[String:Any]]()
                        var newQuestions = [[String:Any]]()

                        for i in points{
                            if i["user"] as! String == question.sender{
                                let x = ["user":question.sender, "point":i["point"]!, "streak":i["streak"] as! Int + 1] as [String:Any]
                                newPoints.append(x)
                            }else{
                                newPoints.append(i)
                            }
                        }
                        
                        for i in questions{
                            if String(i["prompt"] as! String).decode_hash() != question.prompt
                                && i["o1"] as! String != question.options[0]{
                                newQuestions.append(i)
                            }
                        }
                                                
                        db.collection("users").document(userID).updateData(
                            [
                                "points": newPoints,
                                "questions":newQuestions
                            ]
                        )
                        
                    }
                }
                
                let docRef2 = db.collection("users").document(question.sender)
                docRef2.getDocument { (document, error) in
                    if let document = document, document.exists {
                        let points = document.data()!["points"] as! [[String:Any]]
                        var newPoints = [[String:Any]]()

                        for i in points{
                            if i["user"] as! String == userID{
                                let x = ["user":userID, "point":i["point"]!, "streak":i["streak"] as! Int + 1] as [String:Any]
                                newPoints.append(x)
                            }else{
                                newPoints.append(i)
                            }
                        }
                      
                                                
                        db.collection("users").document(question.sender).updateData(
                            [
                                "points": newPoints,
                            ]
                        )
                        
                        
                    }
                }
                
                showingAlert = true
                answerStat = "Incorrect"
            }.alert(answerStat, isPresented: $showingAlert) {
                Button("OK", role: .cancel) {
                    self.presentation.wrappedValue.dismiss()
                }
            }.frame(width: 320.0, height: 45, alignment: .center).background(ZStack {
                Color(.yellow)
                LinearGradient(gradient: Gradient(colors: [Color.white.opacity(0.3) , Color.clear]), startPoint: .top, endPoint: .bottom)
                })
            
                .foregroundColor(.black)
                .cornerRadius(21.0)
        }.padding()
    }
}

struct QuestionRow: View {
    var question: Question
    var body: some View {
        HStack {
            Text(question.prompt)
            Spacer()
        }
    }
}
