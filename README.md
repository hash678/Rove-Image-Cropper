

# Rove Image Cropper

A simple image cropper which allows you to crop images to area bounded by the rectangle or remove the area inside of the rectangle. 
### NOTE: This cropper only allows you to crop vertically. 


## Getting Started



### Installing

Copy the project's classes to your own project.

### Sample Usage:


let cropper = ImageViewer()


cropper.frame = CGRect(x: 0, y: 50, width: view.frame.width, height: view.frame.height - 100)
cropper.setupViews()

//MARK: - Optional Params

Cropping Style
cropper.croppingStyle

Overlay Color
cropper.color


view.addSubview(cropper)

//MARK: To crop
 cropper.cropImage() {[weak self] (image) in
            guard let image = image else{
                print("Couldn't crop image")
                return
            }
            self?.cropper.loadImage(image: image)
           
        }
    }




## Built With

* SWIFT


## Authors

* Hassan Abbasi


## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details








