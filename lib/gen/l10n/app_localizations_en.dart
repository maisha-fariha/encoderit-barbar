// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get home => 'Home';

  @override
  String get skip => 'Skip';

  @override
  String get continueLabel => 'Continue';

  @override
  String get alreadyHaveAccount => 'Already have an account? ';

  @override
  String get signIn => 'Sign in';

  @override
  String get logIn => 'Log in';

  @override
  String get signUp => 'Sign up';

  @override
  String get loginTitle => 'Sign in to your account';

  @override
  String get loginSubtitle => 'Welcome back! Enter your details.';

  @override
  String get forgotPassword => 'Forgot password';

  @override
  String get dontHaveAccount => 'Don\'t have an account? ';

  @override
  String get registerTitle => 'Create an account';

  @override
  String get registerSubtitle => 'Join us and explore new opportunities!';

  @override
  String get fullNameHint => 'Full name';

  @override
  String get emailHint => 'youremail@mail.com';

  @override
  String get phoneHint => '+39 333 12 4564';

  @override
  String get passwordHint => 'Password';

  @override
  String get recurring => 'Recurring';

  @override
  String get service => 'Service';

  @override
  String get barber => 'Barber';

  @override
  String get date => 'Date';

  @override
  String get time => 'Time';

  @override
  String get total => 'Total';

  @override
  String get address => 'Address';

  @override
  String get connectionInfo => 'Connection information';

  @override
  String get acceptThe => 'I accept the ';

  @override
  String get and => ' and ';

  @override
  String get privacyPolicy => 'Privacy policy';

  @override
  String get termsOfService => 'Terms of service';

  @override
  String get acceptPrivacyAndTermsSnack =>
      'Please accept the privacy policy and terms of service';

  @override
  String get onboardingTitle => 'Beauty salon and barber\\nBooking is easy';

  @override
  String get enterFullName => 'Enter full name';

  @override
  String get enterYourEmail => 'Enter your email';

  @override
  String get enterPassword => 'Enter password';

  @override
  String get minChars2 => 'At least 2 characters';

  @override
  String get minChars6 => 'At least 6 characters';

  @override
  String get enterYourName => 'Enter your name';

  @override
  String get enterYourSubject => 'Enter your subject';

  @override
  String get nameLabel => 'Name';

  @override
  String get lastNameLabel => 'Last name';

  @override
  String get dateOfBirthLabel => 'Date of birth';

  @override
  String get phoneNumberLabel => 'Phone number';

  @override
  String get zipCodeLabel => 'ZIP code';

  @override
  String get cityLabel => 'City';

  @override
  String get provinceLabel => 'Province';

  @override
  String get countryLabel => 'Country';

  @override
  String get emailLabel => 'E-mail';

  @override
  String get subjectLabel => 'Subject';

  @override
  String get messageLabel => 'Message';

  @override
  String get writeSomethingHint => 'Write something...';

  @override
  String get invalidEmail => 'Invalid email';

  @override
  String get invalidNumber => 'Invalid number';

  @override
  String get forgotPasswordTitle => 'Forgot password';

  @override
  String get forgotPasswordSheetSubtitle =>
      'Enter your email and we’ll send you a verification code.';

  @override
  String get sendOtp => 'Send OTP';

  @override
  String get verifyOtpTitle => 'Verify OTP';

  @override
  String get verifyOtpSubtitle => 'Enter the code we sent to your email.';

  @override
  String get otpHint => 'Enter OTP';

  @override
  String get otpInvalid => 'Invalid OTP';

  @override
  String get resendCode => 'Resend code';

  @override
  String get otpResent => 'OTP resent';

  @override
  String get verify => 'Verify';

  @override
  String get resetPasswordTitle => 'Reset password';

  @override
  String get resetPasswordSubtitle => 'Create a new password for your account.';

  @override
  String get newPassword => 'New password';

  @override
  String get confirmPassword => 'Confirm password';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get resetPasswordCta => 'Reset password';

  @override
  String get passwordResetSuccess => 'Password reset successfully';

  @override
  String get back => 'Back';

  @override
  String get bookAppointment => 'Book an appointment';

  @override
  String get stepChooseBarber => 'Choose your shop';

  @override
  String get stepSelectService => 'Select the service';

  @override
  String get stepSelectBarber => 'Select the barber';

  @override
  String get stepChooseDate => 'Choose a date';

  @override
  String get stepBookingSummary => 'Booking summary';

  @override
  String phaseOf(Object step, Object total) {
    return 'Step $step of $total';
  }

  @override
  String get someoneAvailable => 'Someone available';

  @override
  String get confirmBooking => 'Confirm booking';

  @override
  String get areYouSure => 'Are you sure?';

  @override
  String get actionCannotBeUndone =>
      'This action cannot be undone.\\nConfirm if you want to proceed.';

  @override
  String get cancelAction => 'Cancel';

  @override
  String get confirmAction => 'Confirm';

  @override
  String get everyThursday => 'Every Thursday';

  @override
  String everyWeekday(Object day) {
    return 'Every $day';
  }

  @override
  String get every2Weeks => 'Every 2 weeks';

  @override
  String get every3Weeks => 'Every 3 weeks';

  @override
  String get every4Weeks => 'Every 4 weeks';

  @override
  String get howManyBookings => 'How many bookings';

  @override
  String get fiveTimes => '5 times';

  @override
  String nTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count times',
      one: '1 time',
    );
    return '$_temp0';
  }

  @override
  String get select => 'Select';

  @override
  String get noBarberAvailable => 'No barber available';

  @override
  String get waitlistMe => 'Add me to the waitlist';

  @override
  String get selectPreferredTime => 'Select the time slot you prefer';

  @override
  String get recurringAppointments => 'Recurring appointments';

  @override
  String get recurringIntervalTitle => 'Recurring appointment interval';

  @override
  String get nextAppointment => 'Next appointment';

  @override
  String idNumber(Object id) {
    return 'ID no.: $id';
  }

  @override
  String get profile => 'Profile';

  @override
  String get contactUs => 'Contact us';

  @override
  String get reservationListTitle => 'Reservation list';

  @override
  String get reservations => 'Reservations';

  @override
  String get bookings => 'Bookings';

  @override
  String get serviceBooking => 'Service booking';

  @override
  String get upcoming => 'Upcoming';

  @override
  String get confirmed => 'Confirmed';

  @override
  String get completed => 'Completed';

  @override
  String get cancelled => 'Cancelled';

  @override
  String get logout => 'Logout';

  @override
  String get update => 'Update';

  @override
  String get changeProfilePhoto => 'Change profile photo';

  @override
  String get takePhoto => 'Take a photo';

  @override
  String get chooseFromGallery => 'Choose from gallery';

  @override
  String get cancel => 'Cancel';

  @override
  String get photoSavedOffline =>
      'Photo saved. It will sync when you\'re online.';

  @override
  String get photoSyncedOnline => 'Profile photo synced.';

  @override
  String get photoPickError => 'Could not access the selected image.';

  @override
  String get cameraPermissionDenied =>
      'Camera permission was denied. Enable it in Settings to take a photo.';

  @override
  String get galleryPermissionDenied =>
      'Photo library permission was denied. Enable it in Settings to choose a photo.';

  @override
  String get cameraUnavailable =>
      'Camera is not available on this device or simulator.';

  @override
  String get pickerNotInstalled =>
      'Picker not installed. Please fully restart the app after adding the plugin.';

  @override
  String get notSignedIn => 'You need to be signed in to set a profile photo.';

  @override
  String get sendYourMessage => 'Send your message';

  @override
  String get barberAndHairConcept => 'Barber and Hair Concept';
}
