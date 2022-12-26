

//SnakePlayGround.swift

//SwiftUITest

//

//Created by Alok Sagar P on 16/12/22.

//



import SwiftUI
import Combine
import AVFAudio



struct SnakePlayGround: View{
    
    
    @State private var soundPlayer:AVAudioPlayer? = nil
    
    @State var  array: [Ball]  =  []
    
    @Binding var  currentDirection: Direction
    
    @Binding var  head: CGPoint
    
    @Binding var  gameState: GameState
    
    @State var  timeRemaining: Int =  0
    
    @State private var  feed: Ball?
    
    @State private var  timerValue =  0.6
    
    @State var  currentHeadPosition:CGPoint =  CGPoint(x: 0, y: 0)
    
    @State var  currentTalePosition:CGPoint =  CGPoint(x: 50, y: 50)
    
    @State var  timerSubscription: Cancellable?
    
    let  snakeElementSize:CGFloat =  10
    
    let  stepSize:CGFloat =  10
    
    var  dx:CGFloat =  0.0
    
    var  dy:CGFloat =  0.0
    
    @State private var  windowSize: CGSize =  .zero
    
    @State private var  score: Int =  0
    
    @State var  clear:Bool =  false
    
    
    
    @State var  timer =  Timer.publish(every:1, on: .main, in: .common)
    
    var  body: some View{
        
        GeometryReader{ proxy in
            VStack(alignment:.trailing,spacing: 0) {
                HStack{
                    Text("High Score: \(score)")
                        .font(.custom("Silkscreen-Bold", size: 10))
                        .foregroundColor(.black)
                    
                        .padding(.trailing,10)
                    
                    Spacer()
                    
                    Text("Score: \(score)")
  
                        .font(.custom("Silkscreen-Bold", size: 10))
                        .foregroundColor(.black)
                    
                        .padding(.trailing,10)
                    
                }

                Rectangle().frame(width: proxy.size.width, height: 3)
                    .foregroundColor(.black)
                    
                
                
                
                ZStack(alignment: .topLeading){
                    
                    if gameState ==  .gameOver{
                        
                        Text("GAME OVER \n Score: \(score)")
                        
                            .font(.custom("Silkscreen-Bold", size: 30))
                        
                            .offset(x: 0, y: 0)
                        
                            .foregroundColor(.black)
                        
                            .padding(0)
                        
                    }

                    else{
                        
                        ForEach(array,id: \.self) { ball in
                            
                            SnakeBody()
                            
                                .frame(width: snakeElementSize, height: snakeElementSize)
                            
                                .position(x: ball.position.x, y: ball.position.y)
                            
                                .foregroundColor(ball.color)
                            
                            
                            
                        }
                        
                    }
                    
                    
                    
                    if feed !=  nil{
                        
                        SnakeBody()
                        
                            .frame(width: snakeElementSize, height: snakeElementSize, alignment: .center)
                        
                            .position(x: feed!.position.x, y: feed!.position.y)
                        
                            .foregroundColor(feed!.color)
                        
                    }
                    
                }
                
                .frame(width: proxy.size.width, height: proxy.size.height)
                
                .border(.black, width: 0)
                
                .onAppear(perform: {
                    
                    currentHeadPosition =  CGPoint.init(x: proxy.size.width/2, y: proxy.size.height/2)
                    
                    array =  Ball.getInitialArray(headPoint: currentHeadPosition)
                    
                    
                    
                })
                
                
                
                .onReceive(timer) { time in
                    
                    // withAnimation(.linear(duration: 1)) {
                    
                    timeRemaining +=  1
                    
                    
                    
                    let  first =  array.first
                    
                    
                    
                    checkCollidWithWall()
                    
                    
                    
                    //if proxy.size.width/2 + snakeElementSize + first!.position.x > =  proxy.size.width {
                    
                    //print("Game over")
                    
                    //}
                    
                    //if timeRemaining  =  =  2 {
                    
                    //appendBall(ball: Ball.init(color: .blue, index: array.count, position: .zero))
                    
                    //} else iftimeRemaining  =  =  5{
                    
                    //appendBall(ball: Ball.init(color: .black, index: array.count, position: .zero))
                    
                    //
                    
                    //}
                    
                    move(direction: currentDirection)
                    
                    // }
                    
                    
                    
                }
                
                .onAppear{
                    
                    windowSize =  proxy.size
                    
                    self.timer =  Timer.publish(every: timerValue, on: .main, in: .common)
                    
                    self.timerSubscription =  self.timer.connect()
                    
                    dropFeed()
                    
                }
                
                .onChange(of: gameState) { newValue in
                    
                    switch gameState{
                        
                    case .initial:
                        
                        head =  CGPoint.init(x: 50, y: 50)
                        
                        currentDirection =  .Right
                        
                    case .gameOver:
                        
                        feed =  nil
                        playGameoverSoud()
                        
                    case .onGoing:
                        
                        break
                        
                    case .pause:
                        
                        stopTimer()
                        
                    case .reset:
                        
                        stopTimer()
                        
                        head =  CGPoint.init(x: 50, y: 50)
                        
                        currentDirection =  .Right
                        
                        array.removeAll()
                        
                        array =  Ball.getInitialArray(headPoint: head)
                        
                        startTimer()
                        
                    }
                    
                }
                .onChange(of: currentDirection) { newValue in
                    playButtonSoud()
                }
                
            }
            
            
            
        }.background(screenBackgroundColor)
        
            .ignoresSafeArea()
        
    }
    
    
    
    
    
