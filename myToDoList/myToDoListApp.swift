import SwiftUI

@main
struct myToDoListApp: App {
    var body: some Scene {
        let persistentContainer = PersistentController.shared
        
        WindowGroup {
            ContentView().environment(\.managedObjectContext, persistentContainer.container.viewContext)
        }
    }
}
