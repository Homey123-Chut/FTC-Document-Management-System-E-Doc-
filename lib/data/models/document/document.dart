
class DocumentModel {
  final int id;
  final String titleKhmer;
  final String titleLatin;            
  final String documentNumber;  
  final String date;          
  final String status;                 
  final String subject;          
  final String program;          
  final String documentHistory;  
  final String attachedFile; 

  const DocumentModel({
    required this.id,
    required this.titleKhmer,
    required this.titleLatin,
    required this.documentNumber,
    required this.date,
    required this.status,
    required this.subject,
    required this.program,
    required this.documentHistory,
    required this.attachedFile,
  });

  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    return DocumentModel(
      id: json['id'] as int,
      titleKhmer: json['titleKhmer'] as String,
      titleLatin: json['titleLatin'] as String,
      documentNumber: json['documentNumber'] as String,
      date: json['date'] as String,
      status: json['status'] as String,
      subject: json['subject'] as String,
      program: json['program'] as String,
      documentHistory: json['documentHistory'] as String,
      attachedFile: json['attachedFile'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titleKhmer': titleKhmer,
      'titleLatin': titleLatin,
      'documentNumber': documentNumber,
      'date': date,
      'status': status,
      'subject': subject,
      'program': program,
      'documentHistory': documentHistory,
      'attachedFile': attachedFile,
    };
  }
}