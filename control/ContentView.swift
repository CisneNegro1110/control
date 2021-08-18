//
//  ContentView.swift
//  control
//
//  Created by Jesús Francisco Leyva Juárez on 24/03/21.
//

import SwiftUI
import SwiftUIX
import Firebase
import FirebaseDatabase

struct ContentView: View {
    
    @AppStorage("log_Status") var status = false
    @StateObject var model = ModelDataLogin()
    @State var index = 0
    
    var body: some View {
        
        if status{
            
            homePage(index: self.$index)
            
        }
        else{
            LoginView(model: model)
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    @State static var index = 0
    
    static var previews: some View {
        
        LoginView(model: .init())
        
        SingUpView(model: .init())
        
        homePage(index: $index)
        
        
        horaDeActivar()
        
        tiempoActivo()
        
        
        
        diasXActivar()
        
    
        
         // tiempoSlider()
        
    }
}

struct LoginView : View {
    
    @ObservedObject var model : ModelDataLogin
    
    var body: some View{
        
        ZStack{
            
            Color.offWhite
                .edgesIgnoringSafeArea(.all)
            
            VStack{
                
                Image("marca1")
                    .resizable()
                    .scaledToFit()
                    .padding(.horizontal)
                    .padding(.vertical,20)
                    //  .modifier(TopModifier())
                    .padding(.horizontal)
                
                VStack(spacing: 20){
                    CustomTextField(image: "person", placeHolder: "Email", txt: $model.email)
                        .foregroundColor(Color.black.opacity(0.7))
                        //.foregroundColor(.gray)
                    CustomTextField(image: "lock", placeHolder: "Password", txt: $model.password)
                        .foregroundColor(Color.black.opacity(0.7))
                       // .foregroundColor(.gray)
                }
                
                .padding(.top)
                
                Button(action: model.login) {
                    Text("Login")
                        .foregroundColor(Color.black.opacity(0.7))
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width - 150)
                    
                }
                .buttonStyle(ButtonModifier())
                .padding(.top,22)
                
                HStack(spacing: 12){
                    Text("Don´t have an account?")
                        .foregroundColor(Color.gray.opacity(0.7))
                    Button(action: {model.isSingUp.toggle()}) {
                        Text("Sing Up Now")
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                    }
                    
                }
                .padding(.top,25)
                Spacer(minLength: 0)
                
                Button(action: model.resetPassword) {
                    Text("Foreget Password?")
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                }
                .padding(.vertical,22)
                
            }
            
            if model.isLoading{
                
                LoadingView()
                
            }
        }
        .fullScreenCover(isPresented: $model.isSingUp) {
            SingUpView(model: model)
        }
        .alert(isPresented: $model.alert, content: {
            Alert(title: Text("Message"), message: Text(model.alertMsg), dismissButton: .destructive(Text("Ok")))
        })
    }
}

struct CustomTextField : View {
    var image : String
    var placeHolder : String
    @Binding var txt : String
    
    var body: some View{
        
        ZStack(alignment: Alignment(horizontal: .leading, vertical: .center)) {
            HStack{
                Image(systemName: image)
                    .foregroundColor(.gray)
                
                ZStack{
                    if placeHolder == "Password" || placeHolder == "Re-Enter"{
                        SecureField(placeHolder, text: $txt)
                            
                           
                    }else{
                        TextField(placeHolder, text: $txt)
                           
                       // Color.offWhite
                            
                    }
                    
                }
                
            }
            
        }
        .modifier(TFModifier())
        .padding(.horizontal)
        
    }
    
}

struct SingUpView: View {
    
    @ObservedObject var model: ModelDataLogin
    
    var body: some View {
        
        ZStack(alignment: Alignment(horizontal: .trailing, vertical: .top), content: {
            Color.offWhite
                .edgesIgnoringSafeArea(.all)
            
            VStack{
                
                Spacer(minLength: 0)
                Image("marca1")
                    .resizable()
                    .scaledToFit()
                    .padding(.horizontal)
                    .padding(.vertical,20)
                    //   .modifier(TopModifier())
                    .padding(.horizontal)
                
                VStack(spacing : 4){
                    HStack(spacing : 0){
                        Text("New")
                            .font(.system(size: 35, weight: .heavy))
                            .foregroundColor(.blue)
                        Text("Profile")
                            .font(.system(size: 35, weight: .heavy))
                            .foregroundColor(.blue)
                    }
                    Text("Create a profile for you !!")
                        .foregroundColor(Color.black.opacity(0.3))
                        .fontWeight(.heavy)
                }
                .padding(.top)
                
                VStack(spacing: 20){
                    CustomTextField(image: "person", placeHolder: "Email", txt: $model.email_SingUp)
                    CustomTextField(image: "lock", placeHolder: "Password", txt: $model.password_SingUp)
                    CustomTextField(image: "lock", placeHolder: "Re-Enter", txt: $model.reEnterPassword)
                }
                .padding(.top)
                
                Button(action: model.singUp) {
                    Text("SingUp")
                        
                        .foregroundColor(Color.black.opacity(0.7))
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width - 150)
                    
                }
                .buttonStyle(ButtonModifier())
                .padding(.vertical,22)
                
                Spacer(minLength: 0)
            }
            
            Button (action: {model.isSingUp.toggle()}){
                Image(systemName: "xmark")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black.opacity(0.6))
                    .clipShape(Circle())
            }
            .padding(.trailing)
            .padding(.top,10)
            
            if model.isLoading{
                
                LoadingView()
            }
        })
        
        .alert(isPresented: $model.alert, content: {
            Alert(title: Text("Message"), message: Text(model.alertMsg), dismissButton: .destructive(Text("Ok"), action: {
                
                if model.alertMsg == "Email Verification Has Been Sent !!! Verify Your Email ID !!!" {
                    
                    model.isSingUp.toggle()
                    model.email_SingUp = ""
                    model.password_SingUp = ""
                    model.reEnterPassword = ""
                }
                
                
            }))
        })
    }
}

struct LoadingView : View {
    
    @State var animation = false
    
    var body: some View{
        
        VStack{
            Circle()
                .trim(from: 0, to: 0.7)
                .stroke(Color.blue)
                .frame(width: 75, height: 75)
                .rotationEffect(.init(degrees: animation ? 360 : 0))
                .padding(50)
        }
        .background(Color.white)
        .cornerRadius(20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.4).ignoresSafeArea(.all, edges: .all))
        .onAppear(perform: {
            
            withAnimation(Animation.linear(duration: 1)){
                animation.toggle()
            }
        })
    }
}



struct homePage: View {
    
    @AppStorage("log_Status") var status = false
    
    //DATOS DE FIREBASE
    
    @AppStorage("DOM") var DOM = false
    @AppStorage("LUN") var LUN = false
    @AppStorage("MAR") var MAR = false
    @AppStorage("MIE") var MIE = false
    @AppStorage("JUE") var JUE = false
    @AppStorage("VIE") var VIE = false
    @AppStorage("SAB") var SAB = false
    //DATOS DEL RELOJ DE FIREBASE A LA APP
    @AppStorage("hours1") var hours1 = 0
    @AppStorage("minutes1") var minutes1 = 0
    @AppStorage("hoursOut1") var hoursOut1 = 0
    @AppStorage("minutesOut1") var minutesOut1 = 0
    @AppStorage("minutosDeRiego") var minutosDeRiego = 10.0
    
    @State private var isToggled = false
    @Binding var index : Int
    
    @State var refresh = Refresh(started: false, released: false)
    var ref = Database.database().reference()
    
