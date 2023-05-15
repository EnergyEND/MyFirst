//
//  ActivitiesView.swift
//  MyFirst
//
//  Created by MAC on 26.01.2023.
//

import SwiftUI


struct Activity: Identifiable, Codable, Hashable {
    var id = UUID()
    var name = String()
    var info = String()
    var image = String()
    var count = 1
    var time = Date().formatted(date: .abbreviated, time: .shortened)
}

class ActivityList: ObservableObject {
    // Main array for activities:
    @Published var activities : [Activity] = []
    
    // URL creating:
    private static func getActivitiesFileURL() throws -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("activities.data")
    }
    
    // Add element to array:
    func add(_ act: Activity) {
            activities.append(act)
    }
    
    // Remove element from array:
    func delete(_ act: Activity) {
        activities.removeAll { $0.id == act.id}
    }
    
    // Load content from URL:
    func load() {
        do {
            let fileURL = try ActivityList.getActivitiesFileURL()
            let data = try Data(contentsOf: fileURL)
            activities = try JSONDecoder().decode([Activity].self, from: data)
            print("Activities has been loaded")
        } catch {
            print("Failed to load.")
        }
    }
    
    // Save content to URL:
    func save() {
        do {
            let fileURL = try ActivityList.getActivitiesFileURL()
            let data = try JSONEncoder().encode(activities)
            try data.write(to: fileURL, options: [.atomic, .completeFileProtection])
            print("Saved")
        } catch {
            print("Unable to save")
        }
    }
}

//MARK: Main view with activities
struct ActivitiesView: View {
    
    @ObservedObject private var list = ActivityList()
    @State private var showCreator = false
    @State private var newActivity = Activity()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("ActivitiesBack").ignoresSafeArea()
                
                VStack {
                    if !list.activities.isEmpty {
                        // If main array contains activity:
                        List{
                            ForEach($list.activities, id: \.self) { $act in
                                Section {
                                    NavigationLink(destination: ActivityInfoView(activity: $act)) {
                                        HStack(alignment: .center) {
                                            Text("\(act.name)").bold()
                                            Spacer()
                                            Text("TIMES:  \(act.count)").font(.footnote).foregroundColor(.secondary)
                                        }
                                    }
                                    // Editing menu:
                                    .contextMenu{
                                        Button {
                                            act.count += 1
                                            act.time = Date()
                                                .formatted(date: .abbreviated, time: .shortened)
                                        } label: {
                                            HStack {
                                                Text("Increase times")
                                                Image(systemName: "arrow.up")
                                            }
                                        }

                                        Button(role: .destructive) {
                                            withAnimation {
                                                list.delete(act)
                                            }
                                        } label: {
                                            HStack {
                                                Text("Delete activity")
                                                Image(systemName: "trash.fill")
                                            }
                                        }
                                    }
                                }.shadow(radius: 20)
                            }
                        }.scrollContentBackground(.hidden)
                            .padding(.top, 15)
                        // Footer message:
                        Text("Hold activity for editing")
                            .font(.footnote)
                            .bold()
                            .offset(y: 15)
                        
                    }else {
                        //If activities array is empty:
                        HStack {
                            Text("Add your first activity")
                            Image(systemName: "arrow.up.circle")
                        }.font(.title)
                        .shadow(radius: 15)
                        .padding()
                        .background(.regularMaterial)
                        .cornerRadius(10)
                        .onAppear {
                            list.load()
                        }
                    }
                    
                }.navigationTitle("My Activities")
                    .toolbar {
                        ToolbarItem {
                            HStack{
                                // Button for open activity creating sheet:
                                Button {
                                    showCreator.toggle()
                                } label: {
                                    Image(systemName: "plus").font(.title2)
                                        .padding(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20))
                                        .background()
                                        .cornerRadius(15)
                                        .foregroundColor(Color("questButton"))
                                }
                            }
                        }
                    }
            }.sheet(isPresented: $showCreator) {
                ActivityCreatingView(activityList: list)
            }
            // Auto save on change of activities array:
            .onChange(of: list.activities) { _ in
                list.save()
                print("Count: \(list.activities.count)")
            }
        }
    }
}

//MARK: View with activity info
struct ActivityInfoView: View {
    
