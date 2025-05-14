//
//
//

import SwiftUI

struct AddRestrictionView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var restrictions: [Restriction]
    
    @State private var appName: String = ""
    @State private var timeLimit: Double = 60 // Default 1 hour
    @State private var cooldownTime: Double = 10 // Default 10 minutes
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("App Details")) {
                    TextField("App Name", text: $appName)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                }
                
                Section(header: Text("Time Limit")) {
                    VStack(alignment: .leading) {
                        Text("Daily Time Limit: \(Int(timeLimit)) minutes")
                            .font(.headline)
                        
                        Slider(value: $timeLimit, in: 5...240, step: 5)
                            .padding(.vertical, 10)
                        
                        Text("Set how much time you want to allow yourself to use this app each day.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Section(header: Text("Cooldown Time")) {
                    VStack(alignment: .leading) {
                        Text("Cooldown Time: \(Int(cooldownTime)) minutes")
                            .font(.headline)
                        
                        Slider(value: $cooldownTime, in: 5...15, step: 1)
                            .padding(.vertical, 10)
                        
                        Text("Set how much additional time you get when bypassing a restriction (5-15 minutes).")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Add Restriction")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveRestriction()
                    }
                }
            }
            .alert(alertMessage, isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            }
        }
    }
    
    private func saveRestriction() {
        guard !appName.isEmpty else {
            alertMessage = "Please enter an app name"
            showAlert = true
            return
        }
        
        let newRestriction = Restriction(
            appName: appName,
            timeLimit: Int(timeLimit),
            cooldownTime: Int(cooldownTime)
        )
        
        restrictions.append(newRestriction)
        Restriction.saveRestrictions(restrictions)
        
        dismiss()
    }
}

#Preview {
    AddRestrictionView(restrictions: .constant([]))
}
