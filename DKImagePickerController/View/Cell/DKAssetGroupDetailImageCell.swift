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
        self.errorView.frame = self.bounds
        self.errorView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.contentView.addSubview(self.checkView)
        self.contentView.addSubview(self.errorView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class DKImageErrorView: UIView{
        internal lazy var checkErrorView:UIImageView = {
            let imageView = UIImageView(image: DKImageResource.checkedError().withRenderingMode(.alwaysOriginal))
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
    
    class DKImageCheckView: UIView {
        
        internal lazy var checkImageView: UIImageView = {
            let imageView = UIImageView(image: DKImageResource.checkedImage().withRenderingMode(.alwaysOriginal))
            imageView.isHidden = true
            return imageView
        }()
        
        internal lazy var checkLabel: UILabel = {
            let label = UILabel()
            label.textAlignment = .center
            
            return label
        }()
        

        override init(frame: CGRect) {
            super.init(frame: frame)
            self.addSubview(checkImageView)
            self.addSubview(checkLabel)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            let checkOrigin : CGPoint = CGPoint(x:self.bounds.width - 25,y:0)
            let checkSize : CGSize = CGSize(width: 25, height: 25)
            self.checkImageView.frame = CGRect(origin:checkOrigin,size:checkSize)
            self.checkLabel.frame = CGRect(origin: checkOrigin, size: checkSize)
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
    
    public let errorView = DKImageErrorView()
    
    override var isSelected: Bool {
        didSet {
            checkView.isHidden = !super.isSelected
            checkView.checkImageView.isHidden = !super.isSelected
            checkView.checkLabel.isHidden = !super.isSelected
        }
    }
    override var isSelectable: Bool {
        didSet {
            errorView.isHidden = super.isSelectable
            errorView.errorWhiteView.isHidden = super.isSelectable
            errorView.checkErrorView.isHidden = super.isSelectable
        }
    }
    
    
} /* DKAssetGroupDetailCell */
