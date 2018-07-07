//
//  SettingViewController.swift
//  Timer
//
//  Created by 外間麻友美 on 2018/04/09.
//  Copyright © 2018年 外間麻友美. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {

    @IBOutlet weak var timerPicker: UIPickerView!
    
    let valueArray: [Int] = [10,30,60,120,180]
    let settingKey = "timerValue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timerPicker.delegate = self
        timerPicker.dataSource = self
        
        let settings = UserDefaults.standard
        let timerValue = settings.integer(forKey: settingKey)
        
        valueArray.enumerated().forEach { (offset, value) in
            if value == timerValue {
                timerPicker.selectRow(offset, inComponent: 0, animated: true)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func chooseAction(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
}

extension SettingViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return valueArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(valueArray[row])
    }
    
}
extension SettingViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let settings = UserDefaults.standard
        settings.setValue(valueArray[row], forKey: settingKey)
        settings.synchronize()
    }
}
