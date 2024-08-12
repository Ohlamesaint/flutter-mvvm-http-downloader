import 'package:flutter/material.dart';

import '../../../model/image_model.dart';

class ImageDetailCardView extends StatelessWidget {
  const ImageDetailCardView({super.key, required this.imageModel});

  final ImageModel imageModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(32.0),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: FileImage(imageModel.thumbnail),
              fit: BoxFit.fill,
            ),
            const SizedBox(
              height: 8.0,
            ),
            CardDescriptionRow(
              description: imageModel.filename,
              descriptiveIcon: Icons.file_copy,
            ),
            CardDescriptionRow(
              description: imageModel.url,
              descriptiveIcon: Icons.link,
            ),
            const SizedBox(
              height: 16.0,
            )
          ],
        ),
      ),
    );
  }
}

class CardDescriptionRow extends StatelessWidget {
  const CardDescriptionRow(
      {super.key, required this.description, required this.descriptiveIcon});

  final String description;
  final IconData descriptiveIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
      child: Row(
        // padding: const EdgeInsets.all(8.0),
        children: [
          Expanded(
            flex: 1,
            child: Icon(
              descriptiveIcon,
              color: Colors.black54,
            ),
          ),
          const SizedBox(
            width: 15.0,
          ),
          Expanded(
            flex: 9,
            child: Text(
              description,
              style: const TextStyle(color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }
}
