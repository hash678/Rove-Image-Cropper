//
//  ImageViewer.swift
//  PracticeApp
//
//  Created by Hassan Abbasi on 23/12/2019.
//  Copyright © 2019 Rove. All rights reserved.
//

import Foundation
import UIKit

class ImageViewer:UIView{
    
    
    
    
    var croppingStyle:CroppingStyle = CroppingStyle.KeepAreaBetween{
        
        didSet{
            color = croppingStyle == CroppingStyle.KeepAreaBetween ? #colorLiteral(red: 0.5563425422, green: 0.9793455005, blue: 0, alpha: 1) : #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        }
    }
    
    var color:UIColor = #colorLiteral(red: 0.5563425422, green: 0.9793455005, blue: 0, alpha: 1){
        didSet{
           // over.backgroundColor = color
            overlay.color = color
        }
    }
    
    fileprivate let model = Cropper()
    fileprivate var imageScaleFactor:CGFloat = 1
    //fileprivate var imageStartY:CGFloat?
   // fileprivate var imageEndY:CGFloat?
    
    fileprivate var scrollScaleFactor:CGFloat = 1
    fileprivate var scrollTranslation:CGFloat = 0
    
    
    fileprivate lazy var scrollView:UIScrollView = {
        let v = UIScrollView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.delegate = self
        v.maximumZoomScale = 3
        v.minimumZoomScale = 1
        return v
        
        
    }()
    
    
    
    fileprivate lazy var imageView:UIImageView = {
        let v = UIImageView()
        // v.translatesAutoresizingMaskIntoConstraints = false
        v.contentMode = .scaleAspectFit
        v.backgroundColor = .black
        return v
        
        
    }()
    
    
    fileprivate lazy var overlay:CropView = {
        let v = CropView(container: UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)),frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 100))
        v.center = imageView.center
        return v
        
    }()
    
    fileprivate func getScaleFactor() -> CGFloat{
        
        let image = imageView.image!
        //let width = imageView.frame.width
        //let height = imageView.frame.height
        
        //let imageWidth = image.size.width
        let imageHeight = image.size.height
        //let widthBigger = imageWidth > imageHeight
        
        let newImageHeight = imageView.getScaledImageSize()!.height

        //let newImageHeight = widthBigger ? (imageHeight/imageWidth * width) : height
        let imageCenterY = imageView.center.y
     
        
        
         overlay.imageMinY = imageCenterY - (newImageHeight / 2)
        overlay.imageMaxY = imageCenterY + (newImageHeight / 2)
        

        //print("ImageStartY \(imageStartY!)")
        
        //overlay.imageMaxY = imageEndY
       // overlay.imageMinY = imageStartY
        
        return newImageHeight/imageHeight
        //return (widthBigger ? width / imageWidth : height / imageHeight)
    }
    
    
    fileprivate func calculateImageStartEnd(){
            
           //let image = imageView.image!
           //let width = imageView.frame.width
           //let height = imageView.frame.height
           
          // let imageWidth = image.size.width
          // let imageHeight = image.size.height
           //let widthBigger = imageWidth > imageHeight
           
           let newImageHeight = imageView.getScaledImageSize()!.height

           //let newImageHeight = widthBigger ? (imageHeight/imageWidth * width) : height
           let imageCenterY = imageView.center.y
        
           
           
           overlay.imageMinY = imageCenterY - (newImageHeight / 2) - scrollTranslation
           overlay.imageMaxY  = imageCenterY + (newImageHeight / 2) - scrollTranslation
         
           
        
         
           
    }
    
    func loadImage(image:UIImage) {
        imageView.image = image
        scrollView.zoomScale = 1
        scrollView.contentOffset = CGPoint.zero
        scrollScaleFactor = 1
        scrollTranslation = 0
        imageScaleFactor = getScaleFactor()

       
        overlay.center = imageView.center
        
    }
    
    
    func setupViews(){
        
        
        
        print(self.frame)
        
        
        self.backgroundColor = .white
        self.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        
        
        scrollView.addSubview(imageView)
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
        imageView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        
        
        
        print("SCROLVIRE \(scrollView.frame)")
        print("imageView \(imageView.frame)")
        
        
        
        self.addSubview(overlay)
        
        
        //loadImage(image: #imageLiteral(resourceName: "TestImage"))
        
    }
    
    func cropImage( completionHandler: (UIImage?,Cropping?) -> Void) {
        
        let image:UIImage?

        let y1 = model.getBarPos(yPos: overlay.topY, imageScaleFactor: imageScaleFactor / scrollScaleFactor, imageStartY:  overlay.imageMinY!)
        let y2 = model.getBarPos(yPos: overlay.bottomY, imageScaleFactor:  imageScaleFactor / scrollScaleFactor, imageStartY:  overlay.imageMinY!)
        
        
        
        if croppingStyle == .RemoveAreaBetween{
            image = model.removeAreaInBetween(image: imageView.image!, y1: y1, y2: y2)
            
            let cropping = Cropping(y1: Float(y1), y2: Float(y2), cropType: croppingStyle.rawValue)
            completionHandler(image,cropping)
            return
        }else{
            let cgImage = model.cropImage(image: imageView.image!, y1: y1, y2: y2)
            
            if let cgImage = cgImage{
                let cropping = Cropping(y1:  Float(y1), y2: Float(y2), cropType: croppingStyle.rawValue)
                completionHandler(UIImage(cgImage: cgImage),cropping)
                return
            }
        }
        
      completionHandler(nil,nil)
        
    }
    
    fileprivate func scaleView(factor:CGFloat){
        overlay.transform = CGAffineTransform(scaleX: 1, y: factor)
    }
    
    
    override init(frame: CGRect) {
        super.init(frame:frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    
}

extension ImageViewer:UIScrollViewDelegate{
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        //imageScaleFactor = getScaleFactor()
        calculateImageStartEnd()
        print("ScrollView Scaled \(scrollView.contentSize)")
        let factor = scrollView.frame.height / scrollView.contentSize.height
        scrollScaleFactor = factor
        
    }
    
//    fileprivate func calculateNewHeight() -> CGFloat{
//        let imageHeight = (imageEndY! - imageStartY!) / scrollScaleFactor
//        return imageHeight
//
//    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        calculateImageStartEnd()
        
        print("ScrollView translated \(scrollView.contentOffset)")
        scrollTranslation = scrollView.contentOffset.y
    }
}


enum CroppingStyle:String{
    
    case KeepAreaBetween
    case RemoveAreaBetween
}


struct Cropping{
    var y1:Float
    var y2:Float
    var cropType:String?
    
    
}

extension UIImageView {
    /// Retrieve the scaled size of the image within this ImageView.
    /// - Returns: A CGRect representing the size of the image after scaling or nil if no image is set.
    func getScaledImageSize() -> CGRect? {
        if let image = self.image {
            return AVMakeRect(aspectRatio: image.size, insideRect: self.frame);
        }

        return nil;
    }
}


