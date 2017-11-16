/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Main view controller for the AR experience.
*/

import ARKit
import SceneKit
import UIKit

class ViewController: UIViewController {
    
    // MARK: - ARKit Config Properties
    
    var screenCenter: CGPoint?

    let session = ARSession()
    lazy var standardConfiguration: ARWorldTrackingConfiguration = {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        return configuration
    }()
    
    // MARK: - Virtual Object Manipulation Properties
    
    var dragOnInfinitePlanesEnabled = false
    var virtualObjectManager: VirtualObjectManager!
    
    var isLoadingObject: Bool = false {
        didSet {
            DispatchQueue.main.async {
                self.settingsButton.isEnabled = !self.isLoadingObject
                self.addObjectButton.isEnabled = !self.isLoadingObject
                self.restartExperienceButton.isEnabled = !self.isLoadingObject
            }
        }
    }
    
    // MARK: - Other Properties
    
    var textManager: TextManager!
    var restartExperienceButtonIsEnabled = true
    
    // MARK: - UI Elements
    
    var spinner: UIActivityIndicatorView?
    
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var messagePanel: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var addObjectButton: UIButton!
    @IBOutlet weak var restartExperienceButton: UIButton!
    
    @IBOutlet weak var touchSwitch: UISwitch!
    
    private var isSupportTouches:Bool = true
    // MARK: - Queues
    
	let serialQueue = DispatchQueue(label: "com.apple.arkitexample.serialSceneKitQueue")
	
    // MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Setting.registerDefaults()
		setupUIControls()
        setupScene()
    }

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		// Prevent the screen from being dimmed after a while.
		UIApplication.shared.isIdleTimerDisabled = true
		
        if ARWorldTrackingConfiguration.isSupported {
			// Start the ARSession.
            resetTracking()
		} else {
			displayErrorMessage(title: "该设备不支持", message: "", allowRestart: false)
		}
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		session.pause()
	}
	
    // MARK: - Setup
    
	func setupScene() {
        // Synchronize updates via the `serialQueue`.
        virtualObjectManager = VirtualObjectManager(updateQueue: serialQueue)
        virtualObjectManager.delegate = self
		
		// set up scene view
		sceneView.setup()
		sceneView.delegate = self
		sceneView.session = session
//        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]

//         sceneView.showsStatistics = true
		
		sceneView.scene.enableEnvironmentMapWithIntensity(25, queue: serialQueue)
		
		setupFocusSquare()
		
		DispatchQueue.main.async {
			self.screenCenter = self.sceneView.bounds.mid
		}
	}
    
    func setupUIControls() {
        textManager = TextManager(viewController: self)
        
        // Set appearance of message output panel
        messagePanel.layer.cornerRadius = 3.0
        messagePanel.clipsToBounds = true
        messagePanel.isHidden = true
        messageLabel.text = ""
    }
	
    @IBAction func touchSwitchChange(_ sender: Any) {
        if let switcher = sender as? UISwitch{
            isSupportTouches = switcher.isOn
        }
    }
    // MARK: - Gesture Recognizers
	
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isSupportTouches{
            return;
        }
        virtualObjectManager.reactToTouchesBegan(touches, with: event, in: self.sceneView)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isSupportTouches{
            return;
        }
        virtualObjectManager.reactToTouchesMoved(touches, with: event)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isSupportTouches{
            return;
        }
        if virtualObjectManager.virtualObjects.isEmpty {
            chooseObject(addObjectButton)
            return
        }
        virtualObjectManager.reactToTouchesEnded(touches, with: event)
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isSupportTouches{
            return;
        }
        virtualObjectManager.reactToTouchesCancelled(touches, with: event)
    }
	
    // MARK: - Planes
	
	var planes = [ARPlaneAnchor: Plane]()
	
    //检测到平面，并添加到rootNode上
    func addPlane(node: SCNNode, anchor: ARPlaneAnchor) {
        let plane = Plane(anchor)
        planes[anchor] = plane
        node.addChildNode(plane)
//
//        textManager.cancelScheduledMessage(forType: .planeEstimation)
//        textManager.showMessage("检测到平面")
//        if virtualObjectManager.virtualObjects.isEmpty {
//            textManager.scheduleMessage("点击+放置物体", inSeconds: 7.5, messageType: .contentPlacement)
//        }
	}
		
    func updatePlane(anchor: ARPlaneAnchor) {
        
        if self.virtualObjectManager.virtualObjects.count > 0{
            return
        }
        
        if let plane = planes[anchor] {
			plane.update(anchor)
		}
	}
			
    func removePlane(anchor: ARPlaneAnchor) {
		if let plane = planes.removeValue(forKey: anchor) {
			plane.removeFromParentNode()
        }
    }
	
	func resetTracking() {
		session.run(standardConfiguration, options: [.resetTracking, .removeExistingAnchors])
		
//        textManager.scheduleMessage("寻找一个平面位置用来放置物体",
//                                    inSeconds: 7.5,
//                                    messageType: .planeEstimation)
	}

    // MARK: - Focus Square
    
    var focusSquare: FocusSquare?
//    var gridSquare: GridPlane?
	
    func setupFocusSquare() {
		serialQueue.async {
			self.focusSquare?.isHidden = true
			self.focusSquare?.removeFromParentNode()
			self.focusSquare = FocusSquare()
			self.sceneView.scene.rootNode.addChildNode(self.focusSquare!)
		}
		
//        textManager.scheduleMessage("TRY MOVING LEFT OR RIGHT", inSeconds: 5.0, messageType: .focusSquare)
    }
	
	func updateFocusSquare() {
        
        if self.virtualObjectManager.virtualObjects.count > 0{
            return
        }
        
		guard let screenCenter = screenCenter else { return }
		
		DispatchQueue.main.async {
			var objectVisible = false
			for object in self.virtualObjectManager.virtualObjects {
				if self.sceneView.isNode(object, insideFrustumOf: self.sceneView.pointOfView!) {
					objectVisible = true
					break
				}
			}
			
			if objectVisible {
				self.focusSquare?.hide()
			} else {
				self.focusSquare?.unhide()
			}
			
            let (worldPos, planeAnchor, _) = self.virtualObjectManager.worldPositionFromScreenPosition(screenCenter,
                                                                                                       in: self.sceneView,
                                                                                                       objectPos: self.focusSquare?.simdPosition)
			if let worldPos = worldPos {
				self.serialQueue.async {
					self.focusSquare?.update(for: worldPos, planeAnchor: planeAnchor, camera: self.session.currentFrame?.camera)
				}
				self.textManager.cancelScheduledMessage(forType: .focusSquare)
			}
		}
	}
    
	// MARK: - Error handling
	
	func displayErrorMessage(title: String, message: String, allowRestart: Bool = false) {
		// Blur the background.
		textManager.blurBackground()
		
		if allowRestart {
			// Present an alert informing about the error that has occurred.
			let restartAction = UIAlertAction(title: "Reset", style: .default) { _ in
				self.textManager.unblurBackground()
				self.restartExperience(self)
			}
			textManager.showAlert(title: title, message: message, actions: [restartAction])
		} else {
			textManager.showAlert(title: title, message: message, actions: [])
		}
	}
    
}