    @StateObject var dateModel = ModelDataLogin()
    @StateObject var dayD = varToFirebase()
    
    var width = UIScreen.main.bounds.width
    @State var curreant_Time = analogClock(MIN: 0, SEC: 0, HOUR: 0)
    @State var receiver = Timer.publish(every: 1, on: .current, in: .default).autoconnect()
    
    @State var alertLogOut = false
    var alert: Alert {
        Alert(
            title:Text("Cerrar Sesión"),
            message: Text("¿Seguro que quieres cerrar sesión?"),
            primaryButton: .default(Text("Salir"), action: self.dateModel.logOut),
            secondaryButton: .cancel()
        )
    }
    
    var body: some View{
        
        ZStack{
            
            Color.offWhite
                .edgesIgnoringSafeArea(.all)
            
            Spacer()
            VStack{
                ScrollView(.vertical, showsIndicators: false, content:{
                    GeometryReader { reader -> AnyView in
                        DispatchQueue.main.async {
                            if refresh.startOffset == 0{
                                refresh.startOffset = reader.frame(in: .global).minY
                            }
                            refresh.offset = reader.frame(in: .global).minY
                            if refresh.offset - refresh.startOffset > 80 && !refresh.started{
                                refresh.started = true
                            }
                            if refresh.startOffset == refresh.offset && refresh.started && !refresh.released{
                                updateData()
                            }
                        }
                        return AnyView(Color.black.frame(width: 0, height: 0))
                    }
                    .frame(width: 0, height: 0)
                    
                    ZStack(alignment: Alignment(horizontal: .center, vertical: .top)) {
                        if refresh.started && refresh.released {
                            ProgressView()
                                .offset(y: -34)
                        }
                        else {
                            Image(systemName: "arrow.down")
                                .font(.system(size: 16, weight: .heavy))
                                .foregroundColor(.gray)
                                .rotationEffect(.init(degrees: refresh.started ? 180 : 0))
                                .offset(y: -34)
                                .animation(.easeIn)
                        }
                    }
                    /*
                     
                     VStack{
                     Text("Control de Riego")
                     .offset(y: -42)
                     .font(.title)
                     .font(.system(size: 19, weight: .semibold, design: .rounded))
                     .foregroundColor(Color("FontColor"))
                     
                     }
                     
                     */
                    
                    VStack(alignment: .center){
                        HStack(alignment: .center ){
                            
                            Button("Salir"){
                                self.alertLogOut.toggle()
                                
                            }.padding(.horizontal)
                            Spacer()
                            Text("Control de Riego")
                                .offset(x: -32.5)
                                // .font(.largeTitle)
                                .font(.system(size: 31, weight: .semibold, design: .rounded))
                                
                                .foregroundColor(Color("font"))
                            // .padding(.vertical)
                            //Buttom
                            Spacer()
                        }
                        //.frame(height: UIScreen.main.bounds.height -1)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        
                        HStack(alignment: .center, spacing:20 ){
                            
                            Button(action:  {
                                withAnimation {
                                self.index = 0
                                }
                            }) {
                                ZStack{
                                    Rectangle()
                                        .fill(Color("ColorPrimary"))
                                        .frame(width: 60, height: 60)
                                        .cornerRadius(20)
                                    
                                    Image(systemName: "house")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 21, height: 21)
                                    
                                }
                                
                            }
                            .foregroundColor(Color.white)
                            
                            
                            Button(action:  {
                                withAnimation {
                                self.index = 1
                                }
                            }) {
                                Image(systemName: "clock")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 21, height: 21)
                                
                            }.buttonStyle(SimpleButtonStyle())
                            .foregroundColor(Color("font"))
                            
                            Button(action:  {
                                withAnimation {
                                self.index = 2
                                }
                            }) {
                                Image(systemName: "drop")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 21, height: 21)
                                
                            }.buttonStyle(SimpleButtonStyle())
                            .foregroundColor(Color("font"))
                            
                            Button(action:  {
                                withAnimation {
                                self.index = 3
                                }
                            }) {
                                
                                Image(systemName: "calendar")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 21, height: 21)
                                
                            } .buttonStyle(SimpleButtonStyle())
                            .foregroundColor(Color("font"))
                            
                        }//.padding(.all)
                        .padding(.top, 27)
                        
                       Spacer(minLength: 13)
                          //  .frame(maxWidth: .infinity, maxHeight: .infinity)
                        
                        ZStack{
                            Circle()
                                .fill(Color.offWhite)
                                .shadow(color: Color.black.opacity(0.2), radius: 7, x: 10, y: 10)
                                .shadow(color: Color.white.opacity(0.7), radius: 12, x: -5, y: -5)
                            // Second And Minutes
                            ForEach(0..<60, id: \.self) {i in
                                Rectangle()
                                    .fill(Color.black)
                                    .frame(width:2, height: (i % 5) == 0 ? 15 : 5)
                                    .offset(y: (width - 170) / 2)
                                    .rotationEffect(.init(degrees: Double(i) * 6))
                            }
                            // Sec...
                            Rectangle()
                                .fill(Color.red)
                                .frame(width: 2, height: (width - 180 ) / 2)
                                .offset(y: -(width - 200) / 4)
                                .rotationEffect(.init(degrees: Double(curreant_Time.SEC) * 6))
                            
                            // Min...
                            Rectangle()
                                .fill(Color.black)
                                .frame(width: 4, height: (width - 200 ) / 2)
                                .offset(y: -(width - 220) / 4)
                                .rotationEffect(.init(degrees: Double(curreant_Time.MIN) * 6))
                            
                            // Hou...
                            Rectangle()
                                .fill(Color.black)
                                .frame(width: 4.5, height: (width - 240 ) / 2)
                                .offset(y: -(width - 260) / 4)
                                .rotationEffect(.init(degrees: Double(curreant_Time.HOUR) * 30))
                            
                            Circle()
                                .fill(Color.black)
                                .frame(width: 15, height: 15)
                        }
                        .frame(width: width - 140, height: width - 140)
                        .padding(.all)
                        // Spacer(minLength: 0)
                    }
                    //  .frame(height: UIScreen.main.bounds.height + 20)
                    // Spacer(minLength: 10)
                    .onAppear(perform: {
                        let calendar = Calendar.current
                        let MIN = calendar.component(.minute, from: Date())
                        let SEC = calendar.component(.second, from: Date())
                        let HOUR = calendar.component(.hour, from: Date())
                        withAnimation(Animation.linear(duration: 0.01)){
                            self.curreant_Time = analogClock(MIN: MIN, SEC: SEC, HOUR: HOUR)
                        }
                    })
                    .onReceive(receiver) { (_) in
                        let calendar = Calendar.current
                        let MIN = calendar.component(.minute, from: Date())
                        let SEC = calendar.component(.second, from: Date())
                        let HOUR = calendar.component(.hour, from: Date())
                        withAnimation(Animation.linear(duration: 0.01)){
                            self.curreant_Time = analogClock(MIN: MIN, SEC: SEC, HOUR: HOUR)
                        }
                    }
                    
                    
                    
                    VStack(alignment: .center, spacing: 7){
                        
                        Text("Hora de Riego :")
                            .font(.system(size: 18))
                        
                        
                        
                        Text(String(format: "%01d:%02d", hours1, minutes1))
                            .font(.title)
                            .fontWeight(.semibold)
                        
                        Text("Activar :")
                            .font(.system(size: 18))
                        // .font(.subheadline)
                        
                        
                        Text("\(Int (minutosDeRiego) ) Minutos")
                            // Text("\(TiempoDeRiego) Minutos")
                            // Text(String(format: "%01d:%02d", hoursOut1, minutesOut1))
                            //Text(String(format: "%01d:%02d", hoursOut1, minutesOut1))
                            .font(.title)
                            .fontWeight(.semibold)
                        //    }
                        
                        // Spacer()
                        
                        Text("Repetir:")
                        HStack{
                            Image(systemName: DOM ? "d.circle" : "d.circle")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .foregroundColor(DOM ? Color("ColorPrimary") : Color("font").opacity(0.4))
                            
                            Image(systemName: LUN ? "l.circle" : "l.circle")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .foregroundColor(LUN ? Color("ColorPrimary") : Color("font").opacity(0.4))
                            
                            Image(systemName: MAR ? "m.circle" : "m.circle")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .foregroundColor(MAR ? Color("ColorPrimary") : Color("font").opacity(0.4))
                            
                            Image(systemName: MIE ? "m.circle" : "m.circle")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .foregroundColor(MIE ? Color("ColorPrimary") : Color("font").opacity(0.4))
                            
                            Image(systemName: JUE ? "j.circle" : "j.circle")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .foregroundColor(JUE ? Color("ColorPrimary") : Color("font").opacity(0.4))
                            
                            Image(systemName: VIE ? "v.circle" : "v.circle")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .foregroundColor(VIE ? Color("ColorPrimary") : Color("font").opacity(0.4))
                            
                            Image(systemName: SAB ? "s.circle" : "s.circle")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .foregroundColor(SAB ? Color("ColorPrimary") : Color("font").opacity(0.4))
                            
                        }
                        .padding(.horizontal)
                        
                    }
                    //.frame(height: UIScreen.main.bounds.height)
                    //.padding(.bottom, 50)
                    .padding(.top)
                    
                    .ignoresSafeArea()
                    .foregroundColor(Color("font"))
                    .offset(y: refresh.released ? 40 : -10)
                })
                .alert(isPresented: $alertLogOut, content: { self.alert } )
                //  .padding(.top, 20)
               // .frame(height: UIScreen.main.bounds.height)
                
            }
            .frame(height: UIScreen.main.bounds.height)
            if self.index == 1 {
                withAnimation {
                horaDeActivar()
                }
            } else if self.index == 2 {
                withAnimation {
                tiempoActivo()
                }
            } else if self.index == 3 {
                withAnimation {
                diasXActivar()
                }
            }
            
        }
        
        
        
    }
    
    func  updateData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation(Animation.linear){
                dayD.obtenerValores()
                refresh.released = false
                refresh.started = false
            }
        }
    }
}

