//
//
//

import Foundation
import SwiftUI

class RestrictionViewModel: ObservableObject {
    @Published var restrictions: [Restriction] = []
    @Published var showAddRestriction = false
    @Published var isActivityMonitoringEnabled = false
    
    init() {
        loadRestrictions()
        setupAppActivityMonitoring()
    }
    
    func loadRestrictions() {
        restrictions = Restriction.loadRestrictions()
    }
    
    func saveRestrictions() {
        Restriction.saveRestrictions(restrictions)
    }
    
    func addRestriction(_ restriction: Restriction) {
        restrictions.append(restriction)
        saveRestrictions()
        updateActivityMonitoring()
    }
    
    func deleteRestriction(at indexSet: IndexSet) {
        restrictions.remove(atOffsets: indexSet)
        saveRestrictions()
        updateActivityMonitoring()
    }
    
    func updateRestriction(_ restriction: Restriction) {
        if let index = restrictions.firstIndex(where: { $0.id == restriction.id }) {
            restrictions[index] = restriction
            saveRestrictions()
            updateActivityMonitoring()
        }
    }
    
    func resetDailyUsage() {
        var updatedRestrictions = restrictions
        for i in 0..<updatedRestrictions.count {
            updatedRestrictions[i].usedTime = 0
            updatedRestrictions[i].inCooldown = false
            updatedRestrictions[i].cooldownEndTime = nil
        }
        restrictions = updatedRestrictions
        saveRestrictions()
    }
    
    private func setupAppActivityMonitoring() {
        Task {
            await AppActivityMonitor.shared.requestAuthorization()
            DispatchQueue.main.async {
                self.updateActivityMonitoring()
                self.isActivityMonitoringEnabled = true
            }
        }
    }
    
    private func updateActivityMonitoring() {
        if !restrictions.isEmpty {
            AppActivityMonitor.shared.startMonitoring(for: restrictions)
        } else {
            AppActivityMonitor.shared.stopMonitoring()
        }
    }
    
    func refreshUsageData() {
        AppActivityMonitor.shared.updateRestrictionUsage(viewModel: self)
    }
}
