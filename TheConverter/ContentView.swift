import SwiftUI

struct ContentView: View {
    /// If you want to improve this app and add other units rather than Temperature,
    /// visit this link to choose another one between the list:
    /// https://www.hackingwithswift.com/100/swiftui/19
    
    @State private var inputTemperature: Double? = nil
    @FocusState private var isTemperatureFocused: Bool
    
    @State private var selectedTemperature: TemperatureUnit = .celsius
    private enum TemperatureUnit: String, CaseIterable {
        case celsius
        case farenheit
        case kelvin
        
        func getFormula(to targetUnit: TemperatureUnit) -> ((Double) -> (Double)) {
            switch (self, targetUnit) {
            case (.celsius, .farenheit):
                return farenheit(fromCelsius:)
                
            case (.celsius, .kelvin):
                return kelvin(fromCelsius:)
                
            case (.farenheit, .celsius):
                return celsius(fromFarenheit:)
                
            case (.farenheit, .kelvin):
                return kelvin(fromFarenheit:)
                
            case (.kelvin, .celsius):
                return celsius(fromKelvin:)
                
            case (.kelvin, .farenheit):
                return farenheit(fromKelvin:)
                
            default:
                return { (input: Double) -> Double in
                    return input
                }
            }
        }
    }
    
    var body: some View {
        NavigationStack  {
            Form {
                Section("Input") {
                    VStack(alignment: .leading, spacing: 16) {
                        TextField("Enter the value you want", value: $inputTemperature, format: .number)
                            .keyboardType(.decimalPad)
                            .focused($isTemperatureFocused)
                        
                        Picker("Select the input unit", selection: $selectedTemperature) {
                            ForEach(TemperatureUnit.allCases, id: \.self) {
                                Text($0.rawValue.capitalized)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                }
                
                Section("Output") {
                    makeOutput(for: .celsius)
                    makeOutput(for: .farenheit)
                    makeOutput(for: .kelvin)
                }
            }
            .navigationTitle("The Converter")
            .toolbar {
                if isTemperatureFocused {
                    Button("Done") {
                        isTemperatureFocused = false
                    }
                }
            }
        }
    }
    
    private func makeOutput(for unit: TemperatureUnit) -> some View {
        HStack {
            Text("\(unit.rawValue.capitalized):")
            Text(calculateOutput(for: unit), format: .number)
        }
    }
    
    private func calculateOutput(for unit: TemperatureUnit) -> Double {
        guard let inputTemperature else { return 0 }
        
        let f = selectedTemperature.getFormula(to: unit)
        return f(inputTemperature)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