struct horaDeActivar: View {
    
    @State var index = 1
    @AppStorage("hours") var hours = 0
    @AppStorage("minutes") var minutes = 0
    @State var alertIsPresented: Bool = false
    
    @StateObject var dayD = varToFirebase()
    
    var body: some View {
        
        ZStack{
            Color.offWhite
                //  Color("ColorBg1")
                .edgesIgnoringSafeArea(.all)
            
            VStack{
                VStack{
                    Text("Control de Riego")
                        .offset(y: 17)
                        // .font(.title)
                        .font(.system(size: 31, weight: .semibold, design: .rounded))
                        .foregroundColor(Color("font"))
                    
                    HStack(alignment: .center, spacing:20 ){
                        
                        Button(action:  {
                            withAnimation {
                            self.index = 0
                            }
                            
                        }) {
                            Image(systemName: "house")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 21, height: 21)
                            
                        }
                        .buttonStyle(SimpleButtonStyle())
                        .foregroundColor(Color("font"))
                        //.background(Color)
                        
                        //.foregroundColor(.blue)
                        
                        //.foregroundColor(.white)
                        // .accentColor(.white)
                        Button(action:  {
                            withAnimation {
                            self.index = 1
                            }
                        }) {
                            ZStack{
                                Rectangle()
                                    .fill(Color("ColorPrimary"))
                                    .frame(width: 60, height: 60)
                                    .cornerRadius(20)
                                
                                Image(systemName: "clock")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 21, height: 21)
                                
                            }
                            
                            
                        }
                        .foregroundColor(Color.white)
                        
                        Button(action:  {
                            withAnimation {
                            self.index = 2
                            }
                        }) {
                            Image(systemName: "drop")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 21, height: 21)
                            // .foregroundColor(.primary)
                            //  .foregroundColor(.white)
                        }.buttonStyle(SimpleButtonStyle())
                        .foregroundColor(Color("font"))
                        
                        
                        Button(action:  {
                            withAnimation {
                            self.index = 3
                            }
                        }) {
                            
                            //.foregroundColor(.blue)
                            Image(systemName: "calendar")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 21, height: 21)
                            //.foregroundColor(.primary)
                            //  .foregroundColor(.white)
                        } .buttonStyle(SimpleButtonStyle())
                        .foregroundColor(Color("font"))
                        
                        
                        
                    }
                    
                    //  Spacer(minLength: 10)
                    
                    //.padding(.all)
                    .padding(.vertical, 44)
                    // Spacer()
                    // .frame(maxWidth: .infinity, maxHeight: .infinity)
                    //Spacer()
                }//.frame(width: UIScreen.main.bounds.width)
                //.frame(maxWidth: .infinity, maxHeight: .infinity)
               
                Spacer()
                VStack(alignment: .center, spacing: 25){
                    
                    
                    HStack{
                        Image(systemName: "clock")
                            .font(.system(size: 22, weight: .semibold, design: .rounded))
                            .foregroundColor(Color("font"))
                        Text("Hora de Inicio")
                           // .fontWeight(.semibold)
                         //   .font(.custom("Poppins", size: 20))
                            
                           .font(.system(size: 22, weight: .semibold, design: .rounded))
                            
                            .foregroundColor(Color("font"))
                            .font(.headline)
                        // .padding(.vertical, 10)
                    }
                    
                    HStack(alignment: .center, spacing: 25){
                        
                        ZStack {
                            
                            RoundedRectangle(cornerRadius: 25)
                                .fill(Color.offWhite)
                                .frame(width: 80, height: 220)
                                .shadow(color: Color.black.opacity(0.2), radius: 6, x: 10, y: 10)
                                .shadow(color: Color.white.opacity(0.5), radius: 6, x: -8, y: -8)
                            //  .shadow(color: Color(.black).opacity(0.14), radius: 20, x: 0, y: 20 )
                            
                            
                            //   HStack {
                            
                            Picker("", selection: $hours){
                                ForEach(0..<24, id: \.self) { i in
                                    Text("\(i) ").tag(i)
                                        .font(.custom("Poppins", size: 20))
                                        .foregroundColor(Color("font"))
                                }
                            }
                            
                            
                            .labelsHidden()
                            // RoundedRectangle(cornerRadius: 25)
                            // .fixedSize()
                            // .backgroundColor(Color("font"))
                            .frame(width: 70)
                            //  .fill(Color.offWhite)
                            // .cornerRadius(20)
                            // .clipped()
                            .clipShape(Capsule())
                            
                            // .cornerRadius(20)
                        }
                        
                        Text(":")
                            .font(.custom("Poppins", size: 20))
                            .foregroundColor(Color("font"))
                        ZStack{
                            RoundedRectangle(cornerRadius: 25)
                                .fill(Color.offWhite)
                                .frame(width: 80, height: 220)
                                .shadow(color: Color.black.opacity(0.2), radius: 6, x: 10, y: 10)
                                .shadow(color: Color.white.opacity(0.5), radius: 6, x: -8, y: -8)
                            
                            Picker("", selection: $minutes){
                                ForEach(0..<60, id: \.self) { b in
                                    Text(String(format: "%02d", b)).tag(b)
                                        // Text("\(b) ").tag(b)
                                        .font(.custom("Poppins", size: 20))
                                        .foregroundColor(Color("font"))
                                }
                            } //.pickerStyle(WheelPickerStyle())
                            .labelsHidden()
                            .frame(width: 70)
                            
                            .clipped()
                        }
                    }
                    //   }
                    .alert(isPresented: $alertIsPresented, content: {
                        Alert(title: Text("Datos Guardados"), message: Text("La hora de inicio ha sido guardada correctamente"), dismissButton: .default(Text("Ok")))
                    })
                    
                }
                .padding(.bottom, 35)
                Spacer()
                VStack{
                    //  ZStack{
                    /*
                     RoundedRectangle(cornerRadius: 15)
                     .stroke(lineWidth: 2.0)
                     .fill(Color("ColorPrimary"))
                     .frame(width: 200, height: 55)
                     */
                    
                    Button(action: {
                        self.dayD.guardarHora()
                        self.alertIsPresented = true
                        
                    }) {
                        Text("Cambiar Hora")
                            // .foregroundColor(Color.black.opacity(0.7))
                            .padding(.vertical)
                            .frame(width: UIScreen.main.bounds.width - 200)
                        
                    }
                    .buttonStyle(ButtonModifier())
                    .foregroundColor(Color("ColorPrimary"))
                    
                    
                    // }
                    
                }
                
                .padding(.bottom, 35)
                
            }
            
            .padding(.top, 20)
            .frame(height: UIScreen.main.bounds.height)
            
            if self.index == 0 {
                withAnimation {
                homePage(index: self.$index)
                }
            } else if self.index == 2 {
                withAnimation {
                tiempoActivo()
                }
            } else if self.index == 3 {
                withAnimation {
                diasXActivar()
                }
                
            }
            
            
        }
        
    }
}

