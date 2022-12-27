//
//  ViewModel.swift
//  Retro Snake
//
//  Created by Alok Sagar on 27/12/22.
//

import Foundation
import AVFAudio

enum Direction{
    
    case Left,Right,Up,Down
    
}

enum GameState{
    
    case initial,gameOver,onGoing,pause,reset
    
}

class ViewModel:ObservableObject {
    @Published var direction:Direction =  .Right
    @Published var head:CGPoint = .zero
    @Published var gameState:GameState = .onGoing
    @Published var  snakeBodyArray: [SnakeBodyBlock]  =  []
    @Published var feed:SnakeBodyBlock?
    private var soundPlayer:AVAudioPlayer? = nil
    var  timeRemaining: Int =  0
    private var  timerValue =  0.6
    private var timer :Timer  = Timer()
    var  snakePlayGroundSize: CGSize =  .zero
    var  score: Int =  0

    var isFeedAvailable : Bool {
        feed != nil
    }
    
    var feedX:CGFloat {
        feed?.position.x ?? 0
    }
    
    var feedY:CGFloat {
        feed?.position.y ?? 0
    }
    
    var highestScore : Int {
        get {
            UserDefaults.standard.integer(forKey: "HIGHEST_SCORE")
        }
        
        set {
            UserDefaults.standard.setValue(newValue, forKey: "HIGHEST_SCORE")
        }
    }
    
    func appendBall(ball:SnakeBodyBlock){
        
        var ballToAppend = ball
        var prev = snakeBodyArray.last!
        switch direction{
            
        case .Left:
            
            ballToAppend.position = CGPoint.init(x: prev.position.x+snakeElementSize, y: prev.position.y)
            
        case .Right:
            
            ballToAppend.position = CGPoint.init(x: prev.position.x-snakeElementSize, y: prev.position.y)
            
        case .Up:
            
            ballToAppend.position = CGPoint.init(x: prev.position.x, y: prev.position.y+snakeElementSize)
            
        case .Down:
            
            ballToAppend.position = CGPoint.init(x: prev.position.x, y: prev.position.y-snakeElementSize)
            
        }
        
        snakeBodyArray.append(ballToAppend)
        
        playFeedSound()
        
        feed = nil
        
        if snakeBodyArray.count%3 == 0 &&  timerValue >= 0.1{ // Increase speed to next level
            
            stopTimer()
            
            timerValue -= 0.1
            
            startTimer()
            
        }
        
        score += 10
        
        if score > highestScore {
            highestScore = score
        }
            
        
        //move(direction: .Right)
        
    }
    
    func startTimer(){
        self.timer.invalidate()
        
        self.timer = Timer.scheduledTimer(withTimeInterval: timerValue, repeats: true, block: { [weak self] timer in
           
            self?.timeRemaining +=  1
        
           // let  first = snakeBodyArray.first
            
            self?.checkCollidWithWall()
            
            self?.move()
        })
        
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
    
    func showInitialMenu(snakePlayGroundSize:CGSize){
        self.snakePlayGroundSize = snakePlayGroundSize
        score = 0
        gameState = .initial
    }
    
    func initiliseAndStartGame(snakePlayGroundSize:CGSize){
        
        score = 0
        stopTimer()
        
        self.snakePlayGroundSize = snakePlayGroundSize
        head = CGPoint.init(x: snakePlayGroundSize.width/2, y:snakePlayGroundSize.height/2)
       // currentHeadPosition =  CGPoint.init(x: proxy.size.width/2, y: proxy.size.height/2)
        snakeBodyArray =  SnakeBodyBlock.getInitialArray(headPoint: head)
        
        startTimer()
        
        dropFeed()
    }
    
    func checkCollidWithWall(){
        
        var first = snakeBodyArray.first!
        
        
        switch direction{
            
        case .Left:
            
            if first.position.x - snakeElementSize <= 0{
                
                gameState = .gameOver
                
                stopTimer()
                
                print("Game over")
                
                return
                
            }
            
        case .Right:
            
            if snakeElementSize + first.position.x >= snakePlayGroundSize.width{
                
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
            
            if first.position.y + snakeElementSize >=  snakePlayGroundSize.height{
                
                gameState = .gameOver
                
                stopTimer()
                
                print("Game over")
                
                return
                
            }
            
        }
        
    }
    
    func stopTimer() {
        timer.invalidate()
        feed = nil
    }
  
    func dropFeed(){
        
        let  x  =  CGFloat.random(in: 20.0...snakePlayGroundSize.width-20)
        
        let  y  =  CGFloat.random(in: 20.0...snakePlayGroundSize.height-20)
        
        feed =  SnakeBodyBlock(color: .black, index: 0, position:CGPoint.init(x: x, y: y))
        
    }
    
    func move(){
        var  tempArray  =  snakeBodyArray
        for(index,ball) in snakeBodyArray.enumerated() {

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
                
                let  prev  =  snakeBodyArray[index-1]
                
                
                
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
        

        snakeBodyArray =  tempArray
     
        head =  snakeBodyArray.first!.position
    
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
            
            
            
            var temp = snakeBodyArray
            
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
        
    }
    
    func gameOver(){
        feed =  nil
        playGameoverSoud()
    }
    
    func resetGame() {
        playGameoverSoud()
        initiliseAndStartGame(snakePlayGroundSize: snakePlayGroundSize)
    }
}



