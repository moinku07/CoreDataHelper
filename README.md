Swift CoreData Handler to manage Core Data related tasks easily.

<code>
	// create managed object context with database name
	let moc: NSManagedObjectContext = CoreDataHelper.managedObjectContext("database_name")
	
	// with default name
	let moc: NSManagedObjectContext = CoreDataHelper.managedObjectContext()
	
	// Let your CoreData entity name is "Carts"
	// Create an insert instance with following
	let cart: Carts = CoreDataHelper.insertManagedObject(NSStringFromClass(Carts), managedObjectContext: moc) as! Carts
	
	// Now set your cart values to store
	cart.name = "Burger"
    cart.details = "Some details"
    cart.item_id = 1
    cart.quantity = 1
    cart.price = 2.99
    
    // Now save the data
    let success: Bool = CoreDataHelper.saveManagedObjectContext(moc)
    if success{
    	// do for success
    }else{
    	// do for error
    }
    
    // fetch all from Carts entity
    let cartArray: [Carts] = CoreDataHelper.fetchEntities(NSStringFromClass(Carts), withPredicate: nil, andSorter: nil, managedObjectContext: moc) as! [Carts]
    
    // fetch with some conditions
    let predicate: NSPredicate = NSPredicate(format: "name = Burger")
    // with more than one conditions
    let predicate: NSPredicate = NSPredicate(format: "(name = %@) AND (quantity = %d)", "Burger", 1)
    
    let cartArray: [Carts] = CoreDataHelper.fetchEntities(NSStringFromClass(Carts), withPredicate: predicate, andSorter: nil, managedObjectContext: moc) as! [Carts]
    
    // with some expression
    let expression: NSExpressionDescription = NSExpressionDescription()
	expression.name = "sumOfAmmount"
    //expression.expression = NSExpression(forFunction: "sum:", arguments: [NSExpression(forKeyPath: "price")]) // next one is the simplified version of this expression
    expression.expression = NSExpression(forKeyPath: "@sum.price")
	expression.expressionResultType = NSAttributeType.DecimalAttributeType
	
	let cartArray: [Carts] = CoreDataHelper.fetchEntities(NSStringFromClass(Carts), withPredicate: predicate, andSorter: nil, managedObjectContext: moc, limit: nil, expressions: [expression])
	
	// using sorter
	let predicate: NSPredicate = NSPredicate(format: "name = Burger")
    let sorter: NSSortDescriptor = NSSortDescriptor(key: "price", ascending: true)
    let results: [Carts] = CoreDataHelper.fetchEntities(NSStringFromClass(Carts), withPredicate: predicate, andSorter: [sorter], managedObjectContext: moc, limit: nil)
    
    // use limit = 10 to fetch only 10 items
	let results: [Carts] = CoreDataHelper.fetchEntities(NSStringFromClass(Carts), withPredicate: predicate, andSorter: [sorter], managedObjectContext: moc, limit: 10)
</code>