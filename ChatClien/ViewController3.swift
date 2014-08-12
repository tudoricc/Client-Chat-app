//
//  ViewController3.swift
//  ChatClien
//
//  Created by Tudor on 08/08/14.
//  Copyright (c) 2014 meforme. All rights reserved.
//

import UIKit

class ViewController3: UIViewController , UITextViewDelegate , NSStreamDelegate{

    
    @IBOutlet var receiver: UILabel!
    @IBOutlet var senderLabel: UILabel!
    @IBOutlet var messageText: UITextView!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var receiverLabel: UILabel!
    @IBOutlet var ChatView: UITableView!
    
    
    var nameofSender : NSString!
    var nameofReceiver : NSString!
    var inputStream : NSInputStream!
    var outputStream : NSOutputStream!
    var pos = 0
    var messages : NSMutableArray = [" "]
    var messagefrom :[(String,String)]!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(messageText)
        receiverLabel.text  = nameofReceiver
        
        self.messageText.delegate = self
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidHide:", name:UIKeyboardDidHideNotification, object: nil)
        //self.messageText.sizeToFit()
        
        
        self.messageText.layer.borderWidth = 0.4
        self.messageText.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.messageText.layer.cornerRadius = 8.0
        self.messageText.selectedRange = NSMakeRange(0, 0)
        
        self.initNetworkCommunication()
        
    }

    
    func keyboardDidShow(notification :NSNotification){
        println("A aparut")
        print("\(self.messageText.frame.origin)")
        var c = notification.userInfo
        
        
        UIView.beginAnimations(nil, context: nil)
        
        
        UIView.setAnimationDuration(0.25);
        print(" is the height \(self.messageText.frame.height)")
        ChatView.frame = CGRectMake(ChatView.frame.origin.x, 60, ChatView.frame.width, 150 )
        messageText.frame = CGRectMake(messageText.frame.origin.x,220,self.messageText.frame.width,self.messageText.frame.height);
        //CGRectMake(<#x: CGFloat#>, <#y: CGFloat#>, <#width: CGFloat#>, <#height: CGFloat#>)
        
        
        UIView.commitAnimations()
        
    }
    
    func keyboardDidHide(notification : NSNotification){
        println("A disparut"   )
        
        var x = self.messageText.frame
        x.origin.y = self.view.frame.height
        messageText.frame = x;
        //self.messageText.frame.origin.y += 80
        
        UIView.beginAnimations(nil, context: nil)
        
        
        UIView.setAnimationDuration(0.25);
        ChatView.frame = CGRectMake(0, 60, ChatView.frame.width, 300)
        messageText.frame = CGRectMake(0,450,self.messageText.frame.width,self.messageText.frame.height);
        

        [UIView.commitAnimations];

        
        //        NSIndexPath* ipath = [NSIndexPath indexPathForRow: cells_count-1 inSection: sections_count-1];
//        [tableView scrollToRowAtIndexPath: ipath atScrollPosition: UITableViewScrollPositionTop animated: YES];
//        
    }
    
   
    
    func initNetworkCommunication() {
        
        //declari niste stream-uri din care citesti si in care  scrii
        var readStream:Unmanaged<CFReadStream>?;
        var writeStream:Unmanaged<CFWriteStream>?     ;
        
        CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault,"localhost",8023,&readStream,&writeStream)
        
        inputStream = readStream!.takeUnretainedValue()
        outputStream = writeStream!.takeUnretainedValue()
        
        self.inputStream!.delegate=self
        self.outputStream!.delegate = self
        
        self.inputStream!.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
        self.outputStream!.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
        
        self.inputStream.open()
        self.outputStream.open()
        //println("\(UsernameField.text)");
        var msg = "iam:\(self.nameofSender).thirdView\r\n"
        //println("\(msg)")
        var ptr = msg.nulTerminatedUTF8
        var res = outputStream.write(msg, maxLength:msg.lengthOfBytesUsingEncoding(NSASCIIStringEncoding))
        messages[0]=""
    }

    func tableView (tableView:UITableView , cellForRowAtIndexPath indexPath : NSIndexPath)->UITableViewCell{
        var cellIdentifier = "MessageCell"
        var cell : UITableViewCell
        cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as UITableViewCell
        
        
        var st = indexPath
        
        if ( cell == nil){
            cell = UITableViewCell (style: UITableViewCellStyle.Default, reuseIdentifier: cellIdentifier)
        }
        
        var word:NSString
        word = messages[indexPath.row] as NSString
        if (word.containsString(":you")){
           // println("Trimite mesaj")
            var asd = word.componentsSeparatedByString(":")[0] as NSString
            print("\(asd) este textul")
            var ceva = asd
            cell.textLabel.text = asd
            cell.textLabel.textColor = UIColor.orangeColor()
            cell.layer.borderWidth = 0.4
            cell.layer.borderColor = UIColor.lightGrayColor().CGColor
            cell.layer.cornerRadius = 8.0
            
            
        
        }
        else if (word.containsString(":he")){
           // println("Rimeste mesaj")
            var asd = word.componentsSeparatedByString(":")[0] as NSString
            cell.textLabel.text = asd
            cell.textLabel.textColor = UIColor.blueColor()
            cell.textLabel.textAlignment = NSTextAlignment.Right
            cell.layer.borderWidth = 0.4
            cell.layer.borderColor = UIColor.lightGrayColor().CGColor
            cell.layer.cornerRadius = 8.0
        }
        if word.containsString("has joined"){
            return cell
        }
        else{
            
        cell.textLabel.text = word
        
        }
        return cell
    }
    
    
       func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        
        println("Good Job")
        
    }
    
    func tableView(tableView:UITableView ,numberOfRowsInSection section :NSInteger)->Int{
    
        return self.messages.count
    }
    
    func tableView(tableView :UITableView , heightForRowAtIndexPath  indexPath :NSIndexPath ) ->CGFloat{
        var text = messages[indexPath.row ] as NSString
        var rowSize = CGSizeMake(CGFloat(text.length), 20)
        
        return rowSize.height + 10
    }
    
    func stream(theStream:NSStream , handleEvent streamEvent: NSStreamEvent) {
        switch(streamEvent){
        case NSStreamEvent.OpenCompleted :
            println("Opened correctly")
        case NSStreamEvent.HasBytesAvailable :
            if (theStream == inputStream){
               // println("macar intra aici pe receive")
                var len : Int
                var buffer : UnsafePointer<uint_fast8_t>!
                while (inputStream.hasBytesAvailable){
                    let buffer2=UnsafePointer<UInt8>.alloc(120);
                    len = inputStream.read(buffer2, maxLength: 120)
                    if(len>0){
                        var output = NSString(bytes: buffer2, length: len, encoding: NSASCIIStringEncoding)
                        //aici trebuie sa faci si tu un split sa vezi daca e numele tau cel de la care a trimis
                        //si daca e sa afisezi cu alta culoare si vezi daca nu e numele tau afisezi c u alta culoare
                        
                        //REMINDER: nu uita de treaba aia cu variabila dintr-un controller in altul
                        if ( output == nil){
                            
                        }
                        else{
                            
                            println("Server said : \(output)")
                            self.messageReceived(output)
                            
                            println(" \(messages)  ")
                            ChatView?.reloadData()
                            
                        }
                    }
                }
                
            }
        
        case NSStreamEvent.ErrorOccurred :
            println("Can not connect to the host")
        case NSStreamEvent.EndEncountered :
            println("Here it is")
            
        default:
            println("Unknown event")
        }
    }
    func messageReceived(msg:NSString){
        var split :NSArray
        var text = msg
        
        split = msg.componentsSeparatedByString(":")
        var ceva :NSString
        ceva = msg
        // text = split.objectAtIndex(1) as NSString
        // var ceva = String()
        if msg.containsString("You just sent a message"){
            //mie prima si prima data imi vine o lista de utilizatori si am zis sa o modific aici ca sa nu am nici-o surpriza.
            //fac vectorul frumos si il urc mai sus
            ceva = "ALTA BUCURIE"
            var partOfIt = msg.componentsSeparatedByString("\n")[1].componentsSeparatedByString(":")[6] as NSString
            ceva = "\(partOfIt):you "
            
            messages[pos] = ceva;
            pos++
        }
        else if msg.containsString("you have a message") {
            var fromuser = msg.componentsSeparatedByString("\n")[1].componentsSeparatedByString(":")[2] as NSString
            //println("asdasd ads asd\(fromuser)")
            if fromuser == self.receiverLabel.text  {
                
                //println("asdasd ads asd\(fromuser)")
                var partOfIt = msg.componentsSeparatedByString("\n")[1].componentsSeparatedByString(":")[6] as NSString
                var ceva = "\(partOfIt):he"
                messages[pos] = ceva;
                pos++
            }
           else{
                var partOfIt = msg.componentsSeparatedByString("\n")[1].componentsSeparatedByString(":")[6] as NSString
                var tuple = (partOfIt,fromuser)
                messagefrom.append(tuple)
                
               println("Deschide un view nou")
           }
        }
        else{
            messages[pos] = ceva;
            pos++
        }
        
    }
    
    // var timer : NSTimer
    //timer = NSTimer(timeInterval: 10, target: self, selector: "getMessages:", userInfo: nil, repeats: true)
//NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(yourMethod) userInfo:nil repeats:YES];
    func getMessages(){
        var msg = self.messageText.text as String!
        var uname = self.nameofSender as String!
        var hname = self.nameofReceiver as String!
       // println("Se apeleaza")
        var response = "messages:bla"
        var res : Int
        
        self.outputStream.write(response, maxLength :response.lengthOfBytesUsingEncoding(NSASCIIStringEncoding))
        
    
    }
 
    
    @IBAction func sendMessage(sender: UIButton!){
        
        var msg = self.messageText.text as String!
        var uname = self.nameofSender as String!
        var hname = self.nameofReceiver as String!
        
        var response = "msgtouser:"
            response += uname!
                response += ":"
                    response += hname!
                        response += ":" + msg
        var res : Int
        var timer : NSTimer
        timer = NSTimer(timeInterval: 0.2, target: self, selector: "getMessages:", userInfo: nil, repeats: true)

        self.outputStream.write(response, maxLength :response.lengthOfBytesUsingEncoding(NSASCIIStringEncoding))
    }
    
    
  
    
//    
//    -  (CGSize) calculateLabelHeightWith:(CGFloat)width text:(NSString*)textString
//    {
//    CGSize maximumSize = CGSizeMake(width, 9999);
//    CGSize size = [textString sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:14]
//    constrainedToSize:maximumSize
//    lineBreakMode:UILineBreakModeWordWrap];
//    return size;
//    }
//    use table cell height delegate method
//    
//    -(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//    {
//    //Get String for corresponding Row
//    NSString *stringObject=fullText;
//    //here i ave taken row width 320
//    CGSize rowSize=[Utils calculateLabelHeightWith:320 text:stringObject];
//    
//    return (rowSize.height+20);
//    }
    
    
}
