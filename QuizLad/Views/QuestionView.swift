//
//  QuestionView.swift
//  QuizLad
//
//  Created by Sepehr on 3/14/22.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct QuestionPage: View {

    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject private var questionList: QuestionList
    var db = Firestore.firestore()

    var friend: Friend
    @State var prompt: String = ""
    @State var option1: String = ""
    @State var option2: String = ""
    @State var option3: String = ""
    @State var option4: String = ""
    
    var body: some View {
        VStack{
            VStack{
                VStack{
                    Text(
                        "Prompt"
                    )
                    TextEditor(text: $prompt)
                        .frame(minHeight: 100)
                        .foregroundColor(Color.blue)
                        .background(Color.gray)
                        .font(.custom("HelveticaNeue", size: 13))
                        .lineSpacing(5)
                        .lineLimit(10).border(.gray, width: 2)
                        .cornerRadius(5)
                }.padding()
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            Spacer()
                                Button("Done") {
                                    self.hideKeyboard()
                                }
                        }
                    }
                HStack{
                VStack{
                    
                    Text(
                        "Correct Answer"
                    ).foregroundColor(.green)
                    TextEditor(text: $option1)
                        .frame(minHeight: 50)
                        .foregroundColor(Color.primary)
                        .font(.custom("HelveticaNeue", size: 13))
                        .lineSpacing(5)
                        .lineLimit(10).border(.gray, width: 2)
                        .cornerRadius(5)
                }.padding()
                    
                    
                VStack{
                    Text(
                        "Option 2"
                    ).foregroundColor(.red)
                    TextEditor(text: $option2)
                        .frame(minHeight: 50)
                        .foregroundColor(Color.primary)
                        .font(.custom("HelveticaNeue", size: 13))
                        .lineSpacing(5)
                        .lineLimit(10).border(.gray, width: 2)
                        .cornerRadius(5)
                }.padding()
                    
                }
                HStack{
                VStack{
                    Text(
                        "Option 3"
                    ).foregroundColor(.red)
                    TextEditor(text: $option3)
                        .frame(minHeight: 50)
                        .foregroundColor(Color.primary)
                        .font(.custom("HelveticaNeue", size: 13))
                        .lineSpacing(5)
                        .lineLimit(10).border(.gray, width: 2)
                        .cornerRadius(5)
                }.padding()
                    
                    
                VStack{
                    Text(
                        "Option 4"
                    ).foregroundColor(.red)
                    TextEditor(text: $option4)
                        .frame(minHeight: 50)
                        .foregroundColor(Color.primary)
                        .font(.custom("HelveticaNeue", size: 13))
                        .lineSpacing(5)
                        .lineLimit(10).border(.gray, width: 2)
                        .cornerRadius(5)

                }.padding()
                }
                    
            }
            
            Button {
                let q = Question(pr: prompt, opt: [option1, option2, option3, option4], snd: "", rec: friend.id)                
                let userID = Auth.auth().currentUser!.uid
                db.collection("users").document(friend.id).updateData(

                    [
                        "questions": FieldValue.arrayUnion([["prompt": q.prompt.hash(), "o1": String(q.options[0]).hash(), "o2": String(q.options[1]).hash(), "o3": String(q.options[2]).hash(), "o4": String(q.options[3]).hash(),"sender": userID]])
                    ]
                )
                
                prompt = ""
                option1 = ""
                option2 = ""
                option3 = ""
                option4 = ""
            } label: {
                Text("Create").foregroundColor(.black)
            }
            
            .frame(width: 100.0, height: 45, alignment: .center).background(ZStack {
                Color(.yellow)
                LinearGradient(gradient: Gradient(colors: [Color.white.opacity(0.3) , Color.clear]), startPoint: .top, endPoint: .bottom)
                })
            
                .foregroundColor(.white)
                .cornerRadius(21.0)
        }.navigationTitle("Create Question")
            .navigationBarTitleDisplayMode(.inline)

    }
}

extension String{
    func hash() -> String{
        var hash = self
        hash = hash.replacingOccurrences(of: " ", with: "--0-0-")
        hash = hash.replacingOccurrences(of: "a", with: "--e12--")
        hash = hash.replacingOccurrences(of: "c", with: "--p43--")
        hash = hash.replacingOccurrences(of: "g", with: "--k42342--")
        hash = hash.replacingOccurrences(of: "s", with: "--142342---")
        hash = hash.replacingOccurrences(of: "v", with: "-z42-")
        hash = hash.replacingOccurrences(of: "u", with: "-tp42-")
        hash = hash.replacingOccurrences(of: "e", with: "-fsadf42-")
        hash = hash.replacingOccurrences(of: "o", with: "--gfd4420--")
        hash = hash.replacingOccurrences(of: "?", with: "--bye--")
        return hash
    }
    
    func decode_hash() -> String{
        var hash = self
        hash = hash.replacingOccurrences(of: "--0-0-", with: " ")
        hash = hash.replacingOccurrences(of: "--e12--", with: "a")
        hash = hash.replacingOccurrences(of: "--p43--", with: "c")
        hash = hash.replacingOccurrences(of: "--k42342--", with: "g")
        hash = hash.replacingOccurrences(of: "--142342---", with: "s")
        hash = hash.replacingOccurrences(of: "-z42-", with: "v")
        hash = hash.replacingOccurrences(of: "--bye--", with: "?")
        hash = hash.replacingOccurrences(of: "-tp42-", with: "u")
        hash = hash.replacingOccurrences(of: "-fsadf42-", with: "e")
        hash = hash.replacingOccurrences(of: "--gfd4420--", with: "o")
        hash = hash.replacingOccurrences(of: "--e12--", with: "a")
        return hash
    }
}
