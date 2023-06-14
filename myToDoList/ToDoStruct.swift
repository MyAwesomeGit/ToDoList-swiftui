import Foundation

struct sampleToDo: Identifiable, Equatable {
    let id = UUID()
    var name: String
    var category: String
    var todoDescription: String
}
