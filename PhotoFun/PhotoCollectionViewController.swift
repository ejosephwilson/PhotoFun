//
//  PhotoCollectionViewController.swift
//  PhotoFun
//
//  Created by Joe Wilson on 8/19/16.
//  Copyright © 2016 Joe Wilson. All rights reserved.
//

import UIKit
import Photos


class PhotoCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    @IBOutlet var imageCollectionView: UICollectionView!
    
    var imageArray = [UIImage]()
    var fullQualityImageArray = [UIImage]()
    var hasFirstAppeared = false
    
    override func viewWillAppear(animated: Bool) {
        super.viewDidAppear(true)
        if hasFirstAppeared == true {
            //fetchPhotos()
            //print("fetching photos")
        }
        hasFirstAppeared = true
        fullQualityImageArray.removeAll()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchPhotos()

        //NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(didBecomeActive), name: UIApplicationDidBecomeActiveNotification, object: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toPhotoViewController" {
            if let selectedIndexPath = imageCollectionView.indexPathsForSelectedItems()?.first {
                
                let imgManager = PHImageManager.defaultManager()
                
                let requestOptions = PHImageRequestOptions()
                requestOptions.networkAccessAllowed = true
                
                requestOptions.synchronous = true
                requestOptions.deliveryMode = .Opportunistic
                
                let fetchOptions = PHFetchOptions()
                fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)] // most recent image will be displayed first
                let tappedImage = imageArray.indexOf(imageArray[selectedIndexPath.row])
                if let fetchResult: PHFetchResult = PHAsset.fetchAssetsWithMediaType(.Image, options: fetchOptions) {
                    if fetchResult.count > 0 {
                       
                            imgManager.requestImageForAsset(fetchResult.objectAtIndex(tappedImage!) as! PHAsset, targetSize: PHImageManagerMaximumSize, contentMode: .AspectFill, options: requestOptions, resultHandler: {
                                image, error in
                                
                                self.fullQualityImageArray.append(image!)
                            })
                        
                    }
                }
                
                
                let photo = fullQualityImageArray.first
                
                let destinationVC = segue.destinationViewController as! PhotoViewController
                destinationVC.photo = photo
                //imageArray.removeAll()
            }
        }
    }
    
    func fetchPhotos() {
        let imgManager = PHImageManager.defaultManager()
        
        let requestOptions = PHImageRequestOptions()
        requestOptions.synchronous = true
        requestOptions.deliveryMode = .Opportunistic
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)] // most recent image will be displayed first
        
        if let fetchResult: PHFetchResult = PHAsset.fetchAssetsWithMediaType(.Image, options: fetchOptions) {
            imageArray.removeAll()
            if fetchResult.count > 0 {
                for i in 0..<fetchResult.count{
                    imgManager.requestImageForAsset(fetchResult.objectAtIndex(i) as! PHAsset, targetSize: CGSize(width: 120, height: 120), contentMode: .AspectFill, options: requestOptions, resultHandler: {
                        image, error in
                        
                        self.imageArray.append(image!)
                    })
                }
            } else {
                print("u got no photos")
                let reloadAlertController = UIAlertController(title: "No Photos", message: nil, preferredStyle: .Alert)
                let reloadAction = UIAlertAction(title: "Reload", style: .Default, handler: {
                    action in
                    
                    if let fetchResult: PHFetchResult = PHAsset.fetchAssetsWithMediaType(.Image, options: fetchOptions) {
                        if fetchResult.count != self.imageArray.count {
                            self.imageArray.removeAll()
                            if fetchResult.count > 0 {
                                for i in 0..<fetchResult.count{
                                    imgManager.requestImageForAsset(fetchResult.objectAtIndex(i) as! PHAsset, targetSize: CGSize(width: 120, height: 120), contentMode: .AspectFill, options: requestOptions, resultHandler: {
                                        image, error in
                                        
                                        self.imageArray.append(image!)
                                    })
                                }
                            }
                        }
                        self.collectionView?.reloadData()
                    }
                    
                })
                reloadAlertController.addAction(reloadAction)
                presentViewController(reloadAlertController, animated: true, completion: nil)
            }
            
            
        } else {
            return
        }
    }
    
//    func didBecomeActive() {
//        fetchPhotos()
//        self.collectionView?.reloadData()
//        print("did become active")
//    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath)
        let imageView = cell.viewWithTag(1) as! UIImageView
        
        imageView.image = imageArray[indexPath.row]
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let dimension = collectionView.frame.width / 3 - 1
        
        return CGSize(width: dimension, height: dimension)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1.0
    }

}