//
//  CassiniViewController.swift
//  Cassini
//
//  Created by Zac on 2/5/17.
//  Copyright © 2017 Zac. All rights reserved.
//

import UIKit

class CassiniViewController: UIViewController, UISplitViewControllerDelegate
{
    private struct Storyboard
    {
        static let showImageSegue = "Show Image"
    }
    
    
    /// In a storyboard-based application, you will often want to do a little preparation before navigation
    ///
    /// - Parameters:
    ///   - segue: <#segue description#>
    ///   - sender: UIButton
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == Storyboard.showImageSegue
        {
            if let ivc = segue.destination.contentViewController as? ImageViewController
            {
                let imageName = (sender as? UIButton)?.currentTitle
                
                ivc.imageURL = DemoURL.NASAImageNamed(imageName: imageName) as URL?
                
                ivc.title = imageName
            }
        }
    }
    
    
    /// iPad and iPhone
    ///
    /// - Parameter sender: <#sender description#>
    @IBAction func showImage(_ sender: UIButton)
    {   // No segue for iPad
        if let ivc = splitViewController?.viewControllers.last?.contentViewController as? ImageViewController
        {
            let imageName = sender.currentTitle
            
            ivc.imageURL = DemoURL.NASAImageNamed(imageName: imageName) as URL?
            
            ivc.title = imageName
        }
        else  // segue for iPhone
        {
            performSegue(withIdentifier: Storyboard.showImageSegue, sender: sender)
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        splitViewController?.delegate = self
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary
                            secondaryViewController: UIViewController,
                            onto primaryViewController: UIViewController) -> Bool
    {
        if primaryViewController.contentViewController == self
        {
            if let ivc = secondaryViewController.contentViewController as? ImageViewController, ivc.imageURL == nil
            {
                return true
            }
        }
        return false
    }
}

extension UIViewController
{
    var contentViewController: UIViewController
    {
        if let navcon = self as?  UINavigationController
        {
            return navcon.visibleViewController ?? self
        }
        return self
    }
}
