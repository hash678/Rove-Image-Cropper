//
//  CropView.swift
//  PracticeApp
//
//  Created by Hassan Abbasi on 18/06/2019.
//  Copyright © 2019 Rove. All rights reserved.
//

import Foundation
import UIKit

class CropView:UIView{
    
    
    fileprivate let leftTop = UIView()
    fileprivate let leftBottom = UIView()
    fileprivate let rightTop = UIView()
    fileprivate let rightBottom = UIView()
    
    fileprivate var maxX:CGFloat {get{return self.view.frame.width - self.frame.width}}
    
    fileprivate var maxY:CGFloat {get {return imageMaxY! - self.frame.height + Sheight}}
    
   fileprivate  var minX:CGFloat {get{return self.view.frame.origin.x}}
   fileprivate  var minY:CGFloat {get {return imageMinY! - Sheight}}
    
    
    
   fileprivate var minWidth:CGFloat {get{return self.size.width}}
   fileprivate var minHeight:CGFloat {get{return self.size.height}}
  
    fileprivate var Swidth:CGFloat { get {return self.frame.width    }}
   fileprivate var Sheight:CGFloat { get {return 20 }}
    
    
    var imageMaxY:CGFloat?
    var imageMinY:CGFloat?
    
    fileprivate var view:UIView!

    
    var bottomY:CGFloat{
        return self.frame.maxY - Sheight
    }

    
    
