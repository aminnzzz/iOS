//
//  FriendListView.swift
//  QuizLad
//
//  Created by Sepehr on 3/14/22.
//

import Foundation
import SwiftUI

//struct ListOfFriendsView: View {
//    @EnvironmentObject private var friendList: FriendList
//    var body: some View {
//        List(friendList.friends(), id: \.self){
//            Text($0.name)
//        }
//    }
//}


struct ListOfFriendsView: View {
    @EnvironmentObject private var questionList: QuestionList
    @EnvironmentObject private var friendList: FriendList
    
    var body: some View {
        return NavigationView {
            VStack{
                Spacer()
                Spacer()
                Text("Click on each of your friends to add a question").bold().kerning(0.1).font(.subheadline).multilineTextAlignment(.center)
                List(friendList.friends(), id: \.self) { friend in
                    NavigationLink {
                        QuestionPage(friend: friend)
                    } label: {
                        FriendRow(friend: friend).foregroundColor(.yellow).font(.title3)
                    }
                }
                .navigationTitle("Friends")
            }
        }.onAppear{
            friendList.loadFriends()
        }
    }
}

struct FriendRow: View {
    var friend: Friend
    
    var body: some View {
        HStack {
            Text(friend.name)
            Spacer()
            HStack{
                Text("\(friend.points)")
                Text("Points").font(.system(size: 10, weight: .medium, design: .rounded))

            }
            HStack{
               Text("\(friend.streak)")
                Text("Streaks").font(.system(size: 10, weight: .medium, design: .rounded))
            }
        }
    }
}