    func startTimer() {
        
        self.timer =  Timer.publish(every: timerValue, on: .main, in: .common)
        
        self.timerSubscription =  self.timer.connect()
        
        gameState =  .onGoing
        
        // self.timer.upstream.connect().cancel()
        
    }
    
    
    
    func stopTimer() {
        
        timerSubscription?.cancel()
        
        timerSubscription =  nil
        
        
        
    }
    
    
    
    
    
    func getPoints(index:Int){
        
        var  point  =  currentHeadPosition
        
        switch self.currentDirection{
            
        case .Left:
            
            point.x =  currentHeadPosition.x-CGFloat(index*20)
            
            
            
        case .Right:
            
            point.x =  currentHeadPosition.x+CGFloat(index*20)
            
        case .Up:
            
            point.y =  currentHeadPosition.y-CGFloat(index*20)
            
        case .Down:
            
            point.y =  currentHeadPosition.y+CGFloat(index*20)
            
        }
        
    }
    
    
    
    func dropFeed(){
        
        let  x  =  CGFloat.random(in: 20.0...windowSize.width-20)
        
        let  y  =  CGFloat.random(in: 20.0...windowSize.height-20)
        
        feed =  Ball(color: .black, index: 0, position:CGPoint.init(x: x, y: y))
        
    }
    
    
    
    func move(direction:Direction){
        
        var  tempArray  =  array
        
        
        
        for(index,ball) in array.enumerated() {
            
            
            
            var  cur =  ball
            
            if index ==  0{
                
                switch direction {
                    
                case .Left:
                    
                    cur.position =  CGPoint.init(x: cur.position.x-stepSize, y: cur.position.y)
                    
                case .Right:
                    
                    cur.position =  CGPoint.init(x: cur.position.x+stepSize, y: cur.position.y)
                    
                case .Up:
                    
                    cur.position =  CGPoint.init(x: cur.position.x, y: cur.position.y-stepSize)
                    
                case .Down:
                    
                    cur.position =  CGPoint.init(x: cur.position.x, y: cur.position.y+stepSize)
                    
                }
                
                tempArray[index]  =  cur
                
            } else{
                
                let  prev  =  array[index-1]
                
                
                
                switch direction {
                    
                case .Left:
                    
                    cur.position =  CGPoint.init(x: prev.position.x-snakeElementSize*2, y: prev.position.y)
                    
                case .Right:
                    
                    cur.position =  CGPoint.init(x: prev.position.x+snakeElementSize*2, y: prev.position.y)
                    
                case .Up:
                    
                    cur.position =  CGPoint.init(x: prev.position.x, y: prev.position.y-snakeElementSize*2)
                    
                case .Down:
                    
                    cur.position =  CGPoint.init(x: prev.position.x, y: prev.position.y+snakeElementSize*2)
                    
                }
                
                
                
                
                
                
                
                cur.position =  prev.position
                
                
                
                tempArray[index]  =  cur
                
                
                
            }
            
            
            
            
            
            
            
            
            
        }
        
        
        
        
        
        
        
        
        
        // ifsnakeElementSize + first.position.x > =  windowSize.width {
        
        //gameState  =  .gameOver
        
        //stopTimer()
        
        // print("Game over")
        
        //} else {
        
        array =  tempArray
        
        
        
        head =  array.first!.position
        
        
        
        if let  feedPoint  =  feed?.position{
            
            let  headMinX  =  head.x-snakeElementSize/2
            
            let  headMiny  =  head.y-snakeElementSize/2
            
            
            
            let  headMaxX  =  head.x+snakeElementSize/2
            
            let  headMaxy  =  head.y+snakeElementSize/2
            
            
            
            let  feedMinX  =  feedPoint.x-snakeElementSize/2
            
            let  feedMiny  =  feedPoint.y-snakeElementSize/2
            
            
            
            let  feedMaxX  =  feedPoint.x+snakeElementSize/2
            
            let  feedMaxy  =  feedPoint.y+snakeElementSize/2
                    
            let  feedFrame  =  CGRect.init(x: feedMinX, y: feedMiny, width: snakeElementSize, height: snakeElementSize)
            
            
            
            let  headFrame  =  CGRect.init(x: headMinX, y: headMiny, width: snakeElementSize, height: snakeElementSize)
            
            
            
            var  headPointOne:CGPoint =  .zero
            
            var  headPointTwo:CGPoint =  .zero
            
            switch direction {
                
            case .Left:
                
                headPointOne = CGPoint.init(x: headMinX, y: headMiny)
                
                headPointTwo = CGPoint.init(x: headMinX, y: headMaxy)
                
            case .Right:
                
                headPointOne = CGPoint.init(x: headMaxX, y: headMiny)
                
                headPointTwo = CGPoint.init(x: headMaxX, y: headMaxy)
                
            case .Up:
                
                headPointOne = CGPoint.init(x: headMinX, y: headMiny)
                
                headPointTwo = CGPoint.init(x: headMaxX, y: headMiny)
                
            case .Down:
                
                headPointOne = CGPoint.init(x: headMinX, y: headMaxy)
                
                headPointTwo = CGPoint.init(x: headMaxX, y: headMaxy)
                
            }
            
            
            
            var temp = array
            
            temp.removeFirst()
            
            
            
            let didCollideBody = temp.reduce(into: false) { isHit, body in
                
                
                
                isHit = isHit || CGRect.init(x: body.position.x, y: body.position.y, width: snakeElementSize, height: snakeElementSize).contains(headPointOne)  || CGRect.init(x: body.position.x, y: body.position.y, width: snakeElementSize, height: snakeElementSize).contains(headPointTwo) //headFrame.contains(body.position)
                
            }
            
            
            
            
            
            if didCollideBody {
                print("#ALK Did collide :\(didCollideBody)")
                gameState = .gameOver
            }
            let isPointInFrame = feedFrame.contains(headPointOne) || feedFrame.contains(headPointTwo)
            
            if isPointInFrame {
                
                appendBall(ball: feed!)
                
                dropFeed()
                
            }
            
        }
        
        
        
        //}
        
        
        
        
        
        // currentHeadPosition = array.first?.position ?? .zero
        
        
        
    }
    
    
    
