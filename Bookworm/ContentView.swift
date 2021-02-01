//
//  ContentView.swift
//  Bookworm
//
//  Created by SuShenghung on 2021/1/30.
//

import SwiftUI

struct ContentView: View {
    // inform current view that there's an environment property "moc"
    @Environment(\.managedObjectContext) var moc
    
    // an fetched result called "books"
    @FetchRequest(entity: Book.entity(), sortDescriptors: [
        NSSortDescriptor(keyPath: \Book.rating, ascending: false),
        NSSortDescriptor(keyPath: \Book.title, ascending: true)
    ]) var books: FetchedResults<Book>
    
    // an state property to store Boolean status of AddBookView
    @State private var showingAddBookView = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(books, id:\.self) { book in
                    NavigationLink(destination: DetailView(book: book)) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(book.title ?? "Unknown title")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .foregroundColor(book.rating <= 1 ? .red : .primary)
                                Text(book.author ?? "Unknown author")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .trailing) {
                                Text((self.formatDate(by: book.date ?? Date())))
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .italic()
                                RatingView(rating: .constant(Int(book.rating)))
                                    .font(.subheadline)
                            }
                            
                        }
                    }
                }
                .onDelete(perform: deleteBooks)
            }
            .navigationBarTitle("Bookworm")
            .navigationBarItems(leading: EditButton(), trailing: Button(action: {
                self.showingAddBookView.toggle()
            }, label: {
                Image(systemName: "plus")
            }))
            .sheet(isPresented: $showingAddBookView, content: {
                AddBookView().environment(\.managedObjectContext, self.moc)
            })
        }
    }
    
    // function for deleting book row by swiping or edit button
    func deleteBooks(at offsets: IndexSet) {
        for offset in offsets {
            // find this book in our fetch result
            let book = books[offset]
            
            // delete specific book
            moc.delete(book)
        }
        
        // save to moc
        try? moc.save()
    }
    
    // function to format date
    func formatDate(by date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "y-MM-dd"
        return formatter.string(from: date)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
