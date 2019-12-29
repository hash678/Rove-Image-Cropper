//
//  Cropper.swift
//  PracticeApp
//
//  Created by Hassan Abbasi on 24/12/2019.
//  Copyright © 2019 Rove. All rights reserved.
//

import Foundation
import UIKit

class Cropper{
    
    
     func cropImage(image:UIImage, y1:CGFloat, y2:CGFloat) -> CGImage?{
          let startY = y1 > y2 ? y2 : y1
          let endY = y1 > y2 ? y1 : y2
          let cropArea = CGRect(x: 0 , y: startY, width: image.size.width , height: endY - startY)
          
          let cgImage = image.cgImage?.cropping(to: cropArea)
            return cgImage
         // imageView.image = UIImage(cgImage:cgImage!)
          
      }
      
    
    func removeAreaInBetween(image:UIImage, y1:CGFloat, y2:CGFloat) -> UIImage?{
          let startY = y1 > y2 ? y2 : y1
               let endY = y1 > y2 ? y1 : y2
        
        let imageStartY:CGFloat = 0
        let imageEndY = image.size.height
        
        print("ImageStartY \(y1)  ImageEndY \(y2)")
        
        guard let topImage = cropImage(image: image, y1: imageStartY, y2: startY) else{return nil}
        guard let bottomImage = cropImage(image: image, y1: endY, y2: imageEndY) else{return nil}
        
        let size = CGSize(width: image.size.width, height: CGFloat(topImage.height + bottomImage.height))
        UIGraphicsBeginImageContext(size)
        var areaSize = CGRect(x: 0, y: 0, width: size.width, height: CGFloat(topImage.height))
        UIImage(cgImage:topImage).draw(in: areaSize)

        
        areaSize = CGRect(x: 0, y: CGFloat(topImage.height), width: size.width, height: CGFloat(bottomImage.height))

        UIImage(cgImage:bottomImage).draw(in: areaSize)

        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
        
        
    }
    
    
    func getBarPos(yPos:CGFloat, imageScaleFactor:CGFloat,imageStartY:CGFloat ) -> CGFloat{
        //let barPos = yPos
        let yRelativeToImage = yPos - imageStartY
        let yBarScaled = yRelativeToImage / imageScaleFactor
        return yBarScaled
    }

    
    
}