    var topY:CGFloat{
        return self.frame.minY + Sheight
    }
    
    
    var color:UIColor = #colorLiteral(red: 0.5563425422, green: 0.9793455005, blue: 0, alpha: 1){
        didSet{
            self.backgroundColor = color
        }
    }
    
    var overlayHeight:CGFloat = 100 {
        didSet{
            self.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: overlayHeight)
        }
    }
    
    
    
    var size:CGSize = CGSize(width: 200, height: 100)
    var transparency:CGFloat = 0.6{
        didSet{
            self.alpha = transparency
        }
    }
    

    
    
    
    @objc fileprivate func scalePiece(_ gestureRecognizer : UIPinchGestureRecognizer) {   guard gestureRecognizer.view != nil else { return }
        
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
          // self.transform = self.transform.scaledBy(x:  gestureRecognizer.scale, y:  gestureRecognizer.scale)
           
           
            
            guard let deltaX =  gestureRecognizer.scale(view: view)?.x else{
                return
            }
            
            guard let deltaY =  gestureRecognizer.scale(view: view)?.y else{
                return
            }
            
            var newHeight = self.frame.height * deltaY
            var newWidth = self.frame.width * deltaX
            
        
            
        
            
       
            
            
            let adjustX = self.frame.width - newWidth
            var newX =  self.frame.minX + (adjustX / 2)
            
            let adjustY = self.frame.height - newHeight
            var newY =  self.frame.minY + (adjustY / 2)
            
             validateSize(width: &newWidth, height: &newHeight, newX: &newX, newY: &newY)
 
            self.frame = CGRect(x: newX, y: newY, width: newWidth, height: newHeight)
            positionStretchers(container: self)

            gestureRecognizer.scale = 1.0
        }}
    
    
  
   
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init( container view:UIView,frame:CGRect ){
        size.width = frame.width
        size.height = frame.height
        
        super.init(frame:frame)
        self.view = view
        setupView()
    }
    
    fileprivate func setupView(){
        
      
        self.backgroundColor = color
        self.alpha = transparency
        
        self.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(dragged(gesture:))))
       // self.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(scalePiece(_:))))
        
        self.isUserInteractionEnabled = true
        
        self.addSubview(createStrechers(dir: .leftDown, container: self))
        self.addSubview(createStrechers(dir: .leftTop, container: self))
        self.addSubview(createStrechers(dir: .rightTop, container: self))
        self.addSubview(createStrechers(dir: .rightDown, container: self))
        
        positionStretchers(container: self)
        
        
    }
    fileprivate func positionStretchers(container:UIView){
      
        
        
        leftTop.frame = CGRect(x: 0, y: 0, width: Swidth, height: Sheight)
        rightTop.frame = CGRect(x: container.frame.width - Swidth, y: 0, width: Swidth, height: Sheight)
        leftBottom.frame = CGRect(x: 0, y: container.frame.height - Sheight, width: Swidth, height: Sheight)
        rightBottom.frame = CGRect(x: container.frame.width - Swidth, y: container.frame.height - Sheight, width: Swidth, height: Sheight)
        
        
    }
    
    fileprivate func createStrechers(dir:direction, container:UIView) -> UIView{
        
        let view:UIView!
        let gesture:UIPanGestureRecognizer!
        
        
        switch dir {
        case .leftTop:
            view = leftTop
            
            
            gesture = UIPanGestureRecognizer(target: self, action: #selector(stretchLeftTop(gesture:)))
            
        case .rightTop:
            view = rightTop
            
            
            gesture = UIPanGestureRecognizer(target: self, action: #selector(stretchRightTop(gesture:)))
        case .leftDown:
            view = leftBottom
            
            
            gesture = UIPanGestureRecognizer(target: self, action: #selector(stretchLeftDown(gesture:)))
        case .rightDown:
            view = rightBottom
            
            
            gesture = UIPanGestureRecognizer(target: self, action: #selector(stretchRightDown(gesture:)))
        }
        
        
        view.backgroundColor = UIColor.gray.withAlphaComponent(0.8)
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(gesture)
        return view
    }
    
    
    
    
    @objc fileprivate func stretchLeftTop(gesture:UIPanGestureRecognizer){
        strecthObject(dir: .leftTop, gesture: gesture, mainView: self, container: view)
        
    }
    @objc fileprivate func stretchLeftDown(gesture:UIPanGestureRecognizer){
        strecthObject(dir: .leftDown, gesture: gesture, mainView: self, container: view)
        
    }
    @objc fileprivate func stretchRightTop(gesture:UIPanGestureRecognizer){
        strecthObject(dir: .rightTop, gesture: gesture, mainView: self, container: view)
        
    }
    @objc fileprivate func stretchRightDown(gesture:UIPanGestureRecognizer){
        strecthObject(dir: .rightDown, gesture: gesture, mainView: self, container: view)
        
    }
    
    
    
    
    fileprivate func strecthObject(dir:direction, gesture:UIPanGestureRecognizer, mainView:UIView, container:UIView){
        
        
        
        let translation = gesture.translation(in: view)
        
        
        
        let stepX =  translation.x
        let stepY =  translation.y
       
        
       
        
        
        var width:CGFloat!
        var newX:CGFloat!
        
        
        var newY:CGFloat!
        var height:CGFloat!
        
        
        
        
        
        
        
        
        width = mainView.frame.width - stepX
        height = mainView.frame.height - stepY
        
        
        
        switch dir {
        case .leftTop:
            newX = mainView.frame.origin.x + stepX
            newY = mainView.frame.origin.y + stepY
            
        case .rightTop:
            width = mainView.frame.width + stepX
            
            newX = mainView.frame.origin.x
            newY = mainView.frame.origin.y + stepY
            
        case .leftDown :
            
            height = mainView.frame.height + stepY
            
            newX = mainView.frame.origin.x + stepX
            newY = mainView.frame.origin.y
            
        case .rightDown:
            width = mainView.frame.width + stepX
            
            newX = mainView.frame.origin.x
            newY = mainView.frame.origin.y
            
            height = mainView.frame.height + stepY
            
        }
        
        
        
        
        
        
        
        validateSize(width: &width, height: &height, newX: &newX, newY: &newY, caseDir: dir)
        
        
        
   
        //APPLY Changes
        mainView.frame = CGRect(x: newX, y: newY, width: width, height: height)
        //fixStretchers()
        positionStretchers(container: mainView)
        gesture.setTranslation(CGPoint.zero, in: view)
      
    
    }
    
    fileprivate func fixStretchers(){
        leftTop.frame = CGRect(x: leftTop.frame.minX, y: leftTop.frame.minY, width: Swidth, height: Sheight)
        rightTop.frame = CGRect(x: rightTop.frame.minX, y: rightTop.frame.minY, width: Swidth, height: Sheight)
        leftBottom.frame = CGRect(x: leftBottom.frame.minX, y: leftBottom.frame.minY, width: Swidth, height: Sheight)
        rightBottom.frame = CGRect(x: rightBottom.frame.minX, y: rightBottom.frame.minY, width: Swidth, height: Sheight)

    }
        
        
    
    
    
    fileprivate func validateSize( width:inout CGFloat,  height: inout CGFloat,  newX: inout CGFloat,  newY: inout CGFloat, caseDir:direction? = nil){
        //Check to make sure rectangle/object stays inside of container.
        if newX < minX{
            
            
            let dif = minX - newX
            newX = minX
            width = width - dif
            
        }
        
        if width < minWidth{
           let dif = minWidth - width
            width = minWidth
            if caseDir == .leftTop || caseDir == .leftDown{
            
                newX = newX - dif
                
            }
            
        }
        
        
        if newX > maxX{
            
           
            
            let dif = newX - maxX
         newX = maxX
            
            width = width - dif
        
        
        }
        
        
        
        if newY > maxY{
            //print("this is maxY 1\(maxY)")
             print("Max Y")
            
            newY = maxY
            let dif = newY - maxY
            height = height - dif
        }
        
        
        
        if newY < minY{
            print("MIN Y")
            let dif = minY - newY
            newY = minY
            height = height - dif
            
        }
        if height < minHeight{
             print("MIN Height")
            
            let dif = minHeight - height
            height = minHeight
            
            if caseDir == CropView.direction.leftTop || caseDir == CropView.direction.rightTop{
                newY = newY - dif
                
            }
            
        }
        
        
        
    }
    
    
    enum direction{
        case leftTop
        case rightTop
        case leftDown
        case rightDown
    }
    
    @objc fileprivate func dragged(gesture:UIPanGestureRecognizer){
        
        
        
        
        
        view.bringSubviewToFront(self)
        let translation = gesture.translation(in: view)
        
        var translatedX = self.center.x + translation.x
        var translatedY =   self.center.y + translation.y
        
        print(self.center.y)
        
        
        
        let maxX = view.frame.maxX  - (self.frame.width / 2)
        let minX = view.frame.minX + (self.frame.width / 2)
        
        //let maxY = view.frame.maxY  - (self.frame.height / 2)
        //let minY = view.frame.minY + (self.frame.height / 2)
        
        let minY = imageMinY! + (self.frame.height / 2) - Sheight
        let maxY = imageMaxY! - (self.frame.height / 2) + Sheight

       print("FRAMEY \(imageMinY!)")
       

        print("MAX Y \(maxY)  currentY \(translatedY)")
        
        print("FRAMEMinY \(view.frame.minY)")
               print("Min Y \(minY)  currentY \(translatedY)")
        
        
        if translatedX > maxX {
            translatedX = maxX
        }else if translatedX  < minX{
            translatedX = minX
        }
        
        if translatedY > maxY {
            translatedY = maxY
        }else if translatedY  < minY{
            translatedY =  minY
        }
        
        
        
        
        translatedY = translatedY > maxY ? view.frame.maxY - (self.frame.height / 2): translatedY
        
        
        
        
        self.center = CGPoint(x: translatedX, y:translatedY)
        gesture.setTranslation(CGPoint.zero, in: view)
        
    }
    
  
    
    func coordinates() -> (leftTop:CGPoint, leftDown:CGPoint, rightTop:CGPoint, rightDown:CGPoint) {
       let leftTop = CGPoint(x: self.frame.minX, y: self.frame.minY)
       let rightTop = CGPoint(x: self.frame.minX + self.frame.width, y: self.frame.minY)
    
        let leftDown = CGPoint(x: self.frame.minX, y: self.frame.minY + self.frame.height)
        let rightDown = CGPoint(x:  self.frame.minX + self.frame.width, y:  self.frame.minY + self.frame.height)
        
        return(leftTop,leftDown,rightTop,rightDown)
        // return(self.frame.minX,)
        
    }
    
    
}
extension UIPinchGestureRecognizer {
    func scale(view: UIView) -> (x: CGFloat, y: CGFloat)? {
        if numberOfTouches > 1 {
            let touch1 = self.location(ofTouch: 0, in: view)
            let touch2 = self.location(ofTouch: 1, in: view)
            let deltaX = abs(touch1.x - touch2.x)
            let deltaY = abs(touch1.y - touch2.y)
            let sum = deltaX + deltaY
            if sum > 0 {
                let scale = self.scale
                return (1.0 + (scale - 1.0) * (deltaX / sum), 1.0 + (scale - 1.0) * (deltaY / sum))
            }
        }
        return nil
    }
    
    func centerTouch() -> CGPoint?{
        
        
        if numberOfTouches > 1 {
            let touch1 = self.location(ofTouch: 0, in: view)
            let touch2 = self.location(ofTouch: 1, in: view)
            
            let middleX = (touch1.x + touch2.x )/2
             let middleY = (touch1.y + touch2.y )/2
            
            return CGPoint(x: middleX, y: middleY)
        }
        return nil
    }
}
