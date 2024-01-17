import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

Future<void> sendEmail(String userEmail, String subject, String body) async {
  // Replace these values with your email and app-specific SMTP configuration
  final String username = 'your_email@gmail.com';
  final String password = 'your_email_password';

  final smtpServer = gmail(username, password);

  // Create our email message
  final message = Message()
    ..from = Address(username, 'Your Name')
    ..recipients.add(userEmail)
    ..subject = subject
    ..html = body;

  try {
    // Send the email
    final sendReport = await send(message, smtpServer);
    
    // Check if the email was sent successfully
    if (sendReport.toString() == 'Email sent!') {
      print('Message sent successfully!');
    } else {
      print('Failed to send the email. Please check your credentials.');
    }
  } catch (e) {
    print('Error sending email: $e');
  }
}

void main() async {
  await sendEmail('user@example.com', 'Test Subject', 'Hello, this is a test email!');
}
