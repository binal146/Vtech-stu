import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';

class SubjectDataUpdate {
  final int id;
  final String subject;
  final int parentId;
  RxBool isSelect;
  RxBool isPartiallySelected;
  final List<SubjectDataUpdate> children;

  SubjectDataUpdate({
    required this.id,
    required this.subject,
    required this.parentId,
    required this.isSelect,
    required this.isPartiallySelected,
    required this.children,
  });

  SubjectDataUpdate copy() {
    return SubjectDataUpdate(
      id: this.id,
      subject: this.subject,
      parentId: this.parentId,
      isSelect: this.isSelect.value.obs,
      isPartiallySelected: this.isPartiallySelected.value.obs,
      children: this.children.map((child) => child.copy()).toList(), // Deep copy of children
    );
  }

  factory SubjectDataUpdate.fromJson(Map<String, dynamic> json) {
    return SubjectDataUpdate(
      id: json['id'],
      subject: json['subject'],
      parentId: json['parent_id'],
      isSelect: (json['is_selected'] != null) ? (json['is_selected'] as bool).obs : false.obs,
      isPartiallySelected: (json['is_partially_selected'] != null) ? (json['is_partially_selected'] as bool).obs : false.obs,
      children: (json['children'] as List<dynamic>)
          .map((childJson) => SubjectDataUpdate.fromJson(childJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['subject'] = this.subject;
    data['parent_id'] = this.parentId;
    data['is_selected'] = this.isSelect.value; // Extract the value of RxBool
    data['is_partially_selected'] = this.isPartiallySelected.value;
    data['children'] = this.children.map((v) => v.toJson()).toList();
    return data;
  }

  void toggleSelection(bool value) {
    isSelect.value = value;
    isPartiallySelected.value = false;
    for (var child in children) {
      child.toggleSelection(value);
    }
  }

  void updateParentSelection() {
    if (children.isEmpty) return;
    if (children.every((child) => child.isSelect.value)) {
      isSelect.value = true;
      isPartiallySelected.value = false;
    } else if (children.every((child) => !child.isSelect.value)) {
      isSelect.value = false;
      isPartiallySelected.value = false;
    } else {
      isSelect.value = false;
      isPartiallySelected.value = true; // Set partially selected state
    }
  }

  void toggleChildSelection(SubjectDataUpdate child, bool value, List<SubjectDataUpdate> allSubjects) {
    child.toggleSelection(value);
    child.updateParentSelection();
    updateParentState(child, allSubjects);
  }

  void updateParentState(SubjectDataUpdate child, List<SubjectDataUpdate> allSubjects) {
    var parent = findParentById(child.parentId, allSubjects);
    if (parent != null) {
      parent.updateParentSelection();
      updateParentState(parent, allSubjects); // Recursively update all ancestors
    }
  }

  SubjectDataUpdate? findParentById(int parentId, List<SubjectDataUpdate> subjects) {
    for (var subject in subjects) {
      if (subject.id == parentId) {
        return subject;
      }
      var parent = findParentById(parentId, subject.children);
      if (parent != null) {
        return parent;
      }
    }
    return null;
  }

}

