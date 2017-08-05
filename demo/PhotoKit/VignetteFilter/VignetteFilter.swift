import UIKit


// NB this bug is fixed in iOS 9

// work around odd behavior (bug?) where CIColor(color:UIColor.whiteColor()) gives transparent, not white
public extension CIColor {
    convenience init(uicolor:UIColor) {
        var red : CGFloat = 0, green : CGFloat = 0, blue : CGFloat = 0, alpha : CGFloat = 0
        uicolor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        self.init(red: red, green: green, blue: blue, alpha:alpha)
    }
}

open class VignetteFilter : CIFilter {
    open var inputImage : CIImage?
    open var inputPercentage : NSNumber? = 1.0
    open override var outputImage : CIImage? {
        return self.makeOutputImage()
    }
    
    
    func makeOutputImage () -> CIImage? {
        guard let inputImage = self.inputImage else {return nil}
        guard let inputPercentage = self.inputPercentage else {return nil}
        
        let extent = inputImage.extent
        
        let grad = CIFilter(name: "CIRadialGradient")!
        let center = CIVector(x: extent.width/2.0, y: extent.height/2.0)
        
        let smallerDimension = min(extent.width, extent.height)
        let largerDimension = max(extent.width, extent.height)
        
        grad.setValue(center, forKey:"inputCenter")
        grad.setValue(smallerDimension/2.0 * CGFloat(inputPercentage), forKey:"inputRadius0")
        grad.setValue(largerDimension/2.0, forKey:"inputRadius1")
        grad.setValue(CIColor(color: UIColor.white), forKey:"inputColor0")
        grad.setValue(CIColor(color: UIColor.clear), forKey:"inputColor1")
        let gradimage = grad.outputImage
        
        let blend = CIFilter(name: "CIBlendWithAlphaMask")!
        blend.setValue(self.inputImage, forKey: "inputImage")
        let background = CIImage(color: CIColor(uicolor: UIColor.white))
        let background2 = background.cropping(to: extent)
        blend.setValue(background2, forKey:"inputBackgroundImage")
        blend.setValue(gradimage, forKey: "inputMaskImage")
        
        return blend.outputImage
    }
}
