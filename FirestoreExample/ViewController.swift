//
//  ViewController.swift
//  FirestoreExample
//
//  Created by Tsunemasa Hachiya on 2018/05/23.
//  Copyright © 2018年 Tsunemasa Hachiya. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var dataCreateTextField: UITextField!
    @IBOutlet weak var dataUpdateTextField: UITextField!
    @IBOutlet weak var dataSearchTextField: UITextField!
    @IBOutlet weak var dataDeleteTextField: UITextField!
    
    var db : Firestore!
    var ref: DocumentReference?
    
    let myId = "gAyvK4fqTvXCUSF1BLTF3Bwf42G2"
    let yourId = "en9MHDRkBAXxZfG6P7xfkQQlQu22"
    let otherId = "YOzC0LRsgtQeH9bjLPxPHggZfu82"
    var roomId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
        
//    roomId = "Room_\(myId)_\(yourId)"
        roomId = "Room_\(myId)_\(otherId)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func didTappedDataCreateButton(_ sender: UIButton) {
//        guard let data = dataCreateTextField.text else { return }
        
        let chatsRef = db.collection("Chats").document(roomId).collection("messages")
        chatsRef.getDocuments { (snapshot, error) in
            if let err = error {
                print("Error writing document: \(err)")
            } else {
                self.createMessage(dataCount: snapshot?.count)
            }
        }
        
    }
    
    private func createMessage(dataCount: Int?) {
        
        let count = dataCount ?? 0
        
        let myMessage = [
            "uid": myId,
            "name": "tsune",
            "gender": "male",
            "age": 39,
            "message": "kyonさんこんにちわ！",
            "lastUpdated": FieldValue.serverTimestamp()
        ] as [String: Any]
        
        let yourMessage = [
            "uid": yourId,
            "name": "hono",
            "gender": "female",
            "age": 32,
            "message": "朝霞なんですね^^ わたしは大宮ですよー！",
            "lastUpdated": FieldValue.serverTimestamp()
        ] as [String: Any]
        
        let otherMessage = [
            "uid": otherId,
            "name": "kyon",
            "gender": "female",
            "age": 24,
            "message": "どうもです",
            "lastUpdated": FieldValue.serverTimestamp()
        ] as [String: Any]
        
        let messageId = "\(count + 1)"
        
        db.collection("Chats").document(roomId)
            .collection("messages").document(messageId).setData(otherMessage) { error in
                if let err = error {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                }
        }
    }
    
    @IBAction func didTappedDataUpdateButton(_ sender: UIButton) {
//        guard let data = dataUpdateTextField.text else { return }
    }
    
    @IBAction func didTappedDataSearchButton(_ sender: UIButton) {
        db.collection("Chats").document(roomId).collection("messages")
            .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                let source = document.metadata.hasPendingWrites ? "Local" : "Server"
                print("\(source): ", document.documents.count)
                let docs = document.documents
                docs.forEach {
                    print("\(source):", $0.data())
                }
                
                let _ = self.db.collection("Chats").document(self.roomId)
                    .collection("messages").whereField("name", isEqualTo: "tsune")
                    .getDocuments(completion: { (querySnapshot, error) in
                        if let err = error {
                            print("Error fetching document: \(err)")
                        } else {
                            for document in querySnapshot!.documents {
                                print(document.data())
                            }
                        }
                    })
                
        }
    }
    
    @IBAction func didTappedDataDeleteButton(_ sender: UIButton) {
//        guard let data = dataDeleteTextField.text else { return }
    }
    
}

