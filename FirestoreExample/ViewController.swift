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
    
    let myId = "vq7ogXCvOeQsNC7qbJST"
    let yourId = "aMBVU5lPemaoAbjBmcV5"
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

        var messages = [[String: Any]]()
        let chatsRef = db.collection("Chats")
        let query1 = chatsRef.whereField("senderId", isEqualTo: myId).whereField("receiverId", isEqualTo: yourId)
        let query2 = chatsRef.whereField("senderId", isEqualTo: yourId).whereField("receiverId", isEqualTo: myId)
        self.getMessage(query: query1, callback: { data1 in

            self.getMessage(query: query2, callback: { data2 in
                messages = data1 + data2
//                print(messages)
                messages = messages.sorted(by: { (data1, data2) -> Bool in
                    guard let createdAt1 = data1["createdAt"] else { return false }
                    guard let createdAt2 = data2["createdAt"] else { return false }

                    let date1 = createdAt1 as! Date
                    let date2 = createdAt2 as! Date
                    
                    if date1 < date2 {
                        return true
                    } else {
                        return false
                    }
                })
//                print(messages)
                
                self.display(messages: messages)
            })
        })

    }
    
    private func getMessage(query: Query, callback: @escaping (_ data: [[String: Any]]) -> Void) {
        var chatData = [[String: Any]]()
        query.addSnapshotListener { querySnapshot, error in
            if let err = error {
                print("Error fetching document: \(err)")
                return
            }
            guard let document = querySnapshot else { return }
            let docs = document.documents
            docs.forEach {
                chatData.append($0.data())
            }
            callback(chatData)
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

