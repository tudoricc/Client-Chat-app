//
//  ViewController2.swift
//  ChatClien
//
//  Created by iOS Developer on 29/07/14.
//  Copyright (c) 2014 meforme. All rights reserved.
//

import UIKit

class ViewController2: UIViewController,NSStreamDelegate {

 
    @IBOutlet var tableView: UITableView!
    @IBOutlet var textView: UITextField!
    var myData=["mere","pere","alune"]
    var inputStream : NSInputStream!
    var outputStrean : NSOutputStream!
    var message : NSMutableArray = [" "]
    var pos = 0
    var name = String()
    var nameofreceiver : NSString!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.initNetworkCommunication()
        // Do any additional setupnumberOfRowsInSectionew.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    //var ceva:enum
    
    
    func stream(theStream:NSStream , handleEvent streamEvent: NSStreamEvent) {
        switch(streamEvent){
        case NSStreamEvent.OpenCompleted :
            println("Opened correctly")
        case NSStreamEvent.HasBytesAvailable :
            if (theStream == inputStream){
                
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
                            
                            println(" \(message)  ")
                            tableView?.reloadData()
                            
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
        var ceva = msg
           // text = split.objectAtIndex(1) as NSString
       // var ceva = String()
        if msg.containsString("Users"){
            //mie prima si prima data imi vine o lista de utilizatori si am zis sa o modific aici ca sa nu am nici-o surpriza.
            //fac vectorul frumos si il urc mai sus
            ceva = "ALTA BUCURIE"
            
            var smth = msg.componentsSeparatedByString(":")
            var word = ""
            for i in (1..<smth.count){
                var hey = smth[i] as NSString
                var elst = ""
                elst += hey as NSString
                var word2 : NSString
                //word2 += elst + " "
            
                message[pos] = smth[i];
                pos++
            }
        }
        else{
            message[pos] = ceva;
            pos++
        }
    
    }
    func initNetworkCommunication() {
       

      //  declari niste stream-uri din care citesti si in care  scrii
        var readStream:Unmanaged<CFReadStream>?;
        var writeStream:Unmanaged<CFWriteStream>?     ;
        
        CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault,"localhost",8023,&readStream,&writeStream)
        
        inputStream = readStream!.takeUnretainedValue()
        outputStrean = writeStream!.takeUnretainedValue()
        
        self.inputStream!.delegate=self
        self.outputStrean!.delegate = self
        
        self.inputStream!.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
        self.outputStrean!.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
        
        self.inputStream.open()
        self.outputStrean.open()
        
        //println("\(UsernameField.text)");
        var msg = "iam:" + self.name+".secView"+"\r\n"
        //println("\(msg)")
        var ptr = msg.nulTerminatedUTF8
        var res = outputStrean.write(msg, maxLength:msg.lengthOfBytesUsingEncoding(NSASCIIStringEncoding))
        message[0]=""
        
    }
    func tableView (tableView:UITableView , cellForRowAtIndexPath indexPath : NSIndexPath)->UITableViewCell{
        var cellIdentifier = "Cell"
        var cell :UITableViewCell
      
        cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as UITableViewCell
        
        var st = indexPath

        if (cell == nil){
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellIdentifier)
        }
        var word:NSString
        word=message[indexPath.row] as NSString
        if word.containsString("You just sent a message"){
            cell.textLabel.text = word.componentsSeparatedByString("\n")[1].componentsSeparatedByString(":")[6] as NSString}
        if word.containsString("Users"){
            var smth = word.componentsSeparatedByString(":")
            var word = ""
            for i in (1..<smth.count){
                var hey = smth[i] as NSString
                print("\(self.name) is ma name")
                if hey != "\(self.name)" || hey != "\(self.name).secView" {
                    
                    var elst = ""
                    elst += hey as NSString
                    word += elst + " "
                    cell.textLabel.text = word
                }
            }
            
        }
        if word.containsString("has joined"){
            return cell
        }
        else
        {
            cell.textLabel.text = word
        }
            return cell
        
    }
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        println("You selected cell #\(indexPath.row)!")
        let vc: AnyObject! = self.storyboard.instantiateViewControllerWithIdentifier("ChatView")
        
        nameofreceiver = self.message[indexPath.row] as NSString
        var ChatView :ViewController3
        ChatView = self.storyboard.instantiateViewControllerWithIdentifier("ChatView") as ViewController3
        ChatView.nameofSender = self.name
        
        ChatView.nameofReceiver = self.message[indexPath.row] as NSString
        
        
        self.presentViewController(ChatView, animated: true, completion:nil)
        
        //daca pica ai grija ca se poate sa fie aici
        
        self.inputStream.close()
        self.outputStrean.close()
        }
    
    func tableView(tableView:UITableView ,numberOfRowsInSection section :NSInteger)->Int{
        return message.count
    }
    
    
    
    @IBAction func sendMessage(sender:UIButton){
        
        
        //Eu zic sa nu mai facem o actiune sa facem intruna asta.
        //TODO sa nu mai apasam intruna pe acest buton sa faca la fiecare afisare
        var message = textView.text
        var response = "users:ion\r\n"
    
        var res : Int
        outputStrean.write(response, maxLength: response.lengthOfBytesUsingEncoding(NSASCIIStringEncoding))
        
       
        //println("\(response)")
    }
}
