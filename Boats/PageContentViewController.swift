//
//  PageContentViewController.swift
//  Boats
//
//  Created by Absolute Mac on 23/07/2018.
//  Copyright © 2018 Absolute Mac. All rights reserved.
//

import UIKit
import AVFoundation

protocol PageContentVCDelegate{
    func sendImage(image: UIImage)
}
class PageContentViewController: UIViewController , UIScrollViewDelegate ,UIGestureRecognizerDelegate {
    
    var scrollImg : UIScrollView?
    
    var pageIndex: Int = 0
    var imageURL : String?
    var imageObject : UIImage?
    var delegate : PageContentVCDelegate?
    
    
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = #imageLiteral(resourceName: "image_placeholder")
       
        addScrollView()
        refreshZoom()
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(refreshZoom))
        tapGR.delegate = self
        tapGR.numberOfTapsRequired = 2
        view.addGestureRecognizer(tapGR)
        
        if let url = imageURL {
            
            WebService().downImage(imgUrl: url) { (img) in
                self.imageView.image = img
            }
            
        } else {
            
            self.imageView.image = imageObject!
            
        }
        
        
   
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK:Scroll configure
   
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        refreshZoom()
    }
    func addScrollView(){
//        let vWidth = self.view.frame.width
//        let vHeight = self.view.frame.height

            let vWidth = self.view.frame.width
            let vHeight = self.view.frame.height
        
//        let imgRect : CGRect = AVMakeRect(aspectRatio: imageView.image!.size, insideRect: imageView.frame)
        
        scrollImg = UIScrollView()
        scrollImg?.delegate = self

        scrollImg?.frame = CGRect(x: 0, y: 0, width: vWidth, height: vHeight)
        
//        scrollImg?.frame = imgRect
        scrollImg?.backgroundColor = UIColor(red: 90, green: 90, blue: 90, alpha: 0.90)
        scrollImg?.alwaysBounceVertical = false
        scrollImg?.alwaysBounceHorizontal = false
        scrollImg?.showsVerticalScrollIndicator = true
        scrollImg?.flashScrollIndicators()
        
        scrollImg?.minimumZoomScale = 1.0
        scrollImg?.maximumZoomScale = 3.0
        
        self.view.addSubview(scrollImg!)
        
        imageView!.layer.cornerRadius = 11.0
        imageView!.clipsToBounds = false
        scrollImg?.addSubview(imageView!)
    }
    
    func refreshZoom(){
       scrollImg?.setZoomScale(0.0, animated: true)
        scrollImg?.setContentOffset(.zero, animated: true)
    
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
