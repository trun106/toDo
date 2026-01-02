import SwiftUI

struct ContentView: View {
    @State private var newTaskTitle: String = ""
    @StateObject private var viewModel = TasksViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                HStack {
                    TextField("Add a task…", text: $newTaskTitle)
                        .textFieldStyle(.roundedBorder)
                        .onSubmit { add() }

                    Button {
                        add()
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundStyle(.blue)
                            .font(.system(size: 28, weight: .semibold))
                    }
                    .accessibilityLabel("Add task")
                }
                .padding(.horizontal)

                if viewModel.tasks.isEmpty {
                    VStack(spacing: 8) {
                        Image(systemName: "checklist")
                            .font(.largeTitle)
                            .foregroundStyle(.secondary)
                        Text("No tasks")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.top, 40)
                } else {
                    List {
                        ForEach(viewModel.tasks) { task in
                            Button { viewModel.toggle(task) } label: {
                                HStack {
                                    Image(systemName: task.isDone ? "checkmark.circle.fill" : "circle")
                                        .foregroundStyle(task.isDone ? .green : .secondary)
                                    Text(task.title)
                                        .strikethrough(task.isDone, color: .secondary)
                                        .foregroundStyle(task.isDone ? .secondary : .primary)
                                    Spacer()
                                }
                            }
                            .buttonStyle(.plain)
                        }
                        .onDelete(perform: viewModel.delete)
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("To‑Do")
        }
    }

    private func add() {
        viewModel.addTask(title: newTaskTitle)
        newTaskTitle = ""
    }
}

#Preview { ContentView() }
