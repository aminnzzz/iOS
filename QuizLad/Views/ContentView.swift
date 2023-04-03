//
//  ContentView.swift
//  QuizLad
//
//  Created by Sepehr on 3/14/22.
//

import SwiftUI


struct ContentView: View {
    @EnvironmentObject private var questionList: QuestionList
    @EnvironmentObject private var friendList: FriendList
    @State var present = !UserDefaults.standard.bool(forKey: "signed_in")

    var body: some View {
        
            TabView {
                ListOfFriendsView().environmentObject(friendList)
                    .environmentObject(questionList)
                    .tabItem {
                        Text("Friends")
                    }
                ListOfQuestionsPage().environmentObject(questionList)
                    .tabItem {
                        Text("Questions")
                    }
                AddFriendView().environmentObject(friendList)
                    .tabItem {
                        Text("Add Friend")
                    }
                ProfileView()
                    .tabItem {
                        Text("Profile")
                }
                
            }.sheet(isPresented: $present) {
                // show the add user view
                LoginView(present: $present)
            }
        

    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(QuestionList()).environmentObject(FriendList())
            .environmentObject(CloudFuncs())
    }
}
