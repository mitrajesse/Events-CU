//
//  OnCampusView.swift
//  Events@CU
//
//  Created by Jesse Mitra and Abe Howder on 12/12/24.
//

import SwiftUI

struct OnCampusView: View {
    @EnvironmentObject var eventsViewModel: EventsViewModel

    let barBackgroundColor = Color(UIColor(red: 252/255, green: 183/255, blue: 22/255, alpha: 1))
    let appBackgroundColor = Color(UIColor(red: 0/255, green: 56/255, blue: 101/255, alpha: 1))

    var body: some View {
        VStack {
            List {
                ForEach(eventsViewModel.sortedOnCampusEvents) { event in
                    VStack(alignment: .leading, spacing: 4) {
                        NavigationLink(destination: EventDetailView(event: event)) {
                            VStack(alignment: .leading) {
                                Text(event.name)
                                    .font(.headline)
                                    .bold()
                                    .foregroundColor(.white)
                                Text(event.date.formatted(date: .abbreviated, time: .shortened))
                                    .font(.subheadline)
                                    .bold()
                                    .foregroundColor(.white)
                                Text(event.location)
                                    .font(.subheadline)
                                    .bold()
                                    .foregroundColor(barBackgroundColor)
                            }
                        }
                        Divider()
                            .background(Color.white.opacity(0.5)) // Customize divider appearance
                            .padding(.horizontal, -20) // Extend divider edge to edge
                    }
                    .padding(.vertical, 8)
                }
                .listRowBackground(appBackgroundColor)
                .listRowSeparator(.hidden) // Hide the built-in separators completely
            }
            .listStyle(PlainListStyle())
            .scrollContentBackground(.hidden) // Removes default background from List
        }
        .background(appBackgroundColor.ignoresSafeArea())
        .navigationBarTitle("On Campus", displayMode: .inline)
        .navigationBarItems(trailing: SortMenuButton(sortOrder: $eventsViewModel.sortOrder, barBackgroundColor: barBackgroundColor)) // Add sort button
        .onAppear {
            configureNavigationBarAppearance()
            eventsViewModel.fetchEvents(isOffCampus: false) { _ in
                // Events fetched automatically update the list
            }
        }
    }

    private func configureNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(appBackgroundColor)
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
}

