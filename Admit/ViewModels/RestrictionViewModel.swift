//
//
//

import Foundation
import SwiftUI

class RestrictionViewModel: ObservableObject {
    @Published var restrictions: [Restriction] = []
    @Published var showAddRestriction = false
    
    init() {
        loadRestrictions()
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
    }
    
    func deleteRestriction(at indexSet: IndexSet) {
        restrictions.remove(atOffsets: indexSet)
        saveRestrictions()
    }
    
    func updateRestriction(_ restriction: Restriction) {
        if let index = restrictions.firstIndex(where: { $0.id == restriction.id }) {
            restrictions[index] = restriction
            saveRestrictions()
        }
    }
}