struct tiempoActivo: View {
    
    @State var index = 2
    @AppStorage("TiempoDeRiego") var TiempoDeRiego = 10.0
    @State var isEditingSlider: Bool = false
    @State var isPressButton: Bool = false
    
    @State var alertIsPresented: Bool = false
    @StateObject var dayD = varToFirebase()
    
    var body: some View {
        
        ZStack{
            Color.offWhite
                //  Color("ColorBg1")
                .edgesIgnoringSafeArea(.all)
            VStack{
                VStack{
                    Text("Control de Riego")
                        .offset(y: 17)
                        // .font(.title)
                        .font(.system(size: 31, weight: .semibold, design: .rounded))
                        .foregroundColor(Color("font"))
                    
                    HStack(alignment: .center, spacing:20 ){
                        
                        
                        //   ActionButton(image: "calendar", isSelectedButton:
                        //              $iconButton.calendar, animation: animation)
                        
                        
                        
                        Button(action:  {
                            withAnimation {
                            self.index = 0
                            }
                            
                        }) {
                            Image(systemName: "house")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 21, height: 21)
                            
                        }
                        .buttonStyle(SimpleButtonStyle())
                        .foregroundColor(Color("font"))
                        //.background(Color)
                        
                        //.foregroundColor(.blue)
                        
                        //.foregroundColor(.white)
                        // .accentColor(.white)
                        Button(action:  {
                            withAnimation {
                            self.index = 1
                            }
                            
                            // FormNewData()
                        }) {
                            
                            Image(systemName: "clock")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 21, height: 21)
                            //   .foregroundColor(.primary)
                            //.foregroundColor(.blue)
                            
                            //  .foregroundColor(.white)
                        }.buttonStyle(SimpleButtonStyle())
                        .foregroundColor(Color("font"))
                        
                        
                        
                        Button(action:  {
                            withAnimation {
                            self.index = 2
                            }
                        }) {
                            ZStack{
                                Rectangle()
                                    .fill( Color("ColorPrimary"))
                                    .frame(width: 60, height: 60)
                                    .cornerRadius(20)
                                
                                Image(systemName: "drop")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 21, height: 21)
                                
                            }
                            
                        }
                        .foregroundColor(Color.white)
                        
                        Button(action:  {
                            withAnimation {
                            self.index = 3
                            }
                        }) {
                            
                            
                            //.foregroundColor(.blue)
                            Image(systemName: "calendar")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 21, height: 21)
                            //.foregroundColor(.primary)
                            //  .foregroundColor(.white)
                        }
                        .buttonStyle(SimpleButtonStyle())
                        .foregroundColor(Color("font"))
                        
                        
                        
                    }
                    //.padding(.all)
                    .padding(.vertical, 44)
                    // Spacer(minLength: 0)
                    // .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    //  Spacer()
                    
                }
                
                
                Spacer()
                VStack(alignment: .center, spacing: 37){
                    
                    
                    HStack{
                        Image(systemName: "timer")
                            .font(.system(size: 22, weight: .semibold, design: .rounded))
                            .foregroundColor(Color("font"))
                        Text("Tiempo Activo")
                            .font(.system(size: 22, weight: .semibold, design: .rounded))
                            .foregroundColor(Color("font"))
                            .font(.headline)
                        //  .padding()
                        
                    }
                    
                    
                    VStack(spacing: 9){
                        ZStack {
                            
                            Capsule()
                                .fill(Color.offWhite)
                                //  .fill(Color.white.opacity(0.40))
                                .frame(width: 383, height: 59)
                                // .shadow(color: Color(.black).opacity(0.14), radius: 20, x: 0, y: 20 )
                                .shadow(color: Color.black.opacity(0.2), radius: 6, x: 10, y: 10)
                                .shadow(color: Color.white.opacity(0.5), radius: 6, x: -8, y: -8)
                            // .padding(.horizontal)
                            
                            HStack(alignment: .center){
                                
                                // Spacer()
                                
                                Text("10 min")
                                    .foregroundColor(Color("font"))
                                    .padding(.leading, 20)
                                
                                
                                Slider(value: $TiempoDeRiego, in: 10...150, step: 1.0, onEditingChanged: { (editing) in
                                        isEditingSlider = editing})
                                //   .padding()
                                Text("150 min")
                                    .foregroundColor(Color("font"))
                                    .padding(.trailing, 20)
                            }
                            
                        }
                        
                        Text("\(Int (TiempoDeRiego ) ) Minutos")
                            .foregroundColor(isEditingSlider ? .green : Color("font"))
                        // .foregroundColor(Color("FontColor"))
                        
                        
                    }
                    // .padding(.top, -1)
                    // }
                    .alert(isPresented: $alertIsPresented, content: {
                        Alert(title: Text("Datos Guardados"),
                              message: Text("El tiempo activo ha sido guardado correctamente"),
                              dismissButton: .default(Text("Ok")))
                    })
                    //  Spacer()
                }
                .padding(.bottom, 35)
                Spacer()
                VStack{
                    
                    
                    Button(action:  {
                        self.dayD.guardarDesactivarHora()
                        self.alertIsPresented = true
                        
                    }) {
                        
                        Text("Cambiar Tiempo")
                            .padding(.vertical)
                            .frame(width: UIScreen.main.bounds.width - 200)
                    }
                    .buttonStyle(ButtonModifier())
                    .foregroundColor(Color("ColorPrimary"))
                    
                    
                }
                .padding(.bottom, 35)
                
            }
            .padding(.top, 20)
            .frame(height: UIScreen.main.bounds.height)
            
            if self.index == 0 {
                withAnimation {
                homePage(index: self.$index)
                }
            } else if self.index == 1 {
                withAnimation {
                horaDeActivar()
                }
            } else if self.index == 3 {
                withAnimation {
                diasXActivar()
                }
                
                
            }
            
            
            
        }
        
        
    }
    
}

