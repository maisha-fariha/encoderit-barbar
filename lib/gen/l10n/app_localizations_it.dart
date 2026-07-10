// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get home => 'Casa';

  @override
  String get skip => 'Saltare';

  @override
  String get continueLabel => 'Continuare';

  @override
  String get alreadyHaveAccount => 'Hai già un account? ';

  @override
  String get signIn => 'Accedi';

  @override
  String get logIn => 'Accedi';

  @override
  String get signUp => 'Iscrizione';

  @override
  String get loginTitle => 'Accedi al tuo account';

  @override
  String get loginSubtitle => 'Bentornato! Inserisci i tuoi dati.';

  @override
  String get forgotPassword => 'Ha dimenticato la password';

  @override
  String get dontHaveAccount => 'Non hai un account? ';

  @override
  String get registerTitle => 'Creare un account';

  @override
  String get registerSubtitle => 'Unisciti a noi ed esplora nuove possibilità!';

  @override
  String get fullNameHint => 'Nome e cognome';

  @override
  String get emailHint => 'tuaemail@mail.com';

  @override
  String get phoneHint => '+39 333 12 4564';

  @override
  String get passwordHint => 'Password';

  @override
  String get recurring => 'Ricorrente';

  @override
  String get service => 'Servizio';

  @override
  String get barber => 'Barbiere';

  @override
  String get date => 'Data';

  @override
  String get time => 'Tempo';

  @override
  String get total => 'Totale';

  @override
  String get address => 'Indirizzo';

  @override
  String get connectionInfo => 'Informazioni di collegamento';

  @override
  String get acceptThe => 'Accetto il ';

  @override
  String get and => ' e ';

  @override
  String get privacyPolicy => 'politica sulla riservatezza';

  @override
  String get termsOfService => 'Termini di servizio';

  @override
  String get acceptPrivacyAndTermsSnack =>
      'Accetta politica sulla riservatezza e termini di servizio';

  @override
  String get onboardingTitle =>
      'Salone di bellezza e barbiere\\nPrenotare è facile';

  @override
  String get enterFullName => 'Inserisci nome e cognome';

  @override
  String get enterYourEmail => 'Inserisci la tua email';

  @override
  String get enterPassword => 'Inserisci la password';

  @override
  String get minChars2 => 'Almeno 2 caratteri';

  @override
  String get minChars6 => 'Almeno 6 caratteri';

  @override
  String get enterYourName => 'Inserisci il tuo nome';

  @override
  String get enterYourSubject => 'Inserisci il tuo argomento';

  @override
  String get nameLabel => 'Nome';

  @override
  String get lastNameLabel => 'Cognome';

  @override
  String get dateOfBirthLabel => 'Data di nascita';

  @override
  String get dateOfBirthHintText => 'AAAA/MM/GG';

  @override
  String get phoneNumberLabel => 'Numero di telefono';

  @override
  String get zipCodeLabel => 'CAP';

  @override
  String get cityLabel => 'Comune';

  @override
  String get provinceLabel => 'Provincia';

  @override
  String get countryLabel => 'Nazione';

  @override
  String get emailLabel => 'E-mail';

  @override
  String get subjectLabel => 'Soggetto';

  @override
  String get messageLabel => 'Messaggio';

  @override
  String get writeSomethingHint => 'Scrivi qualcosa...';

  @override
  String get invalidEmail => 'Email non valida';

  @override
  String get invalidNumber => 'Numero non valido';

  @override
  String get forgotPasswordTitle => 'Ha dimenticato la password';

  @override
  String get forgotPasswordSheetSubtitle =>
      'Inserisci la tua email e ti invieremo un codice di verifica.';

  @override
  String get sendOtp => 'Invia OTP';

  @override
  String get verifyOtpTitle => 'Verifica OTP';

  @override
  String get verifyOtpSubtitle => 'Inserisci il codice inviato alla tua email.';

  @override
  String get otpHint => 'Inserisci OTP';

  @override
  String get otpInvalid => 'OTP non valido';

  @override
  String get resendCode => 'Reinvia codice';

  @override
  String get otpResent => 'OTP reinviato';

  @override
  String get verify => 'Verificare';

  @override
  String get resetPasswordTitle => 'Reimposta password';

  @override
  String get resetPasswordSubtitle =>
      'Crea una nuova password per il tuo account.';

  @override
  String get newPassword => 'Nuova password';

  @override
  String get confirmPassword => 'Conferma password';

  @override
  String get passwordsDoNotMatch => 'Le password non corrispondono';

  @override
  String get resetPasswordCta => 'Reimposta password';

  @override
  String get passwordResetSuccess => 'Password reimpostata con successo';

  @override
  String get back => 'Indietro';

  @override
  String get bookAppointment => 'Prenota un appuntamento';

  @override
  String get stepChooseBarber => 'Scegli il tuo barbiere';

  @override
  String get stepSelectService => 'Seleziona il servizio';

  @override
  String get stepSelectBarber => 'Seleziona il barbiere';

  @override
  String get stepChooseDate => 'Scegli una data';

  @override
  String get stepBookingSummary => 'Riepilogo della prenotazione';

  @override
  String phaseOf(Object step, Object total) {
    return 'Fase $step di $total';
  }

  @override
  String get someoneAvailable => 'Qualcuno disponibile';

  @override
  String get confirmBooking => 'Conferma la prenotazione';

  @override
  String get areYouSure => 'Sei sicuro?';

  @override
  String get actionCannotBeUndone =>
      'Questa azione non può essere annullata.\nConferma se desideri procedere.';

  @override
  String get cancelAction => 'Cancellare';

  @override
  String get confirmAction => 'Confermare';

  @override
  String get deleteAppointmentTitle => 'Elimina appuntamento';

  @override
  String get deleteAppointmentMessage =>
      'Sei sicuro di voler eliminare questo appuntamento? Questa azione non può essere annullata.';

  @override
  String get noAction => 'No';

  @override
  String get yesAction => 'Sì';

  @override
  String get appointmentDeleted => 'Appuntamento eliminato';

  @override
  String get everyThursday => 'Ogni giovedì';

  @override
  String everyWeekday(Object day) {
    return 'Ogni $day';
  }

  @override
  String get every2Weeks => 'Ogni 2 settimane';

  @override
  String get every3Weeks => 'Ogni 3 settimane';

  @override
  String get every4Weeks => 'Ogni 4 settimane';

  @override
  String get howManyBookings => 'Quante prenotazioni';

  @override
  String get fiveTimes => '5 volte';

  @override
  String nTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count volte',
      one: '1 volta',
    );
    return '$_temp0';
  }

  @override
  String get select => 'Selezionare';

  @override
  String get noBarberAvailable => 'Nessun barbiere disponibile';

  @override
  String get noBarbersForSelectedService =>
      'Nessun barbiere disponibile per questo servizio.';

  @override
  String get waitlistMe => 'Tienimi in lista d\'attesa';

  @override
  String get selectPreferredTime => 'Seleziona la fascia oraria che preferisci';

  @override
  String get recurringAppointments => 'Appuntamenti ricorrenti';

  @override
  String get recurringIntervalTitle => 'Intervallo appuntamenti ricorrenti';

  @override
  String get nextAppointment => 'Prossimo appuntamento';

  @override
  String idNumber(Object id) {
    return 'ID n.: $id';
  }

  @override
  String get profile => 'Profilo';

  @override
  String get contactUs => 'Contattaci';

  @override
  String get contactFormIncomplete => 'Compila tutti i campi.';

  @override
  String get contactSubmitNetworkError =>
      'Impossibile inviare il messaggio. Controlla la connessione e riprova.';

  @override
  String get contactSubmitSuccessFallback => 'Messaggio inviato.';

  @override
  String get contactNoShopsHint =>
      'Nessun dato negozio. Apri la prenotazione e scegli un negozio per vedere indirizzo e mappa.';

  @override
  String get contactMapNoCoordinates =>
      'Posizione sulla mappa non disponibile per questo negozio.';

  @override
  String get profileNameRequired => 'Inserisci nome o cognome.';

  @override
  String get profileEmailRequired => 'Inserisci la tua email.';

  @override
  String get profileUpdateSuccessFallback => 'Profilo aggiornato.';

  @override
  String get profileUpdateNetworkError =>
      'Impossibile aggiornare il profilo. Controlla la connessione e riprova.';

  @override
  String get noBookedAppointmentsFound =>
      'Nessun appuntamento prenotato trovato.';

  @override
  String get noReservationsFound => 'Nessuna prenotazione trovata.';

  @override
  String get retryLabel => 'Riprova';

  @override
  String get noSlotsAvailableForSelectedDate =>
      'Nessuna fascia oraria disponibile per la data selezionata.';

  @override
  String get noBarberWorkingDays =>
      'Questo barbiere non ha giorni lavorativi configurati. Scegli un altro barbiere o una data diversa.';

  @override
  String get selectTimeRequired =>
      'Seleziona una fascia oraria disponibile prima di continuare.';

  @override
  String get slotsStillLoading =>
      'Attendi il caricamento degli orari disponibili.';

  @override
  String get nextSlotLabel => 'Prossimo slot';

  @override
  String get nextDateLabel => 'Data';

  @override
  String get reservationListTitle => 'Elenco prenotazioni';

  @override
  String get reservations => 'Prenotazioni';

  @override
  String get bookings => 'Prenotazioni';

  @override
  String get serviceBooking => 'Prenotazione di un servizio';

  @override
  String get upcoming => 'Prossimamente';

  @override
  String get confirmed => 'Confermato';

  @override
  String get completed => 'Completato';

  @override
  String get cancelled => 'Annullata';

  @override
  String get logout => 'Esci';

  @override
  String get update => 'Aggiorna';

  @override
  String get changeProfilePhoto => 'Cambia foto profilo';

  @override
  String get takePhoto => 'Scatta una foto';

  @override
  String get chooseFromGallery => 'Scegli dalla galleria';

  @override
  String get cancel => 'Annulla';

  @override
  String get photoSelected =>
      'Foto selezionata. Tocca Aggiorna per salvare il profilo.';

  @override
  String get photoSavedOffline =>
      'Foto salvata sul dispositivo. Tocca Aggiorna quando sei online per caricarla.';

  @override
  String get photoSyncedOnline => 'Foto profilo sincronizzata.';

  @override
  String get photoPickError =>
      'Impossibile accedere all\'immagine selezionata.';

  @override
  String get cameraPermissionDenied =>
      'Permesso fotocamera negato. Abilitalo nelle Impostazioni per scattare una foto.';

  @override
  String get galleryPermissionDenied =>
      'Permesso galleria negato. Abilitalo nelle Impostazioni per scegliere una foto.';

  @override
  String get cameraUnavailable =>
      'La fotocamera non è disponibile su questo dispositivo o simulatore.';

  @override
  String get pickerNotInstalled =>
      'Plugin non installato. Riavvia completamente l\'app dopo aver aggiunto il plugin.';

  @override
  String get notSignedIn => 'Devi accedere per impostare una foto profilo.';

  @override
  String get bookingSuccess => 'Appuntamento prenotato con successo.';

  @override
  String get bookingGenericError => 'Qualcosa è andato storto. Riprova.';

  @override
  String withBarberLabel(String name) {
    return 'con $name';
  }

  @override
  String alternativeBarberLabel(String name) {
    return 'Barbiere alternativo con $name';
  }

  @override
  String get alternativeBarbersTitle => 'Barbieri alternativi';

  @override
  String get selectAlternativeBarber => 'Seleziona barbiere alternativo';

  @override
  String get clearAlternativeBarberSelection => 'Nessun barbiere alternativo';

  @override
  String selectedAlternativeBarber(String name) {
    return 'Selezionato: $name';
  }

  @override
  String get recurringAlternativeBarberRequired =>
      'Seleziona un barbiere alternativo per ogni appuntamento non disponibile.';

  @override
  String recurringDatesExcludedHint(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count date senza barbiere o lista d\'attesa non verranno prenotate.',
      one: '1 data senza barbiere o lista d\'attesa non verrà prenotata.',
    );
    return '$_temp0';
  }

  @override
  String get recurringSuccess => 'Appuntamenti ricorrenti elaborati.';

  @override
  String get recurringMissingSelection =>
      'Seleziona un intervallo ricorrente e il numero di prenotazioni.';

  @override
  String get recurringIntervalRequired =>
      'Seleziona la frequenza della ripetizione prima di continuare.';

  @override
  String get recurringQuantityRequired =>
      'Seleziona quante prenotazioni desideri prima di continuare.';

  @override
  String recurringAllSkipped(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tutti gli $count slot selezionati sono stati saltati.',
      one: 'Lo slot selezionato è stato saltato.',
    );
    return '$_temp0';
  }

  @override
  String recurringPartialSuccess(int booked, int skipped) {
    String _temp0 = intl.Intl.pluralLogic(
      booked,
      locale: localeName,
      other: '$booked appuntamenti prenotati',
      one: '1 appuntamento prenotato',
    );
    String _temp1 = intl.Intl.pluralLogic(
      skipped,
      locale: localeName,
      other: '$skipped saltati',
      one: '1 saltato',
    );
    return '$_temp0, $_temp1.';
  }

  @override
  String get sendYourMessage => 'Invia il tuo messaggio';

  @override
  String get barberAndHairConcept => 'Barber and Hair Concept';
}
