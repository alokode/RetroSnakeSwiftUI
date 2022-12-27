

//SnakePlayGround.swift

//SwiftUITest

//

//Created by Alok Sagar P on 16/12/22.

//



import SwiftUI
import Combine
import AVFAudio



struct SnakePlayGround: View{
    
    
   
    
    @ObservedObject var viewModel:ViewModel
    
//    @Binding var  currentDirection: Direction
//
//    @Binding var  head: CGPoint
//
//    @Binding var  gameState: GameState
//
//    @State var  currentHeadPosition:CGPoint =  CGPoint(x: 0, y: 0)
//
//    @State var  currentTalePosition:CGPoint =  CGPoint(x: 50, y: 50)
//
//    @State var  timerSubscription: Cancellable?
//
//    var  dx:CGFloat =  0.0
//
//    var  dy:CGFloat =  0.0
//
//
//
//
//    @State var  clear:Bool =  false
//
//
//
//    @State var  timer =  Timer.publish(every:1, on: .main, in: .common)
    
    var  body: some View{
        
        GeometryReader{ proxy in
            VStack(alignment:.trailing,spacing: 0) {
                HStack{
                    Text("High Score: \(viewModel.score)")
                        .font(.custom("Silkscreen-Bold", size: 10))
                        .foregroundColor(.black)
                    
                        .padding(.trailing,10)
                    
                    Spacer()
                    
                    Text("Score: \(viewModel.score)")
  
                        .font(.custom("Silkscreen-Bold", size: 10))
                        .foregroundColor(.black)
                    
                        .padding(.trailing,10)
                    
                }

                Rectangle().frame(width: proxy.size.width, height: 3)
                    .foregroundColor(.black)
                    
                
                
                
                ZStack(alignment: .topLeading){
                    
                    if viewModel.gameState ==  .gameOver{
                        
                        Text("GAME OVER \n Score: \(viewModel.score)")
                        
                            .font(.custom("Silkscreen-Bold", size: 30))
                        
                            .offset(x: 0, y: 0)
                        
                            .foregroundColor(.black)
                        
                            .padding(0)
                        
                    }

                    else{
                        
                        ForEach(viewModel.snakeBodyArray,id: \.self) { ball in
                            
                            SnakeBody()
                            
                                .frame(width: snakeElementSize, height: snakeElementSize)
                            
                                .position(x: ball.position.x, y: ball.position.y)
                            
                                .foregroundColor(ball.color)
                            
                            
                            
                        }
                        
                    }
                    
                    
                    
                    if viewModel.isFeedAvailable {
                        
                        SnakeBody()
                        
                            .frame(width: snakeElementSize, height: snakeElementSize, alignment: .center)
                        
                            .position(x: viewModel.feedX, y: viewModel.feedY)
                        
                            .foregroundColor(viewModel.feed!.color)
                        
                    }
                    
                }
                
                .frame(width: proxy.size.width, height: proxy.size.height)
                
                .border(.black, width: 0)
                
                .onAppear(perform: {
                    
                    viewModel.initiliseAndStartGame(snakePlayGroundSize: proxy.size )
                    

                    
                })
                

                
                .onAppear{
                    
                    
                    
                }
                
                .onChange(of: viewModel.gameState) { newValue in
                    
                    switch newValue{
                        
                    case .initial:
                        viewModel.initiliseAndStartGame(snakePlayGroundSize: proxy.size)
//                        head =  CGPoint.init(x: 50, y: 50)
//
//                        currentDirection =  .Right
                        
                    case .gameOver:
                        viewModel.gameOver()
                        
                    case .onGoing:
                        
                        break
                        
                    case .pause:
                        
                        viewModel.stopTimer()
                        
                    case .reset:
            
                        viewModel.initiliseAndStartGame(snakePlayGroundSize: proxy.size)
                        
                    }
                    
                }
                .onChange(of: viewModel.direction) { newValue in
                    viewModel.playButtonSoud()
                }
                
            }
            
            
            
        }.background(Color.retroSreenGray)
        
            .ignoresSafeArea()
        
    }
    
//    func startTimer() {
//
//        self.timer =  Timer.publish(every: timerValue, on: .main, in: .common)
//
//        self.timerSubscription =  self.timer.connect()
//
//        gameState =  .onGoing
//
//        // self.timer.upstream.connect().cancel()
//
//    }
//
//
//
//    func stopTimer() {
//
//        timerSubscription?.cancel()
//
//        timerSubscription =  nil
//
//
//
//    }
//
    
    
    
    
//    func getPoints(index:Int){
//
//        var  point  =  currentHeadPosition
//
//        switch self.currentDirection{
//
//        case .Left:
//
//            point.x =  currentHeadPosition.x-CGFloat(index*20)
//
//
//
//        case .Right:
//
//            point.x =  currentHeadPosition.x+CGFloat(index*20)
//
//        case .Up:
//
//            point.y =  currentHeadPosition.y-CGFloat(index*20)
//
//        case .Down:
//
//            point.y =  currentHeadPosition.y+CGFloat(index*20)
//
//        }
//
//    }
    
    
    
   
    
    
    
    
    
   
    
}



struct SnakePlayGround_Previews: PreviewProvider{
    
    @State static var direction:Direction = .Up
    
    @State static var head:CGPoint = .zero
    
    @State static var gameState:GameState = .onGoing
    
    
    
    
    
    @State private static var feed: SnakeBodyBlock? = .init(color: .black, index: 1, position: .zero)
    
    static var previews: some View{
        
        
        SnakePlayGround(viewModel: ViewModel())
        
            .previewInterfaceOrientation(.portrait)
        
    }
    
}



struct SnakeBody: View{
    
    
    
    var body: some View{
        
        GeometryReader{ proxy in
            
            ZStack{
                
                Rectangle()
                
                    .stroke(lineWidth: 2)
                
                    .frame(width: proxy.size.width, height: proxy.size.height)
                
                    .foregroundColor(.black)
                
                Rectangle()
                
                    .stroke(lineWidth: 2)
                
                    .frame(width: proxy.size.width/2, height: proxy.size.height/2)
                
                    .foregroundColor(.black)
                
            }
            
        }
        
        
        
    }
    
}
