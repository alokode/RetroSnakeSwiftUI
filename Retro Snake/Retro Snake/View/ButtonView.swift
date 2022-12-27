//

//ButtonsView.swift

//SwiftUITest

//

//Created by Alok Sagar P on 25/12/22.

//



import SwiftUI


struct ButtonsView: View{
    
    @ObservedObject var viewModel:ViewModel
    
    var body: some View{
        
        GeometryReader{ rect in
            
            let radius : CGFloat = CGFloat.minimum(rect.size.width, rect.size.height)
            
            let buttonSize : CGFloat = 75
            
            let buttonRottationAngle:CGFloat = 0
            
            VStack(spacing:0) {
                
                Spacer()
                
                HStack(alignment:.top) {
                    
                    ZStack(alignment:.topLeading) {
                        
                        
                        
                        Circle()
                        
                            .stroke(lineWidth: 1)
                        
                            .frame(width: radius/2, height: radius/2, alignment: .center)
                        
                            .opacity(0)
                        
                        
                        
                        Button{
                            
                            print("Image tapped!")
                            
                            if viewModel.direction != .Up && viewModel.direction != .Down{
                                
                                viewModel.direction = .Up
                                
                            }
                            
                            
                            
                        } label: {
                            
                            Image("up-arrow")
                            
                               // .renderingMode(.template)
                            
                                .resizable()
                            
                                .frame(width: buttonSize, height: buttonSize, alignment: .center)
                            
                            
                            
                                .rotationEffect(Angle.init(degrees: -buttonRottationAngle))
                            
                                .foregroundColor(.yellow)
                            
                            
                            
                        }
                        
                        
                        
                        .offset(x: 0, y: -radius/4)
                        
                        
                        
                        
                        
                        
                        
                        Button{
                            
                            if viewModel.direction != .Left && viewModel.direction != .Right{
                                
                                viewModel.direction = .Left
                                
                            }
                            
                            
                            
                        } label: {
                            
                            Image("up-arrow")
                            
                                //.renderingMode(.template)
                            
                                .resizable()
                            
                                .frame(width: buttonSize, height: buttonSize, alignment: .center)
                            
                                .rotationEffect(Angle.degrees(270-buttonRottationAngle))
                            
                                .foregroundColor(.yellow)
                            
                        }
                        
                        .offset(x: -radius/4, y: 0)//Left
                        
                        Button{
                            
                            if viewModel.direction != .Up && viewModel.direction != .Down{
                                
                                viewModel.direction = .Down
                                
                            }
                            
                            
                            
                        } label: {
                            
                            Image("up-arrow")
                            
                               // .renderingMode(.template)
                            
                                .resizable()
                            
                                .frame(width: buttonSize, height: buttonSize, alignment: .center)
                            
                            
                            
                                .rotationEffect(Angle.degrees(180-buttonRottationAngle))
                            
                                .foregroundColor(.yellow)
                            
                        }
                        
                        .offset(x: 0, y: radius/4)//Down
                        
                        
                        
                        Button{
                            
                            if viewModel.direction != .Left && viewModel.direction != .Right{
                                
                                viewModel.direction = .Right
                                
                            }
                            
                            
                            
                        } label: {
                            
                            Image("up-arrow")
                            
                                //.renderingMode(.template)
                            
                                .resizable()
                            
                                .frame(width: buttonSize, height: buttonSize, alignment: .center)
                            
                                .rotationEffect(Angle.degrees(90-buttonRottationAngle))
                            
                                .foregroundColor(.yellow)
                            
                        }
                        
                        .offset(x: radius/4, y: 0) //Right
                        
                        
                        
                        
                        
                        
                        
                    }.offset(x: buttonSize+30, y: buttonSize/2)
                    
                        .rotationEffect(Angle.init(degrees: buttonRottationAngle))
                    
                    
                    
                    Spacer()
                    
                    
                    
                    VStack(alignment:.leading,spacing: 0) {
                        
                        Button{
                            
                            if viewModel.gameState == .onGoing{
                                
                                viewModel.gameState = .pause
                                
                            } else if viewModel.gameState == .gameOver {
                                
                                viewModel.gameState = .reset
                                
                            } else if viewModel.gameState == .pause{
                                
                                viewModel.gameState = .onGoing
                                
                            }
                            
                            // gameState = (gameState == .onGoing) ? .pause : .onGoing
                            
                        } label: {
                            
                            Text("\(viewModel.gameState == .gameOver || viewModel.gameState == .pause ? "START": "PAUSE")")
                            
                                .fontWeight(.bold)
                            
                                .foregroundColor(.black)
                            
                                .padding()
                            
                                .background(.yellow)
                            
                                .foregroundColor(.white)
                            
                                .foregroundColor(.black)
                            
                                .cornerRadius(40)
                            
                        }
                        
                        .padding(.bottom,40)
                        
                        
                        
                        
                        
                        Button{
                            
                            viewModel.resetGame()
                            
                        } label: {
                            
                            
                            
                            Text("RESET")
                            
                                .fontWeight(.bold)
                            
                                .foregroundColor(.black)
                            
                                .padding()
                            
                                .background(.red)
                            
                                .foregroundColor(.white)
                            
                                .cornerRadius(40)
                            
                            
                            
                            
                            
                        }
                        
                    }.padding(.trailing,5)
                    
                    
                    
                }
                
                .frame(width: rect.size.width,height: rect.size.height)
                
                Spacer()
                
            }
            
            
            
        }
        
        
        
    }
    
}



struct ButtonsView_Previews: PreviewProvider{
    
    @State static var direct:Direction = .Right
    
    @State static var gameState:GameState = .onGoing
    
    static var previews: some View{
        
        
        
        Group{
            
            ButtonsView(viewModel: ViewModel())
            
        }
        
    }
    
}
