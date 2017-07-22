//
//  Created by apple on 2016/10/27.
//  Copyright © 2016年 vidream. All rights reserved.
//

import UIKit

class CAEmitterLayerVC: UIViewController {

    var b1: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        title = "CAEmitter"

        b1 = UIBarButtonItem(title: "next", style: .plain, target: self, action: #selector(nextVC))
        navigationItem.rightBarButtonItems = [b1]

        setUp()
        createYanhua()
    }
    
    /// 烟火发射
    fileprivate func createYanhua() {
        //创建发射器
        let emitter = CAEmitterLayer()
        
        //发射器中心点
        emitter.emitterPosition = CGPoint(x: self.view.bounds.size.width / 2.0, y: self.view.bounds.size.height)
        
        //发射器尺寸
        emitter.emitterSize = CGSize(width: 50, height: 0.0)
        
        //发射器发射模式
        //        NSString * const kCAEmitterLayerPoints;//从发射器中发出
        //        NSString * const kCAEmitterLayerOutline;//从发射器边缘发出
        //        NSString * const kCAEmitterLayerSurface;//从发射器表面发出
        //        NSString * const kCAEmitterLayerVolume;//从发射器中点发出
        emitter.emitterMode = kCAEmitterLayerOutline
        
        //发射器形状
        //        NSString * const kCAEmitterLayerPoint;//点的形状，粒子从一个点发出
        //        NSString * const kCAEmitterLayerLine;//线的形状，粒子从一条线发出
        //        NSString * const kCAEmitterLayerRectangle;//矩形形状，粒子从一个矩形中发出
        //        NSString * const kCAEmitterLayerCuboid;//立方体形状，会影响Z平面的效果
        //        NSString * const kCAEmitterLayerCircle;//圆形，粒子会在圆形范围发射
        //        NSString * const kCAEmitterLayerSphere;//球型
        emitter.emitterShape = kCAEmitterLayerLine
        
        //发射器粒子渲染效果
        //        NSString * const kCAEmitterLayerUnordered;//粒子无序出现
        //        NSString * const kCAEmitterLayerOldestFirst;//声明久的粒子会被渲染在最上层
        //        NSString * const kCAEmitterLayerOldestLast;//年轻的粒子会被渲染在最上层
        //        NSString * const kCAEmitterLayerBackToFront;//粒子的渲染按照Z轴的前后顺序进行
        //        NSString * const kCAEmitterLayerAdditive;//粒子混合
        emitter.renderMode = kCAEmitterLayerAdditive
        
        //创建烟花子弹
        let bullet = CAEmitterCell()
        
        //子弹诞生速度,每秒诞生个数
        bullet.birthRate = 2.0
        
        //子弹的停留时间,即多少秒后消失
        bullet.lifetime = 1.3
        
        //子弹的样式,可以给图片
        bullet.contents = self.imageWithColor(UIColor.white).cgImage
        
        //子弹的发射弧度
        bullet.emissionRange = 0.15 * CGFloat(Double.pi)
        
        //子弹的速度
        bullet.velocity = self.view.bounds.size.height - 100
        //随机速度范围
        bullet.velocityRange = 10
        //y轴加速度
        bullet.yAcceleration = 0
        //自转角速度
        bullet.spin = CGFloat(Double.pi/2)
        
        //三种随机色
        bullet.redRange = 1.0
        bullet.greenRange = 1.0
        bullet.blueRange = 1.0
        
        //开始爆炸
        let burst = CAEmitterCell()
        //属性同上
        burst.birthRate = 1.0
        burst.velocity = 0;
        burst.scale 	= 2.5;
        burst.redSpeed = -1.5;		// shifting
        burst.blueSpeed = 1.5;		// shifting
        burst.greenSpeed = 1.0;		// shifting
        burst.lifetime = 0.35;
        
        //爆炸后的烟花
        let spark = CAEmitterCell()
        //属性设置同上
        spark.birthRate = 666
        spark.lifetime = 3
        spark.velocity = 125
        spark.velocityRange = 100
        spark.emissionRange = 2 * CGFloat(Double.pi)
        
        spark.contents = UIImage(named: "fire")?.cgImage
        spark.scale = 0.1
        spark.scaleRange = 0.05
        
        spark.greenSpeed		= -0.1;
        spark.redSpeed			= 0.4;
        spark.blueSpeed			= -0.1;
        spark.alphaSpeed		= -0.5;
        spark.spin				= 2 * CGFloat(Double.pi)
        spark.spinRange			= 2 * CGFloat(Double.pi)
        
        //这里是重点,先将子弹添加给发射器
        emitter.emitterCells = [bullet]
        
        //子弹发射后,将爆炸cell添加给子弹cell
        bullet.emitterCells = [burst]
        
        //将烟花cell添加给爆炸效果cell
        burst.emitterCells = [spark]
        
        //最后将发射器附加到主视图的layer上
        view.layer.addSublayer(emitter)
    }
    
    /// 粒子发射
    fileprivate func setUp() {
        let viewBounds = view.layer.bounds
        
        let snowEmitter = CAEmitterLayer()
        snowEmitter.emitterPosition = CGPoint(x: viewBounds.size.width / 2.0 , y: 200)
        snowEmitter.emitterSize = CGSize(width: 1, height: 0)
        snowEmitter.emitterMode = kCAEmitterLayerOutline
        snowEmitter.emitterShape = kCAEmitterLayerLine;
        snowEmitter.backgroundColor = UIColor.orange.cgColor
        
        view.layer.addSublayer(snowEmitter)
        
        // Configure the snowflake emitter cell
        let snowflake = CAEmitterCell()
        
        // 随机颗粒的大小
        snowflake.scale = 0.5;
        snowflake.scaleRange = 0.1;
        
        // 缩放比列速度
        //    snowflake.scaleSpeed = 0.1;
        
        // 粒子参数的速度乘数因子；
        snowflake.birthRate		= 10.0;
        
        // 生命周期
        snowflake.lifetime		= 60.0;
        
        // 粒子速度
        snowflake.velocity		= 30 //falling down slowly
        snowflake.velocityRange = 10;
        // 粒子y方向的加速度分量
        snowflake.yAcceleration = -20;
        
        // 周围发射角度
        snowflake.emissionRange = CGFloat(Double.pi) //some variation in angle
        snowflake.emissionLongitude = CGFloat(Double.pi)
        //        snowflake.emissionLatitude = CGFloat(M_PI)
        // 自动旋转
        snowflake.spinRange		= CGFloat(Float.pi) //slow spin
        
        snowflake.contents		=  UIImage(named: "fire")?.cgImage
        snowflake.color = UIColor(colorLiteralRed: 0.6, green: 0.658, blue: 0.743, alpha: 1.000).cgColor
        
        // Make the flakes seem inset in the background
        //        snowEmitter.shadowOpacity = 1.0;
        //        snowEmitter.shadowRadius  = 0.0;
        //        snowEmitter.shadowOffset  = CGSize(width: 0, height: 1)
        //        snowEmitter.shadowColor   = UIColor.white.cgColor
        
        // Add everything to our backing layer below the UIContol defined in the storyboard
        snowEmitter.emitterCells = [snowflake]
    }
    
    /// 将颜色转为图片
    fileprivate func imageWithColor(_ color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: 5.0, height: 5.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }

    func nextVC(_ sender: Any) {
        (sender as? UIBarButtonItem)?.isEnabled = false
        let vc = CAEmitterLayerVC1()
        self.show(vc, sender: nil)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        b1.isEnabled = true
    }

}

