//
//  DetailView.swift
//  Bookworm
//
//  Created by SuShenghung on 2021/2/1.
//

import SwiftUI
import CoreData

struct DetailView: View {
    // inform current view that there's an environment property "moc"
    @Environment(\.managedObjectContext) var moc
    
    // an environment property to get current view's presentation status
    @Environment(\.presentationMode) var presentationMode
    
    // inform current view that there's a Book
    let book: Book
    
    // another state property to store showing confirmation of deleting action
    @State private var showingDeleteAlert = false
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                // an image with genre mark at bottom trailing
                ZStack(alignment: .bottomTrailing) {
                    Image(self.book.genre ?? "Fantasy")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: geo.size.width)
                    
                    Text(self.book.genre?.uppercased() ?? "FANTASY")
                        .font(.caption)
                        .fontWeight(.black)
                        .padding(8)
                        .foregroundColor(.white)
                        .background(Color.black.opacity(0.75))
                        .clipShape(Capsule())
                        .offset(x: -5, y: -5)
                }
                
                Text(self.book.author ?? "Unknown author")
                    .font(.title2)
                    .fontWeight(.black)
                
                RatingView(rating: .constant(Int(self.book.rating)))
                    .padding(5)
                
                Divider()
                
                HStack {
                    Spacer()
                    Text("Reviews on: \(self.formatDate(by: self.book.date ?? Date())) ")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .italic()
                }
                .padding(.horizontal, 10)
                
                Text(self.book.review ?? "No review")
                    .padding()

                Spacer()
            }
        }
        .navigationBarTitle(book.title ?? "Unknown book", displayMode: .inline)
        .navigationBarItems(trailing: Button(action: {
            self.showingDeleteAlert = true
        }, label: {
            Image(systemName: "trash")
        }))
        .alert(isPresented: $showingDeleteAlert) {
            Alert(title: Text("Delete book"), message: Text("Are you sure?"),
                primaryButton: .destructive(Text("Delete")) {
                    self.deleteBook()
                },
                secondaryButton: .cancel()
            )
        }
    }
    
    // function to delete current book
    func deleteBook() {
        // delete book and save to moc
        moc.delete(book)
        try? moc.save()
        
        // close detail view
        presentationMode.wrappedValue.dismiss()
    }
    
    // function to format date
    func formatDate(by date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "y-MM-dd"
        return formatter.string(from: date)
    }
    
}

struct DetailView_Previews: PreviewProvider {
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    static var previews: some View {
        let book = Book(context: moc)
        
        book.title = "Test book"
        book.author = "Test author"
        book.genre = "Fantasy"
        book.rating = 5
        book.review = "This was a test review"
        
        return NavigationView {
            DetailView(book: book)
        }
    }
}
