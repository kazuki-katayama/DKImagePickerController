//
//  DKAssetGroupDetailImageCell.swift
//  DKImagePickerController
//
//  Created by ZhangAo on 07/12/2016.
//  Copyright © 2016 ZhangAo. All rights reserved.
//

import UIKit

class DKAssetGroupDetailImageCell: DKAssetGroupDetailBaseCell {
    
    class override func cellReuseIdentifier() -> String {
        return "DKImageAssetIdentifier"
    }
    
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
        self.checkView.isSelectable = self.isSelectable
        self.contentView.addSubview(self.checkView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class DKImageCheckView: UIView {
        
        var isSelectable : Bool = true
        
        internal lazy var checkImageView: UIImageView = {
            let imageView = UIImageView(image: DKImageResource.checkedImage().withRenderingMode(.alwaysOriginal))
            return imageView
        }()
        
        internal lazy var checkLabel: UILabel = {
            let label = UILabel()
            label.textAlignment = .center
            
            return label
        }()
        
        internal lazy var checkErrorView:UIImageView = {
            let imageView = UIImageView(image: DKImageResource.checkedError().withRenderingMode(.alwaysOriginal))
            imageView.isHidden = true
            return imageView
        }()
        
        internal lazy var errorWhiteView:UIView = UIView()

        override init(frame: CGRect) {
            super.init(frame: frame)
            
            self.addSubview(checkImageView)
            self.addSubview(checkLabel)
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
            
            let checkOrigin : CGPoint = CGPoint(x:self.bounds.width - 25,y:0)
            let checkSize : CGSize = CGSize(width: 25, height: 25)
            
            
            self.checkImageView.frame = CGRect(origin:checkOrigin,size:checkSize)
            self.checkLabel.frame = CGRect(origin: checkOrigin, size: checkSize)
            
            self.checkErrorView.frame = CGRect(origin:errorMarkOrigin,size:errorMarkSize)
            self.errorWhiteView.frame = self.bounds

        }
        
    } /* DKImageCheckView */
    
    override var thumbnailImage: UIImage? {
        didSet {
            self.thumbnailImageView.image = self.thumbnailImage
        }
    }
    override var index: Int {
        didSet {
            self.checkView.checkLabel.text =  "\(self.index + 1)"
        }
    }
    
    fileprivate lazy var thumbnailImageView: UIImageView = {
        let thumbnailImageView = UIImageView()
        thumbnailImageView.contentMode = .scaleAspectFill
        thumbnailImageView.clipsToBounds = true
        
        return thumbnailImageView
    }()
    
    public let checkView = DKImageCheckView()
    
    override var isSelected: Bool {
        didSet {
            checkView.isHidden = !super.isSelected
        }
    }
    
} /* DKAssetGroupDetailCell */
