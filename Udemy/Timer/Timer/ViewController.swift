//
//  ViewController.swift
//  Timer
//
//  Created by 外間麻友美 on 2018/04/02.
//  Copyright © 2018年 外間麻友美. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var timeDisplay: UILabel!
    
    var timer: Timer?
    // 経過時間
    var duration = 0
    // 識別子
    let settingKey = "timerValue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let settings = UserDefaults.standard
        settings.register(defaults: [settingKey: 60])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // 画面表示
    override func viewDidAppear(_ animated: Bool) {
        duration = 0
        _ = displayUpdate()
    }
    @IBAction func settingButtonAction(_ sender: Any) {
        if let nowTimer = timer {
            if nowTimer.isValid == true {
                nowTimer.invalidate()
            }
        }
        
        performSegue(withIdentifier: "openSetting", sender: nil)
    }
    
    @IBAction func startTimerAction(_ sender: Any) {
        if let nowTimer = timer {
            // 有効
            if nowTimer.isValid == true {
                return
            }
        }
        // 無効の場合
        // 1秒づつカウント
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.timerStop(_:)), userInfo: nil, repeats: true)
    }
    @IBAction func stopTimerAction(_ sender: Any) {
        if let nowTimer = timer {
            // タイマーが有効なら
            if nowTimer.isValid == true {
                // タイマー停止
                nowTimer.invalidate()
            }
        }
    }
    
    func displayUpdate() -> Int {
        let settings = UserDefaults.standard
        let timerValue = settings.integer(forKey: settingKey)
        let remainSeconds = timerValue - duration
        timeDisplay.text = "あと\(remainSeconds)秒"
        return remainSeconds
    }
    
    @objc func timerStop(_ timer: Timer) {
        duration += 1
        if displayUpdate() <= 0 {
            duration = 0
            // timer停止
            timer.invalidate()
        }
    }
}

