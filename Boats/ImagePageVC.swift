//
//  ImagePageVC.swift
//  Boats
//
//  Created by Absolute Mac on 23/07/2018.
//  Copyright © 2018 Absolute Mac. All rights reserved.
//

import UIKit

class ImagePageVC: UIPageViewController ,UIPageViewControllerDataSource ,UIPageViewControllerDelegate {

    var imagesURLS : [String] = []
    var imagesObjects : [UIImage] = []
    var boatkey: String?
    var pageControl = UIPageControl()
    var sendWithKey : Bool?
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imagesURLS = []
        self.dataSource = self
        self.delegate = self
        
        if let key = boatkey {
            sendWithKey = true
            WebService().retrieveArrayOfImages(boatKey: key) { (result) in
                self.imagesURLS = result
                
                self.setViewControllers([self.getViewControllerAtIndex(index: 0)] as [UIViewController], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
                self.configurePageControl()
            }
        } else {
                
           sendWithKey = false
            self.setViewControllers([self.getViewControllerAtIndex(index: 0)] as [UIViewController], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
            self.configurePageControl()

        }
            
        }
       
        
        
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//    
    func configurePageControl() {
        // The total number of pages that are available is based on how many available colors we have.
        pageControl.removeFromSuperview()
        pageControl = UIPageControl(frame: CGRect(x: self.view.frame.width/2 - 25,y: self.view.frame.height - 50,width: 50,height: 50))
        
        var numberOfImages : Int
        
        if sendWithKey!{
            numberOfImages = imagesURLS.count
            
        } else {
            numberOfImages = imagesObjects.count
                }
        
//        if numberOfImages < 2 {
//            self.view.isUserInteractionEnabled = false
//        } else {
//            self.view.isUserInteractionEnabled = true
//        }
        
        
        self.pageControl.numberOfPages = numberOfImages
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = UIColor.black
        self.pageControl.pageIndicatorTintColor = UIColor.white
        self.pageControl.currentPageIndicatorTintColor = UIColor.black
        self.view.addSubview(pageControl)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?
    {
        let pageContent: PageContentViewController = viewController as! PageContentViewController
        var index = pageContent.pageIndex
        if  (index == NSNotFound)
        {
            return nil
        }
       
        if sendWithKey!{
            
            if imagesURLS.count == 1 {
                return nil
            } else if index == 0 {
                
                index = imagesURLS.count - 1
            } else {
                index -= 1;
            }

        } else{
            
            if imagesObjects.count == 1 {
                return nil
            } else if index == 0 {
                
                index = imagesObjects.count - 1
            } else {
                index -= 1;
            }

            
        }
        
        
       
        
        return getViewControllerAtIndex(index: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        let pageContent: PageContentViewController = viewController as! PageContentViewController
        var index = pageContent.pageIndex
        if (index == NSNotFound)
        {
            return nil;
        }
        
       
        if sendWithKey! {
            
            if imagesURLS.count == 1 {
                return nil
            } else if (index == imagesURLS.count - 1)
                
            {
                index = 0
            } else {
                index += 1;
            }
            
        } else {
            
            if imagesObjects.count == 1 {
                return nil
            } else if (index == imagesObjects.count - 1)
                
            {
                index = 0
            } else {
                index += 1;
            }
            
        }
        
       
        return getViewControllerAtIndex(index: index)
    }
   
    
    func getViewControllerAtIndex(index: NSInteger) -> PageContentViewController
    {
        // Create a new view controller and pass suitable data.
        let pageContentViewController = self.storyboard?.instantiateViewController(withIdentifier: "PageContentViewController") as! PageContentViewController
        
        if sendWithKey!{
            pageContentViewController.imageURL = imagesURLS[index]
        } else {
            pageContentViewController.imageObject = imagesObjects[index]
        }
        
       
        pageContentViewController.pageIndex = index
        return pageContentViewController
    }
   
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let curentPageVC = pageViewController.viewControllers?[0] as! PageContentViewController
        self.pageControl.currentPage = curentPageVC.pageIndex
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
