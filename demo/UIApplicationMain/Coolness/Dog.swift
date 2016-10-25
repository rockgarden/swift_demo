

open class Dog {
    open func bark() {
        print ("woof")
    }
    // interestingly, I have to write and declare init explicitly 显式声明初始化
    // implicit init does not magically carry across the framework boundary 隐式初始化并不会进行跨边界的框架
    public init() {}
}
