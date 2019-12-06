//
//  Message.swift
//  SimpleChatApp
//
//  Created by yonekan on 2019/12/04.
//  Copyright © 2019 yonekan. All rights reserved.
//

import Foundation

// メッセージ1件分の情報を持つ構造体
struct Message {
    
    // メッセージのID
    let documentId: String
    
    // 本文
    let text: String
}
