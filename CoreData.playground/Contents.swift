import CoreData

//: ## Persistent stack
//: This is a generic `struct` which can be used in any project.
struct PersistentStack {
  let modelURL: NSURL
  let storeURL: NSURL
  let managedObjectContext: NSManagedObjectContext


  init(modelURL aModelURL: NSURL, storeURL aStoreURL: NSURL) {
    let managedObjectModel = NSManagedObjectModel(contentsOfURL: aModelURL)!
    modelURL = aModelURL
    storeURL = aStoreURL
    managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
    managedObjectContext.undoManager = NSUndoManager()

    let options = [NSMigratePersistentStoresAutomaticallyOption: true,
      NSInferMappingModelAutomaticallyOption: true]
    managedObjectContext.persistentStoreCoordinator = NSPersistentStoreCoordinator(
      managedObjectModel: managedObjectModel)

    do {
      try managedObjectContext.persistentStoreCoordinator?
        .addPersistentStoreWithType(NSSQLiteStoreType,
          configuration: nil,
          URL: aStoreURL,
          options: options)
    } catch {
      print("Error!")
    }
  }
}

//: ## Store
//: The purpose of this `struct` is to define the application specific
//: properties of the core data stack. In particular, the name of the model.
struct Store {
  static let modelName = "MyModel"
  static let modelURL = NSBundle.mainBundle().URLForResource(
    modelName,
    withExtension: "momd")

  static let storeURL = { () -> NSURL in
    let url: NSURL?
    let documentsDirectory: NSURL
    do {
      try documentsDirectory = NSFileManager.defaultManager().URLForDirectory(
        .DocumentDirectory,
        inDomain: .UserDomainMask,
        appropriateForURL: nil,
        create: true)

      url = documentsDirectory.URLByAppendingPathComponent("\(modelName).sqlite")
    } catch {
      url = nil
    }

    return url!
  }
}

//: ## Usage
//: Below is how to use the 2 `structs` above. The code is commented out because it will throw an error.

// let stack = PersistentStack(modelURL: Store.modelURL!, storeURL: Store.storeURL())
