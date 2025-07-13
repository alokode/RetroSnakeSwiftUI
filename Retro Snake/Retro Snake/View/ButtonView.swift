//

//ButtonsView.swift

//SwiftUITest

//

//Created by Alok Sagar P on 25/12/22.

//



import SwiftUI


struct ButtonsView: View{
    
    @ObservedObject var viewModel:ViewModel
    @State private var isHolding = false
    
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
                        
                        
                        
                        GameControllButton(
                            buttonSize: buttonSize,
                            direction: .Up,
                            viewModel: viewModel
                        )
                        .offset(x: 0, y: -radius/4)
                        
                        
                        
                        
                        
                        GameControllButton(
                            buttonSize: buttonSize,
                            direction: .Left,
                            viewModel: viewModel
                        )
                        .offset(x: -radius/4, y: 0)//Left
                        
                        GameControllButton(
                            buttonSize: buttonSize,
                            direction: .Down,
                            viewModel: viewModel
                        )
                        .offset(x: 0, y: radius/4)//Down
                        
                        
                        
                       
                        GameControllButton(
                            buttonSize: buttonSize,
                            direction: .Right,
                            viewModel: viewModel
                        )
                        .offset(x: radius/4, y: 0) //Right
                        

                        
                    }.offset(x: buttonSize+50, y: buttonSize/2)
                    
                       // .rotationEffect(Angle.init(degrees: buttonRottationAngle))
                    
                    
                    
                    Spacer()
                    
                    
                    
                    VStack(alignment:.leading,spacing: 0) {
                        Button{
                            
                            viewModel.startPauseGame()
                            
                            // gameState = (gameState == .onGoing) ? .pause : .onGoing
                            
                        } label: {
                            
                            Text("\(viewModel.gameState == .gameOver || viewModel.gameState == .pause || viewModel.gameState == .initial ? "START": "PAUSE")")
                            
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

struct GameControllButton : View{
   
    var buttonSize:CGFloat = .zero
    var direction:Direction!
    var viewModel:ViewModel!
    private var buttonRottationAngle:CGFloat = 0
    
    init(buttonSize: CGFloat, direction: Direction!, viewModel: ViewModel!) {
        self.buttonSize = buttonSize
        self.direction = direction
        self.viewModel = viewModel
        switch direction {
        case .Left:
            buttonRottationAngle = 270
        case .Right:
            buttonRottationAngle = 90
        case .Up:
            buttonRottationAngle = 0
        case .Down:
            buttonRottationAngle = 180
        case .none:
            break;
        }
    }
    
    var body : some View {
        
        return Button {

            viewModel.updateDirectionIfNeeded(directionToUpdate: direction)
            
            
        } label: {
           
            
            Image("up-arrow")
            
               // .renderingMode(.template)
            
                .resizable()
            
                .frame(width: buttonSize, height: buttonSize, alignment: .center)
            
                .rotationEffect(Angle.init(degrees: buttonRottationAngle))
            
                .foregroundColor(.yellow)
            
            
            
        }
        
        .simultaneousGesture(
            LongPressGesture(minimumDuration: 0.5)
                .onEnded { _ in
                    viewModel.updateDirectionIfNeeded(directionToUpdate: direction)
                    viewModel.onButtonHoldSpeedIncrease()
                }
        )
        .highPriorityGesture(
            DragGesture(minimumDistance: 0)
                .onEnded { _ in
                    viewModel.updateDirectionIfNeeded(directionToUpdate: direction)
                    viewModel.onButtonHoldRevertSpeed()
                }
        )

        
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
