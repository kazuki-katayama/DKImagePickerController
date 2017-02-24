//
//  PhotoPickerViewController.swift
//  PhotoBook
//
//  Created by 片山 一樹 on 2016/12/09.
//  Copyright © 2016年 New Imaging System Co.,Ltd. All rights reserved.
//

import UIKit
import DKImagePickerController
import Photos


class PhotoPickerViewController : UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var button: UIButton!
    var assets: [ImageAsset]?
    override func viewDidLoad() {
        super.viewDidLoad()
        //
    }
    
    func didNewImagePickerStart(){
        let picker = ImagePicker()
        picker.maxSelectableCount = 3
        picker.imageSizeUnderLimit = [200.0,200.0]
        self.present(picker, animated: true){}
        picker.didSelectAssets = { (assets: [ImageAsset]) in
            print(assets.count)
        }
    }

    @IBAction func didButtonPressed(_ sender: Any) {
        didNewImagePickerStart()
    }
}
