//
//  ParallaxScrollView.swift
//  Parallaxscrollview
//
//  Created by tanchao on 16/4/20.
//  Copyright © 2016年 谈超. All rights reserved.
//
import UIKit
class ParallaxHeader: UIView {

    var headerImage = UIImage()
    weak var headerTitleLabel: UILabel?

    ///  创建一个只有一张图片的headerView
    ///
    ///  - parameter image:     要展示的图片
    ///  - parameter forSize:   view大xiao
    ///  - parameter referView: 依赖view(headerView会依赖于这个view形变)
    class func creatParallaxScrollViewWithImage(image:UIImage,forSize:CGSize,referView:UITableView?) -> ParallaxHeader {
        let paraScrollView = ParallaxHeader(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: forSize))
        paraScrollView.dependTableView = referView
        paraScrollView.headerImage = image
        paraScrollView.initialSetupForDefaultHeader()
        return paraScrollView
    }

    ///  将一个view改造成ParallaxView
    ///
    ///  - parameter subView:   view
    ///  - parameter referView: 依赖view(headerView会依赖于这个view形变)
    class func creatParallaxScrollViewWithSubView(subView:UIView,referView:UITableView) -> ParallaxHeader {
        let paraScrollView = ParallaxHeader(frame: CGRect(origin:  CGPoint(x: 0, y: 0), size: subView.bounds.size))
        paraScrollView.dependTableView = referView
        paraScrollView.initialSetupForCustomSubView(subV: subView)
        return paraScrollView
    }

    ///  刷新
    func refreshBlurViewForNewImage() {
        var screenShot = screenShotOfView(view: self)
        screenShot = screenShot.applyBlurWithblurRadius(blurRadius: 5, tintColor: UIColor(white: 0.6, alpha: 0.2), saturationDeltaFactor: 1.0, maskImage: nil)!
        bluredImageView?.image = screenShot
    }

    internal override func awakeFromNib() {
        if (subView != nil) {
            initialSetupForCustomSubView(subV: subView!)
        }
        else {
            initialSetupForDefaultHeader()
        }
        refreshBlurViewForNewImage()
    }

    // MARK:- 私有函数
    ///  滑动时添加效果
    fileprivate func layoutHeaderViewForScrollViewOffset(offset: CGPoint) {
        var frametemp = imageScrollView!.frame
        if offset.y > 0 {
            frametemp.origin.y = max(offset.y * kParallaxDeltaFactor, 0)
            imageScrollView?.frame = frametemp
            bluredImageView?.alpha = 1 / bounds.size.height * offset.y * 2
            clipsToBounds = true
        }
        else{
            bluredImageView?.alpha = 0
            var delta : CGFloat = 0.0
            var rect = CGRect(origin:  CGPoint(x: 0, y: 0), size: bounds.size)
            delta = fabs(min(0.0, offset.y))
            rect.origin.y -= delta
            rect.size.height += delta
            imageScrollView?.frame = rect
            clipsToBounds = false
            headerTitleLabel?.alpha = 1 - (delta) * 1 / kMaxTitleAlphaOffset
        }
    }

    fileprivate func initialSetupForCustomSubView(subV:UIView) {
        let images =  UIScrollView(frame: bounds)
        imageScrollView = images
        subView = subV
        subView?.contentMode = .scaleAspectFill
        subV.autoresizingMask = [.flexibleLeftMargin,.flexibleRightMargin,.flexibleTopMargin,.flexibleBottomMargin,.flexibleHeight,.flexibleWidth]
        imageScrollView?.addSubview(subV)
        bluredImageView = UIImageView(frame: subV.frame)
        bluredImageView?.autoresizingMask = subV.autoresizingMask
        bluredImageView?.alpha = 0
        imageScrollView?.addSubview(bluredImageView!)
        addSubview(imageScrollView!)
        refreshBlurViewForNewImage()
    }

    private func initialSetupForDefaultHeader() {
        let imageS = UIScrollView(frame: bounds)
        imageScrollView = imageS
        let imageV = UIImageView(frame: imageS.bounds)
        imageView = imageV
        imageView?.contentMode = .scaleAspectFill
        imageView?.image = headerImage
        imageView?.autoresizingMask = [.flexibleLeftMargin,.flexibleRightMargin,.flexibleTopMargin,.flexibleBottomMargin,.flexibleHeight,.flexibleWidth]
        imageScrollView!.addSubview(imageView!)
        var labelRect = imageScrollView!.bounds
        labelRect.origin.x = kLabelPaddingDist
        labelRect.origin.y = kLabelPaddingDist
        labelRect.size.width = labelRect.size.width - 2 * kLabelPaddingDist
        labelRect.size.height = labelRect.size.height - 2 * kLabelPaddingDist
        let headerl = UILabel(frame: labelRect)
        headerTitleLabel = headerl
        headerTitleLabel!.textColor = UIColor.white
        headerTitleLabel!.font = UIFont(name: "AvenirNextCondensed-Regular", size: 23)
        headerTitleLabel!.autoresizingMask = [.flexibleLeftMargin,.flexibleRightMargin,.flexibleTopMargin,.flexibleBottomMargin,.flexibleHeight,.flexibleWidth]
        headerTitleLabel!.textAlignment = .center
        headerTitleLabel!.numberOfLines = 0
        headerTitleLabel!.lineBreakMode = .byWordWrapping
        imageScrollView!.addSubview(headerTitleLabel!)
        let bluredImageV = UIImageView(frame: imageView!.frame)
        bluredImageView = bluredImageV
        bluredImageView!.alpha = 0.0
        imageScrollView!.addSubview(bluredImageView!)
        addSubview(imageScrollView!)
        refreshBlurViewForNewImage()
    }

    private func screenShotOfView(view:UIView) ->UIImage{
        UIGraphicsBeginImageContextWithOptions(bounds.size, true, 0)
        drawHierarchy(in: bounds, afterScreenUpdates: false)
        let icon = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return icon!
    }

    ///  监听依赖View的滚动
    fileprivate func watchDependViewScrolled() {
        var myContext = 0
        dependTableView?.addObserver(self, forKeyPath: "contentOffset", options: [.new,.old], context: &myContext);
    }

    internal override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentOffset" {
            layoutHeaderViewForScrollViewOffset(offset: dependTableView!.contentOffset)
        }
    }

    private var dependTableView : UITableView?{
        didSet{
            watchDependViewScrolled()
        }
    }

    private weak var  imageScrollView: UIScrollView?
    private weak var imageView: UIImageView?
    private weak var subView: UIView?
    private var bluredImageView: UIImageView?

}

