//
//  AzureBlobStorage.swift
//  LocKetApp
//
//  Created by 나유진 on 2022/11/26.
//

//import Foundation

import AZSClient

let connectionString: String = "DefaultEndpointsProtocol=https;AccountName=stlocket;AccountKey=b5UWyGP32QQgAYO/CXro6GdU2PQKLsb5FV+nv5s7AsahZkzp0SLKciLOa6n0I6KrtfwqS4MlfwWv+ASt9RN1fg==;EndpointSuffix=core.windows.net"


class AZBlobService{
    
    let blobContainer: AZSCloudBlobContainer
    
    init(_ connectionString: String, containerName: String) {
        guard let account = try? AZSCloudStorageAccount(fromConnectionString: connectionString) else {
            blobContainer = AZSCloudBlobContainer()
            return
        }
        let blobClient = account.getBlobClient()
        self.blobContainer = blobClient.containerReference(fromName: containerName)
    }
    
    func uploadImage(image: UIImage, blobName: String){
        self.blobContainer.createContainerIfNotExists { error, isExist in
            if let error = error{
                print(error.localizedDescription)
            } else {
                let blockBlob = self.blobContainer.blockBlobReference(fromName: blobName)
                if let data = image.pngData(){
                    blockBlob.upload(from: data) { error in
                        if let error = error{
                            print(error.localizedDescription.description)
                        } else {
                            print("Upload Complete")
                        }
                    }
                }
            }
        }
    }
    
    func downloadImage(blobName: String, handler: @escaping (Data)->()){
        let blockBlob = blobContainer.blockBlobReference(fromName: blobName)
        blockBlob.downloadToData { error, data in
            if let data = data{
               handler(data)
            }
        }
    }
    
    func deleteImage(blobName: String, handler: @escaping ()->()){
        let blockBlob = blobContainer.blockBlobReference(fromName: blobName)
        blockBlob.delete { error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                handler()
            }
        }
    }
    
}
