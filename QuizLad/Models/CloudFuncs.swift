//
//  CloudFuncs.swift
//  QuizLad
//
//  Created by Sepehr on 3/31/22.
//

import Foundation
import FirebaseAuth

class CloudFuncs: ObservableObject {
    
    init() {
        
    }
    
    func signUp(email: String, pass: String) -> Bool{
        var ret = false
        Auth.auth().createUser(withEmail: email, password: pass) { res, error in
            if res?.user != nil{
                ret = true
            }else{
                ret = false
            }
        }
        return ret
    }
    
    func authenticate(email: String, pass: String) -> Bool{
        var ret = false
        Auth.auth().signIn(withEmail: email, password: pass) { [weak self] authResult, error in
            guard self != nil else { return }
            if (authResult?.user != nil) {
                UserDefaults.standard.set(true, forKey: "signed_in")
                ret = true
            }else{
                UserDefaults.standard.set(false, forKey: "signed_in")
                ret = false
            }
        }
        return ret
    }
    
    func forgotPassPressed(email: String) {
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
        }
    }
    
    
}
