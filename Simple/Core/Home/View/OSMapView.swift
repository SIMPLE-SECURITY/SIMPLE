//
//  OSMapView.swift
//  SIMPLE
//
//  Created by Charles Shin on 1/13/23.
//

import MapKit
import SwiftUI

struct OSMapView: UIViewRepresentable {
    let mapView = MKMapView()
    let locationManager = LocationManager.shared
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var viewModel: OSMapViewModel
    @Binding var selectedReport: OSReport?
    
    func makeUIView(context: Context) -> some UIView {
        mapView.tintColor = authViewModel.userIsPolice(authViewModel.userSession?.email ?? "N/A") ? .systemRed : .systemBlue
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        mapView.delegate = context.coordinator
        mapView.isRotateEnabled = false
        context.coordinator.didSetUserRegion = true
        return mapView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        if !viewModel.reports.isEmpty, !context.coordinator.didAddReportsToMap {
            context.coordinator.addReportsToMap()
        }
        
        if selectedReport != nil {
            context.coordinator.didSetUserRegion = false
        }
        
        if context.coordinator.didSetUserRegion {
            context.coordinator.centerMapOnUserLocation()
        }
        
        if selectedReport == nil, context.coordinator.currentSelectedAnno != nil {
//            context.coordinator.didSetUserRegion = false
            context.coordinator.deselectAnno()
        }
        
        if viewModel.shouldUpdateReports {
            context.coordinator.addReportsToMap()
            viewModel.shouldUpdateReports = false
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
}

// MARK: - Coordinator

extension OSMapView {
    class Coordinator: NSObject, MKMapViewDelegate {
        let parent: OSMapView
        var didAddReportsToMap = false
        var didSetUserRegion = false
        var currentSelectedAnno: ReportAnnotation?
       
        init(parent: OSMapView) {
            self.parent = parent
        }
        
        // MARK: - MKMapViewDelegate
        
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            let region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude,
                                               longitude: userLocation.coordinate.longitude),
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            )
            parent.mapView.setRegion(region, animated: false)
            didSetUserRegion = true
        }
        
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            guard let annotation = view.annotation as? ReportAnnotation else { return }
            guard let report = parent.viewModel.reports.first(where: { $0.id == annotation.uid }) else { return }
            self.currentSelectedAnno = annotation
            parent.selectedReport = report
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard !annotation.isKind(of: MKUserLocation.self) else { return nil }

            if let annotation = annotation as? ReportAnnotation {
                let view = MKAnnotationView(annotation: annotation, reuseIdentifier: "anno")
                let imageView = UIImageView(image: UIImage(systemName: annotation.status.imageName))
                imageView.tintColor = annotation.status.tintColor
                imageView.isUserInteractionEnabled = true
                imageView.frame = .init(x: 0, y: 0, width: 32, height: 32)
                view.addSubview(imageView)
                view.frame = imageView.frame
                return view
            }

            return nil
        }
        
        func centerMapOnUserLocation() {
            guard let region = parent.viewModel.userRegion else {
                print("DEBUG: No region")
                return
            }
            DispatchQueue.main.async {
                self.parent.mapView.setRegion(region, animated: true)
                self.parent.viewModel.userRegion = nil
            }
        }
        
        func addReportsToMap() {
            parent.mapView.removeAnnotations(parent.mapView.annotations)
            
            let annotations = parent.viewModel.reports.map { report in
                let coordinate = CLLocationCoordinate2D(latitude: report.geopoint.latitude, longitude: report.geopoint.longitude)
                let anno = ReportAnnotation(uid: report.id, coordinate: coordinate, status: report.status)
                return anno
            }
                                
            parent.mapView.addAnnotations(annotations)
            didAddReportsToMap = true
        }
        
        func deselectAnno() {
            guard let anno = self.currentSelectedAnno else { return }
            parent.mapView.deselectAnnotation(anno, animated: true)
            self.didSetUserRegion = true
        }
    }
}
