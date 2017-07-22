//
//  OperationDemo.swift
//  GCDConcurrencyThreadDemo
//
//  Created by wangkan on 2017/7/22.
//  Copyright © 2017年 rockgarden. All rights reserved.
//

import Foundation

/// 异步回调
class Tester : NSObject {

    let mDQ: DispatchQueue? = nil

    let dQ: DispatchQueue = {
        let q = DispatchQueue(label: "com.rockgarden.tester")
        q.suspend()
        return q
    }()

    /// 1 定义一个队列
    let queue : OperationQueue = {
        let q = OperationQueue()
        /// 2 队列暂停住默认挂起
        q.isSuspended = true
        q.maxConcurrentOperationCount = 1
        return q
    }()

    //用于保持结果的变量
    var result:String?

    /// 外部调用的方法 获取 block 中的 result
    func getResult(block: @escaping (String)->Void, mainBlock: @escaping () -> Void) {

        /// 3 将回调处理加入队列
        queue.addOperation {
            block(self.result!)
        }

        dQ.async {
            block(self.result!)
        }

        /// main 不能 suspend()
        (mDQ ?? DispatchQueue.main).async {
            mainBlock
        }
    }

    /// 4 异步方法 通过对象保持住返回的数据，取消队列暂停
    func requestResult() {
        guard result != nil else {
            result = "ok"
            dQ.resume()
            return
        }
        queue.isSuspended = false
    }

}
