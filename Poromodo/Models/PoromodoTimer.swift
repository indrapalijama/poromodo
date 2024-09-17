//
//  PoromodoTimer.swift
//  Poromodo
//
//  Created by Samudra Palijama on 12/09/24.
//

import Foundation
import SwiftUI

class PoromodoTimer: ObservableObject {
    @Published var timeRemaining = 25 * 60 // 25 minutes
    @Published var isRunning = false
    @Published var workSessionCount = 0
    @Published var currentActivity: String = ""
    @Published var showingInputAlert = false
    @Published var currentSessionType: SessionType = .work
    
    enum SessionType {
          case work
          case shortBreak
          case longBreak
    }
    
    var timer = Timer()
    
    let totalSessions = 4
    
    func startTimer() {
        if !isRunning {
            isRunning = true
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
                self?.tick()
            }
        }
    }
    
    func pauseTimer() {
        isRunning = false
        timer.invalidate()
    }
    
    func resetTimer() {
        pauseTimer()
        timeRemaining = 25 * 60
        currentActivity = ""
        workSessionCount = 0
    }
    
    private func tick() {
        if timeRemaining > 0 {
            timeRemaining -= 1
        } else {
            completeSession()
        }
    }
    
    private func completeSession() {
        workSessionCount += 1
        if workSessionCount % 4 == 0 {
            currentSessionType = .longBreak
            timeRemaining = 15 * 60 // 15 minutes for long break
        } else if workSessionCount % 2 == 0 {
            currentSessionType = .shortBreak
            timeRemaining = 5 * 60 // 5 minutes for short break
        } else {
            currentSessionType = .work
            timeRemaining = 25 * 60 // 25 minutes for work session
        }
        
        if workSessionCount >= totalSessions {
            workSessionCount = 0
        }
        
        isRunning = false
        objectWillChange.send()
    }
}
