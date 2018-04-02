//
//  ViewController.swift
//  MyCamera
//
//  Created by 外間麻友美 on 2018/03/31.
//  Copyright © 2018年 外間麻友美. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func cameraLaunch(_ sender: UIButton) {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let ipc = UIImagePickerController()
            ipc.delegate = self
            ipc.sourceType = .camera
            present(ipc, animated: true, completion: nil)
        } else {
            print("カメラ使えません")
        }
    }
    
    @IBAction func shareAction(_ sender: UIButton) {
        if let sharedImage = imageView.image {
            let sharedImages = [sharedImage]
            let controller = UIActivityViewController(activityItems: sharedImages, applicationActivities: nil)
            // ipad用の表示対策
            controller.popoverPresentationController?.sourceView = view
            present(controller, animated: true, completion: nil)
        }
    }
}
extension ViewController: UINavigationControllerDelegate {
    
}

extension ViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        dismiss(animated: true, completion: nil)
    }
}
