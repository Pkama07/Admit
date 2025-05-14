//
//

import Foundation
import DeviceActivity
import FamilyControls
import ManagedSettings
import SwiftUI

class AppActivityMonitor: ObservableObject {
    static let shared = AppActivityMonitor()
    
    @Published var isAuthorized = false
    private var center: DeviceActivityCenter
    private var deviceActivityReportContent: Set<DeviceActivityReport.Context> = [.application]
    private var monitoredApps: Set<ApplicationToken> = []
    
    init() {
        self.center = DeviceActivityCenter()
    }
    
    func requestAuthorization() async {
        do {
            try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
            DispatchQueue.main.async {
                self.isAuthorized = true
            }
        } catch {
            print("Failed to request authorization: \(error.localizedDescription)")
        }
    }
    
    func startMonitoring(for restrictions: [Restriction]) {
        guard isAuthorized else { return }
        
        monitoredApps = Set()
        
        let activitySelection = FamilyActivitySelection.init()
        
        let schedule = DeviceActivitySchedule(
            intervalStart: DateComponents(hour: 0, minute: 0),
            intervalEnd: DateComponents(hour: 23, minute: 59),
            repeats: true
        )
        
        let center = DeviceActivityCenter()
        
        do {
            try center.startMonitoring(
                .daily,
                during: schedule,
                activities: activitySelection.applicationTokens,
                reportContext: deviceActivityReportContent
            )
        } catch {
            print("Error starting monitoring: \(error.localizedDescription)")
        }
    }
    
    func stopMonitoring() {
        center.stopMonitoring([.daily])
    }
    
    func getUsageTime(for appName: String) -> Int {
        return Int.random(in: 5...60)
    }
    
    func updateRestrictionUsage(viewModel: RestrictionViewModel) {
        guard isAuthorized else { return }
        
        var updatedRestrictions = viewModel.restrictions
        
        for i in 0..<updatedRestrictions.count {
            let appName = updatedRestrictions[i].appName
            let usageTime = getUsageTime(for: appName)
            
            updatedRestrictions[i].usedTime = usageTime
            updatedRestrictions[i].lastUsed = Date()
        }
        
        viewModel.restrictions = updatedRestrictions
        viewModel.saveRestrictions()
    }
}

extension AppActivityMonitor: DeviceActivityReportExtension {
    func reportActivity(_ context: DeviceActivityReport.Context, from startDate: Date, to endDate: Date) async -> DeviceActivityResults {
        do {
            return try await DeviceActivityCenter().activityReport(for: startDate, to: endDate, context: context)
        } catch {
            print("Failed to report activity: \(error.localizedDescription)")
            return DeviceActivityResults()
        }
    }
}