struct diasXActivar: View {
    
    @State var index = 3
    
    @AppStorage("lun") var lun = false
    @AppStorage("dom") var dom = false
    @AppStorage("mar") var mar = false
    @AppStorage("mie") var mie = false
    @AppStorage("jue") var jue = false
    @AppStorage("vie") var vie = false
    @AppStorage("sab") var sab = false
    
    @State var alertIsPresented: Bool = false
    @StateObject var dayD = varToFirebase()
    
    var body: some View {
        ZStack{
            Color.offWhite
                //  Color("ColorBg1")
                .edgesIgnoringSafeArea(.all)
            
            VStack{
                VStack{
                    
                    Text("Control de Riego")
                        .offset(y: 17)
                        //  .font(.title)
                        .font(.system(size: 31, weight: .semibold, design: .rounded))
                        .foregroundColor(Color("font"))
                    
                    HStack(alignment: .center, spacing:20 ){
                        
                        Button(action:  {
                            withAnimation {
                            self.index = 0
                            }
                            
                        }) {
                            Image(systemName: "house")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 21, height: 21)
                            
                        }
                        .buttonStyle(SimpleButtonStyle())
                        .foregroundColor(Color("font"))
                        //.background(Color)
                        
                        //.foregroundColor(.blue)
                        
                        //.foregroundColor(.white)
                        // .accentColor(.white)
                        Button(action:  {
                            withAnimation {
                            self.index = 1
                            }
                            
                            // FormNewData()
                        }) {
                            
                            Image(systemName: "clock")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 21, height: 21)
                            //   .foregroundColor(.primary)
                            //.foregroundColor(.blue)
                            
                            //  .foregroundColor(.white)
                        }.buttonStyle(SimpleButtonStyle())
                        .foregroundColor(Color("font"))
                        
                        
                        Button(action:  {
                            withAnimation {
                            self.index = 2
                            }
                        }) {
                            
                            Image(systemName: "drop")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 21, height: 21)
                            // .foregroundColor(.primary)
                            
                            //  .foregroundColor(.white)
                        }.buttonStyle(SimpleButtonStyle())
                        .foregroundColor(Color("font"))
                        
                        
                        Button(action:  {
                            withAnimation {
                            self.index = 3
                            }
                        }) {
                            
                            ZStack{
                                Rectangle()
                                    .fill(Color("ColorPrimary"))
                                    .frame(width: 60, height: 60)
                                    .cornerRadius(20)
                                
                                Image(systemName: "calendar")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 21, height: 21)
                                
                            }
                            
                        }
                        .foregroundColor(Color.white)
                        
                        
                        
                        
                        
                    }
                    // .padding(.all)
                    .padding(.vertical, 44)
                    // Spacer(minLength: 0)
                    //   .frame(maxWidth: .infinity, maxHeight: .infinity)
                    // Spacer()
                }
                Spacer()
                
                VStack(alignment: .center, spacing: 25){
                    
                    
                    HStack{
                        Image(systemName: "calendar")
                            .font(.system(size: 22, weight: .semibold, design: .rounded))
                            .foregroundColor(Color("font"))
                        Text("Días a Activar")
                            .font(.system(size: 22, weight: .semibold, design: .rounded))
                            .foregroundColor(Color("font"))
                            .font(.headline)
                        //  .padding()
                        
                        
                    }
                    
                    
                    
                    ZStack{
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.offWhite)
                            // .fill(Color.white.opacity(0.40))
                            // .frame(width: 355, height: 315)
                            .frame(width: 355, height: 305)
                            // .frame(height: UIScreen.main.bounds.height)
                            //  .shadow(color: Color(.black).opacity(0.14), radius: 20, x: 0, y: 20 )
                            .shadow(color: Color.black.opacity(0.2), radius: 6, x: 10, y: 10)
                            .shadow(color: Color.white.opacity(0.5), radius: 6, x: -8, y: -8)
                        
                        VStack{
                            //   List{
                            
                            Toggle(isOn: $dom) {
                                Text("Domingo")
                                    .font(.system(size: 18))
                                    //.font(.custom("Poppins", size: 17))
                                    .padding(.leading, 20)
                            } //.toggleStyle(CheckmarkToggleStyle())
                            .padding(.trailing, 20)
                            
                            Toggle(isOn: $lun) {
                                Text("Lunes")
                                    // .font(.custom("Poppins", size: 17))
                                    .font(.system(size: 18))
                                    .padding(.leading, 20)
                            }//.toggleStyle(CheckmarkToggleStyle())
                            .padding(.trailing, 20)
                            
                            Toggle(isOn: $mar) {
                                Text("Martes")
                                    .font(.system(size: 18))
                                    // .font(.custom("Poppins", size: 17))
                                    .padding(.leading, 20)
                            }//.toggleStyle(CheckmarkToggleStyle())
                            .padding(.trailing, 20)
                            
                            Toggle(isOn: $mie) {
                                Text("Miércoles")
                                    .font(.system(size: 18))
                                    // .font(.custom("Poppins", size: 17))
                                    .padding(.leading, 20)
                            }//.toggleStyle(CheckmarkToggleStyle())
                            .padding(.trailing, 20)
                            
                            Toggle(isOn: $jue) {
                                Text("Jueves")
                                    .font(.system(size: 18))
                                    //.font(.custom("Poppins", size: 17))
                                    .padding(.leading, 20)
                            }//.toggleStyle(CheckmarkToggleStyle())
                            .padding(.trailing, 20)
                            
                            Toggle(isOn: $vie) {
                                Text("Viernes")
                                    .font(.system(size: 18))
                                    //  .font(.custom("Poppins", size: 17))
                                    .padding(.leading, 20)
                            }//.toggleStyle(CheckmarkToggleStyle())
                            .padding(.trailing, 20)
                            
                            Toggle(isOn: $sab) {
                                Text("Sábado")
                                    .font(.system(size: 18))
                                    // .font(.custom("Poppins", size: 17))
                                    .padding(.leading, 20)
                            }//.toggleStyle(CheckmarkToggleStyle())
                            .padding(.trailing, 20)
                            
                            //  }.frame(width: 348, height: 305)
                            //  .foregroundColor(Color.offWhite)
                            
                        }//.frame(width: 348, height: 305)
                        .padding(.all)
                        .foregroundColor(Color("font"))
                        
                    }
                    
                    
                    // }
                    .alert(isPresented: $alertIsPresented, content: {
                        Alert(title: Text("Datos Guardados"),
                              message: Text("Los días a activar han sido guardados correctamente"),
                              dismissButton: .default(Text("Ok")))
                    })
                    // Spacer()
                }//.padding(.top,20)
                .padding(.bottom, 35)
                Spacer()
                VStack{
                    
                    
                    Button(action:  {
                        self.dayD.guardarDias()
                        self.alertIsPresented = true
                        
                    }) {
                        
                        Text("Cambiar Días")
                            .padding(.vertical)
                            .frame(width: UIScreen.main.bounds.width - 200)
                    }
                    .buttonStyle(ButtonModifier())
                    .foregroundColor(Color("ColorPrimary"))
                    
                    
                }
                .padding(.bottom, 35)
                
            }
            .padding(.top, 20)
            .frame(height: UIScreen.main.bounds.height)
            
            if self.index == 0 {
                withAnimation {
                homePage(index: self.$index)
                }
            } else if self.index == 1 {
                withAnimation {
                horaDeActivar()
                }
            } else if self.index == 2 {
                withAnimation {
                tiempoActivo()
                }
                
            }
        }
        
    }
}

