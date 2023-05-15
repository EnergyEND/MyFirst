
//  UsersDBView.swift
//  MyFirst
//
//  Created by MAC on 03.02.2023.
//
// https://www.hackingwithswift.com/samples/friendface.json

import SwiftUI

// Human model:
struct Human: Codable {
    let id: String
    var name: String
    let age: Int
    let company: String
    let email: String
    let registered: Date
    let friends: [Friend]
}

// Friend model:
struct Friend: Codable {
    let id: String
    let name: String
}

//MARK: Main user list view
struct UsersDBView: View {
    // Array with data from JSON:
    @State private var results = [Human]()
    // URL with JSON:
    let url = "https://www.hackingwithswift.com/samples/friendface.json"
    @State private var searchText = String()
    
    var filteredList : [Human] {
        if searchText.isEmpty {
            return results
        }else {
            return results.filter{$0.name.localizedCaseInsensitiveContains(searchText)}
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("listBack").ignoresSafeArea()
                    if results.isEmpty {
                        // If array is empty fetching data from JSON:
                        ProgressView()
                            .onAppear{
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    loadData(fromURL: url)
                                }
                            }
                    }else {
                        // If array contains some data:
                        List {
                            ForEach(filteredList, id: \.id) { user in
                                NavigationLink {
                                    UserDetailView(user: user)
                                } label: {
                                    UserCard(user: user)
                                }
                            }.onDelete { indexSet in
                                results.remove(atOffsets: indexSet)
                            }
                        }
                        .scrollContentBackground(.hidden)
                    }
                
            }.navigationTitle(results.isEmpty ? "Fetching JSON..." : "JSON List")
                .searchable(text: $searchText, prompt: "Search for user")
            
            //Edit button
            .toolbar {
                ToolbarItem {
                    EditButton()
                        .padding(EdgeInsets(top: 3, leading: 10, bottom: 3, trailing: 10))
                        .background(.thickMaterial)
                        .cornerRadius(10)
                }
                ToolbarItem {
                    Button {
                        results.removeAll()
                    } label: {
                        Image(systemName: "arrow.clockwise.circle")
                            .padding(EdgeInsets(top: 3, leading: 10, bottom: 3, trailing: 10))
                            .background(.thickMaterial)
                            .cornerRadius(10)
                    }

                }
            }
        }
    }
    
    // Getting data from JSON URL
    func loadData(fromURL url:String) {
        // Checking URL
            guard let url = URL(string: url) else {
                print("Invalid URL")
                return
            }
            let request = URLRequest(url: url)
        // Decoding JSON
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                
                // Saving data to array
                if let decodedResponse = try? decoder.decode([Human].self, from: data) {
                    DispatchQueue.main.async {
                        self.results = decodedResponse
                    }
                    return
                }
            }
            print("Fetch failed...)")
        }.resume()
    }
}


struct UserCard: View {
    var user: Human?
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(user!.name)
                .font(.title2)
            Text(user!.id)
                .font(.subheadline)
        }
    }
}






//MARK: User detail view
struct UserDetailView: View {
    
    var user : Human
    @State private var grids = Array(repeating: GridItem(.fixed(150)), count: 2)
    
    var body: some View {
        NavigationStack{
            ZStack {
                Color("listBack").ignoresSafeArea()
                VStack {
                    
                    // User info block
                    VStack{
                        Text("\(user.name),  \(user.age)")
                            .font(.system(size: 25))
                        
                        Rectangle()
                            .frame(width: 320, height: 3)
                            .foregroundColor(Color("listBack"))
                            .shadow(radius: 10)
                        
                        VStack(alignment: .leading, spacing: 10){
                            HStack(spacing: 20) {
                                Text("Work place:").bold()
                                Text(user.company)
                            }
                            HStack(spacing: 20) {
                                Text("E-mail:").bold()
                                Text(user.email)
                            }
                            HStack(spacing: 20) {
                                Text("Registered:").bold()
                                Text("\(user.registered.formatted(date: .abbreviated, time: .shortened))")
                            }
                            HStack(spacing: 10) {
                                Text("UID:").bold()
                                Text(user.id).font(.footnote)
                            }
                        }
                    }
                    .padding()
                    .background(.thickMaterial)
                    .cornerRadius(10)
                    .padding(.bottom, 30)
                    
                    // Frinds info block
                    VStack {
                        Text(user.friends.count > 1 ? "Friends" : "Friend").font(.system(size: 25))
                        Rectangle()
                            .frame(width: 320, height: 3)
                            .foregroundColor(Color("listBack"))
                            .padding(.bottom, 5)
                            .shadow(radius: 10)
                        
                        LazyVGrid(columns: grids) {
                            ForEach(user.friends, id: \.id) { friend in
                                Text(friend.name)
                                    .frame(width: 150)
                                    .font(.callout)
                                    .bold()
                                    .padding(.bottom, 5)
                            }
                        }.frame(maxWidth: 350)
                    }
                    .padding(.vertical, 20)
                    .background(.thickMaterial)
                    .cornerRadius(10)
                    
                    Spacer()
                }
            }
        }
    }
}


struct UsersDBView_Previews: PreviewProvider {
    static var previews: some View {
        UsersDBView()
    }
}
