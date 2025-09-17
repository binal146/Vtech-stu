import 'package:get/get.dart';

class SubjectDataNew {
  final int id;
  final String subject;
  final int parentId;
  RxBool isSelect;
  RxBool isPartiallySelected = RxBool(false);
  final List<SubjectDataNew> children;

  SubjectDataNew({
    required this.id,
    required this.subject,
    required this.parentId,
    required this.isSelect,
    required this.children,
  });

  factory SubjectDataNew.fromJson(Map<String, dynamic> json) {
    return SubjectDataNew(
      id: json['id'],
      subject: json['subject'],
      parentId: json['parent_id'],
      isSelect: RxBool(json['is_select'] ?? false),
      children: (json['children'] as List<dynamic>)
          .map((childJson) => SubjectDataNew.fromJson(childJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['subject'] = this.subject;
    data['parent_id'] = this.parentId;
    data['is_select'] = this.isSelect.value;
    data['is_partially_selected'] = this.isPartiallySelected.value;
    if (this.children != null) {
      data['children'] = this.children!.map((v) => v.toJson()).toList();
    }
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

  void toggleChildSelection(SubjectDataNew child, bool value, List<SubjectDataNew> allSubjects) {
    child.toggleSelection(value);
    child.updateParentSelection();
    updateParentState(child, allSubjects);
  }

  void updateParentState(SubjectDataNew child, List<SubjectDataNew> allSubjects) {
    var parent = findParentById(child.parentId, allSubjects);
    if (parent != null) {
      parent.updateParentSelection();
      updateParentState(parent, allSubjects); // Recursively update all ancestors
    }
  }

  SubjectDataNew? findParentById(int parentId, List<SubjectDataNew> subjects) {
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