struct analogClock {
    
    var MIN : Int
    var SEC : Int
    var HOUR : Int
}

/*
struct tiempoSlider: View {
    @State var index = 2
    @State var maxHeight: CGFloat = UIScreen.main.bounds.height / 3
    
    @State var alertIsPresented: Bool = false
    @StateObject var dayD = varToFirebase()
    //Slider Properties...
    // @AppStorage("TiempoDeRiego") var TiempoDeRiego = 10.0
    //   @AppStorage("sliderProgress") var sliderProgress = 0.0
    // @AppStorage("Progress") var Progress ; let sliderPtogress
    //@Binding var sliderProgress: CGFloat
    
    @AppStorage("tiempoDeRiego") var tiempoDeRiego = 0.0
  
    
    
    // @State var ss = UserDefaults.standard.defaults.setFloat(CGFloat(.sliderProgress), forKey: "ss")
    
    @State var sliderProgress: CGFloat = 0
    @State var sliderHeight: CGFloat = 0
    @State var lastDragValue: CGFloat = 0
    
    var body: some View {
        
        ZStack{
            Color.offWhite
                .ignoresSafeArea()
            
            VStack{
                Text("Control de Riego")
                    .font(.title)
                    .font(.system(size: 19, weight: .semibold, design: .rounded))
                    .foregroundColor(Color("font"))
                
                HStack(alignment: .center, spacing:20 ){
                    
                    
                    //   ActionButton(image: "calendar", isSelectedButton:
                    //              $iconButton.calendar, animation: animation)
                    
                    
                    
                    Button(action:  {
                        self.index = 0
                        
                    }) {
                        Image(systemName: "house")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 21, height: 21)
                        
                    }
                    .buttonStyle(SimpleButtonStyle())
                    .foregroundColor(Color("font"))
                    //.background(Color)
                    
                    //.foregroundColor(.blue)
                    
                    //.foregroundColor(.white)
                    // .accentColor(.white)
                    Button(action:  {
                        self.index = 1
                        
                        // FormNewData()
                    }) {
                        
                        Image(systemName: "clock")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 21, height: 21)
                        //   .foregroundColor(.primary)
                        //.foregroundColor(.blue)
                        
                        //  .foregroundColor(.white)
                    }.buttonStyle(SimpleButtonStyle())
                    .foregroundColor(Color("font"))
                    
                    
                    
                    Button(action:  {
                        self.index = 2
                    }) {
                        ZStack{
                            Rectangle()
                                .fill( Color("ColorPrimary"))
                                .frame(width: 60, height: 60)
                                .cornerRadius(20)
                            
                            Image(systemName: "drop")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 21, height: 21)
                            
                        }
                        
                    }
                    .foregroundColor(Color.white)
                    
                    Button(action:  {
                        self.index = 3
                    }) {
                        
                        
                        //.foregroundColor(.blue)
                        Image(systemName: "calendar")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 21, height: 21)
                        //.foregroundColor(.primary)
                        //  .foregroundColor(.white)
                    } .buttonStyle(SimpleButtonStyle())
                    .foregroundColor(Color("font"))
                    
                    
                    
                }.padding(.all)
                .padding(.vertical, 36.5)
                Spacer(minLength: 0)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                
            }
            
            VStack(spacing: 37){
                HStack{
                    Image(systemName: "timer")
                        .font(.system(size: 22, weight: .semibold, design: .rounded))
                        .foregroundColor(Color("font"))
                    Text("Tiempo Activo")
                        .font(.system(size: 22, weight: .semibold, design: .rounded))
                        .foregroundColor(Color("font"))
                        .font(.headline)
                    //  .padding()
                    
                }
                
                ZStack(alignment: .bottom, content: {
                    
                    Rectangle()
                        .fill(Color("ColorPrimary").opacity(0.15))
                    Rectangle()
                        .fill(Color("ColorPrimary"))
                        .frame(height: sliderHeight)
                })
                .frame(width: 105, height: maxHeight)
                .cornerRadius(35)
                .overlay(
                    Text("\(Int(sliderProgress * 180)) min")
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 18)
                        .background(Color.white)
                        .cornerRadius(10)
                        .padding(.vertical, 30)
                        .offset(y: sliderHeight < maxHeight - 105.0 ? -sliderHeight : -maxHeight + 105.0)
                    
                    ,alignment: .bottom
                )
                .gesture(DragGesture(minimumDistance: 0).onChanged({(value)in
                    
                    let translation = value.translation
                    sliderHeight = -translation.height + lastDragValue
                    
                    sliderHeight = sliderHeight > maxHeight ? maxHeight : sliderHeight
                    
                    sliderHeight = sliderHeight >= 0 ? sliderHeight : 0
                    
                    let progress = sliderHeight / maxHeight
                    
                    sliderProgress = progress <= 1.0 ? progress : 1
                    
                    // UserDefaults.standard.set(self.sliderProgress, forKey: "Progress")
                    
                }).onEnded({(value) in
                    
                    sliderHeight = sliderHeight > maxHeight ? maxHeight : sliderHeight
                    
                    sliderHeight = sliderHeight >= 0 ? sliderHeight : 0
                    
                    lastDragValue = sliderHeight
                    
                    let progress = sliderHeight / maxHeight
                    
                    sliderProgress = progress <= 1.0 ? sliderProgress : 1
                    
                    
                    
                }))
                .alert(isPresented: $alertIsPresented, content: {
                    Alert(title: Text("Datos Guardados"), message: Text("El tiempo activo ha sido guardado correctamente"), dismissButton: .default(Text("Ok")))
                })
                
             
            }
            VStack{
                ZStack{
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(lineWidth: 2.0)
                        .fill(Color("ColorPrimary"))
                        .frame(width: 200, height: 55)
                    
                    Button(action:  {
                        self.dayD.guardarDesactivarHora()
                        self.alertIsPresented = true
                        
                       // self.slider1 = Double(sliderProgress)
                        //  self.tiempoDeRiego = sliderProgress
                        UserDefaults.standard.set(self.sliderProgress, forKey: "Progress")
                        
                        
                    }) {
                        
                        Text("Cambiar Tiempo")
                    }
                }
            }.padding(.top, 700)
            
            if self.index == 0 {
                homePage(index: self.$index)
            } else if self.index == 1 {
                horaDeActivar()
            } else if self.index == 3 {
                diasXActivar()
                
                
            }
            
        }
        
    }
    
}
 
*/
struct CheckmarkToggleStyle: ToggleStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        
        HStack {
            configuration.label
            Spacer()
            Rectangle()
                .foregroundColor(configuration.isOn ? .green : .secondary)
                .frame(width: 51, height: 31, alignment: .center)
                .opacity(1.8)
                .overlay(
                    Circle()
                        .foregroundColor(.white)
                        .padding(.all, 3)
                        .overlay(
                            Image(systemName: configuration.isOn ? "checkmark" : "xmark")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .font(Font.title.weight(.black))
                                .frame(width: 8, height: 8, alignment: .center)
                                .opacity(1.8)
                                .foregroundColor(configuration.isOn ? .green : .secondary)
                        )
                        
                        .offset(x: configuration.isOn ? 11 : -11, y: 0)
                        .animation(Animation.linear(duration: 0.1))
                    
                ).cornerRadius(20)
                .onTapGesture { configuration.isOn.toggle() }
            
        }
        .padding(.vertical, 3)
        .padding(.horizontal)
    }
    
    
}

