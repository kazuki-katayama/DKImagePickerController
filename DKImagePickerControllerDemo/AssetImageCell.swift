//
//  AssetImageCell.swift
//  PhotoBook
//
//  Created by 片山 一樹 on 2017/02/20.
//  Copyright © 2017年 New Imaging System Co.,Ltd. All rights reserved.
//

import UIKit
import Photos

class AssetImageCell: UICollectionViewCell {
    open class func cellReuseIdentifier() -> String {
        return "AssetImageCell"
    }
    open var asset: ImageAsset?
    open var index:Int = 0 {
        didSet {
            self.checkView.checkLabel.text = "\(self.index + 1)"
        }
    }
    open var thumbnailImage: UIImage? {
        didSet {
            self.thumbnailImageView.image = self.thumbnailImage
        }
    }
    open var imageSize: CGSize!
    open var uniformTypeIdentifer: String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.thumbnailImageView.frame = self.bounds
        self.thumbnailImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.contentView.addSubview(self.thumbnailImageView)
        
        self.checkView.frame = self.bounds
        self.checkView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.checkView.checkImageView.tintColor = nil
        self.checkView.checkLabel.font = UIFont.boldSystemFont(ofSize: 14)
        self.checkView.checkLabel.textColor = UIColor.white
        self.errorView.frame = self.bounds
        self.errorView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.contentView.addSubview(self.checkView)
        self.contentView.addSubview(self.errorView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate lazy var thumbnailImageView: UIImageView = {
        let thumbnailImageView = UIImageView()
        thumbnailImageView.contentMode = .scaleAspectFill
        thumbnailImageView.clipsToBounds = true
        
        return thumbnailImageView
    }()
    
    /** ImageErrorView */
    /** 選択できない画像に表示 */
    class ImageErrorView: UIView{
        internal lazy var checkErrorView:UIImageView = {
            let imageView = UIImageView(image: #imageLiteral(resourceName: "image_error"))
            imageView.isHidden = true
            return imageView
        }()
        
        internal lazy var errorWhiteView:UIView = {
            let errorWhiteView = UIView()
            errorWhiteView.backgroundColor = UIColor.white
            errorWhiteView.alpha = 0.8
            errorWhiteView.isHidden = true
            return errorWhiteView
        }()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            self.addSubview(errorWhiteView)
            self.addSubview(checkErrorView)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            let errorMarkOrigin : CGPoint = CGPoint(x:0,y:self.bounds.height - 30)
            let errorMarkSize : CGSize = CGSize(width: 30, height: 30)
            self.checkErrorView.frame = CGRect(origin:errorMarkOrigin,size:errorMarkSize)
            self.errorWhiteView.frame = self.bounds
        }
        
    }

    
    /** ImageCheckView */
    /** 選択された画像に表示 */
    class ImageCheckView : UIView {
        internal lazy var checkImageView: UIImageView = {
            let imageView = UIImageView(image: #imageLiteral(resourceName: "number_base"))
            return imageView
        }()
        
        internal lazy var checkLabel: UILabel = {
            let label = UILabel()
            label.textAlignment = .center
            label.adjustsFontSizeToFitWidth = true
            label.minimumScaleFactor = 0.5
            return label
        }()
        
        override init(frame: CGRect) {
            super.init(frame:frame)
            self.addSubview(checkImageView)
            self.addSubview(checkLabel)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        override func layoutSubviews() {
            super.layoutSubviews()
            let checkOrigin : CGPoint = CGPoint(x:self.bounds.width - 25,y:0)
            let checkLabelOrigin : CGPoint = CGPoint(x:self.bounds.width - 23,y:0)
            let checkSize : CGSize = CGSize(width: 25, height: 25)
            let checkLabelSize : CGSize = CGSize(width: 20, height: 23)
            self.checkImageView.frame = CGRect(origin:checkOrigin,size:checkSize)
            self.checkLabel.frame = CGRect(origin: checkLabelOrigin, size: checkLabelSize)
        }
    }
    /** ImageCheckView */
    
    public let checkView = ImageCheckView()
    
    public let errorView = ImageErrorView()
    
    override var isSelected: Bool {
        didSet {
            checkView.isHidden = !super.isSelected
            checkView.checkImageView.isHidden = !super.isSelected
            checkView.checkLabel.isHidden = !super.isSelected
        }
    }
    open var isSelectable: Bool = true {
        didSet {
            errorView.isHidden = isSelectable
            errorView.errorWhiteView.isHidden = isSelectable
            errorView.checkErrorView.isHidden = isSelectable
        }
    }

    
}
