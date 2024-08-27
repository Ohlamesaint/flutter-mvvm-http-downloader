package com.example.perfect_corp_homework.download

val kUnSupportMediaTypeErrorMessage =
"""The requested media type is not supported
Please download the media included below:
apng, avif, gif, jpeg, png, webp""";

val kBadRequestErrorMessage = """Please check the format of the input URL.
It seems to be incorrect.""";

val kNoInternetErrorMessage = """Please connect to the internet.
""";

val kSupportMediaTypes = setOf<String>(
"apng",
"avif",
"gif",
"jpeg",
"png",
"webp"
)