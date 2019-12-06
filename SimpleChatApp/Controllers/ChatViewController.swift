//
//  ChatViewController.swift
//  SimpleChatApp
//
//  Created by yonekan on 2019/12/04.
//  Copyright © 2019 yonekan. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {

    // チャット部屋画面でクリックされた部屋のID
    var documentId: String = ""
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var tableVIew: UITableView!
    
    // TablViewに表示するメッセージを全件持つ変数
    var messages: [Message] = [] {
        didSet {
            tableVIew.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableVIew.dataSource = self
        tableVIew.delegate = self
        
        // Firestoreに接続
        let db = Firestore.firestore()
        
        // roomsコレクション ▶ 今いるRoom
            // ▶ messagesコレクション を監視
        db
            .collection("rooms")
            .document(documentId)
            .collection("messages")
            .order(by: "sentDate", descending: true)
            .addSnapshotListener { (querySnapshot, error) in
                
               // ドキュメントがnilでないかチェック
                guard let documents = querySnapshot?.documents else {
                    return
                }
                
                // ドキュメントをループして、メッセージの配列を作成
                var results: [Message] = []
                for document in documents {
                    
                    let documentId = document.documentID
                    let text = document.get("text") as! String
                    
                    let message =
                        Message(documentId: documentId, text: text)
                    
                    results.append(message)
                    
                }
                
                // 画面にメッセージを表示
                self.messages = results
                
        }
        
    }

    @IBAction func didClickButton(_ sender: UIButton) {
        
        // メッセージが空文字かチェックする
        if textField.text!.isEmpty {
            return
        }
        
        // Firestoreに接続
        let db = Firestore.firestore()
        
        // roomsコレクション ▶ 今いるRoom ▶ messagesコレクションに
        // 新しいメッセージを保存
        
        db
            .collection("rooms")
            .document(documentId)
            .collection("messages")
            .addDocument(data: [
                "text": textField.text!,
                "sentDate": FieldValue.serverTimestamp()
            ])
        
        
        // テキストフィールドの文字を空にする
        textField.text = ""
    }
    
}


extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // セルを名前と行番号で取得
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        // 配列から表示するMessageを取得
        let message = messages[indexPath.row]
        
        // Messageのtextを設定
        cell.textLabel?.text = message.text
        
        return cell
        
    }
    
}
