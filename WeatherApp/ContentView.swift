//
//  ContentView.swift
//  WeatherApp
//
//  Created by Matheus Quirino on 12/12/21.
//

import SwiftUI

struct ContentView: View {
    
    @State private var dayTime: DayTime = .dawn
    
    let dayTimeColors: [DayTime: DayTimeColorSet] = [
        .dawn: DayTimeColorSet(primaryColor: .blue, secondaryColor: .yellow),
        .noon: DayTimeColorSet(primaryColor: .blue, secondaryColor: Color("lightBlue")),
        .dusk: DayTimeColorSet(primaryColor: .orange, secondaryColor: .brown),
        .night: DayTimeColorSet(primaryColor: .blue, secondaryColor: .black)
    ]
    
    var body: some View {
        ZStack{
            BackgroundView(colorSet: dayTimeColors[dayTime]!)
            VStack{
                CityNameView(cityName: "Uberaba, MG")
                MainWeatherView(imageName:
                                    dayTime == .dawn || dayTime == .noon
                                    ? "cloud.sun.fill"
                                    : "cloud.moon.fill",
                                temperature: 26)
                OtherWeatherView(days: [
                    WeatherInfo(day: "Tuesday", dayAbbreviation: "TUE", imageName: "cloud.sun.fill", temperature: 27),
                    WeatherInfo(day: "Tuesday", dayAbbreviation: "WED", imageName: "cloud.sun.bolt.fill", temperature: 25),
                    WeatherInfo(day: "Tuesday", dayAbbreviation: "THU", imageName: "wind", temperature: 25),
                    WeatherInfo(day: "Tuesday", dayAbbreviation: "FRI", imageName: "cloud.sun.rain.fill", temperature: 22),
                    WeatherInfo(day: "Tuesday", dayAbbreviation: "SAT", imageName: "cloud.rain.fill", temperature: 20)
                ]).padding()
                Spacer()
                WeatherButton(title: "Change Day Time"){
                    switch(dayTime){
                    case .dawn:
                        dayTime = .noon
                    case .noon:
                        dayTime = .dusk
                    case .dusk:
                        dayTime = .night
                    case .night:
                        dayTime = .dawn
                    }
                }.padding()
                    .padding(.bottom, 40)
            }
        }.onAppear{
            dayTime = getDayTime()
        }
    }
    
    func getDayTime() -> DayTime{
        let dayHour = Calendar.current.component(.hour, from: Date())
        if dayHour >= 19 || dayHour < 5 { return .night }
        if dayHour >= 5 && dayHour < 12 { return .dawn }
        if dayHour >= 12 && dayHour < 16 { return .noon }
        if dayHour >= 16 && dayHour < 19 { return .dusk }
        return .dawn
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

enum DayTime{
    case dawn
    case noon
    case dusk
    case night
}

struct DayTimeColorSet{
    var primaryColor: Color
    var secondaryColor: Color
}

struct WeatherInfo{
    var day: String
    var dayAbbreviation: String
    var imageName: String
    var temperature: Int
}

struct WeatherDayView: View {
    var dayOfWeek: String
    var imageName: String
    var temperature: Int
    var body: some View {
        VStack(spacing: 0){
            Text(dayOfWeek)
                .font(.system(size: 24, design: .rounded))
                .foregroundColor(.white)
            Image(systemName: imageName)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
                .padding(.bottom, 10)
            Text("\(temperature)°C")
                .font(.system(size: 22, design: .rounded))
                .foregroundColor(.white)
        }
    }
}

struct BackgroundView: View {
    var colorSet: DayTimeColorSet
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [
                                    colorSet.primaryColor,
                                    colorSet.secondaryColor
                                    ]),
                       startPoint: .topTrailing,
                       endPoint: .bottomLeading)
            .edgesIgnoringSafeArea(.all)
    }
}

struct CityNameView: View {
    var cityName: String
    var body: some View{
        Text(cityName)
            .font(.system(size: 32, design: .rounded))
            .foregroundColor(.white)
            .padding()
    }
}

struct MainWeatherView: View{
    var imageName: String
    var temperature: Int
    var body: some View{
        VStack(spacing: 10){
            Image(systemName: imageName)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 180, height: 180)
            Text("\(temperature)°C")
                .font(.system(size: 70, design: .rounded))
                .foregroundColor(.white)
                
        }.padding(.bottom, 40)
    }
}

struct OtherWeatherView : View{
    var days: [WeatherInfo]
    var body: some View{
        HStack(spacing: 20){
            ForEach(0..<days.count){ i in
                WeatherDayView(dayOfWeek: days[i].dayAbbreviation,
                               imageName: days[i].imageName,
                               temperature: days[i].temperature)
            }
        }
    }
}

struct WeatherButton: View{
    var title: String
    var bgColor: Color = .white
    var fgColor: Color = .blue
    var fontSize: CGFloat = 20
    var action: () -> Void = {}
    
    var body: some View{
        Button {
            action()
        } label: {
            Text(title)
                .frame(width: 280, height: 50)
                .background(bgColor)
                .font(.system(size: fontSize, weight: .bold, design: .rounded))
                .foregroundColor(fgColor)
                .cornerRadius(50)
        }
    }
}
