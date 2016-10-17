//
//  GCD_Func.swift
//  NSURLSession_NSOperationQueue_GDC
//
//  Created by wangkan on 16/8/21.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import Foundation

/// 并发队列
private let queue = DispatchQueue(label: "test", attributes: DispatchQueue.Attributes.concurrent)
/**
 coordinate
 - parameter barrier: 是否创建同步点
 - parameter block:   <#block description#>
 */
private func coordinate(barrier: Bool = false, block: @escaping () -> Void) {
    if barrier {
        /**
         *  一个dispatch barrier 允许在一个并发队列中创建一个同步点。当在并发队列中遇到一个barrier, 他会延迟执行barrier的block,等待所有在barrier之前提交的blocks执行结束。 这时，barrier block自己开始执行。 之后， 队列继续正常的执行操作。
         *  调用这个函数总是在barrier block被提交之后立即返回，不会等到block被执行。当barrier block到并发队列的最前端，他不会立即执行。相反，队列会等到所有当前正在执行的blocks结束执行。到这时，barrier才开始自己执行。所有在barrier block之后提交的blocks会等到barrier block结束之后才执行。
         *  这里指定的并发队列是自己通过dispatch_queue_create函数创建的。如果你传的是一个串行队列或者全局并发队列，这个函数等同于dispatch_async函数。
         *
         *  @param queue 将barrier添加到那个队列
         *  @param block barrier block 代码块
         *
         *  @return <#return value description#>
         */
        queue.async(flags: .barrier, execute: block)
        return
    }
    queue.async(execute: block)
}
