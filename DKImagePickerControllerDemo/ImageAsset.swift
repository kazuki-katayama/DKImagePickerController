//
//  ImageAsset.swift
//  PhotoBook
//
//  Created by 片山 一樹 on 2017/02/20.
//  Copyright © 2017年 New Imaging System Co.,Ltd. All rights reserved.
//

import Photos

open class ImageAsset: NSObject {
    private var fullScreenImage:(image: UIImage?, info: [AnyHashable: Any]?)?
    open private(set) var originalAsset: PHAsset?
    open var localIdentifier: String
    public init(originalAsset: PHAsset) {
        self.localIdentifier = originalAsset.localIdentifier
        super.init()
        
        self.originalAsset = originalAsset
    }
    private var image: UIImage?
    
    internal init(image: UIImage){
        self.localIdentifier = String(image.hash)
        super.init()
        
        self.image = image
        self.fullScreenImage = (image,nil)
    }
    
    public func fetchImageWithSize(_ size: CGSize, completeBlock: @escaping (_ image: UIImage?, _ info: [AnyHashable: Any]?) -> Void) {
        self.fetchImageWithSize(size, options: nil, completeBlock: completeBlock)
    }
    
    public func fetchImageWithSize(_ size: CGSize, options: PHImageRequestOptions?, completeBlock: @escaping (_ image: UIImage?, _ info: [AnyHashable: Any]?) -> Void) {
        self.fetchImageWithSize(size, options: options, contentMode: .aspectFit, completeBlock: completeBlock)
    }
    
    public func fetchImageWithSize(_ size: CGSize, options: PHImageRequestOptions?, contentMode: PHImageContentMode, completeBlock: @escaping (_ image: UIImage?, _ info: [AnyHashable: Any]?) -> Void) {
        if let _ = self.originalAsset {
            getImageManeger().fetchImageForAsset(self, size: size, options: options, contentMode: contentMode, completeBlock: completeBlock)
        } else {
            completeBlock(self.image, nil)
        }
    }

    public func fetchOriginalImageWithCompleteBlock(_ completeBlock: @escaping(_ image:UIImage?, _ info:[AnyHashable: Any]?) -> Void){
        self.fetchOriginalImage(false, completeBlock: completeBlock)
    }
    
    public func fetchOriginalImage(_ sync:Bool ,completeBlock: @escaping (_ image:UIImage?,_ info:[AnyHashable: Any]?) -> Void ){
        let options = PHImageRequestOptions()
        options.version = .current
        options.isSynchronous = sync
        
        getImageManeger().fetchImageDataForAsset(self, options: options, completeBlock: {(data,info) in
            var image:UIImage?
            if let data = data {
                image = UIImage(data:data)
            }
            completeBlock(image,info)
        })
    }
    
}
