import Foundation

fileprivate let farenheitFraction = 1.8 // 9/5
fileprivate let farenheitCte = 32.0
fileprivate let kelvinCte = 273.15

func farenheit(fromCelsius celsiusInput: Double) -> Double {
    farenheitFraction * celsiusInput + farenheitCte
}

func celsius(fromFarenheit farenheitInput: Double) -> Double {
    (farenheitInput - farenheitCte) / farenheitFraction
}

func celsius(fromKelvin kelvinInput: Double) -> Double {
    kelvinInput - kelvinCte
}

func farenheit(fromKelvin kelvinInput: Double) -> Double {
    farenheit(fromCelsius: celsius(fromKelvin: kelvinInput))
}

func kelvin(fromCelsius celsiusInput: Double) -> Double {
    celsiusInput + kelvinCte
}

func kelvin(fromFarenheit farenheitInput: Double) -> Double {
    kelvin(fromCelsius: celsius(fromFarenheit: farenheitInput))
}
