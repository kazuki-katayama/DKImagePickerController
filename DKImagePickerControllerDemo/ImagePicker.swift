//
//  ImagePicker.swift
//  PhotoBook
//
//  Created by 片山 一樹 on 2017/02/15.
//  Copyright © 2017年 New Imaging System Co.,Ltd. All rights reserved.
//

import UIKit
import Photos

@objc
public protocol ImagePickerUIDelegate {
    
    func prepareLayout(_ imagePicker: ImagePicker, vc: UIViewController)    

    /**
     Called when the count of the selectedAssets did reach `maxSelectableCount`.
     */
    func imagePickerDidReachMaxLimit(_ imagePicker: ImagePicker)
    
    /**
     AssetTypeがjpegOnlyかつ、選択画像がjpeg以外だった際コールされます。
     */
    func imagePickerDidDisableCell(_ imagePicker: ImagePicker)
    
    /**
     画像サイズがimageSizeUnderLimitより低かった際にコールされます。
     */
    func imagePickerDidImageSizeTooSmall(_ imagePicker: ImagePicker)
    
    /**
     フッターのデザインを作成し返すメソッド
     */
    func imagePickerFooterView(_ imagePicker:ImagePicker) -> UIView?
    
    /**
     グリッドレイアウトを作成し返すメソッド
     */
    func imagePickerLayout(_ imagePicker:ImagePicker)-> UICollectionViewLayout.Type
    
    /**
     CollectionViewの背景色を返す
     */
    func imagePickerCollectionViewBackgroundColor() -> UIColor
    
    /**
     ナビゲーションバーデザインを作成し返すメソッド
     */
    func updateNavigationBar(_ imagePicker:ImagePicker, showCancelButton vc: UIViewController)
}

open class ImagePicker : UINavigationController {
    
    public var didCancel: (() -> Void)?
    
    public var imageSizeUnderLimit = [0.0,0.0]
    public var singleSelect = false
    public var selectedAssets = [ImageAsset]()
    public var didSelectAssets: ((_ assets: [ImageAsset]) -> Void)?
    public var maxSelectableCount: Int = 999
    
    lazy var UIDelegate: ImagePickerUIDelegate = {
        return ImagePickerDefaultDelegate()
    }()
    
    public convenience init() {
        let rootVC = UIViewController()
        self.init(rootViewController:rootVC)
        self.preferredContentSize = CGSize(width: 680, height: 600)
        
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private var hasInitialized = false
    open override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // ここでレイアウトView等作成
        if !hasInitialized {
            hasInitialized = true
            let rootVC = AssetGroupDetailVC()
            rootVC.imagePicker = self
            self.UIDelegate.prepareLayout(self, vc: rootVC)
            self.setViewControllers([rootVC], animated: false)
            self.UIDelegate.updateNavigationBar(self, showCancelButton: rootVC)
        }
    }
    
    open func dismissWindow() {
        self.dismiss(animated: true)
    }
    
    open func helpWindow(){
        self.dismiss(animated: true)
    }
    
    private func dismiss(animated flag: Bool){
        self.presentingViewController?.dismiss(animated: flag, completion: {
            self.didCancel?()
        })
    }
    
    open func done() {
        self.presentingViewController?.dismiss(animated: true, completion: {
            self.didSelectAssets?(self.selectedAssets)
        })
    }
    
    open func sort(segcon: UISegmentedControl){
        let sort = getImageManeger().sortByAsc
        if (!sort && segcon.selectedSegmentIndex == 0)
        || (sort && segcon.selectedSegmentIndex == 1){
            getImageManeger().reverseResult()
        }
        let rootVC = self.viewControllers.first as? AssetGroupDetailVC
        rootVC?.collectionView!.reloadData()
        rootVC?.collectionView.performBatchUpdates({
            rootVC?.collectionView!.reloadData()
        }, completion: nil)
    }
    
    internal func selectImage(_ asset: ImageAsset){
        if self.singleSelect {
            self.selectedAssets.append(asset)
            self.done()
        } else {
            self.selectedAssets.append(asset)
        }
    }
    
    internal func deselectImage(_ asset:ImageAsset){
        self.selectedAssets.remove(at: selectedAssets.index(of: asset)!)
    }
}
