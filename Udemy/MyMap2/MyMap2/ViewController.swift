//
//  ViewController.swift
//  MyMap2
//
//  Created by 外間麻友美 on 2018/03/30.
//  Copyright © 2018年 外間麻友美. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    @IBOutlet weak var inputTextField: UITextField! {
        didSet {
            inputTextField.delegate = self
        }
    }
    @IBOutlet weak var displayMap: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        let keyword = textField.text
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(keyword!, completionHandler: { (placemark, error) in
            if let placemark = placemark?[0] {
                if let targetCoordinate = placemark.location?.coordinate {
                    print(targetCoordinate)
                    
                    // ピンを生成
                    let pin = MKPointAnnotation()
                    pin.coordinate = targetCoordinate
                    pin.title = keyword
                    // マップにpinを立てる
                    self.displayMap.addAnnotation(pin)
                    // 表示範囲を500メートル以内にする
                    self.displayMap.region = MKCoordinateRegionMakeWithDistance(targetCoordinate, 500.0, 500.0)
                }
            }
        })
        return true
    }
}

