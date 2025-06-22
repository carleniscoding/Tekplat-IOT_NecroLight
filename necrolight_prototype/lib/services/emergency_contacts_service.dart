import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/emergency_contact.dart';

class EmergencyContactsService {
  static const String _contactsKey = 'emergency_contacts';

  Future<List<EmergencyContact>> getContacts() async {
    final prefs = await SharedPreferences.getInstance();
    final contactsJson = prefs.getStringList(_contactsKey) ?? [];
    
    return contactsJson.map((contactStr) {
      final json = jsonDecode(contactStr);
      return EmergencyContact.fromJson(json);
    }).toList();
  }

  Future<void> addContact(EmergencyContact contact) async {
    final contacts = await getContacts();
    contacts.add(contact);
    await _saveContacts(contacts);
  }

  Future<void> updateContact(EmergencyContact contact) async {
    final contacts = await getContacts();
    final index = contacts.indexWhere((c) => c.id == contact.id);
    if (index != -1) {
      contacts[index] = contact;
      await _saveContacts(contacts);
    }
  }

  Future<void> deleteContact(String contactId) async {
    final contacts = await getContacts();
    contacts.removeWhere((c) => c.id == contactId);
    await _saveContacts(contacts);
  }

  Future<void> _saveContacts(List<EmergencyContact> contacts) async {
    final prefs = await SharedPreferences.getInstance();
    final contactsJson = contacts.map((contact) => jsonEncode(contact.toJson())).toList();
    await prefs.setStringList(_contactsKey, contactsJson);
  }

  Future<void> clearAllContacts() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_contactsKey);
  }
}
