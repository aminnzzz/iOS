//
//  LoginView.swift
//  QuizLad
//
//  Created by Sepehr on 3/31/22.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

let lightGreyColor = Color(red: 219.0/255.0, green: 223.0/255.0, blue: 224.0/255.0, opacity: 1.0)

struct LoginView : View {
    @Binding var present: Bool
    @State var email: String = ""
    @State var username: String = ""
    @State var password: String = ""
    @State var editingMode: Bool = false
    @State private var showingAlert = false
    @EnvironmentObject private var cloud_fns: CloudFuncs
    var db = Firestore.firestore()

    var body: some View {
        
        ZStack {
            VStack {
                WelcomeText()
                UserImage()
                EmailTextField(email: $email, editingMode: $editingMode)
                PasswordSecureField(password: $password, editingMode: $editingMode)
                
                Button(action: {
                    Auth.auth().signIn(withEmail: self.email, password: self.password) { authResult, error in
                        if (authResult?.user != nil) {
                            
                            UserDefaults.standard.set(true, forKey: "signed_in")
                            let docRef = db.collection("users").document(Auth.auth().currentUser!.uid)
                            docRef.getDocument { (document, error) in
                                if let document = document, document.exists {
                                    let name = document.data()!["name"] as! String
                                    UserDefaults.standard.set(name, forKey: "user_name")
                                }
                            }
                            // --------------------- //
                            UserDefaults.standard.set(email, forKey: "user_email")
                            UserDefaults.standard.set(Auth.auth().currentUser?.uid, forKey: "user_id")
                            // --------------------- //
                            present = false
                            
                        }else{
                            UserDefaults.standard.set(false, forKey: "signed_in")
                            showingAlert = true
                        }
                    }
                }) {
                    LoginButtonContent()
                }.alert("Authentication Failed", isPresented: $showingAlert) {
                    Button("Retry", role: .cancel) { }
                }
                
                Button(action: {
                    Auth.auth().createUser(withEmail: self.email, password: self.password) { res, error in
                        if res?.user != nil{
                            db.collection("users").document((res?.user.uid)!).setData([
                                        "id": (res?.user.uid)!,
                                        "email": self.email,
                                        "friends" : [],
                                        "questions" : [],
                                        "points" : [],
                                        "streaks" : [],
                                        "name": self.email.split(separator: "@")[0],
                                        "imageUrl": ""
                                    ]) { err in
                                        if let err = err {
                                            print("Error writing document: \(err)")
                                        } else {
                                            UserDefaults.standard.set(true, forKey: "signed_in")
                                            // --------------------- //
                                            UserDefaults.standard.set(email, forKey: "user_email")
                                            UserDefaults.standard.set(self.email.split(separator: "@")[0], forKey: "user_name")
                                            UserDefaults.standard.set(Auth.auth().currentUser?.uid, forKey: "user_id")
                                            // --------------------- //
                                            present = false
                                }
                            }
                        }else{
                            UserDefaults.standard.set(false, forKey: "signed_in")
                            showingAlert = true
                        }
                    }
                }) {
                    SignUpButtonContent()
                }.alert("Could Not Create Account",isPresented: $showingAlert) {
                    Button("Retry", role: .cancel) { }
                }
            }
            .padding()
            
        }
        .offset(y: editingMode ? -120 : 0)
        .interactiveDismissDisabled(true)
        
    }
}

struct WelcomeText : View {
    var body: some View {
        return Text("QuizLad")
            .font(.largeTitle)
            .fontWeight(.semibold)
            .padding(.bottom, 20)
    }
}

struct UserImage : View {
    var body: some View {
        
        return Image(systemName: "paperplane.fill")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 70, height: 70)
            .clipped()
            .padding(.bottom, 75)
    }
}

struct LoginButtonContent : View {
    var body: some View {
        return Text("Sign in")
            .font(.headline)
        //change
            .foregroundColor(.black)
            .padding()
            .frame(width: 220, height: 60)
            .background(Color.yellow)
            .cornerRadius(15.0)
    }
}

struct SignUpButtonContent : View {
    var body: some View {
        return Text("Sign up")
            .font(.headline)
        //change
            .foregroundColor(.black)
            .padding()
            .frame(width: 220, height: 60)
            .background(Color.yellow)
            .cornerRadius(15.0)
    }
}

//
//struct UsernameTextField : View {
//    @Binding var username: String
//    @Binding var editingMode: Bool
//
//    var body: some View {
//        return TextField("Username", text: $username, onEditingChanged: {edit in
//            if edit == true
//            {self.editingMode = true}
//        }, onCommit: { self.editingMode = false })
//        .padding()
//        .background(lightGreyColor)
//        .cornerRadius(5.0)
//        .padding(.bottom, 20)
//        .foregroundColor(.black)
//    }
//}

struct EmailTextField : View {
    @Binding var email: String
    @Binding var editingMode: Bool
    var body: some View {
        return TextField("Email", text: $email, onEditingChanged: {edit in
            if edit == true
            {self.editingMode = true}
        }, onCommit: { self.editingMode = false })
        .padding()
        .background(lightGreyColor)
        .cornerRadius(5.0)
        .padding(.bottom, 20)
        .foregroundColor(.black)
    }
}

struct PasswordSecureField : View {
    
    @Binding var password: String
    @Binding var editingMode: Bool

    var body: some View {
        return SecureField("Password", text: $password, onCommit: { self.editingMode = false })
            .padding()
            .background(lightGreyColor)
            .cornerRadius(5.0)
            .padding(.bottom, 20)
            .foregroundColor(.black)
            .onTapGesture {
                self.editingMode = true
            }
    }
}
