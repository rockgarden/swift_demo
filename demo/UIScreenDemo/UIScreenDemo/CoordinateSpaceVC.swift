
import UIKit


// MARK: - 屏幕的当前坐标空间, 屏幕当前的坐标空间总是反映应用于设备的任何接口方向。 因此，该坐标空间的边界与屏幕本身的边界属性相匹配。
extension UICoordinateSpace {
    static func convertRect(_ r:CGRect,
                            fromCoordinateSpace s1:UICoordinateSpace,
                            toCoordinateSpace s2:UICoordinateSpace) -> CGRect {
        return s1.convert(r, to:s2)
    }
}


/// 坐标空间测试
class CoordinateSpaceVC: UIViewController {

    @IBAction func doButton1(_ sender: UIButton) {
        let v = sender
        let r = v.superview!.convert(
            v.frame, to: UIScreen.main.fixedCoordinateSpace)
        /// fixedCoordinateSpace 屏幕的固定坐标空间
        /// 此坐标空间的范围始终以纵向向上反映设备的屏幕尺寸。 您可以在需要固定参考框架的地方使用此坐标空间。 例如，如果您的应用程序将屏幕坐标值保存到磁盘，则在执行此操作之前将这些值转换为固定坐标空间。 将它们保存在固定坐标空间中可确保当您的应用程序稍后读取值时，可以将它们正确地转换为当前的坐标空间。
        print(r)
        print(v.frame)
        do {
            let r = v.superview!.convert(
                v.frame, to: UIScreen.main.coordinateSpace)
            print(r)
            print(v.frame)
        }
    }

    @IBAction func doButton2(_ sender: UIButton) {
        let v = sender
        let r = v.superview!.convert(
            v.frame, to: UIScreen.main.fixedCoordinateSpace)
        print(r)
        print(v.frame)
        do {
            let r = v.superview!.convert(
                v.frame, to: UIScreen.main.coordinateSpace)
            print(r)
            print(v.frame)
        }
    }

}

