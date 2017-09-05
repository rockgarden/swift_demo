
import UIKit

class MainVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

/**
 1.在错误的线程访问托管对象上下文（Managed Object Context）
 Core Data从未被设计用来在多线程的环境中使用。幸运的是，这个框架已经在这些年逐渐发展，使得 Core Data 在多线程的应用程序中使用并不困难。
 Core Data使用 线程限制 来保护托管对象上下文。这意味着你只应该通过与托管对象上下文所关联的线程来访问它。但是你怎么知道与之关联的是哪一个线程呢？
 
 在iOS 5和macOS 10.7中,一个托管对象上下文创建并且管理一个调度队列，并在这个队列上进行工作。NSManagedObjectContext 类提供了一个方便的接口来在托管对象上下文创建的调度队列中执行各种操作。你有两个选择:
	•	perform(_:)
	•	performAndWait(_:)
 每个方法都接收一个闭包作为参数，可以在这个闭包中对托管对象上下文所管理的托管对象进行操作。
 managedObjectContext.perform {
     ...
 }
  
 managedObjectContext.performAndWait {
     ...
 }
 perform(_:) 和  performAndWait(_:) 的区别在于托管对象上下文的调度队列如何来计划执行闭包中的操作。
 如名字所示
	•	perform(_:) 方法在托管对象上下文的调度队列中，异步执行闭包中的操作。
	•	performAndWait(_:) 方法在托管对象上下文的调度队列中，同步执行闭包中的操作。
 
 除非你完全确定你在使用正确的线程访问托管对象上下文，否则你应该使用 perform(_:) 或者 performAndWait(_:) 来避免遇到线程问题。
 
 2.跨线程传递托管对象
 另外一个开发者常犯的错误是跨线程传递托管对象。比如，当应用程序从远程后端获取数据时，这一错误并不罕见。你需要遵循的规则很简单，你永远都不应该将一个 NSManagedObject 对象从一个线程传递到另一个线程。
 
 NSManagedObject 类并不是线程安全的。
 
 然而这看上去似乎很不方便。解决方案很简单，Core Data 框架提供了一个跨线程传递托管对象的解决方案:NSManagedObjectID 类。这个类的一个实例唯一标识程序中某一个托管对象。重要的是，NSManagedObjectID 这个类是线程安全的。
 
 你不应该再从一个线程传递托管对象到另一个线程，而是传递 NSManagedObjectID 对象。你可以通过一个 NSManagedObject 的 objectID 属性来获取它的唯一标识。
 let objectID = managedObject.objectID
 
 托管对象上下文知道如何通过你传递的 NSManagedObjectID 对象来获取对应的托管对象。事实上， NSManagedObjectContext 类提供了好几个方法来根据NSManagedObjectID 对象获取对应的托管对象。
	•	object(with:)
	•	existingObject(with:)
	•	registeredObject(for:)
 每个方法都接收一个 NSMangedObjectID 对象作为参数。
 let objectID = managedObject.objectID
  
 DispatchQueue.main.async {
     ...
      
     let managedObject = mainManagedObjectContext.object(with: objectID)
  
     ...
 }
 
 第一个方法,object(with:)，返回一个与 NSManagedObjectID 实例对应的托管对象。如果托管对象上下文中不包含一个与这个标识对应的托管对象，它就会去持久化存储协调器(Persistent store coordinator)中查找。这个方法始终返回一个托管对象。
 
 要了解的是，object(with:) 方法在找不到与唯一标识对应的托管对象时，会抛出异常。比如，如果应用程序删除了与唯一标识对应的记录，Core Data 不能够返回对应的托管对象，结果就是抛出一个异常。
 
 existingObject(with:)方法与之类似。主要的区别是，如果托管对象上下文找不到与这个唯一标识对应的托管对象时，会抛出一个错误。
 
 第三个方法，registeredObject(for:)只有在你所要获取的托管对象已经在托管对象上下文中注册过，才会返回这个托管对象。换而言之，返回值是可选类型的 `NSManagedObject?` 。如果托管对象上下文在持久化存储协调器中找不到对应的记录，它将不会返回托管对象。
 
 托管对象的标识与数据库中的对应记录的主键很相似，但是并不完全相同。它唯一标识这条记录，并且使得你的应用程序可以获取到某条指定的记录，而不用去管当前的操作是在哪个线程。
 */
