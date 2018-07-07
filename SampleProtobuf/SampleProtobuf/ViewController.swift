//
//  ViewController.swift
//  SampleProtobuf
//
//  Created by 外間麻友美 on 2018/07/07.
//  Copyright © 2018年 外間麻友美. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var info = BookInfo()
        info.id = 100
        info.title = "test"
        info.author = "hokama"
        
        // get only
        let info2 = BookInfo.with {
            $0.id = 1735
            $0.title = "Even More Interesting"
            $0.author = "Jane Q. Smith"
        }
        
        do {
            // binary protobuf形式にシリアライズ
            let binaryData: Data = try info.serializedData()
            print("binaryData", binaryData)
            
            // バイナリデータを構造体へ
            let decodedInfo = try BookInfo(serializedData: binaryData)
            print("decodedInfo", decodedInfo)
            
            // JSON形式にシリアライズ
            let jsonData: Data = try info.jsonUTF8Data()
            print("jsonData", jsonData)
            
            // JSONデータから構造体へ
            let receivedFromJSON = try BookInfo(jsonUTF8Data: jsonData)
            print("receivedFromJSON", receivedFromJSON)
            
        } catch (let e) {
            print(e)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

