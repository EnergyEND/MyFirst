//
//  UserCreate.swift
//  MyFirst
//
//  Created by MAC on 21.09.2022.
//

import SwiftUI

//MARK: - User model
struct User : Identifiable, Codable, Hashable {
    var id = UUID()
    var name = String()
    var age = String()
    var pet = String()
    
    init(id: UUID = UUID(), name: String = String(), age: String = String(), pet: String = String()) {
        self.id = id
        self.name = name
        self.age = age
        self.pet = pet
    }
}

//MARK: - User creating view
struct AddUserView: View {
    
    @State var isPress = false
    @FocusState private var isFocused : Bool
    @State private var newUser = User()
    @ObservedObject var content : UserList
    
    var body: some View {
        VStack{
            List{
                HStack{
                    Image(systemName: "highlighter")
                    Text("Tell something about yourself")
                    
                }.listRowBackground(Color.mint).foregroundColor(.white)
                Section{
                    TextField("Your name", text: $newUser.name)
                        .focused($isFocused)
                        .disableAutocorrection(true)
                        .textInputAutocapitalization(.words)
                }
                Section{
                    TextField("Your age", text: $newUser.age)
                        .keyboardType(.numberPad)
                        .focused($isFocused)
                }
                Section{
                    TextField("Your pet", text: $newUser.pet)
                        .focused($isFocused)
                        .textInputAutocapitalization(.words)
                }
            }
            .toolbar{
                ToolbarItem{
                    Button("Add user"){
                        content.add(newUser)
                        isPress = true
                        isFocused = false
                        print("New user login")
                    }
                    .disabled(newUser.name.isEmpty)
                    .buttonStyle(.bordered)
                    .tint(.mint)
                    .alert("Successful add!", isPresented: $isPress) {
                        Button("OK", role: .cancel) {}
                    }
                }
            }
        }
    }
}



//MARK: - All users class
class UserList : ObservableObject  {
    @Published var users: [User] = [
        User(name: "Admin", age: "20", pet: "Labrador ")
    ]
    
    func add(_ user: User) {
            users.append(user)
    }
    
    func delete(_ user: User) {
        users.removeAll { $0.id == user.id}
    }
    
    private static func getUsersFileURL() throws -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("user.data")
    }
    
    func load() {
        do {
            let fileURL = try UserList.getUsersFileURL()
            let data = try Data(contentsOf: fileURL)
            users = try JSONDecoder().decode([User].self, from: data)
            print("Users loaded: \(users.count)")
        } catch {
            print("Failed to load from file. Backup data used")
        }
    }
    
    func save() {
        do {
            let fileURL = try UserList.getUsersFileURL()
            let data = try JSONEncoder().encode(users)
            try data.write(to: fileURL, options: [.atomic, .completeFileProtection])
            print("Changes saved")
        } catch {
            print("Unable to save")
        }
    }
    
}


//MARK: - Users list view
struct Users: View {
    
    @ObservedObject var content : UserList
    @State private var selection : User?
    @State private var isHold = false
    
    private var longPress: some Gesture {
        LongPressGesture()
            .onEnded { value in
                isHold.toggle()
            }
    }
    
    var body: some View {
        NavigationStack {
            List(selection: $selection) {
                ForEach(content.users, id: \.self) { user in
                    Section{
                        HStack{
                            Image(systemName: "person.fill")
                            Text("User ID:").font(.headline)
                            Spacer()
                            Text("\(user.id)").font(.custom("userID", size: 10))
                        }.listRowBackground(Color.mint)
                        .foregroundColor(.white)
                        HStack(spacing: 5){
                            VStack {
                                Text("Name: ")
                                Text("Age: ")
                                Text("Pet: ")
                            }.foregroundStyle(.secondary)
                            VStack (alignment: .leading){
                                Text(user.name)
                                Text(user.age)
                                Text(user.pet)
                            }
                        }
                    }
                    
                }.onDelete { indexSet in
                    content.users.remove(atOffsets: indexSet)
                }
            }.toolbar {
                EditButton()
                    .buttonStyle(.bordered)
                    .tint(.mint)
                    .disabled(content.users.count < 2)
            }
        }
        }
}
