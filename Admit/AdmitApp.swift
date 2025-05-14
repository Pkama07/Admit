//
//  AdmitApp.swift
//  Admit
//
//  Created by Pradyun Kamaraju on 5/14/25.
//

import SwiftUI
import DeviceActivity
import FamilyControls

@main
struct AdmitApp: App {
    @StateObject private var viewModel = RestrictionViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
                .onAppear {
                    checkAndResetDailyUsage()
                    
                    setupRefreshTimer()
                }
        }
    }
    
    private func checkAndResetDailyUsage() {
        let defaults = UserDefaults.standard
        let lastLaunchDateKey = "lastLaunchDate"
        
        let today = Calendar.current.startOfDay(for: Date())
        
        if let lastLaunchDateData = defaults.object(forKey: lastLaunchDateKey) as? Data,
           let lastLaunchDate = try? JSONDecoder().decode(Date.self, from: lastLaunchDateData) {
            
            if lastLaunchDate < today {
                viewModel.resetDailyUsage()
            }
        }
        
        if let encodedDate = try? JSONEncoder().encode(today) {
            defaults.set(encodedDate, forKey: lastLaunchDateKey)
        }
    }
    
    private func setupRefreshTimer() {
        Timer.scheduledTimer(withTimeInterval: 300, repeats: true) { _ in
            viewModel.refreshUsageData()
        }
        
        viewModel.refreshUsageData()
    }
}
