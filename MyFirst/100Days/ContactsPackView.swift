//
//  ContactsPackView.swift
//  MyFirst
//
//  Created by MAC on 15.02.2023.
//

import SwiftUI
import PhotosUI

//MARK: Contact model
struct Contact: Identifiable, Codable {
    
    var id : UUID
    var name: String
    var image: Data
    
    enum CodingKeys: CodingKey {
        case id, name, image
    }
    
    init(id: UUID, name: String, image: UIImage) {
        self.id = id
        self.name = name
        self.image = image.pngData()!
    }
    
    // Custom decoder & encoder for Codable
    init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            id = try values.decode(UUID.self, forKey: .id)
            name = try values.decode(String.self, forKey: .name)
            image = try values.decode(Data.self, forKey: .image)
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(id, forKey: .id)
            try container.encode(name, forKey: .name)
            try container.encode(image, forKey: .image)
        }
}


class ContactList: ObservableObject {
    @Published var contacts = [Contact]()
    
    // Creating JSON of contacts in Doc directory
    func save() {
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(contacts)
            // Creating path
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            // File name
            let fileURL = documentDirectory.appendingPathComponent("contacts.json")
            // Creating new file
            try jsonData.write(to: fileURL)
            print("Save successed")
        } catch {
            print("Error saving contacts: \(error)")
        }
    }
    
    // Read JSON from Doc directory
    func load() {
        let jsonDecoder = JSONDecoder()
        do {
            // Reading path
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            // File name
            let fileURL = documentDirectory.appendingPathComponent("contacts.json")
            let jsonData = try Data(contentsOf: fileURL)
            // Data fetching
            let contacts = try jsonDecoder.decode([Contact].self, from: jsonData)
            // Save fetched data to array
            self.contacts = contacts
            print("Load successed")
        } catch {
            print("Error fetching contacts: \(error)")
        }
    }

}


//MARK: Main view
struct ContactsPackView: View {
    
    @State private var image: Image?
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @ObservedObject private var list = ContactList()
    @State private var isEditing = false
    @State private var showNameSheet = false
    @State private var tempName = String()
    
    // Add new element to array
    func loadImage() {
        guard let inputImage = inputImage else { return }
        list.contacts.insert(Contact(id: UUID(), name: tempName, image: inputImage), at: 0)
    }
    
    var body: some View {
        NavigationStack {
            ZStack{
                Color("ContactsBack").ignoresSafeArea()
                VStack{
                    // When array is empty:
                    if list.contacts.isEmpty {
                        VStack {
                            HStack {
                                Text("Import photo")
                                Image(systemName: "arrow.turn.right.down").bold()
                            }.font(.title)
                                
                            Button {
                                showingImagePicker.toggle()
                            } label: {
                                HStack {
                                    Text("Import ")
                                    Image(systemName: "square.and.arrow.down")
                                }
                                .font(.title)
                                .foregroundColor(Color("questButton"))
                                .padding()
                                .tint(.yellow)
                                .background(.thickMaterial)
                                .cornerRadius(10)
                            }
                            
                            Button("LOAD") {
                                list.load()
                            }
                        }.onAppear {
                            list.load()
                        }

                    }else {
                        // When array conteins data
                        ScrollView {
                            VStack(spacing: 20) {
                                ForEach($list.contacts, id: \.id) { $contact in
                                    Section {
                                        ContactCard(contact: $contact)
                                        // Custom removing button
                                            .overlay {
                                                if isEditing {
                                                    Button {
                                                        withAnimation {
                                                            list.contacts.removeAll { $0.id == $contact.id}
                                                            list.save()
                                                        }
                                                    } label: {
                                                        Image(systemName: "trash.fill")
                                                            .padding(10)
                                                            .background(.red)
                                                            .cornerRadius(20)
                                                            .foregroundColor(Color("questButton"))
                                                    }.offset(x: 145, y: -115)
                                                }
                                            }
                                    }
                                }
                                
                            }.padding(.top, 10)
                            // Toolbar buttons
                            .toolbar {
                                ToolbarItem {
                                    Button {
                                        isEditing.toggle()
                                    } label: {
                                        isEditing ? Text("Done") : Text("Edit")
                                    }.padding(3)
                                        .background(.thickMaterial)
                                        .cornerRadius(10)

                                }
                                ToolbarItem {
                                    Button {
                                        showingImagePicker.toggle()
                                    } label: {
                                        Image(systemName: "plus.circle")
                                            .padding(3)
                                            .background(.thickMaterial)
                                            .cornerRadius(20)
                                    }
                                }
                            }
                        }
                    }
                }
                // Photo picker sheet
                .sheet(isPresented: $showingImagePicker) {
                    ImagePicker(image: $inputImage)
                }
                .sheet(isPresented: $showNameSheet) {
                    VStack {
                        Text("Contact creating").bold()
                        Image(uiImage: inputImage!)
                            .resizable()
                            .frame(width: 350, height: 250)
                            .scaledToFill()
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color("ContactsBack"), lineWidth: 3)
                            )
                            .padding(.bottom, 5)
                        
                        TextField("White contact name here...", text: $tempName)
                            .padding(5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color("ContactsBack"), lineWidth: 3)
                            )
                        
                        Button(action: {
                            withAnimation {
                                loadImage()
                                list.save()
                                showNameSheet.toggle()
                                tempName = String()
                            }
                        }, label: {
                            Text("Save")
                                .foregroundColor(Color("questButton"))
                                .bold()
                                .padding(EdgeInsets(top: 10, leading: 50, bottom: 10, trailing: 50))
                                .background(.thinMaterial)
                                .cornerRadius(10)
                        }).padding(.top, 10)
                        
                            .presentationDetents([.height(400)])
                            .edgesIgnoringSafeArea(.all)
                    }.frame(maxWidth: 350)
                }
            }
            // Open name creating sheet when user choose the image
            .onChange(of: inputImage) { _ in
                showNameSheet.toggle()
            }
        }
    }
}

//MARK: Contact card view
struct ContactCard: View {
    
    @Binding var contact: Contact
    
    var body: some View {
        ZStack {
            VStack(alignment: .center) {
                // From Data to Image
                if let uiImage = UIImage(data: contact.image) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .frame(width: 350, height: 250)
                        .scaledToFit()
                }
                
                Text(contact.name)
                    .bold()
                    .italic()
            }
            .padding(.bottom, 10)
            .background()
            .cornerRadius(15)
        }
    }
}



//MARK: Photo picker struct
struct ImagePicker: UIViewControllerRepresentable {
    
    @Binding var image: UIImage?

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)

            guard let provider = results.first?.itemProvider else { return }

            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { image, _ in
                    self.parent.image = image as? UIImage
                }
            }
        }
    }
}

struct ContactsPackView_Previews: PreviewProvider {
    static var previews: some View {
        ContactsPackView()
    }
}
