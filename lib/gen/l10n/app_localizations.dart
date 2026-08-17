import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_it.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('it'),
  ];

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @continueLabel.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueLabel;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAccount;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @logIn.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get logIn;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signUp;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to your account'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome back! Enter your details.'**
  String get loginSubtitle;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password'**
  String get forgotPassword;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get dontHaveAccount;

  /// No description provided for @registerTitle.
  ///
  /// In en, this message translates to:
  /// **'Create an account'**
  String get registerTitle;

  /// No description provided for @registerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Join us and explore new opportunities!'**
  String get registerSubtitle;

  /// No description provided for @fullNameHint.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fullNameHint;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'youremail@mail.com'**
  String get emailHint;

  /// No description provided for @phoneHint.
  ///
  /// In en, this message translates to:
  /// **'+39 333 12 4564'**
  String get phoneHint;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordHint;

  /// No description provided for @recurring.
  ///
  /// In en, this message translates to:
  /// **'Recurring'**
  String get recurring;

  /// No description provided for @service.
  ///
  /// In en, this message translates to:
  /// **'Service'**
  String get service;

  /// No description provided for @barber.
  ///
  /// In en, this message translates to:
  /// **'Barber'**
  String get barber;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @connectionInfo.
  ///
  /// In en, this message translates to:
  /// **'Connection information'**
  String get connectionInfo;

  /// No description provided for @acceptThe.
  ///
  /// In en, this message translates to:
  /// **'I accept the '**
  String get acceptThe;

  /// No description provided for @and.
  ///
  /// In en, this message translates to:
  /// **' and '**
  String get and;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get privacyPolicy;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of service'**
  String get termsOfService;

  /// No description provided for @acceptPrivacyAndTermsSnack.
  ///
  /// In en, this message translates to:
  /// **'Please accept the privacy policy and terms of service'**
  String get acceptPrivacyAndTermsSnack;

  /// No description provided for @onboardingTitle.
  ///
  /// In en, this message translates to:
  /// **'Beauty salon and barber\\nBooking is easy'**
  String get onboardingTitle;

  /// No description provided for @enterFullName.
  ///
  /// In en, this message translates to:
  /// **'Enter full name'**
  String get enterFullName;

  /// No description provided for @enterYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterYourEmail;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter password'**
  String get enterPassword;

  /// No description provided for @minChars2.
  ///
  /// In en, this message translates to:
  /// **'At least 2 characters'**
  String get minChars2;

  /// No description provided for @minChars6.
  ///
  /// In en, this message translates to:
  /// **'At least 6 characters'**
  String get minChars6;

  /// No description provided for @enterYourName.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get enterYourName;

  /// No description provided for @enterYourSubject.
  ///
  /// In en, this message translates to:
  /// **'Enter your subject'**
  String get enterYourSubject;

  /// No description provided for @nameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameLabel;

  /// No description provided for @lastNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Last name'**
  String get lastNameLabel;

  /// No description provided for @dateOfBirthLabel.
  ///
  /// In en, this message translates to:
  /// **'Date of birth'**
  String get dateOfBirthLabel;

  /// No description provided for @dateOfBirthHintText.
  ///
  /// In en, this message translates to:
  /// **'YYYY/MM/DD'**
  String get dateOfBirthHintText;

  /// No description provided for @phoneNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phoneNumberLabel;

  /// No description provided for @zipCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'ZIP code'**
  String get zipCodeLabel;

  /// No description provided for @cityLabel.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get cityLabel;

  /// No description provided for @provinceLabel.
  ///
  /// In en, this message translates to:
  /// **'Province'**
  String get provinceLabel;

  /// No description provided for @countryLabel.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get countryLabel;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'E-mail'**
  String get emailLabel;

  /// No description provided for @subjectLabel.
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get subjectLabel;

  /// No description provided for @messageLabel.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get messageLabel;

  /// No description provided for @writeSomethingHint.
  ///
  /// In en, this message translates to:
  /// **'Write something...'**
  String get writeSomethingHint;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email'**
  String get invalidEmail;

  /// No description provided for @invalidNumber.
  ///
  /// In en, this message translates to:
  /// **'Invalid number'**
  String get invalidNumber;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot password'**
  String get forgotPasswordTitle;

  /// No description provided for @forgotPasswordSheetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your email and we’ll send you a verification code.'**
  String get forgotPasswordSheetSubtitle;

  /// No description provided for @sendOtp.
  ///
  /// In en, this message translates to:
  /// **'Send OTP'**
  String get sendOtp;

  /// No description provided for @verifyOtpTitle.
  ///
  /// In en, this message translates to:
  /// **'Verify OTP'**
  String get verifyOtpTitle;

  /// No description provided for @verifyOtpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the code we sent to your email.'**
  String get verifyOtpSubtitle;

  /// No description provided for @otpHint.
  ///
  /// In en, this message translates to:
  /// **'Enter OTP'**
  String get otpHint;

  /// No description provided for @otpInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid OTP'**
  String get otpInvalid;

  /// No description provided for @resendCode.
  ///
  /// In en, this message translates to:
  /// **'Resend code'**
  String get resendCode;

  /// No description provided for @otpResent.
  ///
  /// In en, this message translates to:
  /// **'OTP resent'**
  String get otpResent;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @resetPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get resetPasswordTitle;

  /// No description provided for @resetPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create a new password for your account.'**
  String get resetPasswordSubtitle;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get newPassword;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPassword;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @resetPasswordCta.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get resetPasswordCta;

  /// No description provided for @passwordResetSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password reset successfully'**
  String get passwordResetSuccess;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @bookAppointment.
  ///
  /// In en, this message translates to:
  /// **'Book an appointment'**
  String get bookAppointment;

  /// No description provided for @stepChooseBarber.
  ///
  /// In en, this message translates to:
  /// **'Choose your shop'**
  String get stepChooseBarber;

  /// No description provided for @stepSelectService.
  ///
  /// In en, this message translates to:
  /// **'Select the service'**
  String get stepSelectService;

  /// No description provided for @stepSelectBarber.
  ///
  /// In en, this message translates to:
  /// **'Select the barber'**
  String get stepSelectBarber;

  /// No description provided for @stepChooseDate.
  ///
  /// In en, this message translates to:
  /// **'Choose a date'**
  String get stepChooseDate;

  /// No description provided for @stepBookingSummary.
  ///
  /// In en, this message translates to:
  /// **'Booking summary'**
  String get stepBookingSummary;

  /// No description provided for @phaseOf.
  ///
  /// In en, this message translates to:
  /// **'Step {step} of {total}'**
  String phaseOf(Object step, Object total);

  /// No description provided for @someoneAvailable.
  ///
  /// In en, this message translates to:
  /// **'Someone available'**
  String get someoneAvailable;

  /// No description provided for @confirmBooking.
  ///
  /// In en, this message translates to:
  /// **'Confirm booking'**
  String get confirmBooking;

  /// No description provided for @areYouSure.
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get areYouSure;

  /// No description provided for @actionCannotBeUndone.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.\\nConfirm if you want to proceed.'**
  String get actionCannotBeUndone;

  /// No description provided for @cancelAction.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelAction;

  /// No description provided for @confirmAction.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirmAction;

  /// No description provided for @deleteAppointmentTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete appointment'**
  String get deleteAppointmentTitle;

  /// No description provided for @deleteAppointmentMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this appointment? This action cannot be undone.'**
  String get deleteAppointmentMessage;

  /// No description provided for @noAction.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get noAction;

  /// No description provided for @yesAction.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yesAction;

  /// No description provided for @appointmentDeleted.
  ///
  /// In en, this message translates to:
  /// **'Appointment deleted'**
  String get appointmentDeleted;

  /// No description provided for @everyThursday.
  ///
  /// In en, this message translates to:
  /// **'Every Thursday'**
  String get everyThursday;

  /// No description provided for @everyWeekday.
  ///
  /// In en, this message translates to:
  /// **'Every {day}'**
  String everyWeekday(Object day);

  /// No description provided for @every2Weeks.
  ///
  /// In en, this message translates to:
  /// **'Every 2 weeks'**
  String get every2Weeks;

  /// No description provided for @every3Weeks.
  ///
  /// In en, this message translates to:
  /// **'Every 3 weeks'**
  String get every3Weeks;

  /// No description provided for @every4Weeks.
  ///
  /// In en, this message translates to:
  /// **'Every 4 weeks'**
  String get every4Weeks;

  /// No description provided for @howManyBookings.
  ///
  /// In en, this message translates to:
  /// **'How many bookings'**
  String get howManyBookings;

  /// No description provided for @fiveTimes.
  ///
  /// In en, this message translates to:
  /// **'5 times'**
  String get fiveTimes;

  /// No description provided for @nTimes.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 time} other{{count} times}}'**
  String nTimes(int count);

  /// No description provided for @select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// No description provided for @noBarberAvailable.
  ///
  /// In en, this message translates to:
  /// **'No barber available'**
  String get noBarberAvailable;

  /// No description provided for @noBarbersForSelectedService.
  ///
  /// In en, this message translates to:
  /// **'No barbers available for this service.'**
  String get noBarbersForSelectedService;

  /// No description provided for @waitlistMe.
  ///
  /// In en, this message translates to:
  /// **'Add me to the waitlist'**
  String get waitlistMe;

  /// No description provided for @selectPreferredTime.
  ///
  /// In en, this message translates to:
  /// **'Select the time slot you prefer'**
  String get selectPreferredTime;

  /// No description provided for @recurringAppointments.
  ///
  /// In en, this message translates to:
  /// **'Recurring appointments'**
  String get recurringAppointments;

  /// No description provided for @recurringIntervalTitle.
  ///
  /// In en, this message translates to:
  /// **'Recurring appointment interval'**
  String get recurringIntervalTitle;

  /// No description provided for @nextAppointment.
  ///
  /// In en, this message translates to:
  /// **'Next appointment'**
  String get nextAppointment;

  /// No description provided for @idNumber.
  ///
  /// In en, this message translates to:
  /// **'ID no.: {id}'**
  String idNumber(Object id);

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @contactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact us'**
  String get contactUs;

  /// No description provided for @contactFormIncomplete.
  ///
  /// In en, this message translates to:
  /// **'Please fill in all fields.'**
  String get contactFormIncomplete;

  /// No description provided for @contactSubmitNetworkError.
  ///
  /// In en, this message translates to:
  /// **'Could not send your message. Check your connection and try again.'**
  String get contactSubmitNetworkError;

  /// No description provided for @contactSubmitSuccessFallback.
  ///
  /// In en, this message translates to:
  /// **'Your message was sent.'**
  String get contactSubmitSuccessFallback;

  /// No description provided for @contactNoShopsHint.
  ///
  /// In en, this message translates to:
  /// **'No shop data yet. Open booking and pick a shop to see address and map here.'**
  String get contactNoShopsHint;

  /// No description provided for @contactMapNoCoordinates.
  ///
  /// In en, this message translates to:
  /// **'Map location is not available for this shop.'**
  String get contactMapNoCoordinates;

  /// No description provided for @profileNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your first or last name.'**
  String get profileNameRequired;

  /// No description provided for @profileEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email.'**
  String get profileEmailRequired;

  /// No description provided for @profileUpdateSuccessFallback.
  ///
  /// In en, this message translates to:
  /// **'Profile updated.'**
  String get profileUpdateSuccessFallback;

  /// No description provided for @profileUpdateNetworkError.
  ///
  /// In en, this message translates to:
  /// **'Could not update profile. Check your connection and try again.'**
  String get profileUpdateNetworkError;

  /// No description provided for @noBookedAppointmentsFound.
  ///
  /// In en, this message translates to:
  /// **'No booked appointments found.'**
  String get noBookedAppointmentsFound;

  /// No description provided for @noReservationsFound.
  ///
  /// In en, this message translates to:
  /// **'No reservations found.'**
  String get noReservationsFound;

  /// No description provided for @retryLabel.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retryLabel;

  /// No description provided for @noSlotsAvailableForSelectedDate.
  ///
  /// In en, this message translates to:
  /// **'No slots available for selected date.'**
  String get noSlotsAvailableForSelectedDate;

  /// No description provided for @noBarberWorkingDays.
  ///
  /// In en, this message translates to:
  /// **'This barber has no working days configured. Choose another barber or date.'**
  String get noBarberWorkingDays;

  /// No description provided for @selectTimeRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select an available time slot before continuing.'**
  String get selectTimeRequired;

  /// No description provided for @slotsStillLoading.
  ///
  /// In en, this message translates to:
  /// **'Please wait while available times are loading.'**
  String get slotsStillLoading;

  /// No description provided for @nextSlotLabel.
  ///
  /// In en, this message translates to:
  /// **'Next slot'**
  String get nextSlotLabel;

  /// No description provided for @nextDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get nextDateLabel;

  /// No description provided for @reservationListTitle.
  ///
  /// In en, this message translates to:
  /// **'Reservation list'**
  String get reservationListTitle;

  /// No description provided for @reservations.
  ///
  /// In en, this message translates to:
  /// **'Reservations'**
  String get reservations;

  /// No description provided for @bookings.
  ///
  /// In en, this message translates to:
  /// **'Bookings'**
  String get bookings;

  /// No description provided for @serviceBooking.
  ///
  /// In en, this message translates to:
  /// **'Service booking'**
  String get serviceBooking;

  /// No description provided for @upcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get upcoming;

  /// No description provided for @past.
  ///
  /// In en, this message translates to:
  /// **'Past'**
  String get past;

  /// No description provided for @confirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get confirmed;

  /// No description provided for @waitingList.
  ///
  /// In en, this message translates to:
  /// **'Waiting list'**
  String get waitingList;

  /// No description provided for @noShow.
  ///
  /// In en, this message translates to:
  /// **'No show'**
  String get noShow;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @changeProfilePhoto.
  ///
  /// In en, this message translates to:
  /// **'Change profile photo'**
  String get changeProfilePhoto;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take a photo'**
  String get takePhoto;

  /// No description provided for @chooseFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get chooseFromGallery;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @photoSelected.
  ///
  /// In en, this message translates to:
  /// **'Photo selected. Tap Update to save your profile.'**
  String get photoSelected;

  /// No description provided for @photoSavedOffline.
  ///
  /// In en, this message translates to:
  /// **'Photo saved on this device. Tap Update when you\'re online to upload.'**
  String get photoSavedOffline;

  /// No description provided for @photoSyncedOnline.
  ///
  /// In en, this message translates to:
  /// **'Profile photo synced.'**
  String get photoSyncedOnline;

  /// No description provided for @photoPickError.
  ///
  /// In en, this message translates to:
  /// **'Could not access the selected image.'**
  String get photoPickError;

  /// No description provided for @cameraPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Camera permission was denied. Enable it in Settings to take a photo.'**
  String get cameraPermissionDenied;

  /// No description provided for @galleryPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Photo library permission was denied. Enable it in Settings to choose a photo.'**
  String get galleryPermissionDenied;

  /// No description provided for @cameraUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Camera is not available on this device or simulator.'**
  String get cameraUnavailable;

  /// No description provided for @pickerNotInstalled.
  ///
  /// In en, this message translates to:
  /// **'Picker not installed. Please fully restart the app after adding the plugin.'**
  String get pickerNotInstalled;

  /// No description provided for @notSignedIn.
  ///
  /// In en, this message translates to:
  /// **'You need to be signed in to set a profile photo.'**
  String get notSignedIn;

  /// No description provided for @bookingSuccess.
  ///
  /// In en, this message translates to:
  /// **'Appointment booked successfully.'**
  String get bookingSuccess;

  /// No description provided for @bookingGenericError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get bookingGenericError;

  /// No description provided for @withBarberLabel.
  ///
  /// In en, this message translates to:
  /// **'with {name}'**
  String withBarberLabel(String name);

  /// No description provided for @alternativeBarberLabel.
  ///
  /// In en, this message translates to:
  /// **'Alternative barber with {name}'**
  String alternativeBarberLabel(String name);

  /// No description provided for @alternativeBarbersTitle.
  ///
  /// In en, this message translates to:
  /// **'Alternative barbers'**
  String get alternativeBarbersTitle;

  /// No description provided for @selectAlternativeBarber.
  ///
  /// In en, this message translates to:
  /// **'Select alternative barber'**
  String get selectAlternativeBarber;

  /// No description provided for @clearAlternativeBarberSelection.
  ///
  /// In en, this message translates to:
  /// **'No alternative barber'**
  String get clearAlternativeBarberSelection;

  /// No description provided for @selectedAlternativeBarber.
  ///
  /// In en, this message translates to:
  /// **'Selected: {name}'**
  String selectedAlternativeBarber(String name);

  /// No description provided for @recurringAlternativeBarberRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select an alternative barber for each unavailable appointment.'**
  String get recurringAlternativeBarberRequired;

  /// No description provided for @recurringDatesExcludedHint.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 date was not assigned a barber or waitlist and will not be booked.} other{{count} dates were not assigned a barber or waitlist and will not be booked.}}'**
  String recurringDatesExcludedHint(int count);

  /// No description provided for @recurringSuccess.
  ///
  /// In en, this message translates to:
  /// **'Recurring appointments processed.'**
  String get recurringSuccess;

  /// No description provided for @recurringMissingSelection.
  ///
  /// In en, this message translates to:
  /// **'Please choose a recurring interval and number of bookings.'**
  String get recurringMissingSelection;

  /// No description provided for @recurringIntervalRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select how often the appointment repeats before continuing.'**
  String get recurringIntervalRequired;

  /// No description provided for @recurringQuantityRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select how many bookings you want before continuing.'**
  String get recurringQuantityRequired;

  /// No description provided for @recurringAllSkipped.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{The selected slot was skipped.} other{All {count} selected slots were skipped.}}'**
  String recurringAllSkipped(int count);

  /// No description provided for @recurringPartialSuccess.
  ///
  /// In en, this message translates to:
  /// **'{booked, plural, =1{1 appointment booked} other{{booked} appointments booked}}, {skipped, plural, =1{1 skipped} other{{skipped} skipped}}.'**
  String recurringPartialSuccess(int booked, int skipped);

  /// No description provided for @sendYourMessage.
  ///
  /// In en, this message translates to:
  /// **'Send your message'**
  String get sendYourMessage;

  /// No description provided for @barberAndHairConcept.
  ///
  /// In en, this message translates to:
  /// **'Iconico Hair'**
  String get barberAndHairConcept;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'it'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'it':
      return AppLocalizationsIt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
