//
//  Constant.swift
//  Runner
//
//  Created by SamLS Chen on 2024/8/19.
//

import Foundation

struct Constants {
    static let kUnSupportMediaTypeErrorMessage = """
The requested media type is not supported
Please download the media included below:
apng, avif, gif, jpeg, png, webp
"""

    static let kBadRequestErrorMessage = """
"Please check the format of the input URL.
It seems to be incorrect.
"""

    static let kNoInternetErrorMessage = """
Please check your the internet connection...
"""

    static let kSupportMediaTypes: Set = [
      "apng",
      "avif",
      "gif",
      "jpeg",
      "png",
      "webp"
    ]
}
