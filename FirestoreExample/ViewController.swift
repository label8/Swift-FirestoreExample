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
    
    let myId = "vq7ogXCvOeQsNC7qbJST" // aMBVU5lPemaoAbjBmcV5
    let yourId = "aMBVU5lPemaoAbjBmcV5" //vq7ogXCvOeQsNC7qbJST
    var roomCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func didTappedDataCreateButton(_ sender: UIButton) {
    }
    
    @IBAction func didTappedDataSearchButton(_ sender: UIButton) {
        db.collection("Users").document(myId).collection("Chats").getDocuments { documents, error in
            if let err = error {
                print("Documents fetch error: ", err)
            }
            for document in documents!.documents {
                self.searchYourChatId(chatId: document.documentID, callback: { chatRef in
                    self.showChats(chatRef)
                })
            }
        }
    }
    
    private func searchYourChatId(chatId: String, callback: @escaping (_ documentRef: DocumentReference) -> Void) {
        db.collection("Users").document(yourId)
            .collection("Chats").document(chatId).getDocument { document, error in
                if let err = error {
                    print("Documents fetch error: ", err)
                }
                
                if let documentData = document?.data(), let chatRef = documentData["Messages"] as? DocumentReference {
                    callback(chatRef)
                }
        }
    }
    
    private func showChats(_ chatRef: DocumentReference) {
        db.collection("Chats").document(chatRef.documentID).collection("messages").addSnapshotListener { querySnapshot, error in
            if let documents = querySnapshot {
                let docs = documents.documents
                docs.forEach { print($0.data()) }
            }
        }
    }
    
    private func display(messages: [[String: Any]]) {
        print("--- Display ---")
        for message in messages {
            print(message)
        }
    }
    
    @IBAction func didTappedListSearchButton(_ sender: UIButton) {
        
    }

}