    @Binding var activity : Activity
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("ActivitiesBack").ignoresSafeArea()
                // Main info block:
                VStack(alignment: .leading){
                    VStack(alignment: .leading){
                        Text("\(activity.name)   \(activity.image)")
                            .font(.largeTitle)
                            .bold()
                            .padding(EdgeInsets(top: 10, leading: 30, bottom: 1, trailing: 30))
                        
                        Rectangle().frame(width: 350, height: 6)
                            .foregroundColor(Color("ActivitiesBack"))
                            .padding(.bottom, 10)
                    }
                    
                    ScrollView {
                        Text("\(activity.info)")
                            .font(.subheadline)
                            .padding(.horizontal, 30)
                    }
                    
                }.frame(width: 350, height: 400)
                    .background()
                    .cornerRadius(15)
                    .offset(y: -150)
                // Second ifo block:
                VStack(alignment: .leading){
                    Text("Times:  \(activity.count)").padding(.bottom, 5)
                    Text("Last:   \(activity.time)")
                }.padding()
                    .frame(maxWidth: 350)
                    .background()
                    .cornerRadius(15)
                    .offset(y: 120)
                    .bold()
            }
        }
    }
}

//MARK: Activity creating sheet view
struct ActivityCreatingView: View {
    
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var activityList : ActivityList
    @FocusState private var isFocused : Bool
    @State private var newActivity = Activity()
    @State private var showAlert = false
    
    
    var body: some View {
        NavigationStack{
            VStack{
                List {
                    //Activity name:
                    Section("Name of activity") {
                        TextField("Write name here...", text: $newActivity.name)
                            .keyboardType(.alphabet)
                            .focused($isFocused)
                    }.listRowBackground(Color("ActivitiesBack")).foregroundColor(Color("questButton"))
                    
                    //Activity info:
                    Section("Short info") {
                        TextField("Write info here...", text: $newActivity.info, axis: .vertical)
                            .keyboardType(.alphabet)
                            .focused($isFocused)
                            .frame(height: 75)
                    }.listRowBackground(Color("ActivitiesBack")).foregroundColor(Color("questButton"))
                    
                    //Activity emoji:
                    Section("Select emoji") {
                        EmojiView(image: $newActivity.image)
                    }.listRowBackground(Color("ActivitiesBack")).foregroundColor(Color("questButton"))
                    
                    //Confirm button:
                    Button{
                        showAlert.toggle()
                    } label: {
                        Text("Confirm")
                            .padding(.leading, 120)
                            .padding(.vertical, 10)
                    }
                    .disabled(newActivity.name == "" || newActivity.info == "")
                    
                    .alert(Text("Success"), isPresented: $showAlert) {
                        Button("Cancel", role: .destructive) {}
                        Button("Save", role: .cancel) {
                            activityList.add(newActivity)
                            withAnimation {
                                dismiss.callAsFunction()
                            }
                        }
                    } message: {
                        Text("Activity created")
                    }
                    
                }
            }.navigationTitle("Create your activity")
        }
    }
}


//MARK: Custom emoji keyboard
struct EmojiView: View {
    
    @Binding var image: String
    @State private var grid = Array(repeating: GridItem(.fixed(70)), count: 4)
    
    // Get array with emoji:
    func getEmojiList() -> [[Int]] {
        
        var emojis : [[Int]] = []
        for i in stride(from: 0x1F601, to: 0x1F64F, by: 4){
            var temp : [Int] = []
            for j in i...i+3{
                temp.append(j)
            }
            emojis.append(temp)
        }
        return emojis
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: grid) {
                //Insert every emoji form array in grid:
                ForEach(getEmojiList(), id: \.self) { emoji in
                    ForEach(emoji, id: \.self) { j in
                        Button {
                            image = String(UnicodeScalar(j)!)
                        } label: {
                            if (UnicodeScalar(j)?.properties.isEmoji)!{
                                Text(String(UnicodeScalar(j)!)).font(.system(size: 50))
                                //Select mark for selected emoji:
                                    .overlay {
                                        if image == String(UnicodeScalar(j)!) {
                                            withAnimation {
                                                ZStack {
                                                    Circle()
                                                        .foregroundColor(.green)
                                                        .frame(width: 60, height: 60)
                                                    .opacity(0.4)
                                                    Image(systemName: "checkmark")
                                                        .scaleEffect(1.7)
                                                        .bold()
                                                }
                                            }
                                        }
                                    }
                            }
                        }
                    }
                }
            }
        }
        .frame(width: 350, height: 200)
        .cornerRadius(15)
    }
}



struct ActivitiesView_Previews: PreviewProvider {
    static var previews: some View {
        ActivitiesView()
    }
}
