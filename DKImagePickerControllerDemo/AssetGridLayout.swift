//
//  AssetGridLayout.swift
//  PhotoBook
//
//  Created by 片山 一樹 on 2017/02/15.
//  Copyright © 2017年 New Imaging System Co.,Ltd. All rights reserved.
//  UICollectionViewのグリッドレイアウトを作成
//

import UIKit



open class AssetGridLayout: UICollectionViewFlowLayout {
    open override func prepare() {
        super.prepare()
        // セルアイテムのサイズ
        var minItemWidth : CGFloat = 80
        // iPadだった場合はサイズを大きくする
        if UI_USER_INTERFACE_IDIOM() == .pad {
            minItemWidth = 100
        }
        
        // セルの間に入る空白を表現
        let interval: CGFloat = 1
        self.minimumInteritemSpacing = interval
        self.minimumLineSpacing = interval

        let contentWidth = self.collectionView!.bounds.width
        
        let itemCount = Int(floor(contentWidth / minItemWidth))
        var itemWidth = (contentWidth - interval * (CGFloat(itemCount) - 1)) / CGFloat(itemCount)
        let actualInterval = (contentWidth - CGFloat(itemCount) * itemWidth) / (CGFloat(itemCount) - 1)
        itemWidth += actualInterval - interval
        
        let itemSize = CGSize(width: itemWidth, height: itemWidth)
        self.itemSize = itemSize
    }
}
