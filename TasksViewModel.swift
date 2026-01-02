import Foundation
import SwiftUI

final class TasksViewModel: ObservableObject {
    @AppStorage("tasksData") private var tasksData: Data = Data()

    @Published var tasks: [TaskItem] = [] {
        didSet { persist() }
    }

    init() {
        load()
    }

    func addTask(title: String) {
        let trimmed = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty
            else { return }
        tasks.append(TaskItem(title: trimmed))
    }

    func toggle(_ task: TaskItem) {
        guard let idx = tasks.firstIndex(where: { $0.id == task.id })
            else { return }
        tasks[idx].isDone.toggle()
    }

    func delete(at offsets: IndexSet) {
        tasks.remove(atOffsets: offsets)
    }

    private func persist() {
        tasksData = (try? JSONEncoder().encode(tasks)) ?? Data()
    }

    private func load() {
        guard let decoded = try? JSONDecoder().decode([TaskItem].self, from: tasksData) else {
            tasks = []
            return
        }
        tasks = decoded
    }
}
