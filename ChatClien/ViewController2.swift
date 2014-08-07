//
//  ViewController2.swift
//  ChatClien
//
//  Created by iOS Developer on 29/07/14.
//  Copyright (c) 2014 meforme. All rights reserved.
//

import UIKit

class ViewController2: UIViewController,NSStreamDelegate {

 
    @IBOutlet var tableView: UITableView?
    @IBOutlet var textView: UITextField!
    var myData=["mere","pere","alune"]
    var inputStream : NSInputStream!
    var outputStrean : NSOutputStream!
    var message : NSMutableArray = [" "]
    var pos = 0
    var name = String()
    
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
        
        message[pos] = msg;
        pos++
    
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
        
//        self.inputStream.open()
//        self.outputStrean.open()
        
        
        
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
        else
        {
            cell.textLabel.text = word
        }
            return cell
        
    }
    
    func numberOfSectionsInTableView (tableView:UITableView)->Int{
        return 1
    }
    
    func tableView(tableView:UITableView ,numberOfRowsInSection section :NSInteger)->Int{
        return message.count
    }
    
    @IBAction func sendMessage(sender:UIButton){
    
        var message = textView.text
        var response = "msgtouser:"+self.name+":ion:" + message
        var data = response.nulTerminatedUTF8
        var res : Int
        outputStrean.write(response, maxLength: data.count)
        
        
        println("\(response)")
    }
}
