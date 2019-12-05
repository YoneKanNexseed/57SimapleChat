//
//  SampleViewController.swift
//  SimpleChatApp
//
//  Created by yonekan on 2019/12/05.
//  Copyright © 2019 yonekan. All rights reserved.
//

import UIKit
import Firebase

class SampleViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func didClickButton(_ sender: UIButton) {
        
        // 入力された文字の空文字チェック
        if textField.text!.isEmpty {
            return
        }
        
        // Firestoreに接続
        let db = Firestore.firestore()
        
        // 保存
        db.collection("samples").addDocument(data: [
            "text": textField.text!
        ])
        
    }
    
}
