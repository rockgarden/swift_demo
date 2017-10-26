//
//  HomeKitTool.swift
//

import HomeKit

/// 家庭组成的创建
class HomeKitTool: NSObject {

    var homeManager : HMHomeManager!
    
    func initHomeManager() {
        self.homeManager = HMHomeManager.init()
        self.homeManager.delegate = self
    }

    /// 添加家庭
    ///
    /// - Parameter homeName: home name
    func addHome(homeName: String) {
        self.homeManager.addHome(withName: homeName) { (home, error) in
            
        }
    }

    func removeHome(homeName: HMHome)  {
        self.homeManager.removeHome(homeName) { (error) in
            
        }
    }
    
}


// MARK: - HMHomeManagerDelegate, HMHomeDelegate
extension HomeKitTool: HMHomeManagerDelegate, HMHomeDelegate {

    func homeManagerDidUpdateHomes(_ manager: HMHomeManager) {
        print("已经获取了homes数据\(homeManager.homes)")
        if homeManager.homes.count != 0 {
             NotificationCenter.default.post(name: NSNotification.Name(rawValue: "getName"), object: nil, userInfo: nil)
        }
    }

    func homeManagerDidUpdatePrimaryHome(_ manager: HMHomeManager) {
        print("已经更新了PrimaryHOME\(String(describing: homeManager.primaryHome))")
    }

    func homeManager(_ manager: HMHomeManager, didAdd home: HMHome) {
        print("已经添加了home\(home)")
    }

    func homeManager(_ manager: HMHomeManager, didRemove home: HMHome) {
        print("已经移除了Home\(home)")
    }
    
}
