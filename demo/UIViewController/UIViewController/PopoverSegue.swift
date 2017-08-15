

import UIKit

class PopoverSegue: UIStoryboardSegue {

    override func perform() {
        let dest = self.destination
        if let pop = dest.popoverPresentationController {
            delay(0.1) {
                pop.passthroughViews = nil
            }
        }
        super.perform()
    }
}
