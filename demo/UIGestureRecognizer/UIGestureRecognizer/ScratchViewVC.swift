
//
//  Created by JoeJoe on 2016/12/13.
//  Copyright © 2016年 Joe. All rights reserved.
//

import UIKit

class ScratchViewVC: UIViewController, ScratchUIViewDelegate {
    
    var scratchCard: ScratchUIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scratchCard = ScratchUIView(frame: view.frame, Coupon: "image2", MaskImage: "image1", ScratchWidth: CGFloat(40))
        scratchCard.delegate = self
        
        self.view.addSubview(scratchCard)
    }

    @IBAction func getScratchPercent(_ sender: Any) {
        let scratchPercent: Double = scratchCard.getScratchPercent()
        _ = String(format: "%.2f", scratchPercent * 100) + "%"
    }
    
    //Scratch Began Event(optional)
    func scratchBegan(_ view: ScratchUIView) {
        print("scratchBegan")
        
        ////Get the Scratch Position in ScratchCard(coordinate origin is at the lower left corner)
        let position = Int(view.scratchPosition.x).description + "," + Int(view.scratchPosition.y).description
        print(position)

    }
    
    //Scratch Moved Event(optional)
    func scratchMoved(_ view: ScratchUIView) {
        let scratchPercent: Double = scratchCard.getScratchPercent()
        _ = String(format: "%.2f", scratchPercent * 100) + "%"
        print("scratchMoved")
        
        ////Get the Scratch Position in ScratchCard(coordinate origin is at the lower left corner)
        let position = Int(view.scratchPosition.x).description + "," + Int(view.scratchPosition.y).description
        print(position)
    }
    
    //Scratch Ended Event(optional)
    func scratchEnded(_ view: ScratchUIView) {
        print("scratchEnded")
        
        ////Get the Scratch Position in ScratchCard(coordinate origin is at the lower left corner)
        let position = Int(view.scratchPosition.x).description + "," + Int(view.scratchPosition.y).description
        print(position)

    }
}
