//
//  MapViewController.swift
//  miniProject01
//
//  Created by 나유진 on 2022/10/26.
//

import UIKit
import CoreLocation
import MapKit

class MapViewController: UIViewController, MTMapViewDelegate {

    var mapView: MTMapView!
    var markers = [MTMapPOIItem()]
    var locationManager: CLLocationManager!

    
    @IBOutlet var mapViewFrame: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 0 현재 위치 정보 권한 가져오기 by Apple
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization() //위치정보 권한설정
        
        
        // 1 맵뷰 그리기 by Kakao
        mapView = MTMapView(frame: self.mapViewFrame.frame)
        mapView.delegate = self
        mapView.baseMapType = .standard
        self.view.addSubview(mapView)
        

        // 2 좌표 중심 설정 by Kakao
        /*
        let defaultMapPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: 37.4630783, longitude: 126.9059344))
        mapView.setMapCenter(defaultMapPoint, zoomLevel: 1, animated: true)
         */
        
        
        // + 현재 위치 트래킹 by Kakao
        mapView.currentLocationTrackingMode = .onWithoutHeading//.onWithHeading
        mapView.showCurrentLocationMarker = true
        
        
        // + 현재 위치 마커 커스터마이징
        let myMarker = MTMapLocationMarkerItem()
        myMarker.customTrackingImageName = "mylocation"
        mapView.updateCurrentLocationMarker(myMarker)

        self.drawMap()
        
        /*
        // 데이터 가져오기------------------------------------
        var combinedFiveMarkets: [Item] = []
        get5Markets( numOfRows: 10, type: "5일장") {
            
            combinedFiveMarkets = fiveMarkets
            
            get5Markets( numOfRows: 10, type: "상설장+5일장") {
                
                combinedFiveMarkets.append(contentsOf: fiveMarkets)
                fiveMarkets = combinedFiveMarkets
                
                getMarkets {

                    self.drawMap()
                }
            }
        }
        //-----------------------------------------------
        */
            
    }
    override func viewWillAppear(_ animated: Bool) {
        drawMap()
    }

    // 데이터의 좌표 맵에 그리기
    func drawMap(){
        
        //5일장
        for fivemarket in fiveMarkets{
            if let latitude = Double(fivemarket.latitude),
               let longitude = Double(fivemarket.longitude){
                let placeName = fivemarket.mrktNm
                
                // 2 좌표 포인트
                let mapPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: latitude, longitude: longitude))
                
                // 3 마커 찍기 (추가)
                let marker = MTMapPOIItem()
                marker.itemName = placeName
                marker.mapPoint = mapPoint
                marker.markerType = .customImage
                marker.customImage = UIImage(named: "marker")
                marker.showAnimationType = .noAnimation
                markers.append(marker)
                
            }
        }
        //플리마켓
        for market in markets{
            let latitude = Double(market.location.coordinates[0] )
            let longitude = Double(market.location.coordinates[1])
            let placeName = market.name
                
            // 2 좌표 포인트
            let mapPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: latitude, longitude: longitude))
            
            // 3 마커 찍기 (추가)
            let marker = MTMapPOIItem()
            marker.itemName = placeName
            marker.mapPoint = mapPoint
            marker.markerType = .customImage
            marker.customImage = UIImage(named: "liked")
            marker.showAnimationType = .noAnimation
            markers.append(marker)
           
            
        }
        mapView.addPOIItems(markers)
    }
  
    
 
    func mapView(_ mapView: MTMapView!, updateCurrentLocation location: MTMapPoint!, withAccuracy accuracy: MTMapLocationAccuracy) {
        let currentLocation = location?.mapPointGeo()
        if let latitude = currentLocation?.latitude,
           let longitude = currentLocation?.longitude{
            print("좌표:", latitude, "," , longitude)
        }
    }
    
    func mapView(_ mapView: MTMapView!, updateDeviceHeading headingAngle: MTMapRotationAngle) {
        print("headingAngle: ", headingAngle)
    }
    

    func mapView(_ mapView: MTMapView!, touchedCalloutBalloonOf poiItem: MTMapPOIItem!) {
        
        let storyBoard = UIStoryboard(name: "FleaMarketDetailSt", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "FleaMarketDetail")
        self.navigationController?.pushViewController(vc, animated: true)
    
    }
    
    
}




// 위치 권한
extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            //location5
            switch status {
            case .authorizedAlways, .authorizedWhenInUse:
                print("GPS 권한 설정됨")
               // self.locationManager.startUpdatingLocation() // 중요!
            case .restricted, .notDetermined:
                print("GPS 권한 설정되지 않음")
                self.locationManager.requestWhenInUseAuthorization() //권한설정
            case .denied:
                print("GPS 권한 요청 거부됨")
                self.locationManager.requestWhenInUseAuthorization() //권한설정
            default:
                print("GPS: Default")
            }
            
    }
    
    
}
