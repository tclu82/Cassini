//
//  ImageViewController.swift
//  Cassini
//
//  Created by Zac on 2/3/17.
//  Copyright © 2017 Zac. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate
{
    var imageURL: URL?
    {
        didSet
        {
            image = nil
            // if the view is on the window
            if view.window != nil
            {
                fetchImage()  // fetch is expensive, we only run it when view shows
            }
        }
    }
    
    
    /// Normal fetch image, slow
//    private func fetchImage()
//    {
//        if let url = imageURL
//        {
//            if let imageData = try? Data(contentsOf: url)
//            {
//                image = UIImage(data: imageData)
//            }
//        }
//    }
    
    
    /// fetch image using multi-threading
    private func fetchImage()
    {
        if let url = imageURL
        {
            spinner?.startAnimating()
            
            DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async
            {
                let contentsOfURL = try? Data(contentsOf: url)
                
                DispatchQueue.main.async {
                    
                    if url == self.imageURL
                    {
                        if let imageData = contentsOfURL
                        {
                            self.image = UIImage(data: imageData)
                        }
                        else
                        {
                            self.spinner?.stopAnimating()
                        }
                    }
                    else
                    {
                        print("ignored data returned from url \(url)")
                    }
                }
            }
        }
    }
            
    
    @IBOutlet weak var scrollView: UIScrollView!
    {
        didSet
        {
            scrollView.contentSize = imageView.frame.size
            
            scrollView.delegate = self
            
            scrollView.minimumZoomScale = 0.05
            
            scrollView.maximumZoomScale = 1.0 // default
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    // Create image view with code
    private var imageView = UIImageView()
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    private var image: UIImage?
    {
        get
        {
            return imageView.image
        }
        set
        {
            imageView.image = newValue
            
            imageView.sizeToFit()
            
            scrollView?.contentSize = imageView.frame.size
            
            spinner?.stopAnimating()
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        if image == nil
        {
            fetchImage()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // view is the stroyboard view
        scrollView.addSubview(imageView)
        
//        imageURL = URL(string: DemoURL.SF)
    }
}
