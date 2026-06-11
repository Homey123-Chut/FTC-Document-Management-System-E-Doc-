import 'package:e_doc_redo/data/models/user/user.dart';
import 'package:e_doc_redo/ui/features/user/controllers/profile_controller.dart';
import 'package:e_doc_redo/ui/features/user/views/widgets/profile_header_card.dart';
import 'package:e_doc_redo/ui/widgets/input/edoc_dropdown_field.dart';
import 'package:e_doc_redo/ui/widgets/input/edoc_input_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Editable form content for user profile info.
/// Delegates save to [ProfileController].
class EditInfoUserContent extends StatefulWidget {
  final ProfileController controller;

  const EditInfoUserContent({super.key, required this.controller});

  @override
  State<EditInfoUserContent> createState() => _EditInfoUserContentState();
}

class _EditInfoUserContentState extends State<EditInfoUserContent> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _deptCtrl;
  String _gender = '';

  bool _editing = false;
  bool _saving = false;

  UserModel? get _user => widget.controller.user.value;

  bool _controllersReady = false;

  @override
  void initState() {
    super.initState();
    _initFromUser(_user);
    // Fetch user data when this screen is displayed.
    // The controller was created at app start (before login), so we
    // need to trigger the fetch now.
    widget.controller.fetchActiveUserSession();
  }

  void _initFromUser(UserModel? u) {
    _nameCtrl = TextEditingController(text: u?.username ?? '');
    _emailCtrl = TextEditingController(text: u?.email ?? '');
    _phoneCtrl = TextEditingController(text: u?.phoneNumber ?? '');
    _deptCtrl = TextEditingController(text: u?.department ?? '');
    _gender = u?.gender ?? '';
  }

  /// Re-initialize controllers from user data once it arrives.
  void _refreshControllers(UserModel u) {
    _nameCtrl.text = u.username;
    _emailCtrl.text = u.email;
    _phoneCtrl.text = u.phoneNumber;
    _deptCtrl.text = u.department;
    _gender = u.gender;
    _controllersReady = true;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _deptCtrl.dispose();
    super.dispose();
  }

  // ── Actions ──

  void _toggleEdit() => setState(() => _editing = !_editing);

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    final u = _user;
    if (u == null) return;

    setState(() => _saving = true);

    await widget.controller.saveProfile(
      u.copyWith(
        username: _nameCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        phoneNumber: _phoneCtrl.text.trim(),
        gender: _gender,
        department: _deptCtrl.text.trim(),
      ),
    );

    setState(() {
      _saving = false;
      _editing = false;
    });
  }

  // ── Build ──

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (widget.controller.loading.value && _user == null) {
        return const Center(child: CircularProgressIndicator());
      }

      final user = _user;
      if (user == null) {
        return const Center(child: Text('មិនអាចទាញយកទិន្នន័យបានទេ'));
      }

      // Once user data arrives, fill the controllers with real data.
      if (!_controllersReady) {
        _refreshControllers(user);
      }

      return SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Profile Header ──
            ProfileHeaderCard(
              imageUrl: user.profileImg.isNotEmpty
                  ? user.profileImg
                  : 'assets/images/user_avatar.png',
              roleLabel: user.role == 'admin' ? 'អគ្គលេខាធិការ' : 'បុគ្គលិក',
              userName: user.username,
              departmentLabel: 'អង្គភាព',
              departmentName: user.department,
              onCameraTap: () {},
            ),

            const SizedBox(height: 16),

            // ── Info Form Card ──
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'ព័ត៌មានអ្នកប្រើប្រាស់',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                        TextButton.icon(
                          onPressed: _saving ? null : (_editing ? _handleSave : _toggleEdit),
                          style: TextButton.styleFrom(
                            backgroundColor: const Color(0xFFEDF2F9),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          icon: _saving
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : Icon(
                                  _editing
                                      ? Icons.check_circle_outline
                                      : Icons.edit_note_rounded,
                                  size: 20,
                                  color: const Color(0xFF1B5ECF),
                                ),
                          label: Text(
                            _editing ? 'រក្សាទុក' : 'កែប្រែ',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1B5ECF),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // ── Editable fields ──
                    TextFieldWidget(
                      label: 'ឈ្មោះ',
                      controller: _nameCtrl,
                      isRequired: true,
                    ),
                    const SizedBox(height: 16),

                    TextFieldWidget(
                      label: 'អ៊ីមែល',
                      controller: _emailCtrl,
                      isRequired: true,
                    ),
                    const SizedBox(height: 16),

                    TextFieldWidget(
                      label: 'លេខទូរស័ព្ទ',
                      controller: _phoneCtrl,
                      isRequired: true,
                    ),
                    const SizedBox(height: 16),

                    DropdownField(
                      label: 'ភេទ',
                      value: _gender,
                      items: const ['male', 'female'],
                      onChanged: (v) {
                        if (v != null) setState(() => _gender = v);
                      },
                    ),
                    const SizedBox(height: 16),

                    TextFieldWidget(
                      label: 'ដេប៉ាតឺម៉ង់',
                      controller: _deptCtrl,
                      isRequired: false,
                    ),
                    const SizedBox(height: 16),

                    // Role — always read-only
                    TextFieldWidget(
                      label: 'តួនាទី',
                      controller: TextEditingController(
                        text: user.role == 'admin' ? 'Admin' : 'Staff',
                      ),
                      isRequired: false,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
