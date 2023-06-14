import Foundation
import SwiftUI

struct AddToDoView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @Binding var showAddToDoView: Bool
    
    @State private var name: String = ""
    @State private var selectedCategory = 0
    var categoryTypes = ["👨‍🔧", "☄️", "📙", "🏀", "🏝"]
    @State private var todoDescription: String = ""
    
    var body: some View {
        
        VStack {
            Text("Create New ToDo").font(.largeTitle)
            
            TextField("Enter To Do Name", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Text("Category")
            Picker("", selection: $selectedCategory) {
                ForEach(0 ..< categoryTypes.count) {
                    Text(self.categoryTypes[$0])
                }
            }.pickerStyle(SegmentedPickerStyle())
            
            TextField("Describe New To Do", text: $todoDescription, axis: .vertical)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
        }.padding()
        
        Button(action: {
            self.showAddToDoView = false
            
            let newTodoCD = TodoCD(context: viewContext)
            newTodoCD.name = name
            newTodoCD.category = categoryTypes[selectedCategory]
            newTodoCD.todoDescription = todoDescription
            
            do {
                try viewContext.save()
            }
            catch {
                let error = error as NSError
                fatalError("Unresolved error: \(error)")
            }
        },
               label: {
            Text("Add New ToDo.")
        }).foregroundColor(.white)
            .padding()
            .background(Color.indigo)
            .frame(width: 350, height: 20)
        
    }
} 


struct AddToDoView_Previews: PreviewProvider {
    static var previews: some View {
        Color(.black)
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .environment(\.colorScheme, .dark)
    }
}
