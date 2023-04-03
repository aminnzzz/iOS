
//
//  ContentView.swift
//  ProfilePicture
//
//  Created by Hamid Nassehi on 3/30/22.
//

import SwiftUI
import FirebaseFirestore
import FirebaseStorage

struct ProfileView: View {
    
    @State private var nameText = ""
    @State private var userID = ""
    
    @State private var profilepic = "person.circle.fill"
    let gradient = Gradient(colors: [.blue, .purple, .orange, .black])
    @State private var image : Image? = Image(systemName: "person.circle.fill")
    @State private var imageData = Data()
    @State private var shouldPresentImagePicker = false
    @State private var shouldPresentActionScheet = false
    @State private var shouldPresentCamera = false

    var body: some View {
        return VStack{
            Text("PROFILE").font(.callout).bold().font(.system(size: 50)).dynamicTypeSize(.xxxLarge)
            Spacer()
                .frame(height: 30);
            HStack{
                
                image!
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 250, height: 250)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.yellow, lineWidth: 4))
                    .shadow(radius: 10)
                    .frame(alignment: .center)
                    .padding(.trailing, 5)
                    .onTapGesture { self.shouldPresentActionScheet = true }
                    .sheet(isPresented: $shouldPresentImagePicker) {
                        SUImagePickerView(sourceType: self.shouldPresentCamera ? .camera : .photoLibrary, image: self.$image, isPresented: self.$shouldPresentImagePicker, imageData: self.$imageData)
                    }.actionSheet(isPresented: $shouldPresentActionScheet) { () -> ActionSheet in
                        ActionSheet(title: Text("Choose mode"), message: Text("Please choose your preferred mode to set your profile image"), buttons: [ActionSheet.Button.default(Text("Camera"), action: {
                            self.shouldPresentImagePicker = true
                            self.shouldPresentCamera = true
                        }), ActionSheet.Button.default(Text("Photo Library"), action: {
                            self.shouldPresentImagePicker = true
                            self.shouldPresentCamera = false
                        }), ActionSheet.Button.cancel()])
                    }
            }
            .padding()
            Spacer()
            
            VStack(alignment: .center, spacing: 10, content: {
                Text("UserID:").font(.callout).bold()
                Text(userID).textFieldStyle(RoundedBorderTextFieldStyle())
            }).padding(.top, 7.0)
            
            
            VStack(alignment:.center){
                Text("Edit Username:").font(.callout).bold()
                TextField("User Name", text: $nameText) .textFieldStyle(RoundedBorderTextFieldStyle())
                    .multilineTextAlignment(.center)
            }.padding(.top, 7.0)
            
            Spacer()
            Button("Save") {
                
                let storage = Storage.storage()
                let storageRef = storage.reference()
                let riversRef = storageRef.child("images/\(UserDefaults.standard.string(forKey: "user_id")!).jpg")
                riversRef.putData(imageData, metadata: nil)

                let db = Firestore.firestore()
                let docRef = db.collection("users").document( UserDefaults.standard.string(forKey: "user_id")!)
                docRef.updateData(["name": nameText])
                docRef.updateData(["imageUrl": "images/\(UserDefaults.standard.string(forKey: "user_id")!).jpg"])

                UserDefaults.standard.set(nameText, forKey: "user_name")
                // Upload the file to the path "images/rivers.jpg"
                hideKeyboard()
            }.frame(width: 100.0, height: 45, alignment: .center).background(ZStack {
                Color(.yellow)
                LinearGradient(gradient: Gradient(colors: [Color.white.opacity(0.3) , Color.clear]), startPoint: .top, endPoint: .bottom)
            })
            .foregroundColor(.black)
            .cornerRadius(21.0)
        }
        .padding(20)
        .onAppear{
            nameText = UserDefaults.standard.string(forKey: "user_name")!
            userID = UserDefaults.standard.string(forKey: "user_id")!
            
            let db = Firestore.firestore()
            let docRef = db.collection("users").document(userID)
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    let imageUrl = document.data()!["imageUrl"] as! String
                    if imageUrl != "" {
                        let storage = Storage.storage()
                        let storageRef = storage.reference()
                        // Create a reference to the file you want to download
                        print(imageUrl)
                        let islandRef = storageRef.child(imageUrl)

                        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
                        islandRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                          if let error = error {
                            // Uh-oh, an error occurred!
                              print(error.localizedDescription)
                          } else {
                            // Data for "images/island.jpg" is returned
                              print("hereeee")
                              image = Image(uiImage: UIImage(data: data!)!)
                          }
                        }
                    }
                }
            }
            
        }
    }
}


extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
}
