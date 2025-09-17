import SwiftUI
import AVFoundation
import Vision
import UIKit

@MainActor
class FaceAnalysisViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published private var _cameraPermissionGranted = false
    
    // Force camera permission to always be true for testing
    var cameraPermissionGranted: Bool {
        get {
            return true
        }
        set {
            _cameraPermissionGranted = newValue
        }
    }
    @Published var isFaceDetected = false
    @Published var capturedImage: UIImage?
    @Published var selectedImage: UIImage?
    @Published var showingPhotoPicker = false
    @Published var showingConsentSheet = false
    @Published var showingPermissionAlert = false
    @Published var isAnalyzing = false
    @Published var analysisCompleted = false
    
    // MARK: - Camera Properties
    let cameraSession = AVCaptureSession()
    private var videoOutput = AVCaptureVideoDataOutput()
    private var photoOutput = AVCapturePhotoOutput()
    private var currentCamera: AVCaptureDevice?
    private var isFrontCamera = true
    
    // MARK: - Face Detection
    private let faceDetectionRequest = VNDetectFaceLandmarksRequest { request, error in
        // Handle face detection results
    }
    
    init() {
        setupCameraSession()
        
        // Force permission to true for testing
        cameraPermissionGranted = true
    }
    
    // MARK: - Permission Handling
    func checkPermissions() {
        #if targetEnvironment(simulator)
        // For simulator testing, bypass camera permission
        cameraPermissionGranted = true
        return
        #endif
        
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch status {
        case .authorized:
            cameraPermissionGranted = true
            startCameraSession()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                DispatchQueue.main.async {
                    self?.cameraPermissionGranted = granted
                    if granted {
                        self?.startCameraSession()
                    }
                }
            }
        case .denied, .restricted:
            cameraPermissionGranted = false
        @unknown default:
            cameraPermissionGranted = false
        }
    }
    
    func openSettings() {
        if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(settingsUrl)
        }
    }
    
    // MARK: - Camera Session Setup
    private func setupCameraSession() {
        cameraSession.sessionPreset = .high
        
        // Add video input
        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
            print("Failed to get front camera")
            return
        }
        
        do {
            let videoInput = try AVCaptureDeviceInput(device: videoDevice)
            if cameraSession.canAddInput(videoInput) {
                cameraSession.addInput(videoInput)
                currentCamera = videoDevice
            }
        } catch {
            print("Failed to create video input: \(error)")
        }
        
        // Add photo output
        if cameraSession.canAddOutput(photoOutput) {
            cameraSession.addOutput(photoOutput)
        }
        
        // Add video output for face detection
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue.global(qos: .userInteractive))
        if cameraSession.canAddOutput(videoOutput) {
            cameraSession.addOutput(videoOutput)
        }
    }
    
    private func startCameraSession() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.cameraSession.startRunning()
        }
    }
    
    private func stopCameraSession() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.cameraSession.stopRunning()
        }
    }
    
    // MARK: - Camera Controls
    func flipCamera() {
        guard let currentInput = cameraSession.inputs.first as? AVCaptureDeviceInput else { return }
        
        let newPosition: AVCaptureDevice.Position = currentInput.device.position == .front ? .back : .front
        guard let newCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: newPosition) else { return }
        
        do {
            let newInput = try AVCaptureDeviceInput(device: newCamera)
            cameraSession.beginConfiguration()
            cameraSession.removeInput(currentInput)
            
            if cameraSession.canAddInput(newInput) {
                cameraSession.addInput(newInput)
                currentCamera = newCamera
                isFrontCamera = newPosition == .front
            }
            
            cameraSession.commitConfiguration()
        } catch {
            print("Failed to flip camera: \(error)")
        }
    }
    
    // MARK: - Photo Capture
    func capturePhoto() {
        let settings = AVCapturePhotoSettings()
        photoOutput.capturePhoto(with: settings, delegate: self)
        
        // Haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
    }
    
    func retakePhoto() {
        capturedImage = nil
        selectedImage = nil
    }
    
    func confirmPhoto() {
        showingConsentSheet = true
    }
    
    func showPhotoPicker() {
        showingPhotoPicker = true
    }
    
    // MARK: - Analysis
    func startAnalysis() {
        guard let image = capturedImage ?? selectedImage else { return }
        
        isAnalyzing = true
        
        // Simulate analysis delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.isAnalyzing = false
            self?.analyzeSkin(image: image)
        }
    }
    
    private func analyzeSkin(image: UIImage) {
        // TODO: Implement actual skin analysis
        print("Analyzing skin with image: \(image.size)")
        
        // For now, just print the analysis
        print("Skin analysis completed")
        
        // Mark analysis as completed
        analysisCompleted = true
    }
}

// MARK: - AVCaptureVideoDataOutputSampleBufferDelegate
extension FaceAnalysisViewModel: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        let request = VNDetectFaceLandmarksRequest { [weak self] request, error in
            DispatchQueue.main.async {
                self?.isFaceDetected = !request.results.isEmpty
            }
        }
        
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .up)
        try? handler.perform([request])
    }
}

// MARK: - AVCapturePhotoCaptureDelegate
extension FaceAnalysisViewModel: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation(),
              let image = UIImage(data: imageData) else {
            print("Failed to create image from photo data")
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.capturedImage = image
        }
    }
}
