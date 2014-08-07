//
//  ViewController.swift
//  ChatClien
//
//  Created by iOS Developer on 29/07/14.
//  Copyright (c) 2014 meforme. All rights reserved.
//

import UIKit


class ViewController: UIViewController,NSStreamDelegate{
                            
    @IBOutlet var JoinButton: UIButton!
    @IBOutlet var UsernameField: UITextField!
    var inputStream : NSInputStream!
    var outputStrean : NSOutputStream!
    var name: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.initNetworkCommunication()
        name=UsernameField.text
    }
   
    
    func initNetworkCommunication() {
        
        //declari niste stream-uri din care citesti si in care  scrii
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
        
 
        
    }
    func getName()->String!{
        return self.name
    }
    func getInputStream()->NSInputStream{
        return self.inputStream
    }
    func getOutputStream()->NSOutputStream{
        return self.outputStrean
    }
    @IBAction func joinChat (sender:UIButton){
       
        //variabila name din viewController2 e initializata cu asta.
        var FirstView :ViewController2
        FirstView = self.storyboard.instantiateViewControllerWithIdentifier("SecondView") as ViewController2
        FirstView.name = UsernameField.text
        FirstView.inputStream = self.inputStream
        FirstView.outputStrean = self.outputStrean
        self.presentViewController(FirstView, animated: true, completion:nil)
        var response : NSString!
        var actualResponse : NSData!
        response = "iam:" + UsernameField.text
        
        //daca iti pica functia asta inseamna ca e de   aici
        actualResponse = response.dataUsingEncoding(NSASCIIStringEncoding)
        
        //iau continutul raspunsului final : iam:tudor <-asta inseamna raspuns final
        var length : UInt8

        var res:Int
        println("\(UsernameField.text)");
        var msg = "iam:" + UsernameField.text+"\n"
        println("\(msg)")
        var ptr = msg.nulTerminatedUTF8
        res = outputStrean.write(msg, maxLength:10)
        
        self.viewWillDisappear(true)
      //  ViewController2.viewWillAppear(UIViewController)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

