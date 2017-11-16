//
//  GridPlane.swift
//  ARKitExample
//
//  Created by Raw on 21/8/17.
//  Copyright © 2017年 Apple. All rights reserved.
//

import ARKit

class GridPlane: SCNNode {
//    var anchor: ARPlaneAnchor!
    var planeGeometry: SCNPlane!
    
    var lastPositionOnPlane: float3?
    var lastPosition: float3?
    
    // use average of recent positions to avoid jitter
    private var recentGridPositions: [float3] = []
    private var anchorsOfVisitedPlanes: Set<ARAnchor> = []
    
    private var isOpen = false
    
    private lazy var focusSquareNode: SCNNode = {
        planeGeometry = SCNPlane.init(width: 0, height: 0)
        
        //贴图
        let material = SCNMaterial()
        let img = UIImage.init(named: "grid")
        material.diffuse.contents = img
        material.lightingModel = .physicallyBased
        planeGeometry.materials = [material]
        
        let planeNode = SCNNode.init(geometry: planeGeometry)
        planeNode.position = SCNVector3Make(0, 0, 0)
        
        //SceneKit 里的Plane默认为垂直，所以需要翻转90度
        planeNode.transform = SCNMatrix4MakeRotation(Float(-.pi / 2.0), 1.0, 0.0, 0.0)
        
        setTextureScale()
        return planeNode
    }()
    
    override init() {
        super.init()
        self.opacity = 0.0
        self.addChildNode(focusSquareNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func hide() {
        if self.opacity == 1.0 {
            self.renderOnTop(false)
            self.runAction(.fadeOut(duration: 0.5))
        }
    }
    
    func unhide() {
        if self.opacity == 0.0 {
            self.renderOnTop(true)
            self.runAction(.fadeIn(duration: 0.5))
        }
    }
    
    func update(for position: float3, planeAnchor: ARPlaneAnchor?, camera: ARCamera?) {
        lastPosition = position

        if let anchor = planeAnchor {
            lastPositionOnPlane = position
            anchorsOfVisitedPlanes.insert(anchor)
            
            close(flash: !anchorsOfVisitedPlanes.contains(anchor))

            planeGeometry.width = CGFloat(anchor.extent.x)
            planeGeometry.height = CGFloat(anchor.extent.z)
            self.position = SCNVector3Make(anchor.center.x, 0, anchor.center.z)
            setTextureScale()
        } else {
            open()
        }
//        updateTransform(for: position, camera: camera)
    }
    
    private func updateTransform(for position: float3, camera: ARCamera?) {
        // add to list of recent positions
        recentGridPositions.append(position)
        
        // remove anything older than the last 8
        recentGridPositions.keepLast(8)
        
        // move to average of recent positions to avoid jitter
        if let average = recentGridPositions.average {
            self.simdPosition = average
            self.setUniformScale(scaleBasedOnDistance(camera: camera))
        }
        
        // Correct y rotation of camera square
        if let camera = camera {
            let tilt = abs(camera.eulerAngles.x)
            let threshold1: Float = .pi / 2 * 0.65
            let threshold2: Float = .pi / 2 * 0.75
            let yaw = atan2f(camera.transform.columns.0.x, camera.transform.columns.1.x)
            var angle: Float = 0
            
            switch tilt {
            case 0..<threshold1:
                angle = camera.eulerAngles.y
            case threshold1..<threshold2:
                let relativeInRange = abs((tilt - threshold1) / (threshold2 - threshold1))
                let normalizedY = normalize(camera.eulerAngles.y, forMinimalRotationTo: yaw)
                angle = normalizedY * (1 - relativeInRange) + yaw * relativeInRange
            default:
                angle = yaw
            }
            self.rotation = SCNVector4(0, 1, 0, angle)
        }
    }
    
    private func scaleBasedOnDistance(camera: ARCamera?) -> Float {
        guard let camera = camera else { return 1.0 }
        
        let distanceFromCamera = simd_length(self.simdWorldPosition - camera.transform.translation)
        if distanceFromCamera < 0.7 {
            return distanceFromCamera / 0.7
        } else {
            return 0.25 * distanceFromCamera + 0.825
        }
    }
    
    private func normalize(_ angle: Float, forMinimalRotationTo ref: Float) -> Float {
        // Normalize angle in steps of 90 degrees such that the rotation to the other angle is minimal
        var normalized = angle
        while abs(normalized - ref) > .pi / 4 {
            if angle > ref {
                normalized -= .pi / 2
            } else {
                normalized += .pi / 2
            }
        }
        return normalized
    }
    
    private func stopPulsing(for node: SCNNode?) {
        node?.removeAction(forKey: "pulse")
        node?.opacity = 1.0
    }
    
    private func close(flash: Bool = false) {
        if !isOpen {
            return
        }

        stopPulsing(for: focusSquareNode)
        focusSquareNode.opacity = 0.99

        isOpen = false
    }
    
    private func open() {
        if isOpen {
            return
        }
        focusSquareNode.opacity = 1.0
        isOpen = true
    }
    
    func setTextureScale() {
        let width = planeGeometry.width
        let height = planeGeometry.height
        
        let material = planeGeometry.materials.first
        material?.diffuse.contentsTransform = SCNMatrix4MakeScale(Float(width), Float(height), 1)
        material?.diffuse.wrapS = .repeat
        material?.diffuse.wrapT = .repeat
    }
}
