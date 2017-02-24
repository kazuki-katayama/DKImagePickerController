//
//  AssetGroupDetailVC.swift
//  PhotoBook
//
//  Created by 片山 一樹 on 2017/02/15.
//  Copyright © 2017年 New Imaging System Co.,Ltd. All rights reserved.
//

import UIKit
import Photos

extension UIView {
    var bottom : CGFloat{
        get{
            return frame.origin.y + frame.size.height
        }
        set{
            var frame       = self.frame
            frame.origin.y  = newValue - self.frame.size.height
            self.frame      = frame
        }
    }
    var right : CGFloat{
        get{
            return self.frame.origin.x + self.frame.size.width
        }
        set{
            var frame       = self.frame
            frame.origin.x  = newValue - self.frame.size.width
            self.frame      = frame
        }
    }
}

internal class AssetGroupDetailVC : UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    internal weak var imagePicker : ImagePicker!
    internal var collectionView:UICollectionView!
    private var footerView: UIView?
    private var registeredCellIdentifiers = Set<String>()
    private var thumbnailSize = CGSize.zero
    private var currentViewSize: CGSize!
    private var countLabel : UILabel!
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if let currentViewSize = self.currentViewSize, currentViewSize.equalTo(self.view.bounds.size) {
            return
        } else {
            currentViewSize = self.view.bounds.size
        }
        
        self.collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = self.imagePicker.UIDelegate.imagePickerLayout(self.imagePicker).init()
        self.collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        self.collectionView.backgroundColor = self.imagePicker.UIDelegate.imagePickerCollectionViewBackgroundColor()
        self.collectionView.allowsMultipleSelection = true
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.view.addSubview(self.collectionView)
        self.footerView = self.imagePicker.UIDelegate.imagePickerFooterView(self.imagePicker)
        if let footerView = self.footerView {
            self.view.addSubview(footerView)
        }
        self.countLabel = self.createCountLabel()
        self.view.addSubview(countLabel)
        updateCountLabel()
        self.checkPhotoPermission()
        //
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //
    }

    private func createCountLabel() -> UILabel {
        let label = UILabel()

        label.backgroundColor = .black
        label.textColor = .white
        label.textAlignment = .center
        
        label.textRect(forBounds: CGRect(), limitedToNumberOfLines: 1)
        
        label.frame.size = CGSize(width: 170, height: 70)
        label.bottom = view.bounds.size.height - (footerView?.bounds.height)! - 15
        label.right = view.bounds.size.width - 15
        label.alpha = 0.8
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 27)
        label.adjustsFontSizeToFitWidth = true
        label.isUserInteractionEnabled = false
        return label
    }
    
    private func updateCountLabel() {
        let format = "%ld/%ld枚"
        self.countLabel.text = String(format: format, self.imagePicker.selectedAssets.count,self.imagePicker.maxSelectableCount)
    }
    
    internal func checkPhotoPermission() {
        func photoDenied(){
            self.collectionView.isHidden = true
        }
        func setup(){
            //
            getImageManeger().fetchAsset()
            print("test")
        }
        ImageManager.checkPhotoPermission { granted in
            granted ? setup() : photoDenied()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 選択されたAssetを取得
        let selectedAsset = (collectionView.cellForItem(at: indexPath) as? AssetImageCell)?.asset
        
        // 選択されたAssetをimagePickerへセット
        self.imagePicker.selectImage(selectedAsset!)
            
        if let cell = collectionView.cellForItem(at: indexPath) as? AssetImageCell {
            // 選択したAsset数-1のIndexを付ける
            cell.index = self.imagePicker.selectedAssets.count - 1
        }
        self.updateCountLabel()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        // 選択→非選択にされたときの挙動
        if let removedAsset = (collectionView.cellForItem(at: indexPath) as? AssetImageCell)?.asset {
            // 非選択にされるアイテムのインデックス取得
            let removedIndex = self.imagePicker.selectedAssets.index(of: removedAsset)!
            
            let indexPathsForSelectedItems = collectionView.indexPathsForSelectedItems!
            let indexPathsForVisibleItems = collectionView.indexPathsForVisibleItems
            
            let intersect = Set(indexPathsForVisibleItems).intersection(Set(indexPathsForSelectedItems))
            
            for selectedIndexPath in intersect {
                if let selectedCell = (collectionView.cellForItem(at: selectedIndexPath) as? AssetImageCell) {
                    let selectedIndex = self.imagePicker.selectedAssets.index(of: selectedCell.asset!)!
                    if selectedIndex > removedIndex {
                        selectedCell.index = selectedCell.index - 1
                    }
                }
            }
            self.imagePicker.deselectImage(removedAsset)
            self.updateCountLabel()
        }
    }
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        var shouldSelect = true
        let cell = collectionView.cellForItem(at: indexPath) as! AssetImageCell
        let imageSizeWidth = (cell.imageSize?.width)!
        let imageSizeHeight = (cell.imageSize?.height)!
        let imageSizeUnderLimitWidth = CGFloat(self.imagePicker.imageSizeUnderLimit[0])
        let imageSizeUnderLimitHeight = CGFloat(self.imagePicker.imageSizeUnderLimit[1])
        
        if self.imagePicker.selectedAssets.count >= self.imagePicker.maxSelectableCount {
            self.imagePicker.UIDelegate.imagePickerDidReachMaxLimit(self.imagePicker)
            shouldSelect = false
        }else if cell.uniformTypeIdentifer != "public.jpeg" {
            self.imagePicker.UIDelegate.imagePickerDidDisableCell(self.imagePicker)
            shouldSelect = false
        }else if imageSizeWidth < imageSizeUnderLimitWidth || imageSizeHeight < imageSizeUnderLimitHeight {
            self.imagePicker.UIDelegate.imagePickerDidImageSizeTooSmall(self.imagePicker)
            shouldSelect = false
        }
        return shouldSelect
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let footerView = self.footerView {
            footerView.frame = CGRect(x: 0, y: self.view.bounds.height - footerView.bounds.height, width: self.view.bounds.width, height: footerView.bounds.height)
            self.collectionView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height - footerView.bounds.height)
        } else {
            self.collectionView.frame = self.view.bounds
        }
        countLabel.text = String(format: countLabel.text!, self.imagePicker.selectedAssets.count,self.imagePicker.maxSelectableCount)
    }

    // Cell情報作成
    func registerCellIfNeeded(cellClass: AssetImageCell.Type){
        let cellReuseIdentifier = cellClass.cellReuseIdentifier()
        if !self.registeredCellIdentifiers.contains(cellReuseIdentifier){
            self.collectionView.register(cellClass, forCellWithReuseIdentifier: cellReuseIdentifier)
            self.registeredCellIdentifiers.insert(cellReuseIdentifier)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return getImageManeger().fetchResult.count
    }
    
    //データを返すメソッド
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return self.dequeueReusableCell(for: indexPath)
    }
    
    // セル再利用時に使用するメソッド
    func dequeueReusableCell(for indexPath: IndexPath) -> AssetImageCell {
        let asset = getImageManeger().getAsset(for: indexPath.row)!
        let cellClass = AssetImageCell.self
        self.registerCellIfNeeded(cellClass: cellClass)
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: cellClass.cellReuseIdentifier(), for: indexPath) as! AssetImageCell
        self.setup(assetCell: cell, for: indexPath, with: asset)
        return cell
    }
    
    func setup(assetCell cell:AssetImageCell, for indexPath:IndexPath , with asset:ImageAsset){
        cell.asset = asset
        let tag = indexPath.row + 1
        cell.tag = tag
        if self.thumbnailSize.equalTo(CGSize.zero){
            self.thumbnailSize = self.collectionView!.collectionViewLayout.layoutAttributesForItem(at: indexPath)!.size
        }
        asset.fetchImageWithSize(self.thumbnailSize, options: nil, contentMode: .aspectFill, completeBlock: {(image,info) in
            if cell.tag == tag{
                cell.thumbnailImage = image
            }
        })
        
        if let index = self.imagePicker.selectedAssets.index(of: asset){
            cell.isSelected = true
            cell.index = index
            self.collectionView!.selectItem(at: indexPath, animated: false, scrollPosition: [])
        } else {
            cell.isSelected = false
            self.collectionView!.deselectItem(at: indexPath, animated: false)
        }
        cell.imageSize = CGSize(width: asset.originalAsset!.pixelWidth, height: asset.originalAsset!.pixelHeight)
        let options = PHImageRequestOptions()
        PHImageManager.default().requestImageData(for: asset.originalAsset!, options: options){
            (result, uti, orientation, info) -> Void in
            // cellにUTIStringを設定
            cell.uniformTypeIdentifer = uti
            
            let imageSizeWidth = (cell.imageSize?.width)!
            let imageSizeHeight = (cell.imageSize?.height)!
            let imageSizeUnderLimitWidth = CGFloat(self.imagePicker.imageSizeUnderLimit[0])
            let imageSizeUnderLimitHeight = CGFloat(self.imagePicker.imageSizeUnderLimit[1])
            
            // サイズ判定
            let sizeSelectable = (imageSizeWidth >= imageSizeUnderLimitWidth ) && (imageSizeHeight >= imageSizeUnderLimitHeight)
            
            // ファイル拡張子判定
            let utiSelectable = cell.uniformTypeIdentifer == "public.jpeg"
            cell.isSelectable = sizeSelectable && utiSelectable
        }
    }
    
    
}
