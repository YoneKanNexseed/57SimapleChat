//
//  RoomViewController.swift
//  SimpleChatApp
//
//  Created by yonekan on 2019/12/04.
//  Copyright © 2019 yonekan. All rights reserved.
//

import UIKit
import Firebase

class RoomViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var textField: UITextField!
    
    // チャット部屋を全件持つ配列
    var rooms: [Room] = [] {
        didSet {
            // 値が書き換わったら、tableViewを更新する
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // Firestoreに接続
        let db = Firestore.firestore()
        
        // Firestoreのroomsコレクションを監視
        db.collection("rooms")
            .order(by: "createdAt", descending: true)
            .addSnapshotListener { (querySnapshot, error) in
            
            // 最新のroomsコレクションの中身（ドキュメント）を取得
            guard let documents = querySnapshot?.documents else {
                // roomsコレクションの中身がnilの場合、処理を中断
                // 中身がある場合は、変数documentsに中身をすべて入れる
                return
            }
            
            // 結果を入れる配列
            var results: [Room] = []
            
            // ドキュメントをfor文を使ってループする
            for document in documents {
                let name = document.get("name") as! String
                let room =
                    Room(name: name, documentId: document.documentID)
                results.append(room)
            }
            
            // テーブルに表示する変数roomsを全結果の入ったresultsで上書き
            self.rooms = results
        }
        
        
    }
    
    // チャット部屋作成ボタンがクリックされた時の処理
    @IBAction func didClickButton(_ sender: UIButton) {
        
        // 部屋の名前が入力されたかチェック
        if textField.text!.isEmpty {
            // テキストフィールドが空の場合
            return // 処理を中断
        }
        
        // Firestoreに接続
        let db = Firestore.firestore()
        
        // 部屋をFirestoreに作成
        db.collection("rooms").addDocument(data: [
            "name": textField.text!,     // 部屋の名前
            "createdAt": FieldValue.serverTimestamp(), // 作成日時
        ]) { error in
            
            if let err = error {
                // エラーが発生した場合
                //（変数errorがnilでない場合、エラー情報を変数errに入れる）
                print(err.localizedDescription)
            } else {
                // エラーがない場合
                print("チャット部屋作成しました")
            }
            
        }
        
        // TextFieldの値をクリアする
        textField.text = ""
    }
    
}

extension RoomViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // セルを名前と行番号で取得
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        // 配列から、表示する部屋情報1件取得
        let room = rooms[indexPath.row]
        
        cell.textLabel?.text = room.name
        
        return cell
        
    }
    
    // セルがクリックされた時
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "toRoom", sender: nil)
        
    }
    
}
