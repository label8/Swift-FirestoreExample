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
    
    let myId = "kkadgadsdiihc19k"
    let yourId = "kidgeacdgiao984kdg"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func didTappedDataCreateButton(_ sender: UIButton) {
//        guard let data = dataCreateTextField.text else { return }
        
        let chatsRef = db.collection("Chats").document("room-kidgeacdgiao984kdg").collection("messages")
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
            "message": "僕は朝霞っていうところです！ 知ってますか？",
            "lastUpdated": FieldValue.serverTimestamp()
        ] as [String: Any]
        
        let yourMessage = [
            "uid": yourId,
            "name": "hono",
            "gender": "female",
            "age": 32,
            "message": "どちらにお住まいですか？ 私は大宮です^^",
            "lastUpdated": FieldValue.serverTimestamp()
        ] as [String: Any]
        
        let messageId = "\(count + 1)"
        
        db.collection("Chats").document("room-\(yourId)")
            .collection("messages").document(messageId).setData(myMessage) { error in
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
        db.collection("Chats").document("room-\(yourId)").collection("messages")
            .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                print(document.documents.count)
                let docs = document.documents
                docs.forEach {
                    print($0.data())
                }
        }
    }
    
    @IBAction func didTappedDataDeleteButton(_ sender: UIButton) {
//        guard let data = dataDeleteTextField.text else { return }
    }
    
}

