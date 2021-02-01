//
//  AddBookView.swift
//  Bookworm
//
//  Created by SuShenghung on 2021/2/1.
//

import SwiftUI

struct AddBookView: View {
    // inform current view that there's an enviornment property "moc"
    @Environment(\.managedObjectContext) var moc
    
    // an environment property to get current view's presentation status
    @Environment(\.presentationMode) var presentationMode
    
    // state properties to store user inputs
    @State private var title = ""
    @State private var author = ""
    @State private var rating = 3
    @State private var genre = ""
    @State private var review = ""
    
    let genres = ["Fantasy", "Horror", "Kids", "Mystery", "Poetry", "Romance", "Thriller"]
    
    // another state property to store showing confirmation of saving action
    @State private var showingConfirmationAlert = false
    
    // another state property to store showing check alert
    @State private var showingInputCheckAlert = false
    
    var body: some View {
        NavigationView {
            Form {
                // basic information of book
                Section {
                    TextField("Name of book", text: $title)
                    TextField("Author's name", text: $author)
                    
                    Picker("Genre", selection: $genre) {
                        ForEach(self.genres, id:\.self) {
                            Text($0)
                        }
                    }
                }
                
                // personal rating and review of book
                Section {
                    RatingView(rating: $rating)
                    
                    TextField("Write a review", text: $review)
                }
                
                // save button to show confirm alert, use disabled to do verify
                Section {
                    Button("Save") {
                        self.showingConfirmationAlert = true
                    }
                    .disabled(title.isEmpty || author.isEmpty || genre.isEmpty)
                }
            }
            .navigationBarTitle("Add Book")
            .navigationBarItems(trailing: Button("Close") {
                self.presentationMode.wrappedValue.dismiss()
            })
            .alert(isPresented: $showingConfirmationAlert) {
                Alert(title: Text("Save book"), message: Text("Are you sure?"), primaryButton: .destructive(Text("Confirm")) {
                        self.saveNewBook()
                        self.presentationMode.wrappedValue.dismiss()
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
    
    // function to save new book
    func saveNewBook() {
        let newBook = Book(context: moc)
        
        newBook.title = title
        newBook.author = author
        newBook.rating = Int16(rating)
        newBook.genre = genre
        newBook.review = review
        newBook.date = Date()
        
        // save new book
        try? moc.save()
    }
    
}

struct AddBookView_Previews: PreviewProvider {
    static var previews: some View {
        AddBookView()
    }
}
