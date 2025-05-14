//
//
//

import SwiftUI

struct RestrictionDetailView: View {
    let restriction: Restriction
    @ObservedObject var viewModel: RestrictionViewModel
    @State private var showEditSheet = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    VStack(alignment: .leading) {
                        Text(restriction.appName)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text("Screen Time Restriction")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "hourglass")
                        .font(.system(size: 40))
                        .foregroundColor(.blue)
                }
                .padding(.bottom)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Daily Time Limit")
                        .font(.headline)
                    
                    HStack {
                        Image(systemName: "clock")
                            .foregroundColor(.blue)
                        Text("\(restriction.timeLimit) minutes per day")
                            .font(.body)
                    }
                    
                    Text("After reaching this limit, you'll need to send a message to continue using the app.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Cooldown Period")
                        .font(.headline)
                    
                    HStack {
                        Image(systemName: "hourglass")
                            .foregroundColor(.blue)
                        Text("\(restriction.cooldownTime) minutes")
                            .font(.body)
                    }
                    
                    Text("After sending a message, you'll get this much additional time before being prompted again.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Usage Statistics")
                        .font(.headline)
                    
                    HStack {
                        Image(systemName: "chart.bar")
                            .foregroundColor(.blue)
                        Text(restriction.formattedUsedTime)
                            .font(.body)
                    }
                    
                    if restriction.isOverLimit {
                        HStack {
                            Image(systemName: "exclamationmark.triangle")
                                .foregroundColor(.red)
                            Text("Daily limit exceeded")
                                .foregroundColor(.red)
                                .font(.subheadline)
                        }
                    } else {
                        HStack {
                            Image(systemName: "timer")
                                .foregroundColor(.green)
                            Text(restriction.formattedRemainingTime)
                                .font(.subheadline)
                                .foregroundColor(.green)
                        }
                    }
                    
                    Text("Track your usage to stay within your daily limits.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Restriction Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: {
                    showEditSheet = true
                }) {
                    Text("Edit")
                }
            }
            
            ToolbarItem(placement: .destructiveAction) {
                Button(action: {
                    if let index = viewModel.restrictions.firstIndex(where: { $0.id == restriction.id }) {
                        viewModel.deleteRestriction(at: IndexSet(integer: index))
                        dismiss()
                    }
                }) {
                    Text("Delete")
                        .foregroundColor(.red)
                }
            }
        }
        .sheet(isPresented: $showEditSheet) {
            EditRestrictionView(restriction: Binding(
                get: { self.restriction },
                set: { newValue in
                    viewModel.updateRestriction(newValue)
                }
            ), onSave: { updatedRestriction in
                viewModel.updateRestriction(updatedRestriction)
            })
        }
    }
}