struct Refresh {
    var startOffset : CGFloat = 0
    var offset : CGFloat = 0
    var started : Bool
    var released : Bool
}

class ModelDataLogin : ObservableObject {
    
    var ref = Database.database().reference()
    
    @Published var email = ""
    @Published var password = ""
    @Published var isSingUp = false
    @Published var email_SingUp = ""
    @Published var password_SingUp = ""
    @Published var reEnterPassword = ""
    @Published var isLinkSend = false
    
    
    // AlertView With TextFields....
    //Error Alerts...
    @Published var alert = false
    @Published var alertMsg = ""
    //User Status
    @AppStorage("log_Status") var status = false
    @Published var isLoading = false
    //Datos del reloj
    
    func resetPassword() {
        
        let alert = UIAlertController(title: "Reset Password", message: "Enter Your E-mail ID To Reset Your Password", preferredStyle: .alert)
        
        alert.addTextField{(password) in
            password.placeholder = "Email"
            
        }
        let proceed = UIAlertAction(title: "Reset", style: .default) { (_) in
            
            if alert.textFields![0].text! != "" {
                
                withAnimation{
                    
                    self.isLoading.toggle()
                }
                
                Auth.auth().sendPasswordReset(withEmail: alert.textFields![0].text!) { (err) in
                    withAnimation{
                        
                        self.isLoading.toggle()
                    }
                    
                    if err != nil {
                        self.alertMsg = err!.localizedDescription
                        self.alert.toggle()
                        return
                    }
                    
                    self.alertMsg = "Password Reset Link Has Been Sent !!!"
                    self.alert.toggle()
                }
            }
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        alert.addAction(cancel)
        alert.addAction(proceed)
        
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true)
    }
    
    func login() {
        
        if email == "" || password == ""{
            self.alertMsg = "Fill the contents properly !!!"
            self.alert.toggle()
            
            return
        }
        
        withAnimation{
            self.isLoading.toggle()
        }
        
        Auth.auth().signIn(withEmail: email, password: password){ (result, err) in
            
            withAnimation{
                self.isLoading.toggle()
            }
            
            if err != nil {
                self.alertMsg = err!.localizedDescription
                self.alert.toggle()
                return
            }
            
            let  user = Auth.auth().currentUser
            
            if !user!.isEmailVerified{
                self.alertMsg = "Please Verify Email Address !!!"
                self.alert.toggle()
                
                try! Auth.auth().signOut()
                return
            }
            
            withAnimation{
                
                self.status = true
                
                
            }
            
        }
        
    }
    
    func singUp() {
        
        if email_SingUp == "" || password_SingUp == "" || reEnterPassword == "" {
            
            self.alertMsg = "Fill contents proprely !!!"
            self.alert.toggle()
            return
        }
        if password_SingUp != reEnterPassword {
            
            self.alertMsg = "Password Mismatch !!!"
            self.alert.toggle()
            return
        }
        withAnimation{
            
            self.isLoading.toggle()
        }
        
        Auth.auth().createUser(withEmail: email_SingUp, password: password_SingUp) { (result, err) in
            
            withAnimation{
                
                self.isLoading.toggle()
            }
            
            if err != nil {
                self.alertMsg = err!.localizedDescription
                self.alert.toggle()
                return
            }
            result?.user.sendEmailVerification(completion: { (err) in
                
                if err != nil{
                    self.alertMsg = err!.localizedDescription
                    self.alert.toggle()
                    return
                }
                
                self.alertMsg = "Email Verification Has Been Sent !!! Verify Your Email ID !!!"
                self.alert.toggle()
            })
        }
        
    }
    
    func logOut() {
        
        try! Auth.auth().signOut()
        
        withAnimation{
            
            self.status = false
        }
        
        email = ""
        password = ""
        email_SingUp = ""
        password_SingUp = ""
        reEnterPassword = ""
        
    }
    
}

class varToFirebase : ObservableObject {
    
    //DATOS DE LA APLICACION PARA FIREBASE
    @AppStorage("sab") var sab = false
    @AppStorage("lun") var lun = false
    @AppStorage("dom") var dom = false
    @AppStorage("mar") var mar = false
    @AppStorage("mie") var mie = false
    @AppStorage("jue") var jue = false
    @AppStorage("vie") var vie = false
    
    //DATOS DE LA APLICACION A FIREBASE
    @AppStorage("hours") var hours = 0
    @AppStorage("minutes") var minutes = 0
    @AppStorage("TiempoDeRiego") var TiempoDeRiego = 10.0
    
    
    @AppStorage("hoursOut1") var hoursOut1 = 0
    @AppStorage("minutesOut1") var minutesOut1 = 0
    
    
    //DATOS RECUPERADOS DE FIREBASE PARA LA APLICACION
    @AppStorage("hours1") var hours1 = 0
    @AppStorage("minutes1") var minutes1 = 0
    
    @AppStorage("minutosDeRiego") var minutosDeRiego = 10.0
    
    @StateObject var dateModel = ModelDataLogin()
    
    var ref = Database.database().reference()
    let userID = Auth.auth().currentUser?.uid
    
    //DATOS RECUPERADOS DE FIREBASE PARA LA APLICACION
    @AppStorage("DOM") var DOM = false
    @AppStorage("LUN") var LUN = false
    @AppStorage("MAR") var MAR = false
    @AppStorage("MIE") var MIE = false
    @AppStorage("JUE") var JUE = false
    @AppStorage("VIE") var VIE = false
    @AppStorage("SAB") var SAB = false
    
    var setMinuASeg = 0
    var resHour = 0
    var resMin = 0
    var sumaTotalSeg = 0
    
