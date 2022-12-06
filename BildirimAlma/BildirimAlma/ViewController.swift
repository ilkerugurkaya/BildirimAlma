//
//  ViewController.swift
//  BildirimAlma
//
//  Created by İlker Kaya on 4.12.2022.
//

import UIKit
import UserNotifications


class ViewController: UIViewController {
    
    var izinKontrol:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UNUserNotificationCenter.current().delegate = self
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge], completionHandler: {(granted,error) in
            self.izinKontrol = granted
            
            if granted{
                print("İzin alma işlemi başarılı")
            }else{
                print("İzin alma işlemi başarısız..")
            }
        } )
    }
    
    
    @IBAction func bildirimOlustur(_ sender: Any) {
        //Arka planda çalışır sadece
        
        let evet = UNNotificationAction(identifier: "evet", title: "Evet", options: .foreground)
        let hayır = UNNotificationAction(identifier: "hayır", title: "Hayır", options: .foreground)
        let sil = UNNotificationAction(identifier: "sil", title: "Sil", options: .foreground)//Action'lu bildirimin seçeneklerini kodlama kısmı
        
        let kategori = UNNotificationCategory(identifier: "kat", actions: [evet,hayır,sil], intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([kategori])
        
        if izinKontrol{
            let icerik = UNMutableNotificationContent()
            icerik.title = "baslik"
            icerik.subtitle = "Alt Başlık"
            icerik.body = "5 , 4 den büyük mü?"
            icerik.badge = 1
            icerik.sound = UNNotificationSound.default
            
            icerik.categoryIdentifier = "kat"
            
            //Kesin tarih vermek istersek
            /*
            var date = DateComponents()
            date.minute = 30
            date.hour = 8
            date.day = 20
            date.month = 4 // Bu şekilde yılın 4. ayının 20. gününde saat 8 de ve 30.dakikada bu bildirimi verecek, istediğimiz şekilde komut ekleyip çıkartabiliriz.
            
            
            let tetikleme = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)*/
            
            //Bir kez tekrarlanmasını istiyorsak, tekrarlı olmasını istiyorsak false yerine true yazıyoruz ve sürei en az 60 saniye yapmamız gerekiyor.
            let tetikleme = UNTimeIntervalNotificationTrigger(timeInterval: 6, repeats: false)
            
            
            
            let bildirimIstegi = UNNotificationRequest(identifier: "BildirimAlma", content: icerik, trigger: tetikleme)
            UNUserNotificationCenter.current().add(bildirimIstegi,withCompletionHandler: nil)
        }
    }
    

}

extension ViewController: UNUserNotificationCenterDelegate{
    //Ön Planda Çalışması
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert,.sound,.badge])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        //Actiondan seçilen öğenin ne yapması gerektiği kodlandı
        if response.actionIdentifier == "evet" {
            print("Doğru cevap")
        }
        if response.actionIdentifier == "hayır"{
            print("Yanlış cevap")
        }
        if response.actionIdentifier == "sil" {
            print("Cevap Verilmedi")
        }
        completionHandler()
        
    }
}
