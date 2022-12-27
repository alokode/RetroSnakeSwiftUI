//
//  ContentView.swift
//  Retro Snake
//
//  Created by Alok Sagar on 26/12/22.
//

import SwiftUI



struct ContentView: View{
    
    @ObservedObject private var viewModel = ViewModel()
    
    var body: some View {
        
        VStack(alignment:.center,spacing: 0) {
            
            TitleView()
            SnakePlayGround(viewModel: viewModel)
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height*0.40)
            ButtonsView(viewModel: viewModel)
                .background(Color.buttonMainBackgroundColor)
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height*0.40)
            BottomView()
        }
        
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(.yellow)
        
    }
    
}

struct ContentView_Previews: PreviewProvider{
    
    static var previews: some View{
        
        ContentView()
        
    }
}


struct TitleView: View {
    var body: some View {
        VStack(spacing:0) {
            
            Text("Retro Snake ")
            
                .font(.custom("Silkscreen-Bold", size: 30))
            
                .offset(x: 0, y: 0)
            
                .foregroundColor(.yellow)
            
                .padding(0)
            
            HStack() {
                
                Circle()
                
                    .frame(width: 10, height: 20)
                
                    .foregroundColor(.red)
                
                    .padding(0)
                
                Circle()
                
                    .frame(width: 20, height: 20)
                
                    .foregroundColor(.red)
                
                Circle()
                
                    .frame(width: 10, height: 20)
                
                    .foregroundColor(.red)
                
            }.padding(0)
            
                .background(.clear)
            
        }
        
        .frame(width: UIScreen.main.bounds.width, height: 70, alignment: .center)
        
        .background(Color.buttonMainBackgroundColor)
    }
}

struct BottomView: View {
    var body: some View {
        HStack{
            
            Rectangle()
            
                .frame(width: UIScreen.main.bounds.width*0.60, height: 4)
            
                .foregroundColor(.black)
            
            Spacer()
            
            Rectangle()
            
                .frame(width: 4, height: 20)
            
                .foregroundColor(.red)
            
                .rotationEffect(Angle.init(degrees: 13), anchor: .bottomTrailing)
            
            
            
            Rectangle()
            
                .frame(width: 4, height: 20)
            
                .background(.red)
            
            
            
                .rotationEffect(Angle.init(degrees: 13), anchor: .bottomTrailing)
            
            Rectangle()
            
                .frame(width: 4, height: 20)
            
                .foregroundColor(.black)
            
            
            
                .rotationEffect(Angle.init(degrees: 13), anchor: .bottomTrailing)
            
            
            
            Rectangle()
            
                .frame(width: 4, height: 20)
            
                .foregroundColor(.red)
            
            
            
                .rotationEffect(Angle.init(degrees: 13), anchor: .bottomTrailing)
            
            Spacer()
            
            Rectangle()
            
                .foregroundColor(.black)
            
                .frame(width: 50, height: 4)
            
        }.offset(x: 0, y: 10)
    }
}
