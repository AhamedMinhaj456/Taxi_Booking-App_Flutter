import 'package:taxi_booking_app/onbording_components/onboarding_Info.dart';

class OnboardingData {
  List<OnboardingInfo> items = [
    OnboardingInfo(
      title: "Best User Experience",
      description:
          "Simplify your travels with our user-friendly taxi booking app ",
      lottieAsset: "assets/Animation5.json",
    ),
    OnboardingInfo(
        title: "Secure Payments",
        description:
            "Swift rides, secure payments, real-time tracking – Elevate!",
        lottieAsset:
            'assets/animation1.json'),
    OnboardingInfo(
        title: "Instant booking",
        description:
            "Effortless booking, instant rides, and secure transactions redefine convenience",
        lottieAsset:
            'assets/animation4.json'),
  ];
}
