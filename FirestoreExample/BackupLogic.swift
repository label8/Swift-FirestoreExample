//
//  BackupLogic.swift
//  FirestoreExample
//
//  Created by 蜂谷庸正 on 2018/05/31.
//  Copyright © 2018年 Tsunemasa Hachiya. All rights reserved.
//

import Foundation

//        // 自身のチャットを全取得
//        db.collection("Users").document(myId)
//            .collection("Chats").getDocuments { querySnapshot, error in
//                if let err = error {
//                    print("Documents fetch error: ", err)
//                    return
//                }
//
//                guard let chatDocumentAll = querySnapshot else {
//                    print("QuerySnapshot fetch error")
//                    return
//                }
//
//                if chatDocumentAll.isEmpty {
//                    print("Documents is empty")
//                    return
//                }
//
//                // 取得したチャット履歴からひとつずつIDを取得し相手が同じチャットIDを持っているか検索
//                for chatDocument in chatDocumentAll.documents {
////                    self.searchYourChatId(chatId: document.documentID, callback: { chatRef in
////                        self.showChats(chatRef)
////                    })
//
//                    let chatId = chatDocument.documentID
//
//                    // 相手が自分と同じチャットIDを持ってたらチャットルームの参照を取得
//                    self.db.collection("Users").document(self.yourId)
//                        .collection("Chats").document(chatId).getDocument { querySnapshot, error in
//                            if let err = error {
//                                print("Documents fetch error: ", err)
//                                return
//                            }
//
//                            guard let chat = querySnapshot else {
//                                print("QuerySnapshot fetch error")
//                                return
//                            }
//
//                            if !chat.exists {
//                                print("Document not exists: /Users/\(self.yourId)/Chats/\(chatId)")
//                                return
//                            }
//
//                            let chatData = chat.data()
//                            if let chatRef = chatData["Messages"] as? DocumentReference {
//
//                            }
//                    }
//                }
//        }


//    // 相手のチャットIDを検索
//    private func searchYourChatId(chatId: String, callback: @escaping (_ documentRef: DocumentReference) -> Void) {
//        // 相手が自分と同じチャットIDを持ってたらチャットルームの参照を取得
//        db.collection("Users").document(yourId)
//            .collection("Chats").document(chatId).getDocument { querySnapshot, error in
//                if let err = error {
//                    print("Documents fetch error: ", err)
//                    return
//                }
//
//                guard let document = querySnapshot else {
//                    print("QuerySnapshot fetch error")
//                    return
//                }
//
//                if !document.exists {
//                    print("Document not exists: /Users/\(self.yourId)/Chats/\(chatId)")
//                    return
//                }
//
//                let documetData = document.data()
//                if let chatRef = documetData["Messages"] as? DocumentReference {
//                    callback(chatRef)
//                }
//        }
//    }
