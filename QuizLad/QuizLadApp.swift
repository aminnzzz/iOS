//
//  QuizLadApp.swift
//  QuizLad
//
//  Created by Sepehr on 3/14/22.
//

import SwiftUI
import Firebase

@main
struct QuizLadApp: App {
    init(){
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(QuestionList())
                .environmentObject(FriendList())
                .environmentObject(CloudFuncs())
        }
    }
}
