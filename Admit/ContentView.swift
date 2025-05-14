//
//  ContentView.swift
//  Admit
//
//  Created by Pradyun Kamaraju on 5/14/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var viewModel: RestrictionViewModel
    @State private var showAddRestriction = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                if viewModel.restrictions.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "hourglass")
                            .font(.system(size: 60))
                            .foregroundColor(.blue)
                        
                        Text("No Restrictions Yet")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text("Add your first app restriction to start controlling your screen time.")
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                            .padding(.horizontal)
                        
                        Button(action: {
                            showAddRestriction = true
                        }) {
                            Text("Add Restriction")
                                .fontWeight(.semibold)
                                .padding()
                                .frame(maxWidth: 250)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding(.top)
                    }
                    .padding()
                } else {
                    List {
                        ForEach(viewModel.restrictions) { restriction in
                            RestrictionRow(restriction: restriction, viewModel: viewModel)
                                .swipeActions(edge: .trailing) {
                                    Button(role: .destructive) {
                                        if let index = viewModel.restrictions.firstIndex(where: { $0.id == restriction.id }) {
                                            viewModel.deleteRestriction(at: IndexSet(integer: index))
                                        }
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                        }
                        .onDelete(perform: viewModel.deleteRestriction)
                    }
                    .listStyle(InsetGroupedListStyle())
                }
            }
            .navigationTitle("Admit")
            .toolbar {
                if !viewModel.restrictions.isEmpty {
                    ToolbarItem(placement: .primaryAction) {
                        Button(action: {
                            showAddRestriction = true
                        }) {
                            Image(systemName: "plus")
                        }
                    }
                }
            }
            .sheet(isPresented: $showAddRestriction) {
                AddRestrictionView(restrictions: $viewModel.restrictions)
            }
        }
    }
}

struct RestrictionRow: View {
    let restriction: Restriction
    @ObservedObject var viewModel: RestrictionViewModel
    
    var body: some View {
        NavigationLink(destination: RestrictionDetailView(restriction: restriction, viewModel: viewModel)) {
            VStack(alignment: .leading, spacing: 8) {
                Text(restriction.appName)
                    .font(.headline)
                
                HStack {
                    Label("\(restriction.timeLimit) min/day", systemImage: "clock")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Label("\(restriction.cooldownTime) min cooldown", systemImage: "hourglass")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.vertical, 8)
        }
    }
}

#Preview {
    ContentView()
}