    @objc public func guardarHora(){
        self.ref.child("users").child("\(userID!)").child("activar").child("HoraActiv").setValue(hours)
        self.ref.child("users").child("\(userID!)").child("activar").child("MinutosActiv").setValue(minutes)
        
        setMinuASeg = Int(TiempoDeRiego * 60)
        resHour = hours * 3600
        resMin = minutes * 60
        sumaTotalSeg = resHour + resMin + setMinuASeg
        
        func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
            return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
        }
        let (h,m,s) = secondsToHoursMinutesSeconds(seconds: sumaTotalSeg)
        self.ref.child("users").child("\(userID!)").child("desactivar").child("HoursOut").setValue(h)
        self.ref.child("users").child("\(userID!)").child("desactivar").child("MinutesOut").setValue(m)
        print(s)
        
        
    }
    
    @objc public func guardarDesactivarHora(){
        self.ref.child("users").child("\(userID!)").child("desactivar").child("TiempoDeRiego").setValue(TiempoDeRiego)
        
        setMinuASeg = Int(TiempoDeRiego * 60)
        resHour = hours * 3600
        resMin = minutes * 60
        sumaTotalSeg = resHour + resMin + setMinuASeg
        
        func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
            return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
        }
        let (h,m,s) = secondsToHoursMinutesSeconds(seconds: sumaTotalSeg)
        self.ref.child("users").child("\(userID!)").child("desactivar").child("HoursOut").setValue(h)
        self.ref.child("users").child("\(userID!)").child("desactivar").child("MinutesOut").setValue(m)
        print(s)
    }
    
    @objc public func guardarDias(){
        let object: [String: Any] = ["Sabado" : sab, "Lunes" : lun, "Domingo" : dom, "Martes" : mar, "Miercoles" : mie, "Jueves" : jue,
                                     "Viernes" : vie]
        
        self.ref.child("users").child("\(userID!)").child("dias").setValue(object)
    }
    
    
    
    @objc public func obtenerValores(){
        
        self.ref.child("users/\(userID!)/desactivar/TiempoDeRiego").getData { [self] (error, snapshot) in
            if let error = error {
                print("Error getting data \(error)")
            }
            else if snapshot.exists() {
                //    print("HoursOut : \(snapshot.value!)")
                self.minutosDeRiego = Double((snapshot.value!) as! Int)
                //    print("HoursOut\(hoursOut1)")
            }
        }
        
        self.ref.child("users/\(userID!)/desactivar/HoursOut").getData { [self] (error, snapshot) in
            if let error = error {
                print("Error getting data \(error)")
            }
            else if snapshot.exists() {
                //    print("HoursOut : \(snapshot.value!)")
                self.hoursOut1 = (snapshot.value!) as! Int
                //    print("HoursOut\(hoursOut1)")
            }
        }
        
        self.ref.child("users/\(userID!)/desactivar/MinutesOut").getData { [self] (error, snapshot) in
            if let error = error {
                print("Error getting data \(error)")
            }
            else if snapshot.exists() {
                //   print("MinutesOut : \(snapshot.value!)")
                self.minutesOut1 = (snapshot.value!) as! Int
                //   print("MinutesOut\(minutesOut1)")
            }
        }
        
        
        self.ref.child("users/\(userID!)/activar/MinutosActiv").getData { [self] (error, snapshot) in
            if let error = error {
                print("Error getting data \(error)")
            }
            else if snapshot.exists() {
                //  print("MinutosActiv : \(snapshot.value!)")
                self.minutes1 = (snapshot.value!) as! Int
                // print("MinutosActiv \(minutes1)")
            }
        }
        
        self.ref.child("users/\(userID!)/activar/HoraActiv").getData { [self] (error, snapshot) in
            if let error = error {
                print("Error getting data \(error)")
            }
            else if snapshot.exists() {
                //  print("HoraActiv : \(snapshot.value!)")
                self.hours1 = (snapshot.value!) as! Int
                //print("HoraActiv \(hours1)")
            }
        }
        self.ref.child("users/\(userID!)/dias/Domingo").getData { [self] (error, snapshot) in
            if let error = error {
                print("Error getting data \(error)")
            }
            else if snapshot.exists() {
                //    print("Domingo : \(snapshot.value!)")
                self.DOM = (snapshot.value!) as! Bool
                //   print("Domingo \(DOM)")
            }
        }
        self.ref.child("users/\(userID!)/dias/Lunes").getData { (error, snapshot) in
            if let error = error {
                print("Error getting data \(error)")
            }
            else if snapshot.exists() {
                //    print("Lunes : \(snapshot.value!)")
                self.LUN = (snapshot.value!) as! Bool
                //    print("Lunes \(self.LUN)")
            }
        }
        self.ref.child("users/\(userID!)/dias/Martes").getData { (error, snapshot) in
            if let error = error {
                print("Error getting data \(error)")
            }
            else if snapshot.exists() {
                //  print("Martes : \(snapshot.value!)")
                self.MAR = (snapshot.value!) as! Bool
                //     print("Martes \(self.MAR)")
            }
        }
        self.ref.child("users/\(userID!)/dias/Miercoles").getData { (error, snapshot) in
            if let error = error {
                print("Error getting data \(error)")
            }
            else if snapshot.exists() {
                //      print("Miercoles : \(snapshot.value!)")
                self.MIE = (snapshot.value!) as! Bool
                //   print("Miercoles \(self.MIE)")
            }
        }
        self.ref.child("users/\(userID!)/dias/Jueves").getData { (error, snapshot) in
            if let error = error {
                print("Error getting data \(error)")
            }
            else if snapshot.exists() {
                //    print("Jueves : \(snapshot.value!)")
                self.JUE = (snapshot.value!) as! Bool
                //   print("Jueves \(self.JUE)")
            }
        }
        self.ref.child("users/\(userID!)/dias/Viernes").getData { (error, snapshot) in
            if let error = error {
                print("Error getting data \(error)")
            }
            else if snapshot.exists() {
                //     print("Viernes : \(snapshot.value!)")
                self.VIE = (snapshot.value!) as! Bool
                //   print("Viernes \(self.VIE)")
            }
        }
        self.ref.child("users/\(userID!)/dias/Sabado").getData { (error, snapshot) in
            if let error = error {
                print("Error getting data \(error)")
            }
            else if snapshot.exists() {
                //  print("Sabado : \(snapshot.value!)")
                self.SAB = (snapshot.value!) as! Bool
                // print("Sabado \(self.SAB)")
            }
        }
        
    }
    
}

extension Color {
    // static let offWhite = Color(red: 225 / 255, green: 225 / 255, blue: 235 / 255)
    static let offWhite = Color("CC")
}

struct SimpleButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(20)
            .background(
                Group{
                    if configuration.isPressed{
                        Rectangle()
                            // .fill(self.index == 1 ? Color("ColorPrimary") : Color.offWhite)
                            .fill(Color.offWhite)
                    } else{
                        Rectangle()
                            // .fill(self.index == 1 ? Color("ColorPrimary") : Color.offWhite)
                            .fill(Color.offWhite)
                            .frame(width: 60, height: 60)
                            //.foregroundColor(self.index == 1 ? Color("ColorPrimary") : Color.black.opacity(0.3))
                            .cornerRadius(20)
                            .shadow(color: Color.black.opacity(0.2), radius: 6, x: 10, y: 10)
                            .shadow(color: Color.white.opacity(0.5), radius: 6, x: -8, y: -8)
                    }
                    
                })
    }
}

struct TopModifier : ViewModifier {
    
    func body(content: Content) -> some View {
        
        content.background(Color("CC"))
            .cornerRadius(15)
            .shadow(color: Color.black.opacity(0.2), radius: 6, x: 10, y: 10)
            .shadow(color: Color.white.opacity(0.5), radius: 6, x: -8, y: -8)
    }
}

struct TFModifier : ViewModifier {
    func body(content: Content) -> some View {
        
        content.padding(20)
            .background(Color("CC"))
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.black.opacity(0.05), lineWidth: 4)
                    .shadow(color: Color.black.opacity(0.2), radius: 3, x: 5, y: 5)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .shadow(color: Color.white.opacity(0.5), radius: 3, x: -5, y: -5)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
            )
    }
}

struct ButtonModifier : ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(Color("CC"))
            .cornerRadius(15)
            .overlay(
                VStack{
                    if configuration.isPressed {
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.black.opacity(0.05), lineWidth: 4)
                            .shadow(color: Color.black.opacity(0.2), radius: 3, x: 5, y: 5)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .shadow(color: Color.white.opacity(0.2), radius: 3, x: -5, y: -5)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                    }
                }
            )
            .shadow(color: Color.black.opacity(configuration.isPressed ? 0 : 0.2), radius: 5, x: 5, y: 5)
            .shadow(color: Color.white.opacity(configuration.isPressed ? 0 : 0.7), radius: 5, x: 5, y: 5)
    }
}


extension View {
    func getWidth()->CGFloat{
        return UIScreen.main.bounds.width
    }
}

