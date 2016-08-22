//
//  PhotoViewController.swift
//  PhotoFun
//
//  Created by Joe Wilson on 8/19/16.
//  Copyright © 2016 Joe Wilson. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet weak var contentView: UIView!
    
    var photo: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.maximumZoomScale = 15.0
        
        imageView.image = photo
        print("image size: \((Double((UIImageJPEGRepresentation(photo, 0.8)?.length)!)) / 1000000)MB")

        
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
}
