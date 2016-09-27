//
//  Chat2ViewController.swift
//  SwiftExample
//
//  Created by LvApril on 9/14/16.
//  Copyright © 2016 MacMeDan. All rights reserved.
//

import FirebaseAuth
import FirebaseDatabase
import Firebase
import Alamofire
import SDWebImage
import MobileCoreServices
import AVFoundation
import AVKit
import MBProgressHUD
//import SwiftExample.Swift

class Chat2ViewController: ZHCMessagesViewController,UIImagePickerControllerDelegate
    , UINavigationControllerDelegate
    ,ChatMapViewControllerDelegate, CLLocationManagerDelegate
    {

    
    
    var datachaturl = "https://hapapp-dc7be.firebaseio.com/chats"
    var storageUrl = "gs://hapapp-dc7be.appspot.com"
    var pictburl = "chatpic/iphone"
    var filetburl = "chatfile/iphone"
    var videotburl = "chatvideo/iphone"
    var voicetburl = "chatvoice/iphone"
    var idfeedplaces1 : NSInteger?
    var idfp3 : NSInteger?
    override func viewDidLoad() {
        super.viewDidLoad()
//        FBUER
        if let users = NSUserDefaults.standardUserDefaults().valueForKey(ChatConstants.FBUserName) as? String {
            self.userName = users
        }
        if let users = NSUserDefaults.standardUserDefaults().valueForKey(ChatConstants.FBUserId) as? String {
            self.userID = users
        }
        
        if NSUserDefaults.standardUserDefaults().integerForKey(ChatConstants.FBAuthed) ?? 0 == 1 {
            datachaturl = datachaturl + "/\(idfp3 ?? 0)"
            let refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: Selector(setupFirebase0()),
                                     forControlEvents: .ValueChanged)
            self.refreshControl1 = refreshControl
            
            refreshControl.attributedTitle = NSAttributedString(string: "Loading more messages...")
            self.messageTableView?.addSubview(refreshControl)
        }else{
            let para=["phoneNumber": self.userID ?? ""
                ,"username": self.userName ?? ""];
            //let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            // hud.label.text = "Login..."
            Alamofire.request(.GET, ChatConstants.ServiceURL + ChatConstants.GetFirebaseTokenSeviceURL
                ,parameters: para)
                .responseJSON { response in
                    let JSON = response.result.value
                    if let customToken = JSON?.valueForKey("message") as? String{
                        //                        FIRApp.configure()
                        FIRAuth.auth()?.signInWithCustomToken(customToken) { (user, error) in
                            if let user = FIRAuth.auth()?.currentUser {
                                if user.uid == self.userID {
                                    NSUserDefaults.standardUserDefaults().setInteger(1, forKey: ChatConstants.FBAuthed)
                                    
                                }
                                
                                
                                self.datachaturl = self.datachaturl + "/\(self.idfp3 ?? 0)"
                                let refreshControl = UIRefreshControl()
                                refreshControl.addTarget(self, action: Selector(self.setupFirebase0()),
                                    forControlEvents: .ValueChanged)
                                self.refreshControl1 = refreshControl
                                
                                refreshControl.attributedTitle = NSAttributedString(string: "Loading more messages...")
                                self.messageTableView?.addSubview(refreshControl)
                            }
                        }
                        
                    }
                    
                    
            }
        }
        
    }
    
    
    var userName: String?
    var userID: String?
    override func senderDisplayName() -> String {
        return userName ?? ""
    }
    
    override func senderId() -> String {
        return userID ?? ""
    }

    override func tableView(tableView: ZHCMessagesTableView, messageDataForCellAtIndexPath indexPath: NSIndexPath) -> ZHCMessageData {
        return messages[indexPath.row]
    }
    
    override func tableView(tableView: ZHCMessagesTableView, messageBubbleImageDataForCellAtIndexPath indexPath: NSIndexPath) -> ZHCMessageBubbleImageDataSource? {
        
        let bf = ZHCMessagesBubbleImageFactory()
        let msg = self.messages[indexPath.row]
        let a = UIColor(red: 0.9016, green: 0.9016, blue: 0.92, alpha:  1)
        return msg.senderId == self.senderId() ? bf.outgoingMessagesBubbleImageWithColor(a) : bf.incomingMessagesBubbleImageWithColor(a)
        if msg.senderId == self.senderId() {
            
            return bf.outgoingMessagesBubbleImageWithColor(UIColor.zhc_messagesBubbleBlueColor())
        }else{
            return bf.incomingMessagesBubbleImageWithColor(UIColor.zhc_messagesBubbleGreenColor())
        }
    }
    override func tableView(tableView: ZHCMessagesTableView, avatarImageDataForCellAtIndexPath indexPath: NSIndexPath) -> ZHCMessageAvatarImageDataSource? {
        
//        ZHCMessagesAvatarImageFactory *avatarFactory = [[ZHCMessagesAvatarImageFactory alloc] initWithDiameter:kZHCMessagesTableViewCellAvatarSizeDefault];
//        ZHCMessagesAvatarImage *cookImage = [avatarFactory avatarImageWithImage:[UIImage imageNamed:@"demo_avatar_cook"]];
        
        let af = ZHCMessagesAvatarImageFactory(diameter: 35)
        let img = af.avatarImageWithImage(UIImage(named: "avatar"))
        return img
    }
    
    override func tableView(tableView: ZHCMessagesTableView, attributedTextForCellTopLabelAtIndexPath indexPath: NSIndexPath) -> NSAttributedString {
//        if (indexPath.row %3 == 0) {
//            ZHCMessage *message = [self.demoData.messages objectAtIndex:indexPath.row];
//            return [[ZHCMessagesTimestampFormatter sharedFormatter]attributedTimestampForDate:message.date];
//        }
//        return nil;
        if indexPath.row % 3 == 0 {
            let msg = self.messages[indexPath.row]
//        let var = zhc
//        print(ZHCMessagesTimestampFormatter.sharedFormatter().attributedTimestampForDate(msg.date))
            return ZHCMessagesTimestampFormatter.sharedFormatter().attributedTimestampForDate(msg.date)
        }
//        }
        return NSAttributedString(string: "")
//        return ZHCMessagesTimestampFormatter.sharedFormatter().attributedTimestampForDate(msg.date)

    }
    
    
