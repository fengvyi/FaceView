//
//  FaceView.swift
//  FaceIt
//
//  Created by Zefeng Song on 17/4/1.
//  Copyright © 2017年 Zefeng Song. All rights reserved.
//

import UIKit

class FaceView: UIView {

    var scale: CGFloat = 0.90
    
    var mouthCurvature: Double = 1.0 // 1 full smile, -1 full frown
    
    var skullRadius: CGFloat { return min(bounds.size.width, bounds.size.height) / 2 * scale }
    var skullCenter: CGPoint { return CGPoint(x: bounds.midX, y: bounds.midY) }
    
    private struct Ratios {
        static let SkullRatiosToEyeOffset: CGFloat = 3
        static let SkullRatiosToEyeRadius: CGFloat = 10
        static let SkullRatiosToMouthWidth: CGFloat = 1
        static let SkullRatiosToMouthHeight: CGFloat = 3
        static let SkullRatiosToMouthOffset: CGFloat = 3
    }
    
    enum Eye {
        case Left
        case Right
    }
    
    func pathForCircleCenteredAtPoint(midPoint: CGPoint, withRadius radius: CGFloat) -> UIBezierPath {
        
        let path = UIBezierPath(
            arcCenter: midPoint,
            radius: radius,
            startAngle: 0.0,
            endAngle: 2*CGFloat(M_PI),
            clockwise: false
        )
        path.lineWidth = 5.0
        return path
        
    }
    
    private func getEyeCenter(eye: Eye) -> CGPoint {
        let eyeOffset = skullRadius / Ratios.SkullRatiosToEyeOffset
        var eyeCenter = skullCenter
        eyeCenter.y -= eyeOffset
        switch eye {
        case .Left: eyeCenter.x -= eyeOffset
        case .Right: eyeCenter.x += eyeOffset
        }
        return eyeCenter
    }
    
    private func pathForEye(eye: Eye) -> UIBezierPath{
        let eyeRadius = skullRadius / Ratios.SkullRatiosToEyeRadius
        let eyeCenter = getEyeCenter(eye: eye)
        return pathForCircleCenteredAtPoint(midPoint: eyeCenter, withRadius: eyeRadius)
    }
    
    private func pathForMouth() -> UIBezierPath {
        let mouthWidth = skullRadius / Ratios.SkullRatiosToMouthWidth
        let mouthHeight = skullRadius / Ratios.SkullRatiosToMouthHeight
        let mouthOffset = skullRadius / Ratios.SkullRatiosToMouthOffset
        
        let mouthRect = CGRect(x: skullCenter.x - mouthWidth/2, y: skullCenter.y + mouthOffset, width: mouthWidth, height: mouthHeight)
        
        let smileOffset = CGFloat(max(-1,min(mouthCurvature,1))) * mouthRect.height
        let start = CGPoint(x: mouthRect.minX, y: mouthRect.minY)
        let end = CGPoint(x: mouthRect.maxX, y: mouthRect.minY)
        let cp1 = CGPoint(x: mouthRect.minX + mouthRect.width / 3, y: mouthRect.minY + smileOffset)
        let cp2 = CGPoint(x: mouthRect.maxX - mouthRect.width / 3, y: mouthRect.minY + smileOffset)
        
        let path = UIBezierPath()
        path.move(to: start)
        path.addCurve(to: end, controlPoint1: cp1, controlPoint2: cp2)
        path.lineWidth = 5.0
        return path
        
    }
    
    override func draw(_ rect: CGRect) {
        
        UIColor.blue.set()
        pathForCircleCenteredAtPoint(midPoint: skullCenter, withRadius: skullRadius).stroke()
        pathForEye(eye: .Left).stroke()
        pathForEye(eye: .Right).stroke()
        pathForMouth().stroke()
    }
    

}
