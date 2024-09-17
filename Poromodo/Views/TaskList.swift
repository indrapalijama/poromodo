//
//  TaskList.swift
//  Poromodo
//
//  Created by Samudra Palijama on 15/09/24.
//

import SwiftUI

struct TaskListView: View {
    @ObservedObject var pomodoroTimer: PoromodoTimer
    @State private var tasks: [Task] = []
    @State private var newTaskTitle: String = ""
    
    var body: some View {
        NavigationView {
            List {
                if !pomodoroTimer.currentActivity.isEmpty {
                    Section(header: Text("Current Activity").padding(.leading, -10)) {
                        HStack {
                            Image(systemName: pomodoroTimer.isRunning ? "play.circle.fill" : "pause.circle.fill")
                                .foregroundColor(pomodoroTimer.isRunning ? .green : .orange)
                            Text(pomodoroTimer.currentActivity)
                        }
                    }
                } else {
                    Section(header: Text("Current Activity").padding(.leading, -10)){
                        Text("No current activity for today")
                            .foregroundColor(.gray)
                    }
                }
                
                if !pomodoroTimer.completedActivities.isEmpty {
                    Section(header: Text("Completed Activities").padding(.leading, -10)) {
                        ForEach(pomodoroTimer.completedActivities, id: \.date) { activity in
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                Text(activity.name)
                                Spacer()
                                Text(formatDate(activity.date))
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                } else {
                    Section(header: Text("Completed Activities").padding(.leading, -10)){
                        Text("No current activity for today")
                            .foregroundColor(.gray)
                    }

                }
            }
            .navigationTitle("Tasks")
        }
    }
    
    private func addTask() {
        guard !newTaskTitle.isEmpty else { return }
        let newTask = Task(title: newTaskTitle)
        tasks.append(newTask)
        newTaskTitle = ""
    }
    
    private func toggleTask(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted.toggle()
        }
    }
    
    private func deleteTasks(at offsets: IndexSet) {
        tasks.remove(atOffsets: offsets)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct TaskRow: View {
    let task: Task
    let toggleCompletion: (Task) -> Void
    
    var body: some View {
        HStack {
            Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                .foregroundColor(task.isCompleted ? .green : .gray)
            Text(task.title)
                .strikethrough(task.isCompleted)
        }
        .onTapGesture {
            toggleCompletion(task)
        }
    }
}

struct Task: Identifiable {
    let id = UUID()
    var title: String
    var isCompleted: Bool = false
}

#Preview {
    TaskListView(pomodoroTimer: PoromodoTimer())
}