//    override func tableView(tableView: ZHCMessagesTableView, heightForCellTopLabelAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//         if indexPath.row % 3 == 0 {
//            return 20.0
//        }
//        return 0
//    }
    
    override func tableView(tableView: ZHCMessagesTableView, heightForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath) -> CGFloat {

         return 20.0
    }
    
   override func tableView(tableView: ZHCMessagesTableView, heightForCellBottomLabelAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let msg = self.messages[indexPath.row]
    if msg.isMediaMessage {
    return 0.0
    }
    return 20.0
    }
    

    
    override func tableView(tableView: ZHCMessagesTableView, attributedTextForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath) -> NSAttributedString? {
        
        let msg = self.messages[indexPath.row]
//        if msg.senderId == self.senderId() {
//            return nil
//        }
//        
//        if indexPath.row > 0 {
//            let msg0 = self.messages[indexPath.row - 1]
//            if msg0.senderId == msg.senderId {
//                return nil
//            }
//        }
        
        var aa = ZHCMessagesTimestampFormatter.sharedFormatter().attributedTimestampForDate(msg.date)
        
        
        return NSAttributedString(string: msg.senderDisplayName + " @ " + aa.string)
    }
    
    override func tableView(tableView: ZHCMessagesTableView, attributedTextForCellBottomLabelAtIndexPath indexPath: NSIndexPath) -> NSAttributedString? {
        return nil
    }
    
    
    
    
    
    var messages =  [ZHCMessage]()
    
    func buildLocationItem(lat: Double, lng: Double) -> ZHCLocationMediaItem {
        
        let ferryBuildingInSF = CLLocation(latitude: lat, longitude: lng)
        let locationItem = ZHCLocationMediaItem(location: ferryBuildingInSF)
        return locationItem
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        if let c = cell as? ZHCMessagesTableViewCell {
            c.textView?.textColor = UIColor.blackColor();
        }
        return cell
    }
    
    func setupFirebase0() {
        if self.messages.count == 0 {
            self.refreshControl1?.endRefreshing()
            self.setupFirebase()
        }else{
            self.setupFirebaseMore()
            
        }
    }
    
    override func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if self.refreshControl1?.refreshing ?? false {
            self.setupFirebase0()
        }
    }
    
    func setupFirebaseMore() {
       
        let a = FIRDatabase.database()
        let  messagesRef =  a.referenceFromURL(datachaturl)
        if let msg0 = self.messages.first {
            let lastCreadate = Int(msg0.date.timeIntervalSince1970)
//        let lastCreadate = Int(NSDate().timeIntervalSince1970)
            print(lastCreadate)
            var i = 0
             let aaaa = messagesRef.queryOrderedByChild("creadate").queryEndingAtValue(lastCreadate)
//            messagesRef.child("message").observeEventType(.Value, withBlock: {(snapshot) in
//                self.refreshControl1?.endRefreshing()
//            })
            
            aaaa.queryLimitedToLast(UInt(25)).observeEventType(.Value, withBlock: {(snapshot) in
                self.refreshControl1?.endRefreshing()
                
                    let dic = snapshot.value
                    print(dic)
                
                    let text = dic?.valueForKey("message") as? String
                    let senderID = (dic?.valueForKey("telephoneNo") as? String) ?? (dic?.valueForKey("username") as? String)
                let senderName = (dic?.valueForKey("username") as? String)
                    let imageUrl = dic?.valueForKey("pic") as? String
                    let creadate = dic?.valueForKey("creadate") as? NSInteger
                    let fileurl = dic?.valueForKey("fileurl") as? String
                    let gps = dic?.valueForKey("gps") as? Bool
                    let latitude = dic?.valueForKey("latitude") as? Double
                    let longitude = dic?.valueForKey("longitude") as? Double
                    let voice = dic?.valueForKey("voice") as? String
                    let voicemsecond = dic?.valueForKey("voicemsecond") as? Double
                    
                    let videotime = dic?.valueForKey("videotime") as? Double
                    let video = dic?.valueForKey("video") as? String
                    //            if (videotime == 8581 && sender == "jack") {
                    //
                    //            }
                    
                    //            print(self.sendingDate, creadate)
                    
                    //            videosnapshot:
                    //            "https://firebasestorage.googleapis.com/v0/b/bas..."
                    let videosnapshot = dic?.valueForKey("videosnapshot") as? String
                    
                    let msgDate = creadate != nil ? NSDate.init(timeIntervalSince1970: Double(creadate!)) : NSDate()
                    //            print(msgDate, creadate, voice)
                    var copyMessage :ZHCMessage?
                    if (lastCreadate == creadate || snapshot.value == nil){
                        
                    }else if gps ?? false {
                        // location
                        
                        let mapsurl = "https://maps.google.com/maps/api/staticmap?markers=color:red%7C\(latitude ?? 0),\(longitude ?? 0)&zoom=16&size=300x250&sensor=true"
                        
                        let photoItem = ZHCPhoto2MediaItem(image: NSURL(string: mapsurl)!)
                        photoItem.lat = "\(latitude ?? 0)"
                        photoItem.lng = "\(longitude ?? 0)"
                        photoItem.appliesMediaViewMaskAsOutgoing = (senderID == self.senderId())
                        copyMessage = ZHCMessage(senderId: (senderID ?? ""), senderDisplayName: (senderName ?? ""), date: msgDate, media: photoItem)
                        
                        
                        
                    }else if voice != nil  && voice != ""{
                        // voice message
                        
                        let audioItem = ZHCAudioMediaItem()
                        
                        audioItem.appliesMediaViewMaskAsOutgoing = (senderID == self.senderId())
                        copyMessage = ZHCMessage(senderId: (senderID ?? ""), senderDisplayName: (senderName ?? ""), date: msgDate, media: audioItem)
                        //                print("fafsdfs");
                        //                print(voice!)
                        audioItem.audioDataURL = voice!
                        audioItem.audioDuration = ((voicemsecond ?? 0)/1000)
                        
                        Alamofire.request(.GET, voice!,parameters: nil).responseData(completionHandler: { (req) in
                            if req.result.error == nil {
                                audioItem.audioData = req.data
                            }
                        })
                        
                    }else if video != nil  && video != ""{
                        //video
                        //
                        let videoItem = ZHCVideoMediaItem(fileURL:NSURL(string: video!)!, isReadyToPlay: true)
                        if videosnapshot != nil  && videosnapshot != ""{
                            if let surl = NSURL(string: videosnapshot!){
                                videoItem.fileFirstPageURL = surl
                            }
                        }
                        
                        
                        videoItem.appliesMediaViewMaskAsOutgoing = (senderID == self.senderId())
                        copyMessage = ZHCMessage(senderId: (senderID ?? ""), senderDisplayName: (senderName ?? ""), date: msgDate, media: videoItem)
                    }else if imageUrl != nil  && imageUrl != ""{
                        // image
                        
                        
                        let photoItem = ZHCPhoto2MediaItem(image: NSURL(string: imageUrl!)!)
                        photoItem.appliesMediaViewMaskAsOutgoing = (senderID == self.senderId())
                        copyMessage = ZHCMessage(senderId: (senderID ?? ""), senderDisplayName: (senderName ?? ""), date: msgDate, media: photoItem)
                        
                        
                        
                        
                    }else if text != nil{
                        // text Message
                        //                let i = ZHCMediaItem()
                        //                i.appliesMediaViewMaskAsOutgoing = (sender == self.senderId())
                        print(senderID, senderName)
                        copyMessage = ZHCMessage(senderId: (senderID ?? ""), senderDisplayName: (senderName ?? ""), date: msgDate, text: text ?? "empty")
                        
                    }
                    
                    //            fasfdasfdsa
                    if let msg = copyMessage {
                        self.messages.insert(msg, atIndex: i)
                        i = i + 1
                        self.messageTableView?.reloadData()
                        self.finishReceivingMessage()
                    }
                })
            print("sssss")
            
        }
        
        
        
    }
    
    
    var refreshControl1 : UIRefreshControl?
    
    func setupFirebase() {
        
        
        let a = FIRDatabase.database()
        let  messagesRef =  a.referenceFromURL(datachaturl)
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.label.text = "Loading Data from server..."
        messagesRef.child("message").observeEventType(.Value, withBlock: {(snapshot) in
            hud.hideAnimated(true)
        })
        
        
        let query = messagesRef.queryLimitedToLast(UInt(25))
//        hud.hideAnimated(true)
        query.observeEventType(.ChildAdded, withBlock: {(snapshot) in
            
            let dic = snapshot.value
                        print(dic)
            
            let text = dic?.valueForKey("message") as? String
            let senderID = (dic?.valueForKey("telephoneNo") as? String) ?? (dic?.valueForKey("username") as? String)
            let senderName = (dic?.valueForKey("username") as? String)
            let imageUrl = dic?.valueForKey("pic") as? String
            let creadate = dic?.valueForKey("creadate") as? NSInteger
            let fileurl = dic?.valueForKey("fileurl") as? String
            let gps = dic?.valueForKey("gps") as? Bool
            let latitude = dic?.valueForKey("latitude") as? Double
            let longitude = dic?.valueForKey("longitude") as? Double
            let voice = dic?.valueForKey("voice") as? String
            let voicemsecond = dic?.valueForKey("voicemsecond") as? Double
            
            let videotime = dic?.valueForKey("videotime") as? Double
            let video = dic?.valueForKey("video") as? String
//            if (videotime == 8581 && sender == "jack") {
//                
//            }
            
//            print(self.sendingDate, creadate)
            
//            videosnapshot:
//            "https://firebasestorage.googleapis.com/v0/b/bas..."
let videosnapshot = dic?.valueForKey("videosnapshot") as? String
            
            let msgDate = creadate != nil ? NSDate.init(timeIntervalSince1970: Double(creadate!)) : NSDate()
            //            print(msgDate, creadate, voice)
            var copyMessage :ZHCMessage?
            if (self.sendingDate.contains(creadate ?? 0)){
                if self.sendingDate.count == 1 {
                    self.sendingDate.removeAll()
                }
            }else if gps ?? false {
                // location
                
                let mapsurl = "https://maps.google.com/maps/api/staticmap?markers=color:red%7C\(latitude ?? 0),\(longitude ?? 0)&zoom=16&size=300x250&sensor=true"
                
                let photoItem = ZHCPhoto2MediaItem(image: NSURL(string: mapsurl)!)
                photoItem.lat = "\(latitude ?? 0)"
                photoItem.lng = "\(longitude ?? 0)"
                photoItem.appliesMediaViewMaskAsOutgoing = (senderID == self.senderId())
                copyMessage = ZHCMessage(senderId: (senderID ?? ""), senderDisplayName: (senderName ?? ""), date: msgDate, media: photoItem)
                
                
                //let locationItem = self.buildLocationItem(latitude ?? 0, lng: longitude ?? 0)
                //locationItem.appliesMediaViewMaskAsOutgoing = (sender == self.senderId())
                //copyMessage = ZHCMessage(senderId: (sender ?? ""), senderDisplayName: (sender ?? ""), date: msgDate, media: locationItem)
            
                
                
            }else if voice != nil  && voice != ""{
                // voice message
                
                let audioItem = ZHCAudioMediaItem()
                
                audioItem.appliesMediaViewMaskAsOutgoing = (senderID == self.senderId())
                copyMessage = ZHCMessage(senderId: (senderID ?? ""), senderDisplayName: (senderName ?? ""), date: msgDate, media: audioItem)
//                print("fafsdfs");
//                print(voice!)
                audioItem.audioDataURL = voice!
                audioItem.audioDuration = ((voicemsecond ?? 0)/1000)
                
                Alamofire.request(.GET, voice!,parameters: nil).responseData(completionHandler: { (req) in
                    if req.result.error == nil {
                        audioItem.audioData = req.data
                    }
                })
                
            }else if video != nil  && video != ""{
                //video
//                
                let videoItem = ZHCVideoMediaItem(fileURL:NSURL(string: video!)!, isReadyToPlay: true)
                if videosnapshot != nil  && videosnapshot != ""{
                    if let surl = NSURL(string: videosnapshot!){
                        videoItem.fileFirstPageURL = surl
                    }
                }
                
                
                videoItem.appliesMediaViewMaskAsOutgoing = (senderID == self.senderId())
                copyMessage = ZHCMessage(senderId: (senderID ?? ""), senderDisplayName: (senderName ?? ""), date: msgDate, media: videoItem)
            }else if imageUrl != nil  && imageUrl != ""{
                // image
                
                
                    let photoItem = ZHCPhoto2MediaItem(image: NSURL(string: imageUrl!)!)
                    photoItem.appliesMediaViewMaskAsOutgoing = (senderID == self.senderId())
                    copyMessage = ZHCMessage(senderId: (senderID ?? ""), senderDisplayName: (senderName ?? ""), date: msgDate, media: photoItem)
               
                
                
                
            }else{
                // text Message
//                let i = ZHCMediaItem()
//                i.appliesMediaViewMaskAsOutgoing = (sender == self.senderId())
                copyMessage = ZHCMessage(senderId: (senderID ?? ""), senderDisplayName: (senderName ?? ""), date: msgDate, text: text ?? "empty")
                
            }
            
//            fasfdasfdsa
            if let msg = copyMessage {
                self.messages.append(msg)
                self.messageTableView?.reloadData()
                self.finishReceivingMessage()
            }
        })
        print("fasdfasdf")
    }
    
    override func messagesMoreViewTitles(moreView: ZHCMessagesMoreView) -> [AnyObject] {
        return ["","","",""]
//        return ["Camera","Photos","Location"];
    }
    override func messagesMoreViewImgNames(moreView: ZHCMessagesMoreView) -> [AnyObject] {
//        return ["","",""]
        return ["camera","image", "videocam", "location"]
    }
    
    override func messagesInputToolbar(toolbar: ZHCMessagesInputToolbar, sendVoice voiceFilePath: String, seconds senconds: NSTimeInterval) {
//        print(voiceFilePath, senconds)
        let url = NSURL(fileURLWithPath: voiceFilePath)
        
            let storage = FIRStorage.storage()
            let storageRef = storage.referenceForURL(storageUrl)
            let date = NSDate()
            let a = Int(date.timeIntervalSince1970)
            let riversRef = storageRef.child(voicetburl + "\(a).caf")
            //        let data: NSData = UIImageJPEGRepresentation(img,0.5)!
            // Create a reference to the file you want to upload
            //        let riversRef = storageRef.child("images/rivers.jpg")
            
            // Upload the file to the path "images/rivers.jpg"
        
        let audioItem = ZHCAudioMediaItem()
        
        audioItem.appliesMediaViewMaskAsOutgoing = true
        let copyMessage = ZHCMessage(senderId: self.senderId(), senderDisplayName: self.senderId(), date: date, media: audioItem)
        audioItem.audioDataURL = voiceFilePath
        audioItem.audioDuration = senconds
        audioItem.audioData = NSData(contentsOfURL: url)
        self.messages.append(copyMessage)
        self.sendingDate.append(a)
        self.messageTableView?.reloadData()
        self.finishReceivingMessage()
        
            let metadata = FIRStorageMetadata()
//            metadata.contentType = "audio/mp4a-latm"
             metadata.contentType = "audio/x-caf"
            riversRef.putFile(url, metadata: metadata).observeStatus(.Success) { (snapshot) in
                // When the image has successfully uploaded, we get it's download URL
                let text = snapshot.metadata?.downloadURL()?.absoluteString
                            print(text)
                let ref = FIRDatabase.database()
                let  messagesRef =  ref.referenceFromURL(self.datachaturl)
                
                
                //            let b : NSInteger = a
                
                //            let videotime = dic?.valueForKey("videotime") as? Double
                //            let video = dic?.valueForKey("video") as? String
                
                messagesRef.childByAutoId().setValue([
                    "message": "",
                    "username": self.senderDisplayName(),
                    "telephoneNo": self.senderId(),
                    "pic": "",
                    "creadate": a,
                    "fileurl" : "",
                    "gps": false,
                    "latitude": 0.0,
                    "longitude" : 0.0,
                    "voice": text ?? "",
                    "voicemsecond": Double(senconds*1000),
                    "video": "",
                    "videotime": 0
                    ])
                self.updateChatCnt()
                self.finishSendingMessageAnimated(true)
            }
        
    }
    
    
    override func messagesMoreView(moreView: ZHCMessagesMoreView, selectedMoreViewItemWithIndex index: Int) {
        switch index {
        case 0:
            //camera
            takePhoto()
        case 1:
            //
            choosePhotoFromLibray()
        case 2:
            takeVedio()
        case 3:
            sendLocation()
        default:
            break
        }
    }
    
    @IBAction func goback(sender: AnyObject) {
        backButtonTapped()
    }
    func backButtonTapped() {
        //        dismissViewControllerAnimated(true, completion: nil)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    let imagePicker =  UIImagePickerController()
    
    func choosePhotoFromLibray() {
//        self.dorecover()
        self.imagePicker.delegate = self
//        self.imagePicker.allowsEditing = true
        self.imagePicker.sourceType = .PhotoLibrary
        self.imagePicker.mediaTypes = [(kUTTypeMovie as String)
            , (kUTTypeImage as String)
            , (kUTTypeJPEG as String)
            , (kUTTypeJPEG2000 as String)
            , (kUTTypePNG as String)
            , (kUTTypeGIF as String)
            , (kUTTypeQuickTimeImage as String)
            , (kUTTypeBMP as String)
            , (kUTTypeRawImage as String)
            , (kUTTypeLivePhoto as String)
            , (kUTTypeVideo as String)
            , (kUTTypeMPEG2Video as String)
            , (kUTTypeMPEG4 as String)
            , (kUTTypeMPEG4Audio as String)
            , (kUTTypeAppleProtectedMPEG4Video as String)
            , (kUTTypeAVIMovie as String)]
        //        self.imagePicker.cameraCaptureMode = .Photo
        self.presentViewController(self.imagePicker, animated: true, completion: nil)
    }
    
    func takeVedio(){
//        self.dorecover()
        self.imagePicker.delegate = self
//        self.imagePicker.allowsEditing = true
        self.imagePicker.sourceType = .Camera
        self.imagePicker.mediaTypes = [(kUTTypeMovie as String)]
        self.imagePicker.cameraCaptureMode = .Video
        self.presentViewController(self.imagePicker, animated: true, completion: nil)
        
    }
    func takePhoto(){
//        self.dorecover()
        self.imagePicker.delegate = self
        self.imagePicker.allowsEditing = true
        self.imagePicker.sourceType = .Camera
        self.imagePicker.mediaTypes = [(kUTTypeImage as String)]
        self.imagePicker.cameraCaptureMode = .Photo
        self.presentViewController(self.imagePicker, animated: true, completion: nil)
        
    }
    func choosePhoto() {
//        self.dorecover()
        let alert: UIAlertController = UIAlertController(title: "Photo", message: nil, preferredStyle: .Alert)
        
        //Create and add the OK action
        let oKAction: UIAlertAction = UIAlertAction(title: "Photo Library", style: .Default) { action -> Void in
            //Do some stuff
            //            let imagePicker =  UIImagePickerController()
            self.imagePicker.delegate = self
            //            imagePicker?.allowsEditing = true
            self.imagePicker.sourceType = .PhotoLibrary
            self.presentViewController(self.imagePicker, animated: true, completion: nil)
        }
        alert.addAction(oKAction)
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Take Photo", style: .Cancel) { action -> Void in
            //Do some stuff
            //            let imagePicker =  UIImagePickerController()
            self.imagePicker.delegate = self
            //            imagePicker?.allowsEditing = true
            self.imagePicker.sourceType = .Camera
            self.imagePicker.cameraCaptureMode = .Photo
            self.presentViewController(self.imagePicker, animated: true, completion: nil)
        }
        
        alert.addAction(cancelAction)
        
        //Present the AlertController
        self.presentViewController(alert, animated: true, completion: nil)
        
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                        print(image.imageOrientation)
            
            uploadAttachedPhoto(image)
        }else if let pickedVideo:NSURL = (info[UIImagePickerControllerMediaURL] as? NSURL) {
            uploadAttachedVideo(pickedVideo, time: 0)
        }
    }
    
    var sendingDate = [Int]()
    private func uploadAttachedPhoto(img:  UIImage){
        let storage = FIRStorage.storage()
        let storageRef = storage.referenceForURL(storageUrl)
        let date = NSDate()
        let a = Int(date.timeIntervalSince1970)
        
        let riversRef = storageRef.child(pictburl + "\(a).jpg")
        let data: NSData = UIImageJPEGRepresentation(img,0.5)!
        // Create a reference to the file you want to upload
        //        let riversRef = storageRef.child("images/rivers.jpg")
        
        // Upload the file to the path "images/rivers.jpg"
        
        let photoItem = ZHCPhotoMediaItem(image: img)
//        photoItem.imageData = img
        photoItem.appliesMediaViewMaskAsOutgoing = true
        let copyMessage = ZHCMessage(senderId: self.senderId(), senderDisplayName: (self.senderId()), date: date, media: photoItem)
        self.sendingDate.append(a)
        self.messages.append(copyMessage)
        self.messageTableView?.reloadData()
        self.finishSendingMessageAnimated(true)
        
        let metadata = FIRStorageMetadata()
        metadata.contentType = "image/jpg"
        riversRef.putData(data, metadata: metadata).observeStatus(.Success) { (snapshot) in
            // When the image has successfully uploaded, we get it's download URL
            let text = snapshot.metadata?.downloadURL()?.absoluteString
//            print(text)
            let ref = FIRDatabase.database()
            let  messagesRef =  ref.referenceFromURL(self.datachaturl)
            
            
            //            let b : NSInteger = a
            messagesRef.childByAutoId().setValue([
                "message": "",
                "username": self.senderDisplayName(),
                "telephoneNo": self.senderId(),
                "pic":text ?? "",
                "creadate": a,
                "fileurl" : "",
                "gps": false,
                "latitude": 0.0,
                "longitude" : 0.0,
                "voice": "",
                "voicemsecond": 0
                ])
            self.updateChatCnt()
            
        }
        
    }
    
    private func uploadAttachedVideo(url:  NSURL, time: Double){
//        print(url.absoluteString, time)
        //        return
        let storage = FIRStorage.storage()
        let storageRef = storage.referenceForURL(storageUrl)
        let date = NSDate()
        let a = Int(date.timeIntervalSince1970)
        let riversRef0 = storageRef.child(pictburl + "\(a).jpg")
        let riversRef = storageRef.child(videotburl + "\(a).MOV")
        //        let data: NSData = UIImageJPEGRepresentation(img,0.5)!
        // Create a reference to the file you want to upload
        //        let riversRef = storageRef.child("images/rivers.jpg")
        
        
       
        
        
        
        // Upload the file to the path "images/rivers.jpg"
        
        let metadata = FIRStorageMetadata()
        metadata.contentType = "video/quicktime"
        
        var err: NSError? = nil
        let asset = AVURLAsset(URL: url, options: nil)
        let imgGenerator = AVAssetImageGenerator(asset: asset)
        
        
        do {
            imgGenerator.appliesPreferredTrackTransform = true
             let cgImage = try imgGenerator.copyCGImageAtTime(CMTimeMake(0, 1), actualTime: nil)
//            debugPrint("Could not find resource \(name).\(type)")
            let uiImage = UIImage(CGImage: cgImage)
            
            let videoItem = ZHCVideoMediaItem(fileURL:url, isReadyToPlay: true)
            videoItem.fileFirstPageImage = uiImage
            videoItem.appliesMediaViewMaskAsOutgoing = true
            let copyMessage = ZHCMessage(senderId: self.senderId()
                , senderDisplayName: self.senderId()
                , date: date, media: videoItem)
            self.sendingDate.append(a)
            self.messages.append(copyMessage)
            self.messageTableView?.reloadData()
            self.finishSendingMessageAnimated(true)
            
            
            let metadata0 = FIRStorageMetadata()
            metadata0.contentType = "image/jpg"
            let data: NSData = UIImageJPEGRepresentation(uiImage,0.5)!
            
            riversRef0.putData(data, metadata: metadata0).observeStatus(.Success) { (snapshot0) in
            let text0 = snapshot0.metadata?.downloadURL()?.absoluteString
                print(text0)
                riversRef.putFile(url, metadata: metadata).observeStatus(.Success) { (snapshot) in
                    // When the image has successfully uploaded, we get it's download URL
                    let text = snapshot.metadata?.downloadURL()?.absoluteString
                                print(text)
                    let ref = FIRDatabase.database()
                    let  messagesRef =  ref.referenceFromURL(self.datachaturl)
                    
                    
                    //            let b : NSInteger = a
                    
                    //            let videotime = dic?.valueForKey("videotime") as? Double
                    //            let video = dic?.valueForKey("video") as? String
                    
                    messagesRef.childByAutoId().setValue([
                        "message": "",
                        "username": self.senderDisplayName(),
                        "telephoneNo": self.senderId(),
                        "videosnapshot": text0 ?? "",
                        "pic": "",
                        "creadate": a,
                        "fileurl" : "",
                        "gps": false,
                        "latitude": 0.0,
                        "longitude" : 0.0,
                        "voice": "",
                        "voicemsecond": 0,
                        "video": text ?? "",
                        "videotime": time
                        ])
                    self.updateChatCnt()
                    self.finishSendingMessageAnimated(true)
                }
            }
            
            return
        } catch {
            debugPrint("Generic error")
        }
        
    }
    var locationManager: CLLocationManager?
    func sendLocation() {
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        //        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        let authorizationStatus = CLLocationManager.authorizationStatus()
        if (authorizationStatus == CLAuthorizationStatus.NotDetermined) {
            locationManager?.requestWhenInUseAuthorization()
        } else if (authorizationStatus == CLAuthorizationStatus.AuthorizedWhenInUse) {
            self.performSegueWithIdentifier("ToMap", sender: nil)
        }   else{
            let winner = UIAlertController(title: "BA-Chat",message: "Please turn on location service with this app in order to use this function.",preferredStyle: UIAlertControllerStyle.Alert)
            let cancelAction = UIAlertAction(title: "OK",style: .Default,handler: {action in [
                //                self.settingRoundNumber()
                //                //            self.gameStart()
                //                //这里写了两个方法，在必要的时候可以更改
                ]})
            winner.addAction(cancelAction)
            self.presentViewController(winner,animated:true,completion:nil)
        }
        
        
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if (status == CLAuthorizationStatus.AuthorizedWhenInUse) {
            self.performSegueWithIdentifier("ToMap", sender: nil)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "ToMap":
                if let con = segue.destinationViewController as? MapViewController {
                    con.delegate = self
                }
            case "ToMap2":
                if let con = segue.destinationViewController as? Map2ViewController, let photo = sender as? ZHCPhoto2MediaItem {
                    
                    con.corr = CLLocationCoordinate2D(latitude: Double(photo.lat ?? "0.0")!, longitude:Double(photo.lng ?? "0.0")!)
                }
//            case "ToMP":
//                if let con = segue.destinationViewController as? MicrophoneViewController {
//                    con.delegate = self
//                }
            default:
                break
            }
        }
    }
    
    func sendLocationS(l: CLLocationCoordinate2D, address: String?) {
        //        let text = snapshot.metadata?.downloadURL()?.absoluteString
        //            print(text)
        let ref = FIRDatabase.database()
        let  messagesRef =  ref.referenceFromURL(self.datachaturl)
        
        
        //            let b : NSInteger = a
        
        //            let videotime = dic?.valueForKey("videotime") as? Double
        //            let video = dfdic?.valueForKey("video") as? String
        let a = NSDate().timeIntervalSince1970
                let b : NSInteger = Int(a)
        
        let lat = Double(l.latitude)
        let lng = Double(l.longitude)
        
        messagesRef.childByAutoId().setValue([
            "message": address ?? "",
            "username": self.senderDisplayName(),
            "telephoneNo": self.senderId(),
            "pic": "",
            "creadate": a,
            "fileurl" : "",
            "gps": true,
            "latitude": lat,
            "longitude" : lng,
            "voice": "",
            "voicemsecond": 0,
            "video": "",
            "videotime": 0
            ])
        updateChatCnt()
        self.finishSendingMessageAnimated(true)
    }
    
    override func didPressSendButton(button: UIButton?, withMessageText text: String, senderId: String, senderDisplayName: String, date: NSDate) {
        let ref = FIRDatabase.database()
        let  messagesRef =  ref.referenceFromURL(datachaturl)
        
        let a = date.timeIntervalSince1970
        let b : NSInteger = Int(a)
        messagesRef.childByAutoId().setValue([
            "message": text,
            "username": self.senderDisplayName(),
            "telephoneNo": self.senderId(),
            "pic":"",
            "creadate": b,
            "fileurl" : "",
            "gps": false,
            "latitude": 0.0,
            "longitude" : 0.0,
            "voice": "",
            "voicemsecond": 0
            ])
        updateChatCnt()
        //        let message = JSQMessage(senderId: senderId, senderDisplayName: senderDisplayName, date: date, text: text)
        //        self.messages.append(message)
        self.finishSendingMessageAnimated(true)
    }
    override func tableView(tableView: ZHCMessagesTableView, didTapMessageBubbleAtIndexPath indexPath: NSIndexPath) {
        let msg = messages[indexPath.row]
        if msg.isMediaMessage {
            if let photo = msg.media as? ZHCPhoto2MediaItem {
                if photo.imageURL?.absoluteString?.hasPrefix("https://maps.google.com/maps/api/staticmap?markers=color:red") ?? false{
                    
                    self.performSegueWithIdentifier("ToMap2", sender: photo)
                }else{
//                    [ImageBrowserViewController show:self type:PhotoBroswerVCTypeModal index:button.tag imagesBlock:^NSArray *{
//                        return weakSelf.imageArray;
//                        }];
                    
                    ImageBrowserViewController.show(self, type: PhotoBroswerVCType.Zoom, index: 0, imagesBlock: { () -> [AnyObject]! in
                        return [photo.imageURL?.absoluteString ?? ""]
                    })
                }
            }else if let photo = msg.media as? ZHCPhotoMediaItem {
                
                    
                    ImageBrowserViewController.show(self, type: PhotoBroswerVCType.Zoom, index: 0, imagesBlock: { () -> [AnyObject]! in
                        return [photo.image!]
                    })
                
            }else if let video = msg.media as? ZHCVideoMediaItem {
                if let url = video.fileURL {
                    do {
                        try playVideo(url)
                       
//                    } catch AppError.InvalidResource(let name, let type) {
//                        debugPrint("Could not find resource \(name).\(type)")
                    } catch {
                        debugPrint("Generic error")
                    }
                    
                }
            }
        }
//        print(msg)
    }
    
    private func playVideo(url : NSURL) throws {
//        guard let path = NSBundle.mainBundle().pathForResource("video", ofType:"m4v") else {
//            throw AppError.InvalidResource("video", "m4v")
//        }
        let player = AVPlayer(URL: url)
        let playerController = AVPlayerViewController()
        playerController.player = player
        self.presentViewController(playerController, animated: true) {
            player.play()
        }
    }
    
    private func updateChatCnt(){
        Alamofire.request(.GET, "http://sdk.itshapapp.com/dbAddChatCount.json",parameters: ["idfeedplaces1":"\(idfeedplaces1 ?? 0)","idfeedplaces3":"\(idfp3 ?? 0)"]).responseData(completionHandler: { (req) in
            if req.result.error == nil {
                
            }
        })
    }
    
    
    
//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        
//    }

}
