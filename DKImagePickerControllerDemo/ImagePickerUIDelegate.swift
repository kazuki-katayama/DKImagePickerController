//
//  ImagePickerUIDelegate.swift
//  PhotoBook
//
//  Created by 片山 一樹 on 2017/02/15.
//  Copyright © 2017年 New Imaging System Co.,Ltd. All rights reserved.
//

import UIKit

open class ImagePickerDefaultDelegate: NSObject , ImagePickerUIDelegate {
    
    open weak var imagePicker: ImagePicker!
    
    open var doneButton: UIButton?
    open var cancelButton: UIButton?
    open var helpButton: UIButton?
    
    lazy var footer : UIToolbar = {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 0, height: 44))
        toolbar.barTintColor = /*Constants.Colors.mainColor*/ .blue
        toolbar.tintColor = UIColor.white
        toolbar.items = [
            // フレキシブルスペース
            // Doneボタン
            UIBarButtonItem(customView: self.createSegmentedControl()),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(customView: self.createDoneButton()),
        ]
        return toolbar
    }()
    
    open func createSegmentedControl() -> UISegmentedControl {
        let seg = UISegmentedControl(items: ["古い順","新しい順"])
        seg.selectedSegmentIndex = 0
        seg.addTarget(self.imagePicker, action: #selector(imagePicker.sort(segcon:)), for: .valueChanged)
        return seg
    }
    
    open func createDoneButton() -> UIButton{
        let button = UIButton(type: .custom)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self.imagePicker, action: #selector(imagePicker.done), for: .touchUpInside)
        self.doneButton = button
        self.updateDoneButtonTitle(button)
        return self.doneButton!
    }

    open func createCancelButton() -> UIButton {
        let button = UIButton(type: .custom)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self.imagePicker, action: #selector(imagePicker.dismissWindow), for: .touchUpInside)
        self.cancelButton = button
        self.updateDoneButtonTitle(button)
        
        return self.cancelButton!
    }
    
    open func createHelpButton() -> UIButton {
        let button = UIButton(type: .custom)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self.imagePicker, action: #selector(imagePicker.helpWindow), for: .touchUpInside)
        self.helpButton = button
        self.updateHelpButtonTitle(button)
        
        return self.helpButton!
    
    }
    
    public func prepareLayout(_ imagePicker: ImagePicker, vc: UIViewController){
        self.imagePicker = imagePicker
    }
    
    
    
    // 選択数上限時にコール
    public func imagePickerDidReachMaxLimit(_ imagePicker: ImagePicker){
        
        let alert = UIAlertController(title: "選択枚数エラー",
                                      message: String(format:"%ld枚まで選択することができます。",imagePicker.maxSelectableCount),
                                      preferredStyle:.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel ){ _ in })
        imagePicker.present(alert, animated: true){}
    }
    
    // 選択不可アイテム(JPG以外のもの)選択時コール
    public func imagePickerDidDisableCell(_ imagePicker: ImagePicker){
        let alert = UIAlertController(title: "画像タイプエラー",
                                      message: String(format:"JPEG以外の画像は選択できません。"),
                                      preferredStyle:.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel ){ _ in })
        imagePicker.present(alert, animated: true){}
    }
    
    // 選択不可アイテム(画像サイズ過小)選択時コール
    public func imagePickerDidImageSizeTooSmall(_ imagePicker: ImagePicker){
        let alert = UIAlertController(title: "画像サイズエラー",
                                      message: String(format:"%ldx%ldpx未満の画像ファイルは選択できません。",Int(imagePicker.imageSizeUnderLimit[0]),Int(imagePicker.imageSizeUnderLimit[1])),
                                      preferredStyle:.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel ){ _ in })
        imagePicker.present(alert, animated: true){}
    }
    
    // フッターデザインを返す
    public func imagePickerFooterView(_ imagePicker:ImagePicker) -> UIView? {
        return self.footer
    }
    
    // グリッドレイアウトを返す
    public func imagePickerLayout(_ imagePicker:ImagePicker)-> UICollectionViewLayout.Type {
        return AssetGridLayout.self
    }
    
    public func imagePickerCollectionViewBackgroundColor() -> UIColor {
        return UIColor.white
    }
    
    
    open func updateDoneButtonTitle(_ button: UIButton) {
        button.setTitle("編集画面へ進む", for: .normal)
        button.sizeToFit()
    }

    open func updateHelpButtonTitle(_ button: UIButton) {
        button.setTitle("ヘルプ", for: .normal)
        button.sizeToFit()
    }
    
    // ナビゲーションバーデザインを作成
    open func updateNavigationBar(_ imagePicker:ImagePicker, showCancelButton vc: UIViewController){
        vc.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: imagePicker , action: #selector(imagePicker.dismissWindow))
        vc.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: createHelpButton())
    }
    
}
