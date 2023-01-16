
import SwiftUI
// Text modifier ->
struct CarText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(Material.regular)
            .cornerRadius(20)
            .font(.title3)
            .foregroundColor(.primary)
    }
}

// Photo modifier ->
struct CarPhoto: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(height: 300)
            .border(Material.bar)
            .cornerRadius(15)
            .scaledToFit()
    }
}

// Sheet button modifier ->
struct InfoButton: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color.teal.gradient)
            .cornerRadius(10)
            .foregroundColor(.white)
            .bold()
            .padding(.top, 30)
    }
}

// Photo carusel ->
func CarCarusel (image: [String]) -> some View{
    ZStack{
        TabView {
            ForEach(image, id: \.self) { item in
                 Image(item)
                    .resizable()
                    .modifier(CarPhoto())
            }
        }.frame(height: 300)
            .padding(.bottom, 40)
            .tabViewStyle(PageTabViewStyle())
    }
}

// Header view ->
func CarHeader (logo: String, text: String) -> some View{
    HStack(alignment:.center, spacing: 90){
        Image(logo).resizable()
            .frame(maxWidth: 50, maxHeight: 50)
        Text(text)
    }.padding(.horizontal, 20)
        .padding(.vertical, 10)
        .font(.headline)
}

// Footer car info ->
func CarInfo (name: String, year: Int, engine: String, power: Int, torque: Int) -> some View{
    VStack(alignment: .leading) {
        Text("Car name: \(name)")
        Text("Year: \(String(year))")
        Text("Engine: \(engine)")
        Text("Power: \(power) Hp")
        Text("Torque: \(torque) Nm")
    }.modifier(CarText())
}

// Info sheet modifier ->
func InfoView (text: String, photo: String) -> some View{
    VStack{
        Image(photo).resizable()
            .frame(maxWidth: 300, maxHeight: 200)
        Text(text)
            .bold()
            .padding()
            .background(Material.regular)
            .cornerRadius(10)
            .padding()
    }
}

// Picker raw values ->
enum SportCars : String, CaseIterable{
    case audi = "AUDI"
    case bmw = "BMW"
    case merc = "Mercedes"
}

// MAIN VIEW ->
struct CarsView: View {
    @State var isOn = false
    @State public var selectedCar : SportCars = .audi
    private let audi = ["RS6", "RS6.2", "RS6.3"]
    private let bmw = ["M5cs","M5cs.2","M5cs.3"]
    private let merc = ["E63s","E63s.2","E63s.3"]
    
    // Picker segment color ->
    init(){
        UISegmentedControl.appearance().selectedSegmentTintColor = .systemTeal
        }
    
    var body: some View {
        VStack{
            VStack(alignment: .center){
                Picker("", selection: $selectedCar) {
                    ForEach(SportCars.allCases, id: \.self) { car in
                        Text(car.rawValue)
                    }
                }.pickerStyle(SegmentedPickerStyle())
                    .padding()
                
              switch selectedCar {
                    
                case .audi :
                    CarHeader(logo: "audi.logo", text: "Quattro power !!")
                    CarCarusel(image: audi)
                    CarInfo(name: "RS6", year: 2021, engine: "4.0 TFSI", power: 600, torque: 800)
                    Button{
                        isOn.toggle()
                    } label: {
                        Text("More info").modifier(InfoButton())
                    }.sheet(isPresented: $isOn){
                        AudiInfo()
                    }
                        
                case .merc :
                    CarHeader(logo: "merc.logo", text: "AMG !!!")
                    CarCarusel(image: merc)
                    CarInfo(name: "E63s AMG", year: 2020, engine: "4.0 Biturbo", power: 603, torque: 627)
                    Button{
                        isOn.toggle()
                    } label: {
                        Text("More info").modifier(InfoButton())
                    }.sheet(isPresented: $isOn){
                        MercInfo()
                    }
                
                default:
                    CarHeader(logo: "bmw.logo", text: "I need more oil...")
                    CarCarusel(image: bmw)
                    CarInfo(name: "M5 CS", year: 2022, engine: "4.4 V8", power: 635, torque: 750)
                    Button{
                        isOn.toggle()
                    } label: {
                        Text("More info").modifier(InfoButton())
                    }.sheet(isPresented: $isOn){
                        BmwInfo()
                    }
                
                }
            }
        }
    }
}

// Audi sheet view ->
struct AudiInfo: View {
    var body: some View {
        InfoView(text: "The \"RS\" initials are taken from the German: RennSport – literally translated as \"racing sport\", and is Audi's ultimate \"top-tier\" high-performance trim level, positioned a noticeable step above the \"S\" model specification level of Audi's regular model range line-up. Like all Audi \"RS\" models, the RS 6 pioneers some of Audi's newest and most advanced engineering and technology, and so could be described as a halo vehicle, with the latest RS 6 Performance having the equal most powerful internal combustion engine out of all Audi models, with the same horsepower and torque as the physically larger Audi S8 Plus.",
                 photo: "RS6.png")
    }
}

// Mercedes sheet view ->
struct MercInfo: View {
    var body: some View {
        InfoView(text: "Mercedes-AMG continues to champion performance, dynamism and efficiency: the new Mercedes-Benz E63 AMG is now available as a particularly powerful S-Model with an output of 430 kW (585 hp), 800 Newton metres of torque and featuring a newly developed performance-oriented AMG 4MATIC all-wheel-drive system. The AMG 5.5-litre V8 biturbo engine continues to be the absolute pinnacle of efficiency: the combination of high performance and low fuel consumption remains unrivalled by any other competitor in the segment worldwide. The permanent all-wheel drive is also optionally available for the other Mercedes-Benz E63 AMG models - on which the V8 engine has been uprated from 386 kW (525 hp) to 410 kW (557 hp), with 720 Nm of torque.",
                 photo: "E63s.png")
    }
}

// BMW sheet view ->
struct BmwInfo: View {
    var body: some View {
        InfoView(text: "This is the first ever CS version of the M5, the car entered production in March 2021. Carbon fibre is used extensively on the M5 CS because it is both lightweight and strong. The brakes are 23 kg lighter than those on the BMW M5 Competition. In total, the carbon fibre parts contribute to a near 70 kg weight reduction over the BMW M5 Competition. Carbon Fibre Reinforced Plastic (CFRP) is used for the bonnet, the front splitter, exterior mirror caps, rear spoiler on the bootlid and the rear diffuser. Despite these improvements, the top speed remains the same at 305 km/h (190 mph), and it only comes in three colors (two of which are BMW Individual colors) Brands Hatch Grey Metallic, Frozen Brands Hatch Grey Metallic, and Frozen Deep Green Metallic.",
                 photo: "M5cs.png")
    }
}

struct CarsView_Previews: PreviewProvider {
    static var previews: some View {
        CarsView()
    }
}

