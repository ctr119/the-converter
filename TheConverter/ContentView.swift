import SwiftUI

struct ContentView: View {
    @State private var inputTemperature: Double? = nil
    @FocusState private var isTemperatureFocused: Bool
    
    @State private var selectedTemperature: TemperatureUnit = .celsius
    private enum TemperatureUnit: String, CaseIterable {
        case celsius
        case farenheit
        case kelvin
        
        func getConversionFunction(to targetUnit: TemperatureUnit) -> ((Double) -> (Double)) {
            switch (self, targetUnit) {
            case (.celsius, .farenheit):
                return { (input: Double) -> Double in
                    return (input * 9 / 5) + 32
                }
                
            case (.celsius, .kelvin):
                return { (input: Double) -> Double in
                    return input + 273.15
                }
                
            case (.farenheit, .celsius):
                return { (input: Double) -> Double in
                    return (input - 32) * 5 / 9
                }
                
            case (.farenheit, .kelvin):
                return { (input: Double) -> Double in
                    return (input - 32) * 5 / 9 + 273.15
                }
                
            case (.kelvin, .celsius):
                return { (input: Double) -> Double in
                    return input - 273.15
                }
                
            case (.kelvin, .farenheit):
                return { (input: Double) -> Double in
                    return (input - 273.15) * 9 / 5 + 32
                }
                
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
        
        let f = selectedTemperature.getConversionFunction(to: unit)
        return f(inputTemperature)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
