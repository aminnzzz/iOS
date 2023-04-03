//
//  AddFriendView.swift
//  QuizLad
//
//  Created by Sepehr on 3/14/22.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct AddFriendView: View {
    @EnvironmentObject private var friendList: FriendList
    @State var name: String = ""
    @State var streak: Int = 0
    @State var points: Int =  0
    @State var id: String = "\(Int.random(in: 1000...999999))"
    @State private var isShowingDetailView = false
    @State private var showingAlert = false
    var db = Firestore.firestore()
    
    var body: some View {
        NavigationView{
            VStack{
                VStack{
                    Text(
                        "User ID".uppercased()
                    ).foregroundColor(Color.primary).kerning(4.0)
                    
                    TextField("   Enter a User ID", text: $name)
                        .frame(minHeight: 50)
                        .foregroundColor(Color.primary)
                        .font(.custom("HelveticaNeue", size: 13))
                        .lineSpacing(5)
                        .lineLimit(10).border(.gray, width: 2)
                        .padding()
                }.padding()
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            Spacer()
                                Button("Done") {
                                    self.hideKeyboard()
                                }
                        }
                    }
                Spacer()
                Button {
                    let userID = Auth.auth().currentUser!.uid
                    if userID != name.replacingOccurrences(of: " ", with: "") {
                        let docRef = db.collection("users").document(name.replacingOccurrences(of: " ", with: ""))
                        docRef.getDocument { (document, error) in
                            if let document = document, document.exists {
                                let q = Friend(id: name.replacingOccurrences(of: " ", with: ""), name: name, points: 0, streak: 0)
                                friendList.addFriend(friend: q)
                                db.collection("users").document(userID).updateData(
                                    [
                                        "friends": FieldValue.arrayUnion([
                                            name.replacingOccurrences(of: " ", with: "")]),
                                        "points": FieldValue.arrayUnion([[
                                            "user": name.replacingOccurrences(of: " ", with: ""),
                                            "point": 0,
                                            "streak": 0
                                        ]])
                                    ]
                                )
                                db.collection("users").document(name.replacingOccurrences(of: " ", with: "")).updateData(
                                    [
                                        "friends": FieldValue.arrayUnion([userID]),
                                        "points": FieldValue.arrayUnion([[
                                            "user": userID,
                                            "point": 0,
                                            "streak": 0
                                        ]])
                                    ]
                                )
                               
                                name = ""
                            } else {
                                showingAlert = true
                                name = ""
                            }
                        }
                    }else{
                        showingAlert = true
                        name = ""
                    }
                    hideKeyboard()
                } label: {
                    Text("Add Friend").foregroundColor(.black)
                }.frame(width: 100.0, height: 45, alignment: .center).background(ZStack {
                    Color(.yellow)
                    LinearGradient(gradient: Gradient(colors: [Color.white.opacity(0.3) , Color.clear]), startPoint: .top, endPoint: .bottom)
                })
                .foregroundColor(.white)
                .cornerRadius(21.0)
                .alert("Could Not Find User",isPresented: $showingAlert) {
                        Button("Retry", role: .cancel) { }
                }
            }.navigationTitle("Add Friend")
        }
    }
    
}
