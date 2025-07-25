import 'package:nextgen_learners/constant/import_export.dart';

class CustomContainer extends StatelessWidget {
  final Color pcolor;
  final Color scolor;
  final String text;
  final String img;
  const CustomContainer({
    super.key,
    required this.pcolor,
    required this.scolor,
    required this.text,
    required this.img,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [pcolor, scolor],
        ),
      ),
      width: 160,
      height: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(img, fit: BoxFit.cover, width: 150, height: 150),
          const SizedBox(height: 10),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
