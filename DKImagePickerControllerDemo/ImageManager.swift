//
//  ImageManager.swift
//  PhotoBook
//
//  Created by 片山 一樹 on 2017/02/17.
//  Copyright © 2017年 New Imaging System Co.,Ltd. All rights reserved.
//

import Photos

public class ImageManager {
    
    static let sharedInstance = ImageManager()
    private let manager = PHCachingImageManager()
    
    private(set) var sortByAsc = true
    
    private lazy var defaultImageRequestOptions: PHImageRequestOptions = {
        let options = PHImageRequestOptions()
        
        return options
    }()
    
    public var autoDownloadWhenAssetIsInCloud = true
    
    var fetchResult = PHAsset.fetchAssets(with: .image, options: nil)
    var fetchResultArray : [ImageAsset] = []
    
    public func reFetchResult(_ options:PHFetchOptions?){
        self.fetchResult = PHAsset.fetchAssets(with: .image, options: options)
    }
    
    public class func checkPhotoPermission (_ handler: @escaping (_ granted: Bool) -> Void ){
        func hasPhotoPermission() -> Bool {
            return PHPhotoLibrary.authorizationStatus() == .authorized
        }
        func needsToRequestPhotoPermission() -> Bool {
            return PHPhotoLibrary.authorizationStatus() == .notDetermined
        }
        if hasPhotoPermission(){
            handler(true)
        }else{
            if needsToRequestPhotoPermission() {
                PHPhotoLibrary.requestAuthorization({ status in
                    DispatchQueue.main.async(execute: { () in
                        hasPhotoPermission() ? handler(true) : handler(false)
                    })
                })
            }else{
                handler(false)
            }
        }
    }
    
    
    
    public func fetchAsset(){
        fetchResult.enumerateObjects({ [weak self] (asset,index,stop) -> Void in
            guard let wself = self else {return}
            wself.fetchResultArray.append(ImageAsset(originalAsset: asset))
        })
    }
    
    public func reverseResult() {
        sortByAsc = !sortByAsc
        fetchResultArray.reverse()
    }
    
    public func getAsset(for index: Int) -> ImageAsset?{
        return fetchResultArray[index]
    }
    public func fetchImageForAsset(_ asset: ImageAsset, size: CGSize, options: PHImageRequestOptions?, contentMode: PHImageContentMode,
                                   completeBlock: @escaping (_ image: UIImage?, _ info: [AnyHashable: Any]?) -> Void) {
        let options = (options ?? self.defaultImageRequestOptions).copy() as! PHImageRequestOptions
        
        self.manager.requestImage(for: asset.originalAsset!,
                                  targetSize: size,
                                  contentMode: contentMode,
                                  options: options,
                                  resultHandler: { image, info in
                                    if let isInCloud = info?[PHImageResultIsInCloudKey] as AnyObject?
                                        , image == nil && isInCloud.boolValue && self.autoDownloadWhenAssetIsInCloud {
                                        options.isNetworkAccessAllowed = true
                                        self.fetchImageForAsset(asset, size: size, options: options, contentMode: contentMode, completeBlock: completeBlock)
                                    } else {
                                        completeBlock(image, info)
                                    }
        })
    }

    public func fetchImageDataForAsset(_ asset: ImageAsset, options: PHImageRequestOptions?, completeBlock: @escaping (_ data: Data?, _ info: [AnyHashable: Any]?) -> Void) {
        self.manager.requestImageData(for: asset.originalAsset!,
                                      options: options ?? self.defaultImageRequestOptions) { (data, dataUTI, orientation, info) in
                                        if let isInCloud = info?[PHImageResultIsInCloudKey] as AnyObject?
                                            , data == nil && isInCloud.boolValue && self.autoDownloadWhenAssetIsInCloud {
                                            let requestCloudOptions = (options ?? self.defaultImageRequestOptions).copy() as! PHImageRequestOptions
                                            requestCloudOptions.isNetworkAccessAllowed = true
                                            self.fetchImageDataForAsset(asset, options: requestCloudOptions, completeBlock: completeBlock)
                                        } else {
                                            completeBlock(data, info)
                                        }
        }
    }
}

public func getImageManeger() -> ImageManager {
    return ImageManager.sharedInstance
}
