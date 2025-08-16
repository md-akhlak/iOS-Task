//
//  UploadView.swift
//  iOS Task
//
//  Created by Md Akhlak on 15/08/25.
//

import Foundation
import SwiftUI
import PhotosUI
import FirebaseStorage
import FirebaseFirestore

struct UploadView: View {
    @StateObject private var viewModel = UploadViewModel()
    @State private var showImagePicker = false
    @State private var showCamera = false
    @State private var selectedImage: UIImage?
    @State private var referenceName: String = ""
    
    var body: some View {
        VStack(spacing: 0) {
            if let image = selectedImage {
                ScrollView {
                    ZStack(alignment: .topTrailing) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding(.horizontal)
                        Button(action: {
                            selectedImage = nil
                            referenceName = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.red)
                                .font(.title2)
                                .padding(8)
                                .background(.white.opacity(0.8))
                                .clipShape(Circle())
                        }
                        .padding(.trailing, 24)
                        .padding(.top, 8)
                    }
                    
                    VStack(spacing: 16) {
                        TextField("Reference Name", text: $referenceName)
                            .padding(14)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                            )
                            .padding(.horizontal)
                        
                        Button(action: {
                            if !referenceName.isEmpty {
                                viewModel.uploadImage(image: image, name: referenceName)
                            }
                        }) {
                            Text("Submit")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(Color.green)
                                .foregroundColor(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .padding(.horizontal)
                        .padding(.bottom)
                    }
                }
            } else {
                Spacer(minLength: 48)
                
                Button(action: { showImagePicker = true }) {
                    VStack(spacing: 8) {
                        Image(systemName: "photo.on.rectangle")
                            .font(.system(size: 44))
                            .foregroundColor(.green)
                        Text("Browser Gallery")
                            .foregroundColor(.primary)
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 28)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(style: StrokeStyle(lineWidth: 2, dash: [12]))
                            .foregroundColor(.green)
                    )
                    .padding(.horizontal, 24)
                }
                .sheet(isPresented: $showImagePicker, onDismiss: { showImagePicker = false }) {
                    ImagePicker(selectedImage: $selectedImage, isPresented: $showImagePicker, sourceType: .photoLibrary)
                }
                
                HStack { 
                    Rectangle().fill(Color.gray.opacity(0.4)).frame(height: 1)
                    Text("OR").foregroundColor(.gray)
                    Rectangle().fill(Color.gray.opacity(0.4)).frame(height: 1)
                }
                .padding(.vertical, 16)
                .padding(.horizontal, 24)
                
                Button(action: { showCamera = true }) {
                    HStack(spacing: 10) {
                        Image(systemName: "camera.fill")
                            .foregroundColor(.green)
                        Text("Open camera")
                            .foregroundColor(.primary)
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 22)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(style: StrokeStyle(lineWidth: 2, dash: [12]))
                            .foregroundColor(.green)
                    )
                    .padding(.horizontal, 24)
                }
                .sheet(isPresented: $showCamera, onDismiss: { showCamera = false }) {
                    ImagePicker(selectedImage: $selectedImage, isPresented: $showCamera, sourceType: .camera)
                }
                
                Spacer()
            }
        }
        .overlay(
            Group {
                if viewModel.isUploading {
                    ZStack {
                        Color.black.opacity(0.3).ignoresSafeArea()
                        VStack(spacing: 12) {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            Text("Image uploading…")
                                .foregroundColor(.white)
                        }
                        .padding(20)
                        .background(Color.black.opacity(0.6))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
            }
        )
        .onChange(of: viewModel.didFinishUpload) { didFinish in
            if didFinish {
                selectedImage = nil
                referenceName = ""
            }
        }
        .alert("Image uploaded", isPresented: $viewModel.didFinishUpload, actions: {
            Button("OK", role: .cancel) { }
        }, message: {
            Text("Your image uploaded successfully.")
        })
        .alert("Upload failed", isPresented: Binding(get: { viewModel.errorMessage != nil }, set: { _ in viewModel.errorMessage = nil }), actions: {
            Button("OK", role: .cancel) { viewModel.errorMessage = nil }
        }, message: {
            Text(viewModel.errorMessage ?? "")
        })
    }
}

#Preview {
    UploadView()
}
