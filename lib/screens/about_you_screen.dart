import 'package:fashion_app/screens/personalization_splash_screen.dart';
import 'package:flutter/material.dart';

class AboutYouScreen extends StatefulWidget {
  const AboutYouScreen({super.key});

  @override
  _AboutYouScreenState createState() => _AboutYouScreenState();
}

class _AboutYouScreenState extends State<AboutYouScreen> {
  String? selectedGender;
  String? selectedAgeGroup;
  Set<String> selectedStyle={};
  bool showStyleSelection = false;

  void selectGender(String gender) {
    setState(() {
      selectedGender = gender;
    });
  }


  void selectAgeGroup(String ageGroup) {
    setState(() {
      selectedAgeGroup = ageGroup;
    });
  }

  void selectStyle(String style) {
    setState(() {
      if(selectedStyle.contains(style)){
        selectedStyle.remove(style);
      }else{
        selectedStyle.add(style);
      }
    });
  }

  void onSave() {
    if (!showStyleSelection) {
      setState(() {
        showStyleSelection = true;
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PersonalizationSplashScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("About You", textAlign: TextAlign.center),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!showStyleSelection) ...[
                      _buildSectionTitle("Choose Gender"),
                      Wrap(
                        alignment: WrapAlignment.start,
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          genderButton("Male"),
                          genderButton("Female"),
                          genderButton("Not Specified"),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _buildSectionTitle("Choose Age Group"),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          ageGroupButton("13-18"),
                          ageGroupButton("19-24"),
                          ageGroupButton("25-34"),
                          ageGroupButton("35-44"),
                          ageGroupButton("45-54"),
                          ageGroupButton("55+"),
                        ],
                      ),
                    ] else ...[
                      _buildSectionTitle("Which style do you associate with the most?"),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          styleButton("Streetwear"),
                          styleButton("Vintage"),
                          styleButton("Classic"),
                          styleButton("Romantic"),
                          styleButton("Preppy"),
                          styleButton("Edgy"),
                          styleButton("Bohemian"),
                          styleButton("Casual"),
                          styleButton("Minimalist"),
                          styleButton("Athleisure"),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: _buildSignUpButton(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignUpButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFD00A62),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: onSave,
        child: const Text('Save', style: TextStyle(color: Colors.white, fontSize: 16)),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget genderButton(String gender) {
    return GestureDetector(
      onTap: () => selectGender(gender),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: selectedGender == gender ? Colors.pink.shade100 : Colors.grey.shade200,
          border: Border.all(color: selectedGender == gender ? Colors.pink : Colors.transparent),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(gender, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
      ),
    );
  }

  Widget ageGroupButton(String ageGroup) {
    return GestureDetector(
      onTap: () => selectAgeGroup(ageGroup),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: selectedAgeGroup == ageGroup ? Colors.pink.shade100 : Colors.grey.shade200,
          border: Border.all(color: selectedAgeGroup == ageGroup ? Colors.pink : Colors.transparent),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(ageGroup, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
      ),
    );
  }

  Widget styleButton(String style) {
    bool isSelected = selectedStyle.contains(style);
    return GestureDetector(
      onTap: () => selectStyle(style),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.pink.shade100 : Colors.grey.shade200,
          border: Border.all(color: isSelected ? Colors.pink : Colors.transparent),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(style, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400)),
      ),
    );
  }
}

