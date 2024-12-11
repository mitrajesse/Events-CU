
import SwiftUI
struct SortMenuButton: View {
    @Binding var sortOrder: EventsViewModel.SortOrder
    let barBackgroundColor: Color

    var body: some View {
        Menu {
            Button("Date Ascending") {
                sortOrder = .dateAscending
            }
            Button("Date Descending") {
                sortOrder = .dateDescending
            }
            Button("Name Ascending") {
                sortOrder = .nameAscending
            }
            Button("Name Descending") {
                sortOrder = .nameDescending
            }
        } label: {
            Image(systemName: "arrow.up.arrow.down.circle")
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundColor(barBackgroundColor)
        }
    }
}
