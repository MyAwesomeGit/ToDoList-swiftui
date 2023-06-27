import SwiftUI

struct ContentView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \TodoCD.name, ascending: true)]) private var todoCD: FetchedResults<TodoCD>
    
    @State private var showAddTodoView = false
    
    @State var sampleToDos = [
        sampleToDo(name: "Create Your ToDo", category: "👨‍🔧", todoDescription: ""),
        sampleToDo(name: "Choose ToDo's Category", category: "📙", todoDescription: ""),
        sampleToDo(name: "Add ToDo's Description", category: "📝", todoDescription: ""),
        sampleToDo(name: "Rearrange Sample ToDo's", category: "🔧", todoDescription: ""),
        sampleToDo(name: "Delete Your ToDo", category: "🗑", todoDescription: ""),
        sampleToDo(name: "Complete Your ToDo", category: "✅", todoDescription: "")
    ]
    
    @State var name: String = ""
    @State var selectedCategory = 0
    var categoryTypes = ["👨‍🔧", "☄️", "📙", "🏀", "🏝"]
    @State var todoDescription: String = ""
    
    var body: some View {
        NavigationView {
            List {
                ForEach(sampleToDos, id: \.name) { (todo) in
                    NavigationLink(destination:
                                    VStack {
                        HStack {
                            Text(todo.category)
                                .bold()
                                .foregroundColor(.green)
                            Text(todo.name)
                                .bold()
                        }
                        Text(todo.todoDescription)
                    }
                    ){
                        HStack {
                            Text(todo.category)
                            Text(todo.name)
                                .bold()
                                .foregroundColor(.black)
                        }
                    }
                }
                .onDelete(perform: { indexSet in
                    sampleToDos.remove(atOffsets: indexSet)
                })
                .onMove(perform: {indices, newOffset in
                    sampleToDos.move (fromOffsets: indices, toOffset: newOffset)

                })
                
                ForEach(sampleToDos, id: \.self) { (todo) in
                    NavigationLink(destination:
                                    VStack {
                        HStack{
                            Text(todo.category ?? "")
                                .foregroundColor(.black)
                            Text(todo.name ?? "Untitled")
                                .bold()
                        }
                        Text(todo.todoDescription ?? "")
                            .foregroundColor(.black)
                    }
                    ){
                        HStack {
                            Text(todo.category ?? "")
                            Text(todo.name ?? "Untitled")
                                .foregroundColor(.black)
                            Text(todo.todoDescription ?? "")
                                .foregroundColor(.black)
                        }
                    }.onLongPressGesture(perform: {
                        completeTodo(todo: todo)
                    })
                }.onDelete(perform: { indexSet in
                    deleteTodo(offsets: indexSet)
                })
                
            }.navigationBarTitle("ToDo List").foregroundColor(.white)
                .navigationBarItems(
                    leading:
                        Button(action: {
                            self.showAddTodoView.toggle()
                        },
                               label: {
                                   Text("New ToDo")
                               }).sheet(isPresented: $showAddTodoView){
                                   AddToDoView(showAddToDoView: self.$showAddTodoView)
                               },
                    trailing: EditButton()
                )
        }
    }
    
    
    private func deleteTodo(offsets: IndexSet) {
        for index in offsets {
            let todo = todoCD [index]
            viewContext.delete(todo)
        }
        do {
            try viewContext.save()
        } catch {
            let error = error as NSError
            fatalError("Unresolved error: \(error)")
        }
    }
    
    
    private func completeTodo(todo: FetchedResults<TodoCD>.Element) {
        todo.name = "✅ \(todo.name!)"
        do {
            try viewContext.save()
        } catch {
            let error = error as NSError
            fatalError("Unresolved error: \(error)")
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color(.black)
                .background(Color.black.edgesIgnoringSafeArea(.all))
            ContentView()
        }
    }
}