private let kLabelPaddingDist : CGFloat = 8.0
private let kParallaxDeltaFactor : CGFloat = 0.5
private let kMaxTitleAlphaOffset : CGFloat = 100

import Accelerate
private extension UIImage{
    func applySubtleEffect() -> UIImage? {
        return applyBlurWithblurRadius(blurRadius: 3, tintColor: UIColor(white: 1.0, alpha: 0.3), saturationDeltaFactor: 1.8, maskImage: nil)
    }
    func applyLightEffect() -> UIImage? {
        return applyBlurWithblurRadius(blurRadius: 30, tintColor: UIColor(white: 1.0, alpha: 0.3), saturationDeltaFactor: 1.8, maskImage: nil)
    }
    func applyExtraLightEffect() -> UIImage? {
        return applyBlurWithblurRadius(blurRadius: 20, tintColor: UIColor(white: 0.97, alpha: 0.82), saturationDeltaFactor: 1.8, maskImage: nil)
    }
    func applyDarkEffect() -> UIImage? {
        return applyBlurWithblurRadius(blurRadius: 20, tintColor: UIColor(white: 0.11, alpha: 0.73), saturationDeltaFactor: 1.8, maskImage: nil)
    }
    func applyTintEffectWithColor(tintColor:UIColor) -> UIImage? {
        let EffectColorAlpha : CGFloat = 0.6
        var effectColor = tintColor
        let componentCount = tintColor.cgColor.numberOfComponents
        if componentCount == 2 {
            var b : CGFloat = 0
            if tintColor.getWhite(&b, alpha: UnsafeMutablePointer<CGFloat>.allocate(capacity: 0)) {
                effectColor = UIColor(white: b, alpha: EffectColorAlpha)
            }
        }
        else{
            var r : CGFloat = 0
            var g : CGFloat = 0
            var b : CGFloat = 0
            if tintColor.getRed(&r, green: &g, blue: &b, alpha: UnsafeMutablePointer<CGFloat>.allocate(capacity: 0)) {
                effectColor = UIColor(red: r, green: g, blue: b, alpha: EffectColorAlpha)
            }
        }
        return applyBlurWithblurRadius(blurRadius: 10, tintColor: effectColor, saturationDeltaFactor: -1.0, maskImage: nil)
    }
    func applyBlurWithblurRadius(blurRadius:CGFloat,tintColor:UIColor?,saturationDeltaFactor:CGFloat,maskImage:UIImage?) -> UIImage? {
        if size.width<1 || size.height<1 {
            print("*** error: invalid size: (\(size.width) x \(size.height)). Both dimensions must be >= 1: \(self)")
            return nil
        }
        if (cgImage == nil) {
            print("*** error: image must be backed by a CGImage: \(self)")
            return nil
        }
        if(maskImage != nil) && (maskImage!.cgImage == nil) {
            print("*** error: maskImage must be backed by a CGImage: \(self)")
            return nil
        }
        let imageRect = CGRect(origin: CGPoint(x: 0, y: 0), size: size)
        var effectImage = self
        let hasBlur = blurRadius > 0
        let hasSaturationChange = fabs(saturationDeltaFactor-1) > 0
        if hasBlur || hasSaturationChange {
            UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
            let effectInContext = UIGraphicsGetCurrentContext()
            effectInContext!.scaleBy(x: 1, y: -1)
            effectInContext!.translateBy(x: 0, y: -size.height)
            effectInContext!.draw(cgImage!, in: imageRect)
            var effectInBuffer : vImage_Buffer = vImage_Buffer()
            effectInBuffer.data = effectInContext!.data
            effectInBuffer.width = UInt(effectInContext!.width)
            effectInBuffer.height = UInt(effectInContext!.height)
            effectInBuffer.rowBytes = effectInContext!.bytesPerRow
            UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
            let effectOutContext = UIGraphicsGetCurrentContext()
            var effectOutBuffer = vImage_Buffer()
            effectOutBuffer.data = effectOutContext!.data
            effectOutBuffer.width = UInt(effectOutContext!.width)
            effectOutBuffer.height = UInt(effectOutContext!.height)
            effectOutBuffer.rowBytes = effectOutContext!.bytesPerRow
            if hasBlur {
                let inputRadius = blurRadius * UIScreen.main.scale
                //                var radius = UInt32(floor(Double(inputRadius) * 3 * sqrt(2 * M_PI)/4 +0.5))
                var radiusd = Double(inputRadius) * 3;
                radiusd = radiusd * 3 * sqrt(2 * Double.pi) / 4
                radiusd = radiusd + 0.5
                var radius = UInt32(floor(radiusd))
                if radius % 2 != 1 {
                    radius += 1
                }
                vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, nil, 0, 0, radius, radius, UnsafePointer<UInt8>(bitPattern: 0), UInt32(kvImageEdgeExtend))
                vImageBoxConvolve_ARGB8888(&effectOutBuffer, &effectInBuffer, nil, 0, 0, radius, radius, UnsafePointer<UInt8>(bitPattern: 0), UInt32(kvImageEdgeExtend))
                vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, nil, 0, 0, radius, radius, UnsafePointer<UInt8>(bitPattern: 0), UInt32(kvImageEdgeExtend))
            }
            var effectImageBuffersAreSwapped = false
            if hasSaturationChange {
                let s = saturationDeltaFactor
                let floatingPointSaturationMatrix = [
                    0.0722 + 0.9278 * s,  0.0722 - 0.0722 * s,  0.0722 - 0.0722 * s,  0,
                    0.7152 - 0.7152 * s,  0.7152 + 0.2848 * s,  0.7152 - 0.7152 * s,  0,
                    0.2126 - 0.2126 * s,  0.2126 - 0.2126 * s,  0.2126 + 0.7873 * s,  0,
                    0,                    0,                    0,  1,
                    ]
                let divisor : Int32 = 256
                _ = MemoryLayout.size(ofValue: floatingPointSaturationMatrix) / MemoryLayout.size(ofValue: floatingPointSaturationMatrix.first)
                let matrixSize = MemoryLayout.size(ofValue: floatingPointSaturationMatrix)/MemoryLayout.size(ofValue: floatingPointSaturationMatrix.first)
                var saturationMatrix : [__int16_t] = Array(repeating: 0, count: matrixSize)
                for i in 0 ... matrixSize {
                    saturationMatrix[i] = __int16_t(Int32(roundf(Float(floatingPointSaturationMatrix[i]))) * divisor)
                }
                if hasBlur {
                    vImageMatrixMultiply_ARGB8888(&effectOutBuffer, &effectInBuffer, saturationMatrix, divisor, nil, nil, UInt32(kvImageNoFlags))
                    effectImageBuffersAreSwapped = true
                }
                else{
                    vImageMatrixMultiply_ARGB8888(&effectInBuffer, &effectOutBuffer, saturationMatrix, divisor, nil, nil, UInt32(kvImageNoFlags))
                }
            }
            if !effectImageBuffersAreSwapped {
                effectImage = UIGraphicsGetImageFromCurrentImageContext()!
                UIGraphicsEndImageContext()
            }
            if effectImageBuffersAreSwapped {
                effectImage = UIGraphicsGetImageFromCurrentImageContext()!
                UIGraphicsEndImageContext()
            }
        }
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        let outputContext = UIGraphicsGetCurrentContext()
        outputContext!.scaleBy(x: 1.0, y: -1.0)
        outputContext!.translateBy(x: 0, y: -size.height)
        // Draw base image.
        outputContext!.draw(cgImage!, in: imageRect)
        //        CGContextDrawImage(outputContext, imageRect, cgImage)
        // Draw effect image.
        if (hasBlur) {
            outputContext!.saveGState()
            if ((maskImage) != nil) {
                outputContext!.clip(to: imageRect, mask: maskImage!.cgImage!)
            }
            outputContext!.draw(effectImage.cgImage!, in: imageRect)


            outputContext!.restoreGState()
        }
        // Add in color tint.
        if ((tintColor) != nil) {
            outputContext!.saveGState()
            outputContext!.setFillColor(tintColor!.cgColor)
            outputContext!.fill(imageRect)
            outputContext!.restoreGState()
        }
        // Output image is ready.
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return outputImage
    }
    
}