    func appendBall(ball:Ball){
        
        var ballToAppend = ball
        
        var prev = array.last!
        
        // var  prev = array.first!
        
        switch currentDirection{
            
        case .Left:
            
            ballToAppend.position = CGPoint.init(x: prev.position.x+snakeElementSize, y: prev.position.y)
            
        case .Right:
            
            ballToAppend.position = CGPoint.init(x: prev.position.x-snakeElementSize, y: prev.position.y)
            
        case .Up:
            
            ballToAppend.position = CGPoint.init(x: prev.position.x, y: prev.position.y+snakeElementSize)
            
        case .Down:
            
            ballToAppend.position = CGPoint.init(x: prev.position.x, y: prev.position.y-snakeElementSize)
            
        }
        
        //array.insert(ballToAppend, at: 0)
        
        array.append(ballToAppend)
        
        playFeedSound()
        
        feed = nil
        
        if array.count%3 == 0 &&  timerValue >= 0.3{
            
            stopTimer()
            
            timerValue -= 0.1
            
            startTimer()
            
        }
        
        score += 10
        
        //move(direction: .Right)
        
    }
    
     func playFeedSound() {
           let url = Bundle.main.url(forResource: "feed", withExtension: "wav")
           soundPlayer = try! AVAudioPlayer(contentsOf: url!)
        soundPlayer?.play()
    }
    
    func playButtonSoud() {
          let url = Bundle.main.url(forResource: "button_sound", withExtension: "wav")
          soundPlayer = try! AVAudioPlayer(contentsOf: url!)
       soundPlayer?.play()
   }
    
    func playGameoverSoud() {
          let url = Bundle.main.url(forResource: "game_over", withExtension: "wav")
          soundPlayer = try! AVAudioPlayer(contentsOf: url!)
       soundPlayer?.play()
   }
    
    func checkCollidWithWall(){
        
        var first = array.first!
        
        
        
        
        
        switch currentDirection{
            
        case .Left:
            
            if first.position.x - snakeElementSize <= 0{
                
                gameState = .gameOver
                
                stopTimer()
                
                print("Game over")
                
                return
                
            }
            
        case .Right:
            
            if snakeElementSize + first.position.x >= windowSize.width{
                
                gameState = .gameOver
                
                stopTimer()
                
                print("Game over")
                
                return
                
            }
            
        case .Up:
            
            if first.position.y - snakeElementSize <= 0{
                
                gameState = .gameOver
                
                stopTimer()
                
                print("Game over")
                
                return
                
            }
            
        case .Down:
            
            if first.position.y + snakeElementSize >=  windowSize.height{
                
                gameState = .gameOver
                
                stopTimer()
                
                print("Game over")
                
                return
                
            }
            
        }
        
    }
    
}



struct SnakePlayGround_Previews: PreviewProvider{
    
    @State static var direction:Direction = .Up
    
    @State static var head:CGPoint = .zero
    
    @State static var gameState:GameState = .onGoing
    
    
    
    
    
    @State private static var feed: Ball? = .init(color: .black, index: 1, position: .zero)
    
    static var previews: some View{
        
        
        SnakePlayGround(currentDirection: $direction, head: $head, gameState: $gameState)
        
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
