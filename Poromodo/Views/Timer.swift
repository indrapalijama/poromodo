//
//  TimerView.swift
//  Poromodo
//
//  Created by Samudra Palijama on 15/09/24.
//

import SwiftUI

struct TimerView: View {
    @ObservedObject var pomodoroTimer: PoromodoTimer
    @State private var newActivity: String = ""
    @State private var showingActivityAlert = false
    @State private var selectedActivity: (name: String, date: Date)?
    
    var body: some View {
        ZStack {
            backgroundView
                .edgesIgnoringSafeArea(.top)
            
            VStack(spacing: 30) {
                titleView
                timerCircle
                completedActivitiesView
                currentActivityView
                controlButtons
                Spacer()
            }
            .padding(.top, 40)
        }
        .alert("Input activity", isPresented: $pomodoroTimer.showingInputAlert) {
            TextField("Enter activity", text: $newActivity)
            Button("Start") {
                pomodoroTimer.currentActivity = newActivity
                newActivity = ""
                pomodoroTimer.startTimer()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Your focus for this session?")
        }
        .alert("Activity Completed", isPresented: $pomodoroTimer.showingCompletionAlert) {
            Button("OK") {
                pomodoroTimer.resetTimer()
            }
        } message: {
            Text("Congrats! Activity '\(pomodoroTimer.currentActivity)' is complete")
        }
        .alert("Activity Details", isPresented: $showingActivityAlert) {
             Button("OK", role: .cancel) { }
         } message: {
             if let activity = selectedActivity {
                 VStack {
                     Text("\(activity.name) - \(formatDate(activity.date))")
                 }
             }
         }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    private var backgroundView: some View {
        pomodoroTimer.isRunning ? Color.pink : Color.white
    }
    
    private var titleView: some View {
        Text("Poromodo")
            .font(.largeTitle)
            .bold()
            .foregroundColor(pomodoroTimer.isRunning ? .white : .pink)
            .padding(.all, 50)
    }
    
    private var timerCircle: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 20)
                .foregroundStyle(Color.gray)
            
            Circle()
                .trim(from: 0.0, to: CGFloat(1.0 - (Double(pomodoroTimer.timeRemaining) / Double(pomodoroTimer.totalTime))))
                .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                .foregroundStyle(pomodoroTimer.isRunning ? Color.white : Color.pink)
                .rotationEffect(Angle(degrees: 270))
                .animation(.linear, value: pomodoroTimer.timeRemaining)
            
            Text(timeFormatted(pomodoroTimer.timeRemaining))
                .font(.largeTitle)
                .bold()
                .foregroundStyle(pomodoroTimer.isRunning ? .white : .pink)
        }
        .frame(width: 250, height: 250)
    }
    
    private var completedActivitiesView: some View {
            HStack {
                ForEach(pomodoroTimer.completedActivities.indices, id: \.self) { index in
                    Circle()
                        .fill(.pink)
                        .frame(width: 30, height: 30)
                        .onTapGesture {
                            selectedActivity = pomodoroTimer.completedActivities[index]
                            showingActivityAlert = true
                        }
                }
            }
    }
    private var currentActivityView: some View {
        Group {
            if !pomodoroTimer.currentActivity.isEmpty {
                Text("Focus : \(pomodoroTimer.currentActivity)")
                    .foregroundStyle(pomodoroTimer.isRunning ? .white : .pink)
                    .font(.headline)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(pomodoroTimer.isRunning ? Color.white.opacity(0.2) : Color.pink.opacity(0.1))
                    )
            }
        }
    }
    private var controlButtons: some View {
        HStack(spacing: 20) {
            resetButton
            startPauseButton
        }
    }
    
    private var resetButton: some View {
        Button(action: pomodoroTimer.resetTimer) {
            CircleButton(
                backgroundColor: pomodoroTimer.isRunning ? .white : .pink,
                foregroundColor: pomodoroTimer.isRunning ? .pink : .white,
                iconName: "arrow.clockwise"
            )
        }
    }
    
    private var startPauseButton: some View {
        Button(action: {
            if pomodoroTimer.isRunning {
                pomodoroTimer.pauseTimer()
            } else if pomodoroTimer.currentActivity.isEmpty {
                pomodoroTimer.showingInputAlert = true
            } else {
                pomodoroTimer.startTimer()
            }
        }) {
            CircleButton(
                backgroundColor: pomodoroTimer.isRunning ? .white : .pink,
                foregroundColor: pomodoroTimer.isRunning ? .pink : .white,
                iconName: pomodoroTimer.isRunning ? "pause.fill" : "play.fill",
                iconOffset: pomodoroTimer.isRunning ? 0 : 8
            )
        }
    }
    
    private func timeFormatted(_ totalSeconds: Int) -> String {
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

struct CircleButton: View {
    let backgroundColor: Color
    let foregroundColor: Color
    let iconName: String
    var iconOffset: CGFloat = 0
    
    var body: some View {
        ZStack {
            Circle()
                .fill(backgroundColor)
                .frame(width: 80, height: 80)
            Circle()
                .fill(foregroundColor)
                .frame(width: 60, height: 60)
            Image(systemName: iconName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
                .foregroundStyle(backgroundColor)
                .padding(.leading, iconOffset)
        }
    }
}

#Preview {
    TimerView(pomodoroTimer: PoromodoTimer())
}
