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
    
    let userA = "vq7ogXCvOeQsNC7qbJST"
    let userB = "aMBVU5lPemaoAbjBmcV5"
    let userC = "i7e04eW7THp7mhbffR17"
    let userD = "abgCBMorAhUJSvB52Trw"
    
    var myId = ""
    var yourId = ""
    
    var chatCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
        
        myId = userC
        yourId = userB
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func didTappedDataCreateButton(_ sender: UIButton) {
        guard let _ = dataCreateTextField.text else { return }
        
        searchYourChatRefFromMyChatId { yourChatRef in
            if let _ = yourChatRef {
                self.sendMessage()
            } else {
                self.createChatAndSendMessage()
            }
        }
}
    
    private func sendMessage() {
        
    }
    
    private func createChatAndSendMessage() {
        let batch = db.batch()
        
        guard let chatText = dataCreateTextField.text else { return }
        let chat = [
            "senderId": myId,
            "receiverId": yourId,
            "message": chatText,
            "isMedia": false,
            "isRead": false,
            "sendDate": FieldValue.serverTimestamp()
        ] as [String : Any]

        let chatsRef = db.collection("Chats").document()
        let chatDocumentId = chatsRef.documentID
        let chatDocument = db.collection("Chats").document(chatDocumentId).collection("Messages")
        
        chatDocument.getDocuments { querySnapshot, error in
            let recordCount = querySnapshot?.count ?? 0
            self.chatCount = recordCount + 1
            
            let chatsMessageRef = chatDocument.document(String(self.chatCount))
            batch.setData(chat, forDocument: chatsMessageRef)
            
            let myChatsRef = self.db.collection("Users").document(self.myId).collection("Chats").document(chatDocumentId)
            let my = [
                "Messages": self.db.collection("Chats").document(chatDocumentId)
            ] as [String: Any]
            
            batch.setData(my, forDocument: myChatsRef)
            
            let yourChatsRef = self.db.collection("Users").document(self.yourId).collection("Chats").document(chatDocumentId)
            let your = [
                "Messages": self.db.collection("Chats").document(chatDocumentId)
            ] as [String: Any]
            
            batch.setData(your, forDocument: yourChatsRef)
            
            batch.commit { error in
                if let err = error {
                    print("Add chat batch error: ", err)
                } else {
                    print("Add chat complete!")
                }
            }
        }
    }
    
    
    // データの検索ボタンをタップ
    @IBAction func didTappedDataSearchButton(_ sender: UIButton) {
        searchYourChatRefFromMyChatId { yourChatRef in
            if let chatRef = yourChatRef {
                self.showChats(chatRef)
            }
        }
    }
    
    private func searchYourChatRefFromMyChatId(callback: @escaping (_ yourChatRef: DocumentReference?) -> Void) {
        // 自身のチャットを全取得
        db.collection("Users").document(myId)
            .collection("Chats").getDocuments { querySnapshot, error in
                if let err = error {
                    print("Documents fetch error: ", err)
                    callback(nil)
                    return
                }
                
                guard let chatDocumentAll = querySnapshot else {
                    print("QuerySnapshot fetch error")
                    callback(nil)
                    return
                }
                
                if chatDocumentAll.isEmpty {
                    print("Documents is empty")
                    callback(nil)
                    return
                }
                
                // 取得したチャット履歴からひとつずつIDを取得し相手が同じチャットIDを持っているか検索
                for chatDocument in chatDocumentAll.documents {
                    let chatId = chatDocument.documentID
                    
                    // 相手が自分と同じチャットIDを持ってたらチャットルームの参照を取得
                    self.db.collection("Users").document(self.yourId)
                        .collection("Chats").document(chatId).getDocument { querySnapshot, error in
                            if let err = error {
                                print("Documents fetch error: ", err)
                                callback(nil)
                                return
                            }
                            
                            guard let chat = querySnapshot else {
                                print("QuerySnapshot fetch error")
                                callback(nil)
                                return
                            }
                            
                            if !chat.exists {
                                print("Document not exists: /Users/\(self.yourId)/Chats/\(chatId)")
                                callback(nil)
                                return
                            }
                            
                            let chatData = chat.data()
                            if let chatRef = chatData["Messages"] as? DocumentReference {
                                callback(chatRef)
                            }
                    }
                }
        }

    }
    
    // チャット内容を表示
    private func showChats(_ chatRef: DocumentReference) {
        db.collection("Chats").document(chatRef.documentID)
            .collection("Messages").order(by: "sendDate", descending: false).addSnapshotListener { querySnapshot, error in
                
                if let err = error {
                    print("Documents fetch error: ", err)
                    return
                }
                
                guard let documents = querySnapshot else {
                    print("QuerySnapshot fetch error")
                    return
                }
                
                if documents.isEmpty {
                    print("Documents is empty: /Chats/\(chatRef.documentID)")
                    return
                }
                
                let docs = documents.documents
                docs.forEach {
                    print($0.data())
                }
        }
    }
    
    @IBAction func didTappedListSearchButton(_ sender: UIButton) {
        
    }

}

